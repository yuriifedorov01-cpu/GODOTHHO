# Инструкция для следующей модели (Model Handoff Guide) — Перенос Helmet Heroes на Godot 4.3
> **Текущая точка GPT-6 Luna — новые кадры и audit (2026-11-13):** seven Godot screenshots still show green grid-aligned rectangles and one translucent blue area; exact cell coordinates are not registered. Новый source audit нашёл подтверждённое обращение порядка non-FG layers: оригинальный childIndex=0 insertion produces Art>Main>Water>G2>G3 front-to-back, while Godot z values produce G3>G2>Water>Main>Art. Это сильная гипотеза причины перекрытий, пока не объясняет каждый пропуск. Дополнительно подтверждены unbacked stat defaults: EnemyEntity uses literals when absent enemyStats.json; original loads enemyStats via PlayerIO BigDB. PersonEntity also holds hardcoded values without profile hydration in _ready. Two-hit kill is a user observation; exact damage path/formula remains unresolved. См. PAR-018/019 и audit addendum. Следующий этап: представить пользователю маленький общий z-order fix план для подтверждения; отдельно trace stats source-data. No game code/tests changed. Most recent Codex quota snapshot 69%; reset Dec 13. GPT-6 Sol исключён; точечные блокеры принимает Luna.
> **Текущая точка GPT-6 Luna — после Stage 6 (2026-11-13):** source trace `map_1 mapMain ID64→52` показал одинаковый static alias, mirror intent и начало клетки в оригинале/Godot; конкретное расхождение draw bounds не установлено, pivot не менять по гипотезе. Stage 5 также не подтвердил pixel fidelity extraction symbol 2970. Не запускались игра/тесты; игровых файлов не меняли. Следующий этап — получить надёжное Godot 4.3 Sprite2D bounds evidence или сопоставимый capture, после чего продолжить локализацию общей причины тайлов. Usage перед Stage 6 — 74% monthly; post-stage снимок ожидается. GPT-6 Sol исключён пользователем; его точечная резервная роль передана GPT-6 Luna.
> **Обновление после возобновления — Stage 5 закрыт (2026-11-13):** выполнен read-only аудит происхождения PNG symbol 2970, атласной нарезки и общего texture sampling/позиционирования; детали и точные ссылки добавлены в `GPT_LUNA_AUDIT_2026-11-12.md`. Вывод: шаг/region 165, nearest и drawable extent 166 согласуются с исходным TileHandler. Точность извлечённого `1.png` к SWF **НЕ УСТАНОВЛЕНА** из-за отсутствия FFDec log/version и pixel reference/hash. Проверен вопрос pivot/anchor зеркальных тайлов: ID 64→52 и координаты размещения совпадают на уровне renderer source; первичный аудит не доказывает отдельный anchor mismatch. Flash задаёт 166 px vertices с шагом 165 и pivot width для зеркалирования, поэтому распределение 1 px overlap может зависеть от точной геометрии; соответствие Godot bounds по имеющимся docs не установлено. Это не объясняет seams. Игровые файлы не изменялись, runtime и тесты не запускались. Следующий точечный шаг: read-only trace конкретного mirrored tile map_1 и точных bounds; после него представить source-backed вариант малого фикса/критерий ручной проверки. Usage после Stage 5 ожидается; расход не считать без скриншота.


> **АКТУАЛЬНЫЙ HANDOFF GPT Luna — 2026-11-13.** Перед началом обязательно прочитать `TOKEN_RULES.md`, `docs/ANTIGRAVITY_WORKING_RULES.md`, `docs/MODEL_ASSIGNMENTS_AND_QUOTA_TRACKER.md`, `docs/PORT_PARITY_MATRIX.md`, `docs/ANTIGRAVITY_BACKLOG.md`, `docs/GPT_LUNA_AUDIT_2026-11-12.md` и этот handoff. Главные правила: только source-backed поведение; не изобретать значения/алгоритмы/fallback; неизвестное оставить не реализованным и записать `НЕ УСТАНОВЛЕНО`. Скрипт запуска Gemini/Antigravity с полным заданием: `docs/ANTIGRAVITY_GEMINI_START_PROMPT.md`. План ролей, этапов и замеров подписок — `docs/MODEL_ASSIGNMENTS_AND_QUOTA_TRACKER.md`.

