extends SceneTree
## test_ui_menus_flash_exact.gd — Тест UI и меню Helmet Heroes на соответствие Flash AS3:
## 1. OptionsMenu (слайдеры звука/музыки, кнопки качества, полноэкранный режим, ignore trades/PMs)
## 2. FriendsMenu (вкладки Friends/Guild/Ignore, список со статусами, добавление друга)
## 3. PetMenu (активный статус питомца, 8 слотов инвентаря, бары любви/HP/XP, кнопки)
## 4. CharacterMenu (размер 606x353, статы x=190, кнопки '+' x=340, AP x=65 y=248, Damage/Defense span x=376)
## 5. ItemMenu (размер 500x487, сетка 4x8 = 32 ячейки, Paperdoll слоты, отсутствие ': [Empty]')
## 6. GameHUD (привязка всех 7 кнопок верхнего бара, хоткей 'K' для SkillsMenu)

const StarlingAtlasLoaderScript = preload("res://scripts/autoload/StarlingAtlasLoader.gd")
const StatsDBScript = preload("res://scripts/autoload/StatsDB.gd")
const AudioManagerScript = preload("res://scripts/autoload/AudioManager.gd")
const PersonEntityScript = preload("res://scripts/entities/PersonEntity.gd")
const GameHUDScript = preload("res://scripts/ui/GameHUD.gd")
const OptionsMenuScript = preload("res://scripts/ui/menus/OptionsMenu.gd")
const FriendsMenuScript = preload("res://scripts/ui/menus/FriendsMenu.gd")
const PetMenuScript = preload("res://scripts/ui/menus/PetMenu.gd")
const CharacterMenuScript = preload("res://scripts/ui/menus/CharacterMenu.gd")
const ItemMenuScript = preload("res://scripts/ui/menus/ItemMenu.gd")
const SkillsMenuScript = preload("res://scripts/ui/menus/SkillsMenu.gd")

var passed_count: int = 0
var failed_count: int = 0

var atlas_loader: Node = null
var stats_db: Node = null
var audio_mgr: Node = null

func _init() -> void:
	call_deferred("_run_tests")


func assert_true(cond: bool, msg: String) -> void:
	if cond:
		passed_count += 1
		print("  [PASS] %s" % msg)
	else:
		failed_count += 1
		printerr("  [FAIL] %s" % msg)


func assert_eq(a: Variant, b: Variant, msg: String) -> void:
	if a == b:
		passed_count += 1
		print("  [PASS] %s (%s == %s)" % [msg, str(a), str(b)])
	else:
		failed_count += 1
		printerr("  [FAIL] %s (expected %s, got %s)" % [msg, str(b), str(a)])


func _run_tests() -> void:
	print("\n=======================================================")
	print("--- STARTING TEST: FLASH EXACT UI & MENUS VERIFICATION ---")
	print("=======================================================\n")

	if not root.has_node("StarlingAtlasLoader"):
		atlas_loader = StarlingAtlasLoaderScript.new()
		atlas_loader.name = "StarlingAtlasLoader"
		root.add_child(atlas_loader)

	if not root.has_node("StatsDB"):
		stats_db = StatsDBScript.new()
		stats_db.name = "StatsDB"
		root.add_child(stats_db)

	audio_mgr = AudioManagerScript.new()
	audio_mgr.name = "AudioManager"
	if not root.has_node("AudioManager"):
		root.add_child(audio_mgr)

	_test_options_menu()
	_test_friends_menu()
	_test_pet_menu()
	_test_character_menu_layout()
	_test_item_menu_layout()
	_test_game_hud_bindings()

	print("\n=======================================================")
	print("UI MENUS TEST SUMMARY: %d passed, %d failed" % [passed_count, failed_count])
	print("=======================================================\n")
	quit(0 if failed_count == 0 else 1)


func _test_options_menu() -> void:
	print("\n--- 1. Testing OptionsMenu ---")
	var opt: Node = OptionsMenuScript.new()
	root.add_child(opt)

	assert_true(opt.get("music_slider") != null, "Music slider exists")
	assert_true(opt.get("sfx_slider") != null, "SFX slider exists")
	assert_true(opt.get("fullscreen_btn") != null, "Fullscreen button exists")
	assert_true(opt.get("quality_low_btn") != null, "Quality LOW button exists")
	assert_true(opt.get("quality_med_btn") != null, "Quality MEDIUM button exists")
	assert_true(opt.get("quality_high_btn") != null, "Quality HIGH button exists")

	# Тестируем изменение слайдера музыки
	opt.call("_on_music_volume_changed", 0.45)
	var active_amgr: Node = root.get_node("AudioManager") if root.has_node("AudioManager") else audio_mgr
	assert_eq(snapped(active_amgr.get("music_volume"), 0.01), 0.45, "AudioManager music volume updated")

	# Тестируем переключение качества
	opt.call("_set_quality", "MEDIUM")
	assert_eq(opt.get("current_quality"), "MEDIUM", "Current quality set to MEDIUM")

	# Тестируем закрытие
	assert_true(opt.get("visible"), "OptionsMenu is visible initially")
	opt.call("close_menu")
	assert_true(not opt.get("visible"), "OptionsMenu hidden on close_menu")

	opt.queue_free()


