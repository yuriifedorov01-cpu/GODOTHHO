extends SceneTree
## test_stage8_ui_and_menus.gd — Комплексный автономный тест Этапа 8:
## 1. Инстанцирование GameHUD и всех его элементов (HP/MP/XP/Energy бары, монеты, чат, кнопки меню).
## 2. Реакция HUD на сигналы PersonEntity: изменение HP, MP, XP, Rage, Coins.
## 3. Открытие и закрытие окон CharacterMenu, ItemMenu, SkillsMenu, MapMenu, MissionMenu, TalkBox.
## 4. Экипирование предмета из инвентаря в соответствующий слот в ItemMenu и снятие.
## 5. Прокачка стата в CharacterMenu при наличии AP (Ability Points).
## 6. Отправка и отображение сообщения в чате LineEdit/RichTextLabel.
## 7. Интеграция GameHUD с GameWorld.

const StarlingAtlasLoaderScript = preload("res://scripts/autoload/StarlingAtlasLoader.gd")
const StatsDBScript = preload("res://scripts/autoload/StatsDB.gd")
const AudioManagerScript = preload("res://scripts/autoload/AudioManager.gd")
const SwfSpriteLoaderScript = preload("res://scripts/autoload/SwfSpriteLoader.gd")

const PersonEntityScript = preload("res://scripts/entities/PersonEntity.gd")
const GameHUDScript = preload("res://scripts/ui/GameHUD.gd")
const CharacterMenuScript = preload("res://scripts/ui/menus/CharacterMenu.gd")
const ItemMenuScript = preload("res://scripts/ui/menus/ItemMenu.gd")
const SkillsMenuScript = preload("res://scripts/ui/menus/SkillsMenu.gd")
const MapMenuScript = preload("res://scripts/ui/menus/MapMenu.gd")
const MissionMenuScript = preload("res://scripts/ui/menus/MissionMenu.gd")
const TalkBoxScript = preload("res://scripts/ui/menus/TalkBox.gd")
const GameWorldScript = preload("res://scripts/world/GameWorld.gd")

var passed_count: int = 0
var failed_count: int = 0

var atlas_loader: Node = null
var stats_db: Node = null
var audio_mgr: Node = null
var swf_loader: Node = null

func _init() -> void:
	call_deferred("_bootstrap_and_run")


func _bootstrap_and_run() -> void:
	print("\n=======================================================")
	print("--- STARTING STAGE 8 TEST: UI, HUD & MENUS ---")
	print("=======================================================\n")

	# Инициализация Autoload синглтонов
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

	_run_all_tests()

	print("\n=======================================================")
	print("STAGE 8 TEST SUMMARY: %d passed, %d failed" % [passed_count, failed_count])
	print("=======================================================\n")
	quit(0 if failed_count == 0 else 1)


func assert_true(cond: bool, msg: String) -> void:
	if cond:
		passed_count += 1
		print("[PASS] %s" % msg)
	else:
		failed_count += 1
		printerr("[FAIL] %s" % msg)


func assert_eq(a: Variant, b: Variant, msg: String) -> void:
	if a == b:
		passed_count += 1
		print("[PASS] %s (expected %s, got %s)" % [msg, str(b), str(a)])
	else:
		failed_count += 1
		printerr("[FAIL] %s (expected %s, got %s)" % [msg, str(b), str(a)])


func _run_all_tests() -> void:
	_test_1_hud_instantiation()
	_test_2_hud_reactive_signals()
	_test_3_menu_windows_open_close()
	_test_4_inventory_and_equipment()
	_test_5_character_menu_stat_upgrade()
	_test_6_skills_menu_and_map_menu()
	_test_7_talkbox_and_missions()
	_test_8_chat_submission()
	_test_9_gameworld_hud_integration()


func _test_1_hud_instantiation() -> void:
	print("\n--- Test 1: GameHUD Instantiation & Visual Elements ---")
	var hud: Node = GameHUDScript.new()
	root.add_child(hud)

	assert_true(hud.get("hp_bar") != null, "HP Bar created")
	assert_true(hud.get("mp_bar") != null, "MP Bar created")
	assert_true(hud.get("xp_bar") != null, "XP Bar created")
	assert_true(hud.get("energy_bar") == null, "No invented Energy Bar on HUD")
	assert_true(hud.get("coins_label") != null, "Coins Label created")
	assert_true(hud.get("chat_log") != null, "Chat Log created")
	assert_true(hud.get("chat_input") != null, "Chat Input LineEdit created")
	assert_true(hud.get("btn_char") != null, "Character button created")
	assert_true(hud.get("btn_items") != null, "Items button created")
	assert_true(hud.get("btn_skills") != null, "Skills button created")
	assert_true(hud.get("btn_map") != null, "Map button created")

	hud.queue_free()