> **Текущий статус:** внесены только документированные изменения: три ранее одобренных узких фикса (theme alias tile20, формулы gravity/water, helmet offsets) и частичный общий tile pipeline в `scripts/world/TileMapRenderer.gd`. Stage 7 последний запуск: **50 passed, 0 failed**, Godot 4.3 headless; это покрывает helper/assertions и загрузку уровней 1/64/100, но **не** визуальное сравнение и не физический проход игрока по реальным маскам. В выводе были pre-existing ошибки certificate store и повторного добавления узла в тесте GameFlow, плюс ObjectDB leak warning.

> **Последние ручные скриншоты пользователя:** tiles всё ещё имеют видимые стыки/пропуски/лишние клетки; отдельно замечена коллизия мобов. Полный ответ проблемы не установлен. Оригинал использует dynamic `tileDefs` → `TileDefRegistry.setPayload` (`source_analysis/decompiled_mygame/scripts/GameMain.as:885, 2726–2728`); локального payload нет, поэтому текущие legacy rules неполны. В оригинале `Enemy.as` создаёт и `GravityObject`, и `HitTester` с per-enemy `Rectangle` (`source_analysis/decompiled_mygame/scripts/com/game_objects/enemies/Enemy.as:79–125`); Godot `EnemyEntity.gd` использует generic `CircleShape2D` (радиус 24), а `GravityBody`/`CharacterBody2D` оставляет стандартные collision layer/mask. Почему именно пользователь ощущает mob collision и какая часть контакта должна сохраняться — **не установлено**, не отключать коллизии вслепую. Текущие screenshots добавлены в диалог пользователя, но не в репозиторий.

> **Результат read-only этапа GPT-6 Luna — 2026-11-13:** точечный аудит карты 1, динамического `tileDefs` и Green Bouncer описан в `GPT_LUNA_AUDIT_2026-11-12.md` (дополнение 2026-11-13). Подтверждены различия геометрии оригинального Green Bouncer (Rectangle `(-16,-32,34,31)`) и Godot generic circle radius 24, но не подтверждено, что circle вызывает наблюдаемое блокирование игрока. Пустой sentinel map=255 переводится Godot в -1 по исследованному пути. Сам `tileDefs` payload в локальных файлах не найден. Клетки со скриншота не привязаны к координатам, поэтому первопричина визуальных дефектов остаётся неизвестной. Игровой код и тесты не менялись/не запускались. Показания Codex после этапа ещё не предоставлены; до/после заносить в model/quota tracker.

> **Следующее действие:** read-only сравнение актуальных screenshots против исходников: (1) проследить видимые разрывы/лишние тайлы до map-layer IDs, decoded cells, atlas rect, alias/fallback, transforms/z-order; (2) установить происхождение оригинального `tileDefs` payload либо точно перечислить, какие правила невозможно восстановить локально; (3) сопоставить enemy rectangle/hitTester и Godot collision behavior. До завершения этой таблицы доказательств не менять игровой код. Потом предложить пользователю маленький source-backed фикс и критерий ручной проверки. Поискать `TOKEN_RULES.md` на корне — есть; отдельный `docs/TOKEN_RULES.md` отсутствует.

> **Обновление GPT-6 Luna — этап 2 завершён (2026-11-13):** read-only поиск в `D:\HHT_CLIENT` и `D:\PERENOS_GODOT\tools` не обнаружил локальный AIR/Flash runtime, оригинальный launcher или runtime log; это не доказывает отсутствие внешней установки на компьютере пользователя. Оригинальный `tileDefs` приходит из серверного сообщения и локально не найден. Статическая сверка показывает похожие правила atlas slicing (row-major, 165 px, visual extent 166 px), но extracted PNG/SWF pixel fidelity и конкретная причина дефектов **НЕ УСТАНОВЛЕНЫ**. В этом этапе код/тесты не менялись/не запускались. Перед этапом Codex было 91% monthly; post-stage Usage ещё ожидается. Следующий шаг: принять quota snapshot и уточнить доступность оригинального runtime; если доступен — получить один парный кадр стартовой карты и tileDefs из собственного runtime/log. Если нет — ограниченный source/asset trace, без догадок и правок.

