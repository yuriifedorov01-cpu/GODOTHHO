# База знаний переноса HHT (AS3 -> Godot 4.3)

Этот файл — обучающая база проекта `D:\PERENOS_GODOT`. Перед исправлением бага проверяй, есть ли здесь готовый разбор; после каждого успешного фикса дополняй базу новым паттерном, чтобы не повторять старые ошибки.

---

## 1. Тайлсеты и экспорт из `MyGame.swf`
- **Проблема**: Швы `7×6` (и до `27×27`) между тайлами.
  - **Причина**: FFDec `g_main` сдвигает только отрицательные границы мувиклипа, игнорируя внутренний сдвиг векторного `#shape0` относительно сетки `165×165`. В `GreenAreaTiles` (2970) и `GreenAreaForegroundTiles` (4202) часть тайлов хранится только в растровых `#tag*` (часть шириной `158`–`159` px вместо `165`).
  - **Решение**: Комбинировать сдвинутый векторный рендер (`-dx-rx, -dy-ry`) + дотянутые `#tag`-клетки для отсутствующих в `#shape0` слотов.
- **Проблема**: «Коробки вместо деревьев» (`"palm tree"` рендерится как ящик древесины).
  - **Причина**: `StarlingAtlasLoader` брал `"trees_fish"` из `items_pets_bodies`, где лежат иконки ресурсов (`"palm tree wood"`).
  - **Решение**: Извлекать оригинальные спрайты из `MyGame.swf` (`TreeFishContainer`, `DefineSprite chid: 218`, маппинг `__` -> пробел) в `assets/extracted/trees_fish/` и возвращать их как `AtlasTexture`.
- **Проблема**: Пустые тайлы (`17`, `23` в `GreenAreaTiles`, `66` в 6 биомах, `11` в `Jungle`/`Haunted`, земля в `CloudAreaTiles`).
  - **Причина**: В новом клиенте `TileDefRegistry.setPayload()` с сервера переопределяет визуальные алиасы и маски; в старом SWF эти ячейки `165×165` физически пустые (`alpha == 0`).

## 2. Коллизии тайлов (AS3 `TileHandler.as`)
- **Анти-паттерн**: Генерация `BitMap.opaque_to_polygons()` на слоях `mapG2`/`mapG3` или на тайлах с торчащей травой.
  - **Последствия**: На `mapG2`/`mapG3` фоновые вывески (`tile_128`) и фоновые скалы (`7, 38, 52, 64`) превращаются в невидимые платформы в небе. На `mapMain` травинки до `y=9` (`tile_6`) создают ступеньки и невидимые стены выше линии пола (`y=25`).
- **Правило**: На `mapG2`/`mapG3` коллидят **строго** только ID из `TileHandler.as:617-639` (`36, 44, 19, 78, 73, 14, 18, 16, 20, 30`). На `mapMain` для недостающих ID (`3, 5, 6, 7, 8, 12, 13, 17, 23`) использовать точные геометрические прямоугольники и ровные наклоны с верхом `y=25` (без травинок).

## 3. Шрифты Starling `BitmapFont` и вёрстка UI
- **Причина сдвига текста и отсутствия контура**: В `MyGame.swf` `stats_font`, `readable_font`, `names_font` имеют чёрную обводку, запечённую в PNG-глифы, а `talk_font` — XML BMFont. Starling `TextFormat` по умолчанию центрирует текст по горизонтали и вертикали (`verticalAlign = "center"`), тогда как Godot `Label` выравнивает по `TOP`.
- **Правило**: Всем текстовым `Label` в HUD и окнах меню выставлять выравнивание строго по `TextFormat` (`VERTICAL_ALIGNMENT_CENTER` где не указано `"top"`), сверять `font_size` и размеры контейнеров с `Controls.as` и `com/menus/*.as`.

## 4. Персонаж, анимации и смерть
- **Стартовая одежда**: `BodyAnimatorNode` должен по умолчанию иметь пустые слоты (`""` -> `"none"` для голых рук/ног), а не `"red shirt"`/`"blue jeans"`. Новый персонаж получает `["white shirt", "green shorts", "white shoe"]` + оружие класса (`stick`, `slingshot`, `basic wand`, `airsoft gun`), а `skin > 4` декодируется в `gender = "female", skin -= 4` (`GameMain.as:648, 3761-3762`).
- **Циклы и удержания**: В `body_animator_data.json` у `running` и `jumping` стоит `loop: false` — в AS3 их зацикливает `PersonFrameHandler.as:538-543` (`50..74`, `214..229`). `block` удерживается на кадре `857`, `ducking` — на `99`.
- **Поворот на 90°**: Вызов `animator.rotation = -PI / 2.0` в `PersonEntity.die()` без блокировки ввода/движения и без респавна приводит к тому, что при `health <= 0` герой продолжает бегать боком. Смерть должна блокировать управление/анимации (`gotoAndStop(1)`), скрывать тень и запускать респавн со сбросом `animator.rotation = 0.0`.

## 5. Схема JSON vs AS3 (`StatsDB`, `ItemMenu`, `CharacterMenu`)
- **Частая ошибка**: Чтение AS3-имён полей (`"type"`, `"defense"`, `"minPower"`, `"maxPower"`, `"power"`, `"range"`, `"magic"`, `"artillery"`, `"sRate"`, `"isMagic"`, `"isRange"`, `"reqLev"`, `"desc"`) из словарей `StatsDB`.
- **Реальные ключи JSON** в `assets/client_data/data/*.json`:
  - категория: `"_category"` (`"helmet"`, `"shirt"`, `"legs"`, `"shoes"`, `"weapon"`, `"acc"`, `"item"`, `"pet"`, `"pet_helmet"`)
  - статы: `"def"`, `"min"`, `"max"`, `"pow"`, `"rng"`, `"mgc"`, `"art"`, `"sr"`, `"lvl"`, `"f"` (frame), `"d"` (описание из `itemDescs.json`).
