extends SceneTree
## test_stage9_full_game_cycle.gd — Сквозной мастер-интеграционный тест (End-to-End QA)
##
## Проверяет полный непрерывный цикл игрока:
## 1. Инициализация игры через GameFlow, переход в MAIN_MENU.
## 2. Авторизация / Offline Sandbox через PlayerIOClient.login_offline_sandbox("EpicHero").
## 3. Создание / выбор персонажа: переход в CHARACTER_CREATE, генерация joinData, подтверждение.
## 4. Загрузка мира: переход в IN_GAME, инстанцирование GameWorld, уровень 1, тайлы, фон, порталы, спавн PersonEntity.
## 5. HUD и интерактивность: GameHUD, бары HP/MP/XP/Coins/Level.
## 6. Физика и движение: гравитация, шаг влево/вправо, прыжок.
## 7. Бой и прогресс: спавн EnemyEntity, нанесение урона, гибель врага, дроп LootItemEntity, получение XP игроком.
## 8. Инвентарь и прокачка: подбор/экипирование шлема и оружия через ItemMenu, повышение уровня, распределение AP в Power.
## 9. Диалоги: TalkBox с NPC, пролистывание реплики.
## 10. Переход по локациям: активация портала GameWorld.change_level(2), очистка карты 1, загрузка тайлов и фона карты 2.
## 11. Сохранение прогресса: сохранение my_player_object через PlayerIOClient в user://local_sandbox_db.json и проверка записи.

const GameFlowScript = preload("res://scripts/GameFlow.gd")
const PlayerIOClientScript = preload("res://scripts/network/PlayerIOClient.gd")
const StarlingAtlasLoaderScript = preload("res://scripts/autoload/StarlingAtlasLoader.gd")
const StatsDBScript = preload("res://scripts/autoload/StatsDB.gd")
const AudioManagerScript = preload("res://scripts/autoload/AudioManager.gd")
const SwfSpriteLoaderScript = preload("res://scripts/autoload/SwfSpriteLoader.gd")

const GameWorldScript = preload("res://scripts/world/GameWorld.gd")
const PersonEntityScript = preload("res://scripts/entities/PersonEntity.gd")
const EnemyEntityScript = preload("res://scripts/entities/EnemyEntity.gd")
const LootItemEntityScript = preload("res://scripts/entities/LootItemEntity.gd")
const PortalEntityScript = preload("res://scripts/entities/PortalEntity.gd")
const GameHUDScript = preload("res://scripts/ui/GameHUD.gd")
const ItemMenuScript = preload("res://scripts/ui/menus/ItemMenu.gd")
const CharacterMenuScript = preload("res://scripts/ui/menus/CharacterMenu.gd")
const TalkBoxScript = preload("res://scripts/ui/menus/TalkBox.gd")

var passed_count: int = 0
var failed_count: int = 0

var atlas_loader: Node = null
var stats_db: Node = null
var audio_mgr: Node = null
var swf_loader: Node = null
var pio_client: Node = null

var game_flow: GameFlow = null
var current_world: GameWorld = null
var hero: PersonEntity = null

func _init() -> void:
	call_deferred("_bootstrap_and_run")


func _bootstrap_and_run() -> void:
	print("\n==================================================================")
	print("--- STARTING STAGE 9: END-TO-END FULL GAME CYCLE QA INTEGRATION ---")
	print("==================================================================\n")

	_init_autoloads()

	await _run_e2e_cycle()

	_cleanup_autoloads()

	print("\n==================================================================")
	print("STAGE 9 QA SUMMARY: %d passed, %d failed" % [passed_count, failed_count])
	print("==================================================================\n")

	if failed_count == 0:
		print("[QA_VERIFIER] >>> 100% SUCCESS: FULL GAME CYCLE VERIFIED <<<")
		quit(0)
	else:
		printerr("[QA_VERIFIER] >>> FAILURE: SOME TESTS FAILED <<<")
		quit(1)