> **Новая заметка передачи GPT Luna (2026-11-12):** прежде чем продолжать, прочитай [ANTIGRAVITY_WORKING_RULES.md](ANTIGRAVITY_WORKING_RULES.md), [PORT_PARITY_MATRIX.md](PORT_PARITY_MATRIX.md), [ANTIGRAVITY_BACKLOG.md](ANTIGRAVITY_BACKLOG.md) и [GPT_LUNA_AUDIT_2026-11-12.md](GPT_LUNA_AUDIT_2026-11-12.md). Старые заявления ниже о завершённых этапах и тестовых цифрах не подтверждены независимой сверкой с оригиналом. Не считай этапы 6–9 готовыми по этим заявлениям; сначала обнови фактическую матрицу и собирай evidence.

> **Точка продолжения GPT Luna (обновлено 2026-11-12):** выполнены одобренные пользователем три небольших фикса. `TileMapRenderer.gd` теперь учитывает тему для tile 20; `GravityBody.gd` повторяет формулу и водные коэффициенты из `GravityObject.as`; `BodyAnimatorNode.gd` применяет source pivot/frame offset для шлема. Проверка: Godot 4.3 headless Stage 7 — 43 passed, 0 failed. Ограничения: это проверка условий кода, а не визуальный паритет; не менялся алгоритм попадания в воду по hitbox (PAR-013); alignment экипировки кроме шлема не портировался. Следующий шаг: сравнить оригинал и Godot на уровне 64 и с несколькими предметами экипировки, затем отдельно изучить точную геометрию/порядок определения воды. Подробности и точный тест — в `GPT_LUNA_AUDIT_2026-11-12.md` и `WORK_REPORT.md`.

> **Обновление GPT Luna после ручного скриншота (2026-11-12):** видимый пользователем скрин — стартовая Wooden Plains, а предыдущий tile-20 fix был для карты 64 и не мог решить эти дефекты. Добавлены PAR-015–016: Godot подменяет исходную collision mask систему полным collider на большинстве `mapMain` tiles и единообразной платформой на G2/G3; collider появляется даже если texture не загрузилась. Также подтверждены fake HUD values (coins/inventory/apple/welcome/Rage), XP cap 100 вместо AS3 формулы (51 на level 1), и неверные позиции/состав кнопок. Следующее действие: сначала инструментировать карту 1 (слои, ID counts, texture failures) и проверить против `HHT_CLIENT`; далее source-based collision masks, отдельно HUD-data/layout. Не интерпретировать ID 0 как пустой без проверки AS3.

> **Обновление GPT-6 Luna — общий renderer trace (2026-11-13):** оригинальный скрин пользователя получен, но это другая зона, поэтому он пока не привязывает дефектные клетки Wooden Plains. В `TileHandler.as` оригинал использует dynamic `TileDefRegistry` для alias/flip/mask, Godot renderer его не применяет — подтверждённое общее архитектурное расхождение, которое потенциально решается одним общим изменением после получения payload. 59 извлечённых tile PNG имеют полные ячейки 165×165; статическая row-major сетка/166 extent согласуются, но точность SWF extraction неизвестна. До следующего этапа Codex 91%; после этапа нужен новый снимок. Не менять игровой код до получения парного кадра и payload/точного источника значений.

> **Обновлённая точка продолжения GPT Luna (2026-11-12):** в общем `TileMapRenderer.gd` теперь есть legacy source-based static collision geometry и atlas tile_0 fallback, так что общие правила применяются на всех картах. Добавлены Stage 7 проверки карт 1/64/100 (темы 1/16/11), итог 50 passed / 0 failed. См. PAR-015. Это ещё не полный визуальный/физический parity: оригинальный серверный `tileDefs` payload отсутствует локально и переопределяет alias/masks/slope; polygons нужно сравнить в оригинальном runtime. Следующий шаг — добыть оригинальный payload и провести ручной скриншот/столкновительный прогон на тех же трёх картах. HUD defects PAR-016 не затронуты этим изменением.