- **Последствие**: Если читать `"type"` вместо `"_category"`, все предметы считаются расходниками (`"item"`), кнопки `Equip`/`Unequip` скрыты, а кнопка `Use` удаляет надетую/лежащую экипировку.

## 6. Механика магии (`basic wand` и посохи, `isMagic` / `mgc > 0`)
- В AS3 (`Person.as:681-705`, `Projectile.as:15-170`, `GameMain.as:11670-11709`): при `mgc > 0` на активном кадре замаха при `mana >= levelMP(2)` тратится `2 * ceil(lev / 100)` маны и создаётся `magicShotsLvl + 1` снарядов (`"<weapon> proj"`), летящих с `velX = (9 + rand*3) * dir`, почти нулевой гравитацией и временем жизни `lifeSpan = 4 + magicDistanceLvl` тиков.

## 7. Физика, мобы, дроп и Hero-pedia
- **Хитбокс игрока**: `Person.as:302` `Rectangle(-23, -36, 54, 84)` — центр в торсе, ноги на `y = +48`. Движение: `velX += (moveSpeed + bonus) / 6.5` (земля) и `/ 13.0` (воздух при `|velX| < 15`), `MIN_VELX = 0.3`.
- **Мобы**: Не толкают игрока физически (`collision_layer = 4`), урон контактом через `Area2D` (`tick % 32 == 0`). Не использовать `vel_x += raw_move_speed` без ограничений/пауз, иначе `green bouncer` разгоняется до ~480 px/s.
- **Дроп и Hero-pedia**: Убийство врага должно начислять XP, обновлять `enemyList` (BigDB + сигнал в `HeropediaMenu`), а не спавнить гарантированное `"apple"` на каждом мобе.

## 8. Посадка ног героя на землю и мосты (`PersonEntity` vs `body_animator_data.json`)
- **Симптом**: Герой визуально парит ~7–12px над землёй и деревянным мостом при совпадении `hit_rect` с AS3.
- **Причина**: В `Person.as:302` низ коллизии `y = +48.0`, а в `body_animator_data.json` босые ноги заканчиваются на `y = +36.65`, с обувью — на `y = +41.30` (в AS3 тень была на `y = +41`, в Godot тень на `y = +48`).
- **Решение**: Сдвинуть `animator.position = Vector2(0, 7.0)` в `PersonEntity._setup_animator()`, сохранив `CollisionShape2D` `54x84` на `Vector2(4, 6)` (подошва обуви ложится ровно на `y = +48.30`, высота прыжков и зазоры не ломаются).

## 9. Недостающие коллизии платформ `mapG2`/`mapG3` и редких проп-тайлов (`TileMapRenderer`)
- **Симптом**: Игрок проходит насквозь через правые края платформ и редкие проп-объекты на отдельных картах.
- **Причина**:
  - На `mapG2`/`mapG3` тайл `1` (правый край платформ `18-19-1`), тайл `17` и тайл `7` (`theme_id == 1`, 193 платформы `14-44-36-7`) отсекались ранним выходом `layer_name != "mapMain"` или не имели формы.
  - Проп-тайлы `84, 85, 89, 92, 93` (`map_119`), `96, 100, 101` (`map_130`), `112` (`map_37`) отсутствовали в `get_source_collision_shapes()`.
- **Решение**: Зарегистрировать `1`, `7` (`theme_id == 1`) и `17` до раннего выхода для `mapG2`/`mapG3` (one-way) и добавить 9 solid rect-ов для проп-тайлов.

## 10. Боевые статы, защита, крит и всплывающий урон (`FloatingDamage` + `Assets_DamageFont`)
- **Причина расхождения статов**: `PersonEntity.def_stat` был равен `5` вместо AS3 `0` (`Person.as:125`), поэтому `green bouncer` (`p=6`) бил по `1` вместо `6`. Также отсутствовал шанс крита `dex / 300.0 + crit_lvl * 0.01` (`CharacterMenu.as:503`) и всплывающий урон.
- **Решение**:
  - Поставить `def_stat = 0`, пробросить `is_crit` в `PersonEntity.execute_attack()` -> `GameWorld.damage_enemies_in_range()` / `MagicProjectile` -> `EnemyEntity.take_damage()`.
  - Извлечь оригинальный растровый шрифт `damage_font` (`Yikes! damage`, `2269_...XML.bin` + `2275_...PNG.png`) в `assets/extracted/bitmap_fonts/` и подключить в `StarlingAtlasLoader.get_damage_font()`.
  - Создать `FloatingDamage.gd` по `GameMain.as:11544-11583, 11630-11647`: обычный урон (`34px`), крит (`48px`), `"avoided"` (`28px`, `#FFFFFF`), цвет по врагу `#FFB200`, по игроку `#CD0000`, линейный твин вверх на `100px` с затуханием за `1.0s`; и `spawn_xp` (`+Nxp`, `16px`, `stats_font`, вверх `60px` за `0.8s`).

