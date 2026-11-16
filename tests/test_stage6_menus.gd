extends SceneTree
## test_stage6_menus.gd — Модульный тест Этапа 6 (Главное меню, авторизация и создание персонажа)

const MainMenuUIScript = preload("res://scripts/menus/MainMenuUI.gd")
const CreateCharacterMenuScript = preload("res://scripts/menus/CreateCharacterMenu.gd")
const GameFlowScript = preload("res://scripts/GameFlow.gd")
const PlayerIOClientScript = preload("res://scripts/network/PlayerIOClient.gd")
const StarlingAtlasLoaderScript = preload("res://scripts/autoload/StarlingAtlasLoader.gd")
const StatsDBScript = preload("res://scripts/autoload/StatsDB.gd")

var passed_count: int = 0
var failed_count: int = 0

var pio_singleton: Node = null
var atlas_singleton: Node = null
var stats_singleton: Node = null

# Флаги для сигналов
var signal_game_started_fired: bool = false
var signal_game_started_user: Dictionary = {}
var signal_sandbox_requested_fired: bool = false

func _init() -> void:
	print("=================================================================")
	print("[STAGE 6 TEST SUITE] Starting MainMenu & CharacterCreation tests...")
	print("=================================================================")

	call_deferred("_run_all_tests")


func _run_all_tests() -> void:
	_setup_singletons()

	await _test_main_menu_instantiation()
	await _test_main_menu_panels_and_servers()
	await _test_character_create_instantiation()
	await _test_character_create_cycle_and_join_data()
	await _test_game_flow_navigation()
	await _test_offline_sandbox_login_transition()

	_teardown_singletons()

	print("=================================================================")
	print("[STAGE 6 TEST SUITE] Finished | Passed: %d | Failed: %d" % [passed_count, failed_count])
	print("=================================================================")

	if failed_count == 0:
		print("ALL STAGE 6 TESTS COMPLETED SUCCESSFULLY!")
		quit(0)
	else:
		printerr("STAGE 6 TESTS FAILED!")
		quit(1)


func _setup_singletons() -> void:
	if not root.has_node("StarlingAtlasLoader"):
		atlas_singleton = StarlingAtlasLoaderScript.new()
		atlas_singleton.name = "StarlingAtlasLoader"
		root.add_child(atlas_singleton)

	if not root.has_node("StatsDB"):
		stats_singleton = StatsDBScript.new()
		stats_singleton.name = "StatsDB"
		root.add_child(stats_singleton)

	if not root.has_node("PlayerIOClient"):
		pio_singleton = PlayerIOClientScript.new()
		pio_singleton.name = "PlayerIOClient"
		root.add_child(pio_singleton)


func _teardown_singletons() -> void:
	if pio_singleton and is_instance_valid(pio_singleton):
		pio_singleton.queue_free()
	if stats_singleton and is_instance_valid(stats_singleton):
		stats_singleton.queue_free()
	if atlas_singleton and is_instance_valid(atlas_singleton):
		atlas_singleton.queue_free()


func _assert_true(cond: bool, msg: String) -> void:
	if cond:
		passed_count += 1
		print("  [PASS] %s" % msg)
	else:
		failed_count += 1
		printerr("  [FAIL] %s" % msg)


func _test_main_menu_instantiation() -> void:
	print("\n--- 1. Testing MainMenu scene instantiation & nodes ---")
	var scene: PackedScene = load("res://scenes/menus/MainMenu.tscn")
	_assert_true(scene != null, "MainMenu.tscn loaded successfully")

	var menu: Node = scene.instantiate()
	_assert_true(menu != null, "MainMenuUI instantiated as Control")
	root.add_child(menu)
	await process_frame

	_assert_true(menu.login_panel != null and menu.login_panel.visible, "LoginPanel visible by default")
	_assert_true(menu.register_panel != null and not menu.register_panel.visible, "RegisterPanel hidden by default")
	_assert_true(menu.recover_panel != null and not menu.recover_panel.visible, "RecoverPanel hidden by default")

	menu.queue_free()
	await process_frame


func _test_main_menu_panels_and_servers() -> void:
	print("\n--- 2. Testing MainMenu panel switching and server list ---")
	var scene: PackedScene = load("res://scenes/menus/MainMenu.tscn")
	var menu: Node = scene.instantiate()
	root.add_child(menu)
	await process_frame

	menu.show_panel("register")
	_assert_true(menu.register_panel.visible and not menu.login_panel.visible, "show_panel('register') switches active panel")

	menu.show_panel("recover")
	_assert_true(menu.recover_panel.visible and not menu.register_panel.visible, "show_panel('recover') switches active panel")

	menu.show_panel("login")
	_assert_true(menu.login_panel.visible, "show_panel('login') switches back to login")

	_assert_true(menu.available_servers.size() >= 2, "Available servers include Pve Server and PvP Server")
	_assert_true(menu.get_selected_server() == "Pve Server", "Default selected server is Pve Server")

	menu.queue_free()
	await process_frame