> **Прочитай этот файл ПЕРВЫМ делом перед началом работы!**
> Здесь собрана вся ключевая информация о проекте, правилах пользователя, уже готовой инфраструктуре и следующих шагах, чтобы ты не тратил токены и время на повторное исследование.

---

## 1. Обязательные правила пользователя и ограничения проекта

1. **Три папки на диске D и их роли**:
   - `D:\PERENOS` — оригинальная папка пользователя с упаковкой Adobe AIR (`HH-cLoader.swf`, `Helmet Heroes.exe`, `icons/`). **СТРОГО READ-ONLY!** Никогда не изменяй и не создавай файлы в `D:\PERENOS`.
   - `D:\HHT_CLIENT` — скачанный полный веб-клиент игры из репозитория `https://github.com/yuriifedorov01-cpu/hht-client` (`MyGame.swf`, `data/`, `dynamic_content/`, `SFX_and_music/`, `cut-scenes/`, `includes/`). **СТРОГО READ-ONLY!**
   - `D:\PERENOS_GODOT` — **рабочая папка нового клиента на движке Godot 4.3**. Все новые скрипты, сцены, ресурсы, тесты, временные файлы (`D:\PERENOS_GODOT\.tmp`) и отчеты создавай **ТОЛЬКО внутри `D:\PERENOS_GODOT`**.