func _test_2_hud_reactive_signals() -> void:
	print("\n--- Test 2: HUD Reactivity to Player Signals ---")
	var hud: Node = GameHUDScript.new()
	root.add_child(hud)

	var player: Node = PersonEntityScript.new()
	root.add_child(player)

	hud.call("bind_player", player)

	var hp_bar: Control = hud.get("hp_bar") as Control
	var mp_bar: Control = hud.get("mp_bar") as Control
	var coins_lbl: Label = hud.get("coins_label") as Label
	var lvl_lbl: Label = hud.get("level_label") as Label

	# Проверяем начальные значения
	assert_eq(int(hp_bar.get("value")), 100, "Initial HP bar value is 100")
	assert_eq(int(mp_bar.get("value")), 0, "Initial MP bar value is 0")
	assert_eq(coins_lbl.text, "Money: $0", "Initial Coins label is Money: $0")

	# Наносим урон игроку
	player.call("take_damage", 30)
	assert_true(int(hp_bar.get("value")) < 100, "HP bar updated on take_damage: %d" % int(hp_bar.get("value")))

	# Тратим ману (выдаём магу 20 MP или выставляем для проверки HUD)
	player.set("max_mana", 50)
	player.set("mana", 50)
	var mp_spent: bool = bool(player.call("use_mp", 20))
	assert_true(mp_spent, "Player spent MP successfully")
	assert_eq(int(mp_bar.get("value")), 30, "MP bar updated to 30")

	# Добавляем монет
	player.call("add_coins", 250)
	assert_eq(coins_lbl.text, "Money: $250", "Coins label updated to Money: $250")

	# Набираем опыт и проверяем ап уровня
	player.call("add_exp", 120)
	assert_eq(int(player.get("level")), 2, "Player reached Level 2")
	assert_eq(lvl_lbl.text, "Lvl 2", "Level label updated to Lvl 2")

	hud.queue_free()
	player.queue_free()


func _test_3_menu_windows_open_close() -> void:
	print("\n--- Test 3: Menu Windows Toggle and Visibility ---")
	var hud: Node = GameHUDScript.new()
	root.add_child(hud)

	var char_menu: Control = hud.get("character_menu") as Control
	var item_menu: Control = hud.get("item_menu") as Control
	var skills_menu: Control = hud.get("skills_menu") as Control
	var map_menu: Control = hud.get("map_menu") as Control

	assert_true(not char_menu.visible, "CharacterMenu is initially hidden")
	hud.call("toggle_character_menu")
	assert_true(char_menu.visible, "CharacterMenu visible after toggle")
	hud.call("toggle_character_menu")
	assert_true(not char_menu.visible, "CharacterMenu hidden after second toggle")

	assert_true(not item_menu.visible, "ItemMenu is initially hidden")
	hud.call("toggle_item_menu")
	assert_true(item_menu.visible, "ItemMenu visible after toggle")
	hud.call("toggle_item_menu")
	assert_true(not item_menu.visible, "ItemMenu hidden after second toggle")

	assert_true(not skills_menu.visible, "SkillsMenu is initially hidden")
	hud.call("toggle_skills_menu")
	assert_true(skills_menu.visible, "SkillsMenu visible after toggle")
	hud.call("toggle_skills_menu")
	assert_true(not skills_menu.visible, "SkillsMenu hidden after second toggle")

	assert_true(not map_menu.visible, "MapMenu is initially hidden")
	hud.call("toggle_map_menu")
	assert_true(map_menu.visible, "MapMenu visible after toggle")
	hud.call("toggle_map_menu")
	assert_true(not map_menu.visible, "MapMenu hidden after second toggle")

	hud.queue_free()