## 11. Стартовые статы 1-го уровня и все 39 скиллов (`PersonEntity`, `SkillsMenu`, `skills_meta.json`)
- **Причина**: В `PersonEntity` стояли выдуманные `ability_points = 5`, `skill_points = 3`, `coins = 100`, статы по `5` и `dash_lvl = 1, accel_down_lvl = 1`; `skills_meta.json` содержал 43 скилла (4 выдуманных, `block` и `down crush` не в тех вкладках); а `SkillsMenu.gd` передавал `required_sp` во второй аргумент `upgrade_skill(skill_id, max_lvl)`.
- **Решение**:
  - `PersonEntity` на старте: `ability_points = 0`, `skill_points = 0`, `coins = 0`, статы `0`, при создании класса применяется `apply_class_starter_stats(char_class)` (`MainStarlingStage.as:1514-1553`).
  - `skills_meta.json` приведён ровно к 39 AS3 скиллам; все скиллы стартуют с `0` и не срабатывают без прокачки (`lvl > 0`); исправлена сигнатура `upgrade_skill(skill_id, required_sp, max_lvl)`; крит-урон = `2.0 + crit_lvl / 8.0`, шанс крита = `dex / 300.0`.

## 12. Неработающие порталы (`PortalEntity`, `GameWorld`, `MapMenu`)
- **Причина**: `PersonEntity.collision_layer = 2`, а `PortalEntity` (`Area2D`) имел дефолтный `collision_mask = 1`, поэтому `body_entered` никогда не срабатывал; при входе нажатием `Down` срабатывал `drop_down()`, но `drop_through_counter` не сбрасывался на новой карте; отсутствовали `scale.y` анимация, очистка лута/снарядов и `createWhite()`.
- **Решение**: В `PortalEntity` задать `collision_layer = 0, collision_mask = 2`, хитбокс `63x77` и `scale.y` (`0.6..1.4`); в `GameWorld` сбрасывать `drop_through_counter = 500`, очищать всех не-игроков в `entities_container`, проигрывать `SFX/teleport` + `createWhite()`, и подключить `MapMenu.area_selected` в `GameHUD`.

## 13. Sandbox Flow и CreateCharacterMenu (`MainMenuUI`, `CreateCharacterMenu`, `GameFlow`)
- **Причина**: `MainMenuUI.offline_sandbox_requested` не был подключён в `GameFlow.gd`; `HAIR_MALE` пропускал `3` (`bald`), имена бород/волос/глаз и описания классов не совпадали с `CreateMenu.as`.
- **Решение**: Подключён `offline_sandbox_requested` -> `CreateCharacterMenu(is_sandbox_mode = true)` с кнопкой **Quick Start (Default Hero)** и полноценным созданием кастомного героя (имя, класс, пол, причёска/лысина `3`, глаза, кожа, борода) + повторное открытие меню при следующем входе в Sandbox.


## 14. CreateCharacterMenu (`CreateMenu.as`), тайминги стрельбы Ковбоя/Лучника и Sandbox-возврат
- **`CreateCharacterMenu` (`CreateMenu.as:123-360, 741-752`)**: Все элементы меню должны позиционироваться в центрированном `MenuRoot` по точным координатам оригинала: `NonChangeFrame` (`772×550`, `(-387, -320)`, `z_index = 2`), `Platform` (`77×248`, `(-230, -63)`, `z_index = 1`), `CenterPersonPreview` (`(-195, -85)`, `scale = 1.0`, живая анимация `"standing"` на 30 FPS), боковые клоны `scale = ±2.0`, а `ClassTitleLabel` / `ClassItemIcon` / `ClassDescLabel` — поверх `NonChangeFrame` (`z_index = 3`). Кнопки стрелок и действий используют `TextureButton` с `left_00`/`left_01`, `right_00`/`right_01`, `back_00`, `finished_00`, `terms_00`.
- **Индексация кадров (`body_animator_data.json` vs AS3 `currentFrame`)**: Flash `currentFrame` 1-based, а `BodyAnimatorNode.current_frame` 0-based (`AS3_frame - 1`). Для `"shoot gun"` (`749..758`) выстрел происходит на кадре `752` (AS3 `753`) с циклом `751..754` по `counter % sRate == 0`; для `"gun shoot upward"` (`759..769`) — только при `upwardShootLvl > 1` и `MP >= levelMP(2)` на кадре `764` (AS3 `765`); для `"shoot bow"` (`87..98`) анимация играет `87 -> 91`, удерживается на `91` (AS3 `92`) с шаром заряда, затем доигрывает до `95` (AS3 `96`) и спавнит стрелу. Блокировка движения на земле и разрешение в воздухе обеспечиваются через `(not is_attacking or not on_ground)` в `PersonEntity`.
- **Возврат в `CreateCharacterMenu` из Sandbox (`GameHUD` + `GameFlow`)**: `GameFlow` не является Autoload (инстанцируется в `Main` как `/root/Main/GameFlow`), поэтому `GameHUD` должен искать его через группу `"game_flow"` / fallback-пути, а при очистке мира в `GameFlow._clear_active_world()` необходимо вызывать `AudioManager.stop_music()`.

## 15. Дуалы, ковбой/маг кастинг, формулы MP/крит/орбы/маунт и UI фокус/карты
- **Дуалы и щиты (`PersonEntity.gd`, `ItemMenu.gd`, `CharacterMenu.gd`)**:
  - Щит в AS3 всегда кладётся в `equipment["weapon"]`, а одноручное оружие переносится в `equipment["weapon2"]`; при экипированном двуручном оружии попытка надеть щит отклоняется с `last_equip_error`, снятие `weapon2` под щитом и снятие `shirt`/`legs`/`shoes` блокируется.
  - Двойная стрельба Ковбоя (`DUAL_GUNS_ARRAY`: `"airsoft gun"`, `"paintball gun"`, `"handgun"`, `"revolver"`, `"mac10"`, `"mp5"`, `"tommy gun"`, `"es c90"`, `"beholder gun"`, `"corruptor"`) разрешает парный выстрел из `weapon2`; одиночный выстрел задаёт `_cowboy_cooldown_ticks` по `sr` оружия (блокируя быстрое повторное нажатие), а `"gun shoot upward"` требует `upward shoot > 1` и `level_mp(2)`.
  - Расчёт урона и `CharacterMenu` при щите берёт активное оружие (`weapon2`), а `ItemMenu` показывает карты сравнения основного и вторичного (`weapon2`) оружия, `dual_wield_panel`, `alert_panel` и читает стат удачи `pet_helmet` из ключа `"l"`.