2. **Экономия токенов**:
   - Обязательно соблюдай правила из [TOKEN_RULES.md](file:///d:/PERENOS_GODOT/TOKEN_RULES.md).
   - Не перечитывай огромные файлы целиком — используй готовые JSON-индексы и документацию в `D:\PERENOS_GODOT\docs\` и `D:\PERENOS_GODOT\assets\extracted\`.
3. **Использование субагентов и инструментов**:
   - Обязательно разделяй работу между субагентами (`godot_coder` для написания сцен/скриптов GDScript, `qa_verifier` для headless-тестирования и исправления ошибок, при необходимости `decompiler_analyst` для точечных справок по AS3).
   - В начале новой сессии/модели вызови `define_subagent` для `godot_coder` и `qa_verifier` (если они не определены в контексте), передав им требование соблюдать `D:\PERENOS_GODOT\TOKEN_RULES.md`.
   - При вопросах по API Godot 4 используй MCP `context7` (библиотека `/websites/godotengine_en_stable`).
4. **Минимальное участие пользователя**:
   - Не задавай пользователю лишних вопросов. Если возникает техническая развилка — выбирай наиболее надежное, полное и безопасное решение самостоятельно и продолжай работу.
5. **Отчетность**:
   - Постоянно обновляй прогресс в [WORK_REPORT.md](file:///d:/PERENOS_GODOT/docs/WORK_REPORT.md) и отмечай выполненные пункты в [WORK_PLAN.md](file:///d:/PERENOS_GODOT/docs/WORK_PLAN.md).

---

## 2. Что УЖЕ сделано и проверено (Этапы 1–5 завершены на 100%)

Ничего из перечисленного ниже переделывать, заново качать или заново декомпилировать **НЕ НУЖНО**:

### 2.1 Готовые инструменты в `D:\PERENOS_GODOT\tools\`
- **Godot 4.3 (Windows 64-bit)**:
  - Консольный бинарник для headless-проверок и тестов:
    `"D:\PERENOS_GODOT\tools\godot4\Godot_v4.3-stable_win64_console.exe"`
  - GUI бинарник:
    `"D:\PERENOS_GODOT\tools\godot4\Godot_v4.3-stable_win64.exe"`
- **Java 21 JRE + FFDec 22.0.1**:
  - `"D:\PERENOS_GODOT\tools\jre\bin\java.exe" -jar "D:\PERENOS_GODOT\tools\ffdec\ffdec.jar"`

### 2.2 Полная декомпиляция и документация архитектуры
- **Главный справочник архитектуры**: [ARCHITECTURE_MAP.md](file:///d:/PERENOS_GODOT/docs/ARCHITECTURE_MAP.md) (2 105 строк) — содержит полное описание `HH-cLoader.swf`, `MyGame.swf` (все 1 016 классов), схему всех 25 таблиц BigDB, таблицы всех **101 входящих** (`addMessageHandler`) и **110 исходящих** (`send`) сетевых пакетов с точными аргументами, физику, рендеринг, боевку и UI.
- **Декомпилированные исходники AS3**:
  - Загрузчик: `D:\PERENOS_GODOT\source_analysis\decompiled_loader\scripts\` (284 `.as` файла).
  - Основной клиент: `D:\PERENOS_GODOT\source_analysis\decompiled_mygame\scripts\` (1 016 `.as` файлов).
  - Машиночитаемые индексы протокола: `D:\PERENOS_GODOT\source_analysis\protocol_complete.json`, `handlers_full_report.json`, `mygame_classes_index.json`.

### 2.3 Все ассеты и извлеченные таблицы в `D:\PERENOS_GODOT\assets\`
1. **`D:\PERENOS_GODOT\assets\client_data\`** (точная копия ресурсов `D:\HHT_CLIENT` внутри проекта Godot `res://assets/client_data/`):
   - `data/` — 144 карты (`map_1.json` .. `map_145.json`, кроме `51`, который в коде перенаправляется на `46`) + 14 JSON-таблиц статов (`weaponStats.json`, `helmetStats.json`, `shirtStats.json`, `legStats.json`, `shoeStats.json`, `accStats.json`, `itemData.json`, `itemDescs.json`, `petHelmets.json`, `basePetData.json`, `enemyStats.json`, `PayVaultItems.json`, `npcs.json` и др.).
   - `dynamic_content/sprite_sheets/` — 17 пар Starling TextureAtlas (`.png` + `.xml`: `items_pets_bodies`, `controls`, `trees_fish`, `power_up_textures`, атласы всех меню) + шрифт `talk_font.png/.fnt`.
   - `dynamic_content/backgrounds/` — 30 пар фоновых атласов (`backgrounds1..30.png/.xml`).
   - `dynamic_content/misc/pet_body_locations.json` и `.xml` — скелетные координаты частей тела для всех 60 видов питомцев.
   - `SFX_and_music/` — 173 MP3-файла (21 музыкальный трек, 82 SFX, 27 звуков выстрелов, 43 звука монстров).
2. **`D:\PERENOS_GODOT\assets\extracted\`** (данные и векторная графика, извлеченные напрямую из `MyGame.swf`):
   - `body_animator_data.json` — все **1 000 кадров** скелетной анимации персонажа из `BodyAnimator.as` (матрицы и декомпозированные `x, y, rot, scaleX, scaleY` для 9 узлов тела/оружия, смещения всех предметов `itemOffsets`, 58 именованных анимаций со `startFrame`, `endFrame`, `loop`, `resetTo`, а также триггеры кадров `slashes`, `gunFlashes`, `rangedProjectileFrames` из `PersonFrameHandler.as`).
   - `moves_data.json` — все **34 боевых приема/комбо** из `Moves.as` (`startFrame`, `earliestCombo`, `endFrame`, `startDmgFrame`, `endDmgFrame`, `keyCode`, `knockback` и т.д.).
   - `skills_meta.json` — все **43 скилла** по 5 вкладкам (`basic`, `warrior`, `archer`, `wizard`, `cowboy`) с формулами, MP-стоимостью и иконками.
   - `missions_data.json` — все **21 квест/миссия** и все **109 NPC** (с их `area`, `x`, `y`, внешностью, диалогами и товарами).
   - `areas_meta.json` — полная таблица всех **145 уровней/карт** (`name`, `theme`, `mainTilesClass`, `foregroundTilesClass`, `backgroundAtlas`, `musicTrack`, `portals`, `closestHeal`, `waterTint`, `isPvpArea`, `mapMarker`, `atmPosition`, `npcs`, а также `tileRules` с правилами коллизий тайлов, односторонних платформ, воды, наклонов `Block*Data` и зеркалирования).
   - `embedded_images_map.json` + папка `swf_sprites/` — все **126 растрированных векторных символов SWF** в PNG:
     - 59 тайлсетов (`DefineSprite_2970_GreenAreaTiles/1.png` и др. — листы тайлов с шагом сетки `165x165` px),
     - 48 монстров и эффектов (`DefineSprite_2134_GreenBouncerVector/1.png .. N.png` и др.),
     - 19 объектов окружения и ловушек (`Portal`, `BouncePad`, `MushroomSpike`, `Pendulum`, `BeholderCannon`, `BushShooter`, `SplashAnimation`, `LightningBolt` и др.).

### 2.4 Готовый и протестированный код Godot 4.3 (`D:\PERENOS_GODOT\scripts\`)
- **Autoload-синглтоны (`scripts/autoload/`)**:
  - `GameConfig.gd` — константы, URL, формулы физики и клавиш.
  - `StarlingAtlasLoader.gd` — парсер всех Starling XML+PNG атласов, возвращающий готовые `AtlasTexture` (с корректным `margin` для `frameX/frameY`) и метаданные `pivotX/pivotY`/`rotated`, а также `pet_body_locations` и шрифты.
  - `StatsDB.gd` — глобальная БД всех предметов, экипировки, врагов, питомцев, NPC, скиллов и всех 144 карт (`map_1..map_145.json`, включая декодирование Base64 слоев в `PackedInt32Array` `int16`).
  - `AudioManager.gd` — проигрыватель фоновой музыки уровней и 16-канального пула SFX.
- **Сетевой стек (`scripts/network/`)**:
  - `ProtobufCodec.gd` — полный кодек PlayerIO HTTP RPC (методы `10, 13, 27, 30, 82, 85, 88, 91, 94, 97, 103, 160..175, 400, 403, 406`) и `BigDBObject`.
  - `BinarySerializer.gd` — побитовый сериализатор/десериализатор TCP-пакетов `PlayerIOMessage`.
  - `PlayerIOConnection.gd` — TCP-соединение комнаты (`StreamPeerTCP`) + локальный симулятор для Offline Sandbox.
  - `PlayerIOClient.gd` — главный клиент PlayerIO с автоматическим и ручным режимом **Offline / Local Sandbox** (`user://local_sandbox_db.json`).
- **Автотесты (`tests/test_foundation_and_network.gd`)**:
  - Все 185 проверок проходят на 100% (`Assertions passed: 185 | failed: 0`).

---

## 3. План действий для следующей модели (С чего сразу начать)

Тебе нужно последовательно выполнить **Этапы 6, 7, 8 и 9** из [WORK_PLAN.md](file:///d:/PERENOS_GODOT/docs/WORK_PLAN.md), используя субагентов `godot_coder` и `qa_verifier`:

### Шаг 1: Расширение `StatsDB.gd` и `StarlingAtlasLoader.gd` для поддержки `assets/extracted/*.json`
- Добавь в `StatsDB.gd` загрузку новых извлеченных JSON-файлов из `res://assets/extracted/`:
  - `areas_meta.json` (доступ к метаданным уровня `get_area_meta(stage_id)` и правилам тайлов `tileRules`),
  - `moves_data.json` (доступ к боевым приемам `get_move_stat(move_name)`),
  - `skills_meta.json` (доступ к полным данным 43 скиллов),
  - `missions_data.json` (доступ к 21 миссии и 109 NPC),
  - `body_animator_data.json` (кешированные таблицы кадров для `BodyAnimatorNode`).
- Добавь в `StarlingAtlasLoader.gd` (или отдельный хелпер `SwfSpriteLoader.gd`) нарезку тайлсетов из `res://assets/extracted/swf_sprites/DefineSprite_*Tiles/1.png` на тайлы `165x165` px по 1-based индексу тайла и загрузку покадровых `SpriteFrames` для монстров `DefineSprite_*Vector/*.png`.

### Шаг 2: Этап 6 — Главное меню, авторизация и создание персонажа (`scripts/menus/`)
- Реализуй `MainMenuUI.gd` / сцену главного меню (логин/пароль через `PlayerIOClient.simple_connect`, регистрация, выбор сервера `Pve Server` / `PvP Server` / **Offline Sandbox**).
- Реализуй `CreateCharacterMenu.gd` (выбор пола, цвета кожи `1..4`, глаз, прически, бороды и стартового класса `warrior`, `archer`, `mage`, `cowboy` с живым превью персонажа).

### Шаг 3: Этап 7 — Игровой мир, тайловый рендерер, физика `GravityBody` и сущности (`scripts/world/` и `scripts/entities/`)
- **`GameWorld.gd` + `TileMapRenderer.gd`**:
  - Загрузка любого уровня `1..145` из `StatsDB.get_map_data(stage_id)` и `areas_meta.json`.
  - Отрисовка параллакс-фона (`backgrounds1..30` из `StarlingAtlasLoader`), 6 тайловых слоев (`mainGround`, `water`, `ground2`, `ground3`, `foreground`, `art`, шаг сетки `165x165`), порталов (`Portal`), деревьев (`Tree`), банкоматов (`ATM`), батутов (`BouncePad`), ловушек и воды.
  - Камера с центром `(475, 449)` на экране `950x700` и ограничением по границам карты (`focusLevel`).
- **`GravityBody.gd`** (порт `com/gravityPackage/GravityObject.as`):
  - Физика на 30 FPS: `gravity = 1.1`, `groundFriction = 0.83`, `airFriction = 0.96`, `maxFallSpeed = 25`, `maxGap = 20` (подъем по ступенькам/склонам), проверка коллизий по `tileRules` (сплошные тайлы `mainGround`, односторонние платформы `ground2`/`ground3` с проваливанием вниз по `S`, плавание в `water`, наклонные маски `Block2Data..Block18Data` из `resources/images/`).
- **`BodyAnimatorNode.gd` + `PersonEntity.gd`** (порт `BodyAnimator.as`, `Person.as`, `PersonKeyHandler.as`, `MoveHandler.as`):
  - Сборка персонажа из 15 узлов `Sprite2D` с текстурами из `items_pets_bodies` (`StarlingAtlasLoader`) и применение покадровых матриц `Matrix(a, b, c, d, tx, ty)` и `itemOffsets` из `body_animator_data.json`.
  - Управление с клавиатуры, комбо-атаки из `moves_data.json`, стрельба/магия (`ProjectileEntity.gd`), блок (`V`), рубка деревьев (`C`), рыбалка (`C`), энергетическая аура (`Y`), переход между локациями через порталы (`W` у портала).
- **`EnemyEntity.gd`, `PetEntity.gd`, `NPCEntity.gd`, `LootItemEntity.gd`**:
  - Спавн врагов карты/сервера с анимациями из `swf_sprites/DefineSprite_*Vector/`, ИИ врагов (`EnemyAI`), получение урона, вылет цифр урона (`DamageFont`), дроп предметов и монет, работа питомцев (5 режимов + `PetOrb`) и диалоги с 109 NPC.
- **Сетевая синхронизация и Offline Sandbox сервер в `PlayerIOConnection.gd` / `GameWorld.gd`**:
  - Подключи обработчики сетевых пакетов комнаты (`"pLoaded"`, `"sP"`, `"tD"`, `"eD"`, `"pD"`, `"sE"`, `"eMove"`, `"iDrop"` и т.д. — полная таблица в `ARCHITECTURE_MAP.md` раздел 3), а в режиме Offline Sandbox эмулируй спавн врагов из `map_*.json`, урон, опыт, дроп, переходы по всем 144 картам и сохранение в `PlayerIOClient`.

### Шаг 4: Этап 8 — Игровой HUD и окна меню (`scripts/ui/` и `scripts/menus/`)
- Реализуй `GameHUD.gd` (полоски HP, MP, Energy, XP, деньги, быстрый слот, чат, кнопки открытия меню сверху справа) на текстурах из `controls` атласа.
- Реализуй ключевые игровые окна (на текстурах соответствующих атласов из `dynamic_content/sprite_sheets/`):
  - `CharacterMenu` (прокачка статов Pow/Dex/Def/Rng/Mgc/Art за AP),
  - `ItemMenu` (инвентарь на 20–40 слотов, надевание/снятие экипировки в 7 слотов, использование зелий/еды/свитков, выбрасывание),
  - `SkillsMenu` (прокачка 43 скиллов по 5 вкладкам из `skills_meta.json`),
  - `MapMenu` (карта мира с маркерами всех открытых локаций из `areas_meta.json` и телепортацией),
  - `TalkBox` / `MissionMenu` / `ShopMenu` (диалоги с NPC, принятие/сдача 21 квеста из `missions_data.json`, покупка/продажа предметов),
  - `PetMenu` / `PetModeMenu` (управление питомцами и выбор режима Attack/Defend/Heal/Loot/Mount),
  - `CraftingMenu`, `BankMenu`, `HeropediaMenu`, `OptionMenu`.

### Шаг 5: Этап 9 — Непрерывная верификация через `qa_verifier`
- После каждого крупного блока запускай `qa_verifier` с headless-скриптами через:
  `"D:\PERENOS_GODOT\tools\godot4\Godot_v4.3-stable_win64_console.exe" --headless --path "D:\PERENOS_GODOT" -s res://tests/...`
- Проверяй, что все сцены инстанцируются без ошибок, персонаж спавнится, анимируется, двигается, бьет монстров, переходит по порталам и открывает окна UI.


> **Дополнение после Stage 6 (2026-11-13):** map_1 mirror case ID64→52 source-to-Godot trace выполнен, см. audit addendum. Совпадают static alias, cell origin и mirror intent. Конкретная разница bounds не установлена; не чинить flip/pivot по догадке и не заявлять, что это причина seams. Для точного следующего хода нужно получить Godot 4.3 Sprite2D draw-bounds evidence либо сравнимый кадр/геометрический capture. GPT-6 Sol исключён пользователем; его точечные блокеры принимает GPT-6 Luna. Stage 6: до — 74%, после — 69% monthly по скриншотам; изменение между наблюдениями не приписывать только этому этапу.

> **Usage update после Stage 6 (2026-11-13):** пользователь прислал Codex monthly 69%, reset Dec 13; предыдущий snapshot 74%. Изменение −5 п.п. между наблюдениями, не приписывать исключительно этапу. Дополнительный запрос Context7 /godotengine/godot/4.3-stable о Sprite2D.flip_h/bounds тоже не нашёл matching docs. Нужна точная engine geometry evidence; код не менять пока mismatch не установлен.



> **GPT Luna handoff — Stage 7B одобрен (2026-11-13):** Gemini Hydrogen может выполнять общий z-order fix по заданию в `docs/ANTIGRAVITY_GEMINI_START_PROMPT.md` (последнее дополнение). Узкий scope: общий renderer only; oracle original `GameMain.as:2740–2755`, `TileHandler.as:435–441`; expected front-to-back `FG > Art > Main > Water > G2 > G3`. Визуальные пропуски/швы полностью этим не объясняются. Не трогать tile data, alpha, collision, entity/UI/stats. Hydrogen запускает source-order check и headless-проверку, отчитывается с diff; GPT Luna делает независимый review, пользователь — ручное сравнение в игре. Usage snapshots после предыдущих этапов отсутствуют/устарели; tracker отмечает это явно.

> **GPT Luna — актуальный handoff (2026-11-13):** пользователь одобрил Stage 7B. Исполнитель Gemini 4 Hydrogen; точная задача и готовый prompt в `docs/ANTIGRAVITY_STAGE_7B_PROMPT.md`. Этот документ supersedes предыдущие фразы «дождаться одобрения» для данного z-order fix. Не начинать другие fixes; stats PAR-019 и прочие tile defects остаются отдельными задачами.