func _test_friends_menu() -> void:
	print("\n--- 2. Testing FriendsMenu ---")
	var fm: Node = FriendsMenuScript.new()
	root.add_child(fm)

	assert_true(fm.get("btn_tab_friends") != null, "Friends tab button exists")
	assert_true(fm.get("btn_tab_guild") != null, "Guild tab button exists")
	assert_true(fm.get("btn_tab_ignore") != null, "Ignore tab button exists")
	assert_true(fm.get("add_input") != null, "Add friend LineEdit exists")
	assert_true(fm.get("btn_chat") != null, "Chat button exists")
	assert_true(fm.get("btn_unfriend") != null, "Unfriend button exists")

	# Переключение вкладки
	fm.call("_switch_tab", "GUILD")
	assert_eq(fm.get("current_tab"), "GUILD", "Switched to GUILD tab")
	fm.call("_switch_tab", "FRIENDS")
	assert_eq(fm.get("current_tab"), "FRIENDS", "Switched back to FRIENDS tab")

	# Добавление друга
	var init_friends_len: int = (fm.get("friends_data") as Array).size()
	fm.call("_add_friend_by_name", "GalahadTheBrave")
	var new_friends_len: int = (fm.get("friends_data") as Array).size()
	assert_eq(new_friends_len, init_friends_len + 1, "Friend successfully added to friends_data")

	fm.queue_free()


func _test_pet_menu() -> void:
	print("\n--- 3. Testing PetMenu ---")
	var pm: Node = PetMenuScript.new()
	root.add_child(pm)

	assert_true(pm.get("name_label") != null, "Pet name label exists")
	assert_true(pm.get("stats_label") != null, "Pet stats label exists")
	assert_true(pm.get("love_bar") != null, "Love bar exists")
	assert_true(pm.get("hp_bar") != null, "HP bar exists")
	assert_true(pm.get("xp_bar") != null, "XP bar exists")

	var slots: Array = pm.get("slot_panels")
	assert_eq(slots.size(), 8, "PetMenu has exactly 8 pet inventory slots")

	# Активация/деактивация питомца
	pm.call("_on_activate_clicked")
	var pets: Array = pm.get("pets_list")
	assert_true(bool(pets[0]["is_active"]), "First pet is active")

	pm.call("_on_withdraw_clicked")
	assert_true(not bool(pets[0]["is_active"]), "First pet withdrawn (inactive)")

	pm.queue_free()


func _test_character_menu_layout() -> void:
	print("\n--- 4. Testing CharacterMenu Exact Flash Layout ---")
	var player: Node = PersonEntityScript.new()
	root.add_child(player)

	var cm: Node = CharacterMenuScript.new(player)
	root.add_child(cm)

	# Проверка размера окна (606 x 353)
	assert_eq(cm.get("custom_minimum_size"), Vector2(606, 353), "CharacterMenu size matches Flash (606x353)")

	# Проверка отсутствия дублирующего заголовка
	assert_true(cm.get("title_label") == null, "Duplicate generic title_label was removed")

	# Проверка координат AP счетчика (Flash: x=65, y=248)
	var ap_lbl: Label = cm.get("ap_label") as Label
	assert_true(ap_lbl != null, "AP label exists")
	assert_eq(ap_lbl.position, Vector2(65, 248), "AP label aligned to Flash coordinates (65, 248)")

	# Проверка координат Damage span и Defense span (Flash: x=376, y=53 / y=101)
	var dmg_lbl: Label = cm.get("damage_span_label") as Label
	assert_true(dmg_lbl != null, "Damage span label exists")
	assert_eq(dmg_lbl.position, Vector2(376, 53), "Damage span aligned to Flash coordinates (376, 53)")

	var def_lbl: Label = cm.get("defense_span_label") as Label
	assert_true(def_lbl != null, "Defense span label exists")
	assert_eq(def_lbl.position, Vector2(376, 101), "Defense span aligned to Flash coordinates (376, 101)")

	# Проверка выравнивания меток статов (x=190) и кнопок '+' (x=340)
	var stat_lbls: Dictionary = cm.get("stat_labels")
	var plus_btns: Dictionary = cm.get("plus_buttons")

	for stat_id in ["power", "dexterity", "defense", "range", "magic", "artillery"]:
		assert_true(stat_lbls.has(stat_id), "Stat label '%s' exists" % stat_id)
		var lbl: Label = stat_lbls[stat_id]
		assert_eq(lbl.position.x, 190.0, "Stat label '%s' x position is 190" % stat_id)

		assert_true(plus_btns.has(stat_id), "Plus button '%s' exists" % stat_id)
		var btn: TextureButton = plus_btns[stat_id]
		assert_eq(btn.position.x, 340.0, "Plus button '%s' x position is 340" % stat_id)
		assert_eq(btn.position.y, lbl.position.y, "Plus button '%s' y matches stat label y" % stat_id)

	cm.queue_free()
	player.queue_free()