- **Магия на кадрах замаха (`PersonEntity.gd`, `MagicProjectile.gd`, `Person.as:681-705`)**:
  - Снаряды `MagicProjectile` спавнятся не при старте атаки, а ровно на 0-based кадрах замаха `MAIN_MAGIC_SWING_FRAMES = [79, 102, 156, 170, 205, 404, 414, 426, 443]` и `OFF_MAGIC_SWING_FRAMES = [117, 106, 160, 169, 183, 194, 430, 447, 458, 469]` при `mana >= level_mp(2)`.
  - В полёте у `MagicProjectile` есть только основной спрайт (`ProjectileSprite`) без орбитальных овалов, время жизни `life_span = 4 + magic_distance_lvl`; овал-эффект (`MagicBurstEffect`) создаётся только при попадании по врагу.
- **MP, крит, орбы и маунт (`PersonEntity.gd`, `SkillsMenu.gd`)**:
  - `level_mp(base_cost) = base_cost * ceili(max(1, level) / 100.0)` (`Person.as:1164-1167`).
  - `mp restore` активен только при `lvl > 1` и восстанавливает `lvl * 3` MP каждые `30.0s`; `"self heal"` требует магическое оружие и тратит `level_mp(15)` (лечит `35 + lvl * 5`), `"guild heal"` — `19` MP (`20 + lvl * 5`), `"self rage"` — `0` MP, `"guild rage"` требует `lvl > 1` и `level_mp(45)`, `"shotgun attack"` — `50 * lvl`, `"training"` даёт `+1` к статам и `+10` max HP/MP.
  - Крит-множитель равен `2.0 + crit_lvl / 8.0`; бонусы орбов (`get_orb_bonuses()`) и верхового пета (`get_riding_pet_power_bonus() = int(rp_pwr * 0.4)`) суммируются в боевые статы и `CharacterMenu`.
  - В `SkillsMenu` `"self rage"` показывает `"MP: 0"`, а при повышении уровня сигнал `exp_changed` динамически обновляет подписи `"MP: %d"`.
- **Карты, `AdminMenu`, `MapMenu` и изоляция `Space` (`StatsDB.gd`, `GameHUD.gd`)**:
  - `StatsDB.get_area_meta()` синхронизирует `theme` / `mainTilesClass` из `map_*.json` (соответствует `AreaCreator.getAreaTheme()`, например Stage `64` -> theme `3`, Stage `100` -> theme `12`, Stages `41-43` -> theme `16`, Stages `33-40, 116` -> theme `11`), обходя устаревшие значения в `areas_meta.json`.
  - В меню и HUD все интерактивные кнопки/списки (`Control` кроме `LineEdit`) обязаны иметь `focus_mode = Control.FOCUS_NONE`, чтобы клавиша атаки `Space` (`ui_accept`) не нажимала фокусированную кнопку открытия/закрытия меню.

## 16. НЕ УСТАНОВЛЕНО (серверная логика отсутствует в клиенте `MyGame.swf`)
- **НЕ УСТАНОВЛЕНО**: точная серверная формула расчёта `enemy dmgE` (передаётся/обрабатывается сервером Player.IO и не полностью присутствует в клиентском SWF).
- **НЕ УСТАНОВЛЕНО**: динамическая таблица серверного спавна летающих птиц (`flying-bird`) в рантайме комнат.

## 17. Сохранение последнего Sandbox-персонажа и полная работоспособность всех 39 навыков
- **Автосохранение и диалог продолжения Offline Sandbox**:
  - `GameFlow` (`scripts/GameFlow.gd`): хранит последнего Offline Sandbox-персонажа в `user://last_sandbox_character.json` (`LAST_SANDBOX_CHAR_PATH`), включая имя, класс, внешность (`gender`, `skin`, `eyes`, `hair`, `beard`), текущую зону (`stage`), `unlocked_maps`, `enemy_list`, уровень, опыт, монеты, базовые статы, HP/MP, AP/SP, `skill_levels`, `dash_lvl`, `accel_down_lvl`, `shield_mastery_lvl`, экипировку, инвентарь и `orb_bonuses`; автосохраняет при старте игры, смене зоны, изменении статов/инвентаря/опыта/монет, очистке мира и выходе.
  - `MainMenuUI` (`scripts/menus/MainMenuUI.gd`): при нажатии `OfflineSandboxButton`, если сохранённый персонаж существует (`GameFlow.has_last_sandbox_character()`), открывает модальный диалог с вопросом `"Хотите ли вы продолжить играть на последнем персонаже?"` и кнопками `"Да"` / `"Нет"` (`focus_mode = FOCUS_NONE`). Выбор `"Да"` эмитит `offline_sandbox_continue_requested` и сразу запускает `IN_GAME` с восстановлением прогресса, пропуская `CreateCharacterMenu`; выбор `"Нет"` открывает `CreateCharacterMenu`.