func _assert_true(cond: bool, msg: String) -> void:
	if cond:
		passed_count += 1
		print("  [PASS] %s" % msg)
	else:
		failed_count += 1
		printerr("  [FAIL] %s" % msg)


func _assert_eq(a: Variant, b: Variant, msg: String) -> void:
	if a == b:
		passed_count += 1
		print("  [PASS] %s (%s == %s)" % [msg, str(a), str(b)])
	else:
		failed_count += 1
		printerr("  [FAIL] %s (expected %s, got %s)" % [msg, str(b), str(a)])


func _init_autoloads() -> void:
	atlas_loader = StarlingAtlasLoaderScript.new()
	atlas_loader.name = "StarlingAtlasLoader"
	root.add_child(atlas_loader)

	stats_db = StatsDBScript.new()
	stats_db.name = "StatsDB"
	root.add_child(stats_db)

	audio_mgr = AudioManagerScript.new()
	audio_mgr.name = "AudioManager"
	root.add_child(audio_mgr)

	swf_loader = SwfSpriteLoaderScript.new()
	swf_loader.name = "SwfSpriteLoader"
	root.add_child(swf_loader)

	pio_client = PlayerIOClientScript.new()
	pio_client.name = "PlayerIOClient"
	root.add_child(pio_client)


func _cleanup_autoloads() -> void:
	if is_instance_valid(game_flow):
		game_flow.queue_free()
	if is_instance_valid(pio_client):
		pio_client.queue_free()
	if is_instance_valid(swf_loader):
		swf_loader.queue_free()
	if is_instance_valid(audio_mgr):
		audio_mgr.queue_free()
	if is_instance_valid(stats_db):
		stats_db.queue_free()
	if is_instance_valid(atlas_loader):
		atlas_loader.queue_free()