func _test_4_inventory_and_equipment() -> void:
	print("\n--- Test 4: Inventory & Equipment Manipulation in ItemMenu ---")
	var player: Node = PersonEntityScript.new()
	root.add_child(player)

	player.set("inventory", ["archer hat", "blue jeans", "short sword", "apple"])
	player.set("equipment", {
		"helmet": "",
		"shirt": "",
		"legs": "",
		"shoes": "",
		"weapon": "",
		"weapon2": "",
		"accessory": ""
	})

	var item_menu: Node = ItemMenuScript.new(player)
	root.add_child(item_menu)

	# Проверяем ограничение по требуемому уровню (archer hat lvl=5) и затем экипируем
	var equip_low_lvl: bool = bool(player.call("equip_item", "archer hat", "helmet"))
	assert_true(not equip_low_lvl and str(player.get("last_equip_error")).contains("5"), "Level 1 player cannot equip lvl-5 'archer hat'")
	player.set("level", 5)

	# Экипируем archer hat в слот helmet
	var equip_ok: bool = bool(player.call("equip_item", "archer hat", "helmet"))
	assert_true(equip_ok, "Equip item 'archer hat' returned true")
	var eq_dict: Dictionary = player.get("equipment")
	assert_eq(eq_dict["helmet"], "archer hat", "Helmet slot contains 'archer hat'")
	var inv_arr: Array = player.get("inventory")
	assert_true(not inv_arr.has("archer hat"), "Archer hat removed from inventory")

	# Снимаем archer hat обратно в инвентарь
	var unequip_ok: bool = bool(player.call("unequip_item", "helmet"))
	assert_true(unequip_ok, "Unequip helmet slot returned true")
	eq_dict = player.get("equipment")
	assert_eq(eq_dict["helmet"], "", "Helmet slot is empty now")
	inv_arr = player.get("inventory")
	assert_true(inv_arr.has("archer hat"), "Archer hat returned to inventory")

	# Использование расходника
	player.set("health", 40)
	player.call("use_item", "apple")
	assert_eq(int(player.get("health")), 90, "Player healed to 90 HP after eating apple")
	inv_arr = player.get("inventory")
	assert_true(not inv_arr.has("apple"), "Apple consumed from bag")

	item_menu.queue_free()
	player.queue_free()


func _test_5_character_menu_stat_upgrade() -> void:
	print("\n--- Test 5: Stat Upgrading in CharacterMenu ---")
	var player: Node = PersonEntityScript.new()
	root.add_child(player)

	player.set("ability_points", 5)
	player.set("power_stat", 10)
	player.set("dex_stat", 8)

	var char_menu: Node = CharacterMenuScript.new(player)
	root.add_child(char_menu)

	# Прокачиваем Power
	var up_pow: bool = bool(player.call("upgrade_stat", "power"))
	assert_true(up_pow, "Power stat upgrade successful")
	assert_eq(int(player.get("power_stat")), 11, "Power stat incremented to 11")
	assert_eq(int(player.get("ability_points")), 4, "AP decreased to 4")

	# Прокачиваем Dexterity
	var up_dex: bool = bool(player.call("upgrade_stat", "dex"))
	assert_true(up_dex, "Dex stat upgrade successful")
	assert_eq(int(player.get("dex_stat")), 9, "Dexterity stat incremented to 9")
	assert_eq(int(player.get("ability_points")), 3, "AP decreased to 3")

	char_menu.call("update_display")
	var stat_lbls: Dictionary = char_menu.get("stat_labels")
	assert_true(stat_lbls["power"].text.contains("11"), "CharacterMenu shows Power: 11")
	assert_true(stat_lbls["dexterity"].text.contains("9"), "CharacterMenu shows Dexterity: 9")

	char_menu.queue_free()
	player.queue_free()


func _test_6_skills_menu_and_map_menu() -> void:
	print("\n--- Test 6: SkillsMenu Categories & MapMenu Areas ---")
	var player: Node = PersonEntityScript.new()
	root.add_child(player)
	player.set("skill_points", 3)

	var skills_menu: Node = SkillsMenuScript.new(player)
	root.add_child(skills_menu)

	var tab_cnt: TabContainer = skills_menu.get("tab_container") as TabContainer
	assert_eq(tab_cnt.get_tab_count(), 5, "SkillsMenu has 5 class tabs")
	assert_true(tab_cnt.has_node("Basic"), "Basic skills tab exists")
	assert_true(tab_cnt.has_node("Warrior"), "Warrior skills tab exists")
	assert_true(tab_cnt.has_node("Archer"), "Archer skills tab exists")

	# Проверяем MapMenu
	var map_menu: Node = MapMenuScript.new(1)
	root.add_child(map_menu)
	var area_btns: Dictionary = map_menu.get("area_buttons")
	assert_true(area_btns.has(1), "MapMenu initially unlocks Stage 1 button")
	assert_true(not area_btns.has(55), "MapMenu does not show locked Stage 55 initially")
	map_menu.call("reveal_all_map")
	area_btns = map_menu.get("area_buttons")
	assert_true(area_btns.has(1), "MapMenu has Stage 1 button after reveal")
	assert_true(area_btns.has(2), "MapMenu has Stage 2 button after reveal")
	assert_true(area_btns.has(55), "MapMenu has Stage 55 button after reveal")

	map_menu.call("set_current_area", 2)
	var area_info: Label = map_menu.get("area_info_label") as Label
	assert_true(area_info.text.contains("Stage 2"), "MapMenu updated to Stage 2")

	skills_menu.queue_free()
	map_menu.queue_free()
	player.queue_free()