- **Исправление привязки блока, комбо-клавиш и всех 39 навыков**:
  - `project.godot`: действие `block` переназначено с `KEY_V` (`keycode=86`) на `KEY_Q` (`keycode=81`) в соответствии с `skills_meta.json` (`"Q (Hold)"`).
  - `PersonEntity` (`scripts/entities/PersonEntity.gd`):
    - Пассивные навыки: `upgrade_skill` начисляет `+1` профильного стата для `expert warrior`/`archer`/`wizard`/`cowboy`, `get_attack_damage_range` сужает минимальный разброс к максимуму; `training` даёт `+2.5%/ур` к `add_exp` и базовые статы; `shield mastery` усиливает защиту щита (`+(lvl)*6%`); `block` снижает урон на `min(0.85, 0.50 + lvl*0.01)`; `avoidability` уклоняется на `min(0.60, lvl*0.02)`; `bullet distance` увеличивает `life_span` при `lvl > 1` без изменения `life_span = 5` на `0/1`; `loot steal` ускоряет подбор чужого дропа в `LootItemEntity.can_be_picked_up_by`.
    - Активные навыки и анимации: все боевые навыки запускают свои анимации `BodyAnimatorNode` (`lunge attack`, `ground stab`, `down slash`, `spin attack`, `shoot bow`, `triple shot`, `rain attack`, `down stab`, `summon beam`, `summon thunder`, `shoot gun`, `gun shoot upward`, `dash attack`), поддерживают `E (Hold & Release)` заряд для `air slash` с пробивающей волной `RangedProjectile`, пробивающую красную стрелу для `piercing arrow`, физический `GrenadeProjectileVFX` для `grenade attack`/`jump grenade`, визуальные эффекты `SkillEffectNode` и комбинации `Fwd/Down/Up + Space` alongside `C`/`V`/`H`/`G`/`R`/`T`/`Q`/`B`/`N`/`M`.
  - `RangedProjectile` (`scripts/entities/RangedProjectile.gd`): добавлены `piercing`, `max_hits`, `_hit_enemies` и растянутый по скорости хитбокс (`maxf(24.0, absf(vel_x))`), исключающий туннелирование быстрых снарядов мимо врагов.

## 18. Плавные ползунки громкости (20% старт), музыка главного меню и классовый MAX Preset (`AudioManager`, `MainMenuUI`, `OptionsMenu`, `AdminMenu`)
- **Аудио и ползунки громкости**:
  - `AudioManager` (`scripts/autoload/AudioManager.gd`): стартовая громкость `music_volume = 0.2` и `sfx_volume = 0.2` (20%); добавлены `set_music_volume()` / `set_sfx_volume()` с синхронизацией `music_muted` / `sfx_muted` на нуле и обновлением активных игроков `_sfx_pool`; добавлен алиас `"main menu music": "Glory_Glory_full_mix"` (оригинальный трек из `GameMain.as:966,10045`).
  - `MainMenu.tscn` / `MainMenuUI.gd`: удалены `SoundCheckBox` и `MusicCheckBox`, вместо них добавлены `HSlider` (`sound_slider`, `music_slider`, `focus_mode = FOCUS_NONE`, `0.0..1.0`, шаг `0.01`, старт `0.2`) и вызов `AudioManager.play_music("main menu music")` при `_ready()`.
  - `OptionsMenu.gd`: удалены кнопки `MusicOff`/`MusicOn`/`SoundOff`/`SoundOn` и `_set_music_enabled`/`_set_sound_enabled`, вместо них установлены `music_slider` и `sfx_slider` (`HSlider`, `focus_mode = FOCUS_NONE`, старт `0.2`) с тёмной подложкой поверх запечённого текста `OFF ON` на фоне панели.
- **Классовый выбор в `AdminMenu` MAX Preset**:
  - `AdminMenu.gd`: кнопка `MAX Preset` открывает модальное окно выбора из 4 классов (`Воин`, `Лучник`, `Маг`, `Ковбой`, кнопки с `FOCUS_NONE`). `apply_max_preset_for_class(cls_id)` выставляет MAX-статы (с безопасной проверкой `exp_points`/`max_exp_points` у `PersonEntity`), устанавливает `player.character_class` и выдаёт лучший комплект класса по `StatsDB` (`helmet`, `shirt`, `legs`, `shoes`, `1x 2H` оружие и `2x 1H` dualhanded оружия; для ковбоя 1H учитывает `PersonEntity.DUAL_GUNS_ARRAY`, для лучника в `weaponStats.json` нет 1H луков), а также прокачивает все `basic` + классовые навыки до `maxLvl` (для бесконечных с `maxLvl >= 1000000` — до `200`). Для сохранения исходного размера окна `status_label` использует перенос и обрезку текста, вызывается `_reset_panel_size()`, справа вверху закреплена кнопка закрытия `CloseButton` (`X`, `FOCUS_NONE`), а перетаскивание окна работает при зажатии ЛКМ за любой край панели (`DRAG_EDGE_MARGIN = 18.0`, `_is_on_panel_edge`).

## 19. Анимации удара монстров, 110 NPC, фильтр лучника и dualhanded-оружие
- **Анимации удара монстров (`enemy_animator_data.json`, `SwfSpriteLoader`, `EnemyEntity`)**:
  - Из `MyGame.swf` (`DefineSprite_*Vector`, `FrameLabel`) извлечены диапазоны кадров `walk`, `jump`, `hit`, `open chest` для всех 46 монстров (42 монстра имеют явный клип `hit`, 4 монстра — `BrickMonsterVector`, `GiantGooCubeVector`, `GooCubeVector`, `KreetusVector` — не имеют `hit`).
  - `SwfSpriteLoader.get_enemy_sprite_frames()` нарезает отдельные анимации (`hit` без цикла `loop = false`, `walk`/`jump` циклично), а `EnemyEntity.take_damage()` запускает клип `"hit"` (не перезаписываемый в `_physics_process` до окончания), `Bounce.easeOut` сквош-твин (`scale: (0.7, 1.3) -> (1.0, 1.0)` за `0.5s` по `GameMain.as:3176-3197`) и убирает неподтверждённый красный тинт.