func _test_character_create_instantiation() -> void:
	print("\n--- 3. Testing CreateCharacterMenu instantiation & preview ---")
	var scene: PackedScene = load("res://scenes/menus/CreateCharacterMenu.tscn")
	_assert_true(scene != null, "CreateCharacterMenu.tscn loaded successfully")

	var char_menu: Node = scene.instantiate()
	root.add_child(char_menu)
	await process_frame

	_assert_true(char_menu.selected_gender == "boy", "Default gender is boy")
	_assert_true(char_menu.selected_skin == 1, "Default skin is 1 (pale)")
	_assert_true(char_menu.selected_class == "warrior", "Default class is warrior")
	_assert_true(char_menu.preview_head != null and char_menu.preview_head.texture != null, "Head texture initialized from atlas")

	char_menu.queue_free()
	await process_frame


func _test_character_create_cycle_and_join_data() -> void:
	print("\n--- 4. Testing CreateCharacter parameter cycling & joinData schema ---")
	var scene: PackedScene = load("res://scenes/menus/CreateCharacterMenu.tscn")
	var char_menu: Node = scene.instantiate()
	root.add_child(char_menu)
	await process_frame

	# 1. Смена пола
	char_menu._cycle_gender(1)
	_assert_true(char_menu.selected_gender == "girl", "Gender cycled to girl")
	_assert_true(char_menu.selected_eyes == 7, "Girl default eyes is 7")
	_assert_true(not char_menu.beard_box.visible, "Beard controls hidden for girl")

	# 2. Смена цвета кожи
	char_menu._cycle_skin(1)
	_assert_true(char_menu.selected_skin == 2, "Skin cycled to 2 (peach)")

	# 3. Смена класса
	char_menu._cycle_class(1)
	_assert_true(char_menu.selected_class == "archer", "Class cycled to archer")

	char_menu.character_name = "SirTest"
	var jd: Dictionary = char_menu.build_join_data()

	# Проверяем соответствие ARCHITECTURE_MAP.md разд. 1.4:
	# skin для girl = selected_skin + 4 (2 + 4 = 6)
	_assert_true(jd.get("skin") == 6, "Girl skin mapped to skin+4 (6)")
	_assert_true(jd.get("eyes") == 7, "Eyes match selected eyes")
	_assert_true(jd.get("classType") == "archer", "ClassType is archer")
	_assert_true(jd.get("username") == "SirTest", "Username is SirTest")
	_assert_true(jd.has("url") and jd.has("onPlayerIO"), "joinData contains required protocol flags")

	char_menu.queue_free()
	await process_frame


func _on_game_started_received(u: Dictionary, _j: Dictionary) -> void:
	signal_game_started_fired = true
	signal_game_started_user = u


func _test_game_flow_navigation() -> void:
	print("\n--- 5. Testing GameFlow navigation states ---")
	var flow: Node = GameFlowScript.new()
	var test_container: Node = Node.new()
	root.add_child(test_container)

	flow.setup_flow(test_container)
	await process_frame

	_assert_true(flow.current_state == 0, "Initial state is MAIN_MENU (0)")
	_assert_true(flow.active_menu_node != null, "Active menu is MainMenuUI")

	flow.show_create_character(test_container)
	await process_frame
	_assert_true(flow.current_state == 1, "Switched state to CHARACTER_CREATE (1)")
	_assert_true(flow.active_menu_node != null, "Active menu is CreateCharacterMenu")

	signal_game_started_fired = false
	signal_game_started_user = {}
	flow.game_started.connect(_on_game_started_received)
	flow.start_game({"name": "TestHero", "stage": 1}, {"classType": "warrior"})

	_assert_true(flow.current_state == 2, "Switched state to IN_GAME (2)")
	_assert_true(flow.active_menu_node == null, "Active menu cleared in IN_GAME")
	_assert_true(signal_game_started_fired, "game_started signal fired")
	_assert_true(signal_game_started_user.get("name") == "TestHero", "user_data propagated correctly")

	test_container.queue_free()
	await process_frame


func _on_sandbox_requested_received() -> void:
	signal_sandbox_requested_fired = true


func _test_offline_sandbox_login_transition() -> void:
	print("\n--- 6. Testing Offline Sandbox login flow ---")
	var had_save: bool = FileAccess.file_exists(GameFlow.LAST_SANDBOX_CHAR_PATH)
	var backup_save: String = ""
	if had_save:
		var rf := FileAccess.open(GameFlow.LAST_SANDBOX_CHAR_PATH, FileAccess.READ)
		if rf != null:
			backup_save = rf.get_as_text()
			rf.close()
	GameFlow.clear_last_sandbox_character()

	var scene: PackedScene = load("res://scenes/menus/MainMenu.tscn")
	var menu: Node = scene.instantiate()
	root.add_child(menu)
	await process_frame

	signal_sandbox_requested_fired = false
	menu.offline_sandbox_requested.connect(_on_sandbox_requested_received)

	var pio: Node = root.get_node("PlayerIOClient")

	menu.login_user_input.text = "SandboxTester"
	await menu._on_offline_pressed()

	_assert_true(signal_sandbox_requested_fired, "offline_sandbox_requested signal triggered")
	_assert_true(pio.is_offline_mode, "PlayerIOClient switched to offline mode")
	_assert_true(pio.connect_user_id == "simpleSandboxTester", "PlayerIOClient connect_user_id set to simpleSandboxTester")

	menu.queue_free()
	await process_frame

	GameFlow.clear_last_sandbox_character()
	if had_save and not backup_save.is_empty():
		var wf := FileAccess.open(GameFlow.LAST_SANDBOX_CHAR_PATH, FileAccess.WRITE)
		if wf != null:
			wf.store_string(backup_save)
			wf.close()