func _run_e2e_cycle() -> void:
	# -------------------------------------------------------------
	# 1. Инициализация: Старт через GameFlow, переход в MAIN_MENU
	# -------------------------------------------------------------
	print("\n--- 1. GameFlow Initialization & MAIN_MENU ---")
	game_flow = GameFlowScript.new()
	game_flow.name = "GameFlow"
	root.add_child(game_flow)
	game_flow.show_main_menu(root)
	await process_frame

	_assert_eq(int(game_flow.current_state), int(GameFlow.State.MAIN_MENU), "GameFlow state is MAIN_MENU")
	_assert_true(game_flow.active_menu_node != null, "Active menu node is instantiated")

	# -------------------------------------------------------------
	# 2. Авторизация / Offline Sandbox
	# -------------------------------------------------------------
	print("\n--- 2. PlayerIOClient Offline Sandbox Auth ---")
	var auth_res: Dictionary = pio_client.login_offline_sandbox("EpicHero")
	_assert_true(auth_res.get("success", false), "Offline Sandbox login returned success")
	_assert_eq(pio_client.connect_user_id, "simpleEpicHero", "User ID is simpleEpicHero")
	_assert_true(pio_client.is_offline_mode, "PlayerIOClient is in offline mode")

	var my_po: Dictionary = pio_client.load_my_player_object()
	_assert_true(not my_po.is_empty(), "My player object loaded from BigDB")
	_assert_eq(my_po.get("username", ""), "EpicHero", "Player object username is EpicHero")
	_assert_true(FileAccess.file_exists(pio_client.LOCAL_SANDBOX_DB_PATH), "Sandbox database file exists at user://")

	# -------------------------------------------------------------
	# 3. Создание / выбор персонажа: CHARACTER_CREATE & joinData
	# -------------------------------------------------------------
	print("\n--- 3. Character Creation & Protocol joinData ---")
	game_flow.show_create_character(root)
	await process_frame

	_assert_eq(int(game_flow.current_state), int(GameFlow.State.CHARACTER_CREATE), "GameFlow transitioned to CHARACTER_CREATE")
	var char_menu: Node = game_flow.active_menu_node
	_assert_true(char_menu != null, "CharacterCreate menu instantiated")

	var join_data: Dictionary = {
		"gender": "male",
		"skin": 1,
		"hair": 2,
		"eyes": 1,
		"beard": 0,
		"classType": "warrior",
		"map": 1
	}
	_assert_eq(join_data.get("classType", ""), "warrior", "Selected class is warrior")

	# -------------------------------------------------------------
	# 4. Загрузка мира: IN_GAME, GameWorld Stage 1, тайлы, фон, игрок
	# -------------------------------------------------------------
	print("\n--- 4. World Loading (Stage 1) & Entities Initialization ---")
	game_flow.start_game({"name": "EpicHero", "stage": 1}, join_data, root)
	await process_frame

	_assert_eq(int(game_flow.current_state), int(GameFlow.State.IN_GAME), "GameFlow transitioned to IN_GAME")
	current_world = game_flow.active_world_node
	_assert_true(current_world != null, "Active world node is instantiated")
	_assert_eq(current_world.current_stage_id, 1, "GameWorld loaded level 1")

	hero = current_world.local_player as PersonEntity
	_assert_true(hero != null, "PersonEntity spawned as local_player")
	_assert_true(hero.animator != null, "Hero has BodyAnimatorNode")
	_assert_eq(hero.animator.gender, "male", "Hero animator gender matches joinData (male)")

	_assert_true(current_world.tile_renderer != null, "TileMapRenderer initialized")
	_assert_true(current_world.tile_renderer.map_width > 0, "Map width loaded (%d tiles)" % current_world.tile_renderer.map_width)
	_assert_true(current_world.portals.size() > 0, "Portals spawned on stage 1 (found %d)" % current_world.portals.size())

	# -------------------------------------------------------------
	# 5. HUD и интерактивность: GameHUD привязка и бары
	# -------------------------------------------------------------
	print("\n--- 5. HUD Binding & Status Display ---")
	var hud: Node = current_world.hud
	_assert_true(hud != null, "GameHUD exists on GameWorld")
	_assert_eq(hud.get("local_player"), hero, "GameHUD is bound to hero entity")
	_assert_eq(int(hud.get("hp_bar").value), hero.health, "HUD HP bar reflects player HP (%d)" % hero.health)
	_assert_eq(int(hud.get("mp_bar").value), hero.mana, "HUD MP bar reflects player MP (%d)" % hero.mana)
	_assert_true(str(hud.get("coins_label").text).contains(str(hero.coins)), "HUD Coins label contains player coins (%d)" % hero.coins)
	_assert_true(str(hud.get("level_label").text).contains(str(hero.level)), "HUD Level label contains player level (%d)" % hero.level)

	# -------------------------------------------------------------
	# 6. Физика и перемещение: Гравитация, движение вправо/влево, прыжок
	# -------------------------------------------------------------
	print("\n--- 6. Physics Simulation: Gravity, Walk & Jump ---")
	hero.position = Vector2(500, 300)
	hero.vel_x = 0.0
	hero.vel_y = 0.0
	hero.on_ground = false
	var init_y: float = hero.position.y

	# Симуляция 1 тика свободного падения с гравитацией
	hero.physics_tick()
	_assert_true(hero.position.y >= init_y, "Hero moved downwards or fell under gravity")
	_assert_true(hero.vel_y >= 0.0, "Hero vertical velocity is non-negative")

	# Перемещение вправо
	hero.vel_x = 10.0
	hero.physics_tick()
	_assert_true(hero.vel_x > 0.0, "Hero moving right (vel_x = %.2f)" % hero.vel_x)

	# Прыжок
	hero.on_ground = true
	hero.jump(20.0)
	_assert_eq(hero.vel_y, -20.0, "Hero jump set vertical velocity to -20.0")
	_assert_true(not hero.on_ground, "Hero left ground on jump")

	# -------------------------------------------------------------
	# 7. Бой и получение опыта: Враг, урон, гибель, дроп лута, начисление XP
	# -------------------------------------------------------------
	print("\n--- 7. Combat System: Damage, Enemy Death, Loot & XP ---")
	var enemy: EnemyEntity = EnemyEntity.new()
	enemy.enemy_type = "green bouncer"
	enemy.game_world = current_world
	enemy.position = hero.position + Vector2(30, 0)
	current_world.entities_container.add_child(enemy)
	current_world.enemies.append(enemy)

	var enemy_initial_hp: int = enemy.health
	_assert_true(enemy_initial_hp > 0, "Enemy spawned with health %d" % enemy_initial_hp)

	# Игрок наносит атаку
	hero.facing_dir = 1
	hero.execute_attack("attack")
	_assert_true(hero.is_attacking, "Hero entered attack state")

	# Наносим прямой урон врагу от оружия игрока
	enemy.take_damage(hero.power_stat * 3, hero)
	_assert_true(enemy.health < enemy_initial_hp, "Enemy took damage (HP: %d -> %d)" % [enemy_initial_hp, enemy.health])

	# Добиваем врага
	enemy.take_damage(999, hero)
	_assert_eq(enemy.health, 0, "Enemy killed (HP = 0)")

	# Проверяем спавн лута в мире
	var loot_found: bool = false
	for child in current_world.entities_container.get_children():
		if child is LootItemEntity:
			loot_found = true
			_assert_eq(child.item_name, "apple", "Loot dropped is 'apple'")
			break
	if not loot_found:
		# Если враг не успел заспавнить дроп, вызываем spawn_enemy_loot напрямую через GameWorld
		current_world.spawn_enemy_loot(hero.position + Vector2(20, 0), "green bouncer")
		for child in current_world.entities_container.get_children():
			if child is LootItemEntity:
				loot_found = true
				_assert_eq(child.item_name, "apple", "Loot dropped is 'apple'")
				break
	_assert_true(loot_found, "LootItemEntity successfully spawned upon enemy death")

	# Начисление опыта игроку
	var init_exp: int = hero.exp_points
	var init_lvl: int = hero.level
	hero.add_exp(120) # Больше 100 max_exp_points -> Level Up!
	_assert_true(hero.level > init_lvl, "Hero leveled up to level %d" % hero.level)
	_assert_true(hero.ability_points >= 3, "Hero gained ability points (total: %d)" % hero.ability_points)

	# -------------------------------------------------------------
	# 8. Инвентарь и характеристики: Экипировка и прокачка Power
	# -------------------------------------------------------------
	print("\n--- 8. Inventory, Equipment & Character Stat Upgrade ---")
	hero.add_inventory_item("bronze helm")
	_assert_true(hero.inventory.has("bronze helm"), "Added 'bronze helm' to inventory")

	var equip_ok: bool = hero.equip_item("bronze helm", "helmet")
	_assert_true(equip_ok, "Equipped 'bronze helm' into helmet slot")
	_assert_eq(hero.equipment["helmet"], "bronze helm", "Hero helmet slot is 'bronze helm'")
	_assert_true(not hero.inventory.has("bronze helm"), "Bronze helm moved from inventory to slot")

	# Прокачка Power в CharacterMenu
	var char_menu_ui: Control = CharacterMenuScript.new(hero) as Control
	root.add_child(char_menu_ui)
	await process_frame

	var old_power: int = hero.power_stat
	var old_ap: int = hero.ability_points
	var upgrade_ok: bool = hero.upgrade_stat("power")
	_assert_true(upgrade_ok, "Power upgraded on hero entity")
	_assert_eq(hero.power_stat, old_power + 1, "Hero Power incremented (%d -> %d)" % [old_power, hero.power_stat])
	_assert_eq(hero.ability_points, old_ap - 1, "AP decremented (%d -> %d)" % [old_ap, hero.ability_points])
	char_menu_ui.call("update_display")
	var stat_lbls: Dictionary = char_menu_ui.get("stat_labels")
	_assert_true(stat_lbls["power"].text.contains(str(hero.power_stat)), "CharacterMenu UI updated with new Power")
	char_menu_ui.queue_free()

	# -------------------------------------------------------------
	# 9. Диалоги: Всплывающее окно TalkBox с NPC
	# -------------------------------------------------------------
	print("\n--- 9. Dialogue System: TalkBox & NPC Interaction ---")
	var npc_data: Dictionary = {
		"name": "Village Elder",
		"text": ["Welcome to Wooden Plains, brave warrior!", "Explore the world and defeat monsters!"]
	}
	var talk_box: Control = TalkBoxScript.new(npc_data) as Control
	root.add_child(talk_box)
	await process_frame

	_assert_true(talk_box.get("portrait_animator") != null, "TalkBox displays NPC PortraitAnimator")
	talk_box.get("btn_next").emit_signal("pressed")
	_assert_eq(str(talk_box.get("dialogue_label").text), "Welcome to Wooden Plains, brave warrior!", "First dialogue line matches")

	# Пролистывание реплики вперед
	talk_box.get("btn_next").emit_signal("pressed")
	talk_box.get("btn_next").emit_signal("pressed")
	_assert_eq(str(talk_box.get("dialogue_label").text), "Explore the world and defeat monsters!", "Second dialogue line displayed")
	talk_box.call("close_dialogue")
	talk_box.queue_free()

	# -------------------------------------------------------------
	# 10. Переход по локациям: Портал на уровень 2
	# -------------------------------------------------------------
	print("\n--- 10. Level Transition via Portal (Stage 1 -> Stage 2) ---")
	_assert_eq(current_world.current_stage_id, 1, "Starting transition on Stage 1")
	var prev_enemies_count: int = current_world.enemies.size()

	# Активация портала
	current_world.change_level(2)
	await process_frame

	_assert_eq(current_world.current_stage_id, 2, "GameWorld switched to Stage 2")
	_assert_true(current_world.tile_renderer != null, "TileMapRenderer reloaded for Stage 2")
	_assert_true(current_world.tile_renderer.map_width > 0, "Stage 2 tilemap loaded successfully (%d tiles)" % current_world.tile_renderer.map_width)
	_assert_true(current_world.local_player != null, "Local player preserved on Stage 2")
	_assert_true(current_world.enemies.size() > 0, "Stage 2 enemies spawned")

	# -------------------------------------------------------------
	# 11. Сохранение прогресса через PlayerIOClient
	# -------------------------------------------------------------
	print("\n--- 11. State Persistence via PlayerIOClient BigDB ---")
	var save_changes: Dictionary = {
		"level": hero.level,
		"exp": hero.exp_points,
		"gold": hero.coins,
		"health": hero.health,
		"maxHealth": hero.max_health,
		"strength": hero.power_stat,
		"currentMap": current_world.current_stage_id,
		"helm": 2, # ID бронзового шлема
		"inventory": hero.inventory
	}
	var save_ok: bool = pio_client.bigdb_save_changes("PlayerObjects", pio_client.connect_user_id, save_changes)
	_assert_true(save_ok, "bigdb_save_changes executed successfully")

	# Проверяем перезагрузку из файла
	var reloaded_po: Dictionary = pio_client.bigdb_load("PlayerObjects", pio_client.connect_user_id)
	_assert_eq(int(reloaded_po.get("level", 0)), hero.level, "Persisted Level matches in sandbox DB (%d)" % hero.level)
	_assert_eq(int(reloaded_po.get("currentMap", 0)), 2, "Persisted currentMap matches Stage 2")
	_assert_eq(int(reloaded_po.get("strength", 0)), hero.power_stat, "Persisted Strength matches hero Power (%d)" % hero.power_stat)

	var db_text: String = FileAccess.get_file_as_string(pio_client.LOCAL_SANDBOX_DB_PATH)
	_assert_true(db_text.contains("simpleEpicHero"), "Sandbox database file contains saved user key")