- **Все 110 мировых NPC (`StatsDB`, `NPCEntity`, `GameWorld`, `TalkBox`, `ShopMenu`, `GameHUD`)**:
  - `StatsDB.npcs_list` хранит все 113 записей `npcs.json` (без коллизий дублирующихся имён вроде `Tanya` на stage 79/140 и `Train Shack Man` на stage 88/126); `get_npcs_for_area(area_id)` возвращает всех NPC локации; из `GameMain.as:7510-8642` извлечён `assets/extracted/npc_dialogs.json`.
  - `NPCEntity.gd` спавнится в `GameWorld._spawn_npcs()` на `(x, y + 50)` (и `William` на stage 1 с `rotation = -90°`, `y += 30` по `GameMain.as:13540-13547`), отображает `BodyAnimatorNode` в `"standing"` и кнопку `TalkBubbleButton`, открывающую `TalkBox` -> `ShopMenu` (покупка/продажа), `Heal` (`talkID = 9`), старт/сдачу миссий, крафт и пет-шоп.
- **Фильтр лучника (`AdminMenu._detect_item_classes`) и dualhanded-оружие (`ItemMenu.update_display`)**:
  - В `weaponStats.json` все пистолеты ковбоя имеют `rng = true` и `sr > 0`, а броня ковбоя (например, `neoplasti helmet`) может иметь второстепенные `+2 rng`. `_detect_item_classes` теперь для оружия разделяет `mgc > 0` (Mage), `sr > 0` (Cowboy), `rng > 0` (Archer), а для брони ориентируется на доминирующий стат (`max_stat`), исключая предметы ковбоя из фильтра лучника.
  - В `ItemMenu.update_display()` убрано сопоставление `remaining_eq` с массивом `inventory`: поскольку `PersonEntity.equip_item()` удаляет надетый предмет из `inventory`, все элементы `inventory` теперь всегда отображаются как неэкипированные, и второй экземпляр парного 1H-оружия больше не пропадает после экипировки первого.

## 20. Баг-репорт (`BugReportMenu`, `GameHUD`, `bug_reports/`)
- Создана папка `D:\PERENOS_GODOT\bug_reports\` в корне нового клиента; в `GameHUD.gd` под кнопкой `Admin Menu` (`sandbox_admin_btn`) добавлена кнопка `Bug Report` (`bug_report_btn`, `y = 220 + y_offset`, `FOCUS_NONE`).
- `BugReportMenu.gd`: прокручиваемый список (`ScrollContainer`) отдельных полей `TextEdit` с нумерацией `1.`, `2.`, ..., кнопками `+ Добавить поле`, `Сохранить`, `Скачать репорт` (экспорт `.txt` в `bug_reports/bug_report_YYYY-MM-DD_HH-MM-SS.txt` с нумерацией `1. ...`, `2. ...`) и `Стереть всё`. Черновик глобально автосохраняется в `user://bug_report_draft.json`, поэтому сохраняется при закрытии окна, перезапуске игры, в Sandbox и при создании нового персонажа.
- **Пыль при дэше и скольжении по стене (`PersonEntity.gd`)**: В оригинале `Person.as:724-747` и `505-519` пыль (`"dash cloud 1..4"` из `items_pets_bodies`) появляется каждые 10 тиков при `"dashing"` / `"pet dashing"` (когда `abs(dx) > 4`) и при `"wall slide"` на стене, с pivot снизу по центру, `scale.x = -facing_dir` и линейным затуханием за `1.0s`; обычный бег (`"running"`) в оригинале пыль не спавнит.
- **Позиционирование и анимация NPC (`NPCEntity.gd`)**: Как и в `PersonEntity.gd`, `BodyAnimatorNode` требует `position = Vector2(0, 7.0)`, вызова `play("standing")` (не `play_animation`), проигрывания кадров через `advance_frame()` в `_physics_process`, передачи `shoes`/`beard`/`accessory` и raycast-приземления на тайл пола (`hit_y - 48.0`), чтобы NPC не парили над полом и не замирали на 0-м кадре.
- **Выравнивание монстров и хитбоксы (`EnemyEntity.gd`, `GameWorld.gd`, `MagicProjectile.gd`)**: Фиксированное смещение `sprite.position = Vector2(0, -24)` при `centered = true` проваливает крупных монстров (`GiantGooCube`, `BrickMonster`, `Kraken`, `Beholder`, `OmegaFluff`) под тайлы; низ спрайта и `DropShadow` должны выравниваться по `hit_offset.y + body_height`. Проверка урона в `GameWorld.damage_enemies_in_range()` и `MagicProjectile._check_enemy_hits()` должна использовать полный прямоугольник `EnemyEntity.get_world_hitbox()` вместо точки центра или фиксированного `44x64`.
- **AdminMenu телепорт к NPC (`AdminMenu.gd`)**: Выпадающий список `npc_select` содержит всех 110 мировых NPC из `StatsDB.npcs_list` с именем, числовым ID зоны (`<Name> (Zone <id>)`) и иконкой (шлем из `items_pets_bodies` или `"%s head %d"` / `"zombie head"`), позволяя телепортироваться к NPC даже в другую зону.
- **Fix Log и перетаскиваемые окна (`FixLogMenu.gd`, `BugReportMenu.gd`, `docs/fix_log.json`)**: `GameHUD` создаёт кнопку `FixLogBtn` с `FOCUS_NONE` прямо под `BugReportBtn` (`y = 252 + y_offset`). `FixLogMenu` загружает `res://docs/fix_log.json` (`updates`: сгруппированные апдейты с кратким `title` и полным `summary`). Оба окна (`FixLogMenu` и `BugReportMenu`) используют перетаскивание за любой край панели (`DRAG_EDGE_MARGIN = 18.0`, `_is_on_panel_edge` + `_input`), аналогичное `AdminMenu.gd`.
- **NPC, `TalkBox` и `ShopMenu` (`NPCEntity.gd`, `TalkBox.gd`, `ShopMenu.gd`)**: В AS3 `NPCEntity` использует 26 причёсок (`BodyAnimator.as:1837-1919`), обувь `"brown shoe"` по умолчанию, текстуру `"talk bubble"` (`"click to talk"`), а имя `William` (Stage 1) не поворачивается на `-90°` вместе с телом. `TalkBox` использует атлас `"talk box"` (`828×242`), `readable_font.fnt`, живой `BodyAnimatorNode`-портрет в `(-339, -10)` и ровно 3 кнопки (`next_btn_00`, `shop_btn_00`, `sell_btn_00`). `ShopMenu` наследует `ItemMenu` (`"item menu"` `500×487`, `stats_font.fnt`, `"buy_btn"`, `"sell_btn_00"`, карточки сравнения), парсит словари `{"item", "price"}` из `npcs.json` и строго проверяет `player.coins >= price`.