func _test_7_talkbox_and_missions() -> void:
	print("\n--- Test 7: TalkBox Dialogue & MissionMenu List ---")
	var talk_box: Node = TalkBoxScript.new()
	root.add_child(talk_box)

	var npc_sample: Dictionary = {
		"name": "Elder Ronald",
		"text": ["Welcome to Wooden Plains!", "Beware of the angry monsters nearby."],
		"items": ["apple", "short sword"]
	}

	talk_box.call("start_dialogue", npc_sample)
	var portrait: Node2D = talk_box.get("portrait_animator") as Node2D
	var dlg_lbl: Label = talk_box.get("dialogue_label") as Label
	var btn_shop: BaseButton = talk_box.get("btn_shop") as BaseButton

	assert_true(portrait != null, "TalkBox displays NPC PortraitAnimator")
	talk_box.call("_on_next_pressed") # finish typewriter
	assert_eq(dlg_lbl.text, "Welcome to Wooden Plains!", "First line displayed")
	assert_true(btn_shop.visible, "Shop button is visible for vendor NPC")

	# Переход на следующую строку
	talk_box.call("_on_next_pressed")
	talk_box.call("_on_next_pressed") # finish typewriter
	assert_eq(dlg_lbl.text, "Beware of the angry monsters nearby.", "Second line displayed")

	var pio: Node = root.get_node_or_null("PlayerIOClient")
	var prev_missions: Variant = null
	if pio != null and pio.get("my_player_object") is Dictionary:
		prev_missions = pio.my_player_object.get("missions", null)
		pio.my_player_object["missions"] = ["The Black Hooded Hatchet"]

	var mission_menu: Node = MissionMenuScript.new()
	root.add_child(mission_menu)
	var m_container: VBoxContainer = mission_menu.get("mission_list_container") as VBoxContainer
	assert_true(m_container.get_child_count() > 0, "MissionMenu populated with active profile missions")

	if pio != null and pio.get("my_player_object") is Dictionary:
		if prev_missions == null:
			pio.my_player_object.erase("missions")
		else:
			pio.my_player_object["missions"] = prev_missions

	talk_box.queue_free()
	mission_menu.queue_free()


func _test_8_chat_submission() -> void:
	print("\n--- Test 8: Chat Log and Message Submission ---")
	var hud: Node = GameHUDScript.new()
	root.add_child(hud)

	var player: Node = PersonEntityScript.new()
	player.set("character_name", "HeroTester")
	root.add_child(player)

	hud.call("bind_player", player)

	var chat_received: Array = [""]
	hud.connect("chat_message_submitted", func(msg: String) -> void: chat_received[0] = msg)

	hud.call("_on_chat_submitted", "Hello World from Stage 8!")
	assert_eq(chat_received[0], "Hello World from Stage 8!", "chat_message_submitted signal emitted with text")
	var history: Array = hud.get("chat_log_history")
	var found_msg: bool = false
	for entry in history:
		if str(entry).contains("Hello World from Stage 8!") and str(entry).contains("HeroTester"):
			found_msg = true
			break
	assert_true(found_msg, "Chat log history updated with message and sender name")

	hud.queue_free()
	player.queue_free()


func _test_9_gameworld_hud_integration() -> void:
	print("\n--- Test 9: GameWorld HUD Integration ---")
	var world: Node = GameWorldScript.new()
	world.set("current_stage_id", 1)
	root.add_child(world)

	var hud_node: Node = world.get("hud") as Node
	var local_p: Node = world.get("local_player") as Node

	assert_true(hud_node != null, "GameWorld spawned GameHUD instance")
	assert_true(local_p != null, "GameWorld spawned local_player")
	assert_eq(hud_node.get("local_player"), local_p, "GameHUD bound to GameWorld local_player")

	world.queue_free()