func _test_item_menu_layout() -> void:
	print("\n--- 5. Testing ItemMenu 4x8 Grid & Paperdoll Layout ---")
	var player: Node = PersonEntityScript.new()
	root.add_child(player)

	var im: Node = ItemMenuScript.new(player)
	root.add_child(im)

	# Проверка размера окна (500 x 487)
	assert_eq(im.get("custom_minimum_size"), Vector2(500, 487), "ItemMenu size matches Flash (500x487)")

	# Проверка 4x8 сетки инвентаря (32 ячейки)
	var inv_btns: Array = im.get("inventory_buttons")
	assert_eq(inv_btns.size(), 32, "Inventory has exactly 32 slots (4x8 grid)")

	var inv_grid: GridContainer = im.get("inventory_container") as GridContainer
	assert_true(inv_grid != null, "GridContainer exists")
	assert_eq(inv_grid.columns, 4, "Inventory grid has 4 columns")

	# Проверка Paperdoll слотов экипировки (helmet, shirt, legs, shoes, weapon, weapon2, accessory)
	var eq_btns: Dictionary = im.get("equip_buttons")
	var required_slots: Array[String] = ["helmet", "shirt", "legs", "shoes", "weapon", "weapon2", "accessory"]
	for slot_id in required_slots:
		assert_true(eq_btns.has(slot_id), "Paperdoll slot '%s' exists" % slot_id)
		var btn: Button = eq_btns[slot_id]
		assert_true(not btn.text.contains("[Empty]"), "Paperdoll slot '%s' does NOT contain ugly '[Empty]' text: '%s'" % [slot_id, btn.text])

	im.queue_free()
	player.queue_free()


func _test_game_hud_bindings() -> void:
	print("\n--- 6. Testing GameHUD Top-Right Buttons & Hotkey Wiring ---")
	var hud: Node = GameHUDScript.new()
	root.add_child(hud)

	# Проверка наличия всех кнопок
	assert_true(hud.get("btn_char") != null, "btn_char exists")
	assert_true(hud.get("btn_items") != null, "btn_items exists")
	assert_true(hud.get("btn_social") != null, "btn_social exists")
	assert_true(hud.get("btn_skills") != null, "btn_skills alias exists")
	assert_true(hud.get("btn_map") != null, "btn_map exists")
	assert_true(hud.get("btn_missions") != null, "btn_missions exists")
	assert_true(hud.get("btn_pets") != null, "btn_pets exists")
	assert_true(hud.get("btn_options") != null, "btn_options exists")

	# Проверка переключения FriendsMenu через toggle_friends_menu
	var fm: Control = hud.get("friends_menu") as Control
	assert_true(fm != null, "friends_menu exists on HUD")
	assert_true(not fm.visible, "friends_menu initially hidden")
	hud.call("toggle_friends_menu")
	assert_true(fm.visible, "friends_menu visible after toggle_friends_menu")
	hud.call("toggle_friends_menu")
	assert_true(not fm.visible, "friends_menu hidden after second toggle")

	# Проверка переключения PetMenu
	var pm: Control = hud.get("pet_menu") as Control
	assert_true(pm != null, "pet_menu exists on HUD")
	assert_true(not pm.visible, "pet_menu initially hidden")
	hud.call("toggle_pet_menu")
	assert_true(pm.visible, "pet_menu visible after toggle_pet_menu")
	hud.call("toggle_pet_menu")
	assert_true(not pm.visible, "pet_menu hidden after second toggle")

	# Проверка переключения OptionsMenu
	var opt: Control = hud.get("options_menu") as Control
	assert_true(opt != null, "options_menu exists on HUD")
	assert_true(not opt.visible, "options_menu initially hidden")
	hud.call("toggle_options_menu")
	assert_true(opt.visible, "options_menu visible after toggle_options_menu")
	hud.call("toggle_options_menu")
	assert_true(not opt.visible, "options_menu hidden after second toggle")

	# Проверка хоткея 'K' для SkillsMenu
	var sm: Control = hud.get("skills_menu") as Control
	assert_true(sm != null, "skills_menu exists on HUD")
	assert_true(not sm.visible, "skills_menu initially hidden")

	var key_k_event: InputEventKey = InputEventKey.new()
	key_k_event.keycode = KEY_K
	key_k_event.pressed = true
	hud.call("_unhandled_input", key_k_event)
	assert_true(sm.visible, "skills_menu visible after 'K' key event")

	hud.call("_unhandled_input", key_k_event)
	assert_true(not sm.visible, "skills_menu hidden after second 'K' key event")

	hud.queue_free()