- **FixLogMenu, скорость мобов, эффекты падения и звуки оружия (`FixLogMenu.gd`, `EnemyEntity.gd`, `PersonEntity.gd`, `AudioManager.gd`)**:
  - `FixLogMenu.gd`: `PANEL_DEFAULT_SIZE = Vector2(600, 420)` с `_reset_panel_size()` при `open_menu()`, `OVERRUN_TRIM_ELLIPSIS` у `ItemList` и `clip_contents = true` на правой панели; `docs/fix_log.json` ведётся строго по порядку с №1 (`"1. ..."`).
  - `EnemyEntity.gd`: физика движения соответствует `Enemy.as:222,254-287` — `super._physics_process(delta)` выполняется до `_process_ai(delta)`, наземные враги ускоряются на `move_speed_stat` (`* 2.0` при рывке, `* 0.5` в воздухе при `|vel_x| < 15`) без деления на `4.5`, без искусственного `clamp` и без ложных пауз патруля; летающие — на `move_speed_stat / 3.0` без `clamp`.
  - `PersonEntity.gd`: `_update_fall_vfx()` реализует `PersonFrameHandler.as:84-114` (`handleDownAccel()` — 2–3 вертикальные белые полосы `1px × 30..100px`, `alpha = 0.9`, затухание 0.7с после 0.3с задержки каждые 7 тиков при `accel_down_multiplier > 0`).
  - `AudioManager.gd` + `PersonEntity.gd`: `get_audio_stream()` ищет MP3 в `SFX/`, `gun sounds/`, `SFX/gun sounds/`, `SFX/enemy sounds/`, `SOUND_ALIASES` покрывает все SFX-алиасы AS3 (`slash`, `slash 2`, `slash 3`, `bow fire`, `magic swing`, `hit`, `sciFiExplosion`, `lightBeam`, `thunder`, `electric`), а `PersonEntity` воспроизводит звуки для всех оружий (ближний бой/дуалы/щиты, луки, все 27 пушек через `StatsDB.sound`, магия и боевые навыки).
- **Кнопка `exit` в `TalkBox`, пыль на стене, зум камеры и советы в `FixLogMenu` (`TalkBox.gd`, `PersonEntity.gd`, `GameWorld.gd`, `FixLogMenu.gd`)**:
  - `TalkBox.gd`: `btn_next` (`ExitBtn`) перекрашивает внутреннюю область `next_btn_00` и отображает `ExitLabel` с текстом `"exit"`, сохраняя `btn_next` API для сигналов и совместимости.
  - `PersonEntity.gd`: `_update_dash_dust()` спавнит пыль бега/дэша только при `on_ground and not on_wall`, а при входе в `wall slide` сбрасывает `is_dashing = false`, очищает облака группы `"dash_run_dust"` (`_clear_run_dash_dust()`) и использует `dash cloud 1` (`Person.as:505-512`).
  - `GameWorld.gd`: добавлен зум камеры на `+` / `-` (`CAMERA_ZOOM_MIN = 0.5`, `CAMERA_ZOOM_MAX = 2.0`, `CAMERA_ZOOM_STEP = 0.1`, базовый `1.0` для `950x700` по `GameMain.as:46,10145`), согласованный с размером окна (`viewport.size_changed`) и границами карты (`_map_pixel_size`), с компенсацией `camera.offset.y = 99.0 / effective_zoom`.
  - `FixLogMenu.gd`: добавлена кнопка `TestTipsButton` и модальное окно `TestTipsPanel` (`520x340`) для отображения поля `test_tips` выбранного обновления с кнопками закрытия и возврата в `FixLogMenu`.
- **Скорость мобов, коллизия лута, `TalkBox` и коллизии тайлов (`EnemyEntity.gd`, `LootItemEntity.gd`, `TalkBox.gd`, `StatsDB.gd`, `TileMapRenderer.gd`)**:
  - `EnemyEntity.gd`: интервал разворота патруля приведён к `Enemy.as:442` (`clampf(300 / (move_speed_stat * 15) / 30, 0.5, 1.8)`), ускорение на земле `move_speed_stat * 0.48` с ограничением `<= 8.8` (`<= 14.0` при рывке) и для летунов `<= 12.0`, чтобы мобы не обгоняли игрока (`~9.05 px/tick`).
  - `LootItemEntity.gd`: `_setup_collision()` задаёт `collision_layer = 0` и `collision_mask = 1 | ONE_WAY_PLATFORM_BIT`, исключая физическое столкновение игроков и мобов с выпавшим лутом.
  - `TalkBox.gd` + `StatsDB.gd`: `ExitBtn` использует шаблон `shop_btn_00` (`112×44`) с выравниванием в один ряд с `SellBtn` (`439`) и `ShopBtn` (`560`) на `x = 681`; `StatsDB.get_npc_dialog_for_trigger()` сохраняет `hasShop`/`hasSell` при возврате веток и покрывает `trigger == 83` (Lottery Man из `GameMain.as:8488`) и `trigger == -1` (`William`, `Item Vendor`, `Pet Vendor`, `Ticket Vendor`).
  - `TileMapRenderer.gd`: `get_source_collision_shapes()` строго соответствует `TileHandler.as:617-737` — удалена коллизия у декоративных тайлов `1, 3, 5, 6, 7, 8, 11, 12, 13, 17, 23, 84, 85, 89, 92, 93, 96, 100, 101, 112`.
  - `GameWorld.gd` (`_setup_background`, `_update_sky_scale`): `sky_sprite` масштабируется под `vp_size / camera.zoom`, слои `far/mid/near` игнорируют `<= 2x2` заглушки, выравниваются от нижнего края (`620/660/700`) и тайлятся на ширину `>= 2800px`.
  - `PersonEntity.gd`: `_is_text_input_focused()` блокирует чтение `Input` при активном фокусе в `LineEdit`/`TextEdit`/`CodeEdit` (движение, прыжки, удержание атаки, хоткеи).
  - `LootItemEntity.gd` + `ItemMenu.gd` + `GameWorld.gd`: `ItemMenu._on_drop_clicked()` спавнит `LootItemEntity` через `GameWorld.spawn_dropped_item()`; `LootItemEntity` берёт текстуры из `items_pets_bodies` и `trees_fish`, выравнивает низ по `y=+12`, поворачивает оружие на `-55°`, крутит монеты, автоподбирает монеты и подбирает предметы по `E` (`try_pickup_nearest_loot`) с tween-полётом к игроку.
  - `AdminMenu.gd`: кнопка `RestoreHPMPBtn` (`_on_restore_hp_mp`) восстанавливает HP и MP до максимума.
  - `PetShopMenu.gd` + `GameHUD.gd`: оригинальное окно магазина питомцев (`pet shop panel`, 2x3 слота `panel_00`/`panel_01`, `petData.json`, `talkID` 42–45).
  - `SkillsMenu.gd`: автоподбор размера шрифта `14..10px` в описании навыка + `clip_text = true`.
  - `FloatingDamage.gd`: прямой рендер глифов из `damage_font.fnt` (`damage_font.png`) и `stats_font.fnt` через `Sprite2D` (`region_rect`) для устранения отката `Label` на системный шрифт.
  - `CharacterMenu.gd`: `SkillInfoPopup` по `mouse_entered`/`mouse_exited` на `FishingInfoBtn` и `ChoppingInfoBtn` с оригинальными текстами из `MainStarlingStage.as:2722,2725`.


## 21. Тайлсеты, метаданные переднего плана, интерактивные блоки монет (CoinBox) и строгая геометрия коллизий
- **Метаданные переднего плана (`themeFg`)**:
  - В картах `map_142.json`, `map_119.json`, `map_117.json`, `map_124.json`, `map_92.json` были ошибочно указаны внешние или чужие тайлсеты переднего плана.
  - По `AreaCreator.as:getAreaTheme` и `TileHandler.as:838-966`:
    - Stage 142 (Theme 29, Cloud Area): `themeFg = "CloudForegroundTiles"`.
    - Stage 119 (Theme 22, Mushroom House): `themeFg = "MushroomHouseForegroundTiles"`.
    - Stages 117, 124 (Theme 24, Robot House): `themeFg = "RobotHouseForegroundTiles"`.
    - Stage 92 (Theme 28, Aqua House): `themeFg = "AquaHouseForegroundTiles"`.
- **Интерактивные блоки монет (`GameWorld._spawn_coin_boxes`, `CoinBoxEntity`)**:
  - В `map_*.json` слои карты хранятся по пути `map_dict["layers"][layer_key]` (или `map_dict[layer_key]`) как одномерные плоские массивы целых чисел, а не двумерные матрицы `rows[r][c]`.
  - Метод `_spawn_coin_boxes` адаптирован под оба формата (1D с вычислением `c = idx % map_w, r = idx / map_w` и 2D) с дедупликацией по координатам.
  - Спавн `_spawn_coin_boxes()` перенесён после `_clear_level_entities()`, благодаря чему созданные экземпляры `CoinBoxEntity` не удаляются сразу при загрузке карты и корректно реагируют на удар снизу головой в прыжке (начисление монет, подпрыгивающий твин и SFX `coinBox`).
- **Строгая верификация коллизий тайлов (`TileMapRenderer.get_source_collision_shapes`)**:
  - Полное соответствие декомпилированному коду `TileHandler.as:617-738`:
    - Платформенные тайлы `[36, 44, 19, 78, 73, 14, 18, 16, 20, 30]` имеют одностороннюю коллизию платформы (`collision_layer = 8`, `one_way_collision = true`) на слоях `mapG2` и `mapG3`.
    - Твёрдые блоки `[38, 40, 72, 75, 77, 0, 25]`, боковые усечения `[48, 64, 50, 52]`, наклоны и полигоны `[62, 42, 54, 10, 55, 67, 22, 9, 21, 33]`, хитбокс CoinBox `[31]` и трубы биома 13 (`[95, 107, 119]`) коллидят на `mapMain` / `mapWater`.
    - Декоративные тайлы на `mapMain`, `mapG2`, `mapG3` и все тайлы `mapArt`/`mapFG` имеют ровно 0 физических коллизий, предотвращая создание ложных невидимых препятствий.
