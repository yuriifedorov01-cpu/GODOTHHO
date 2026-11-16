extends Node
class_name GameFlow
## GameFlow — Менеджер состояний игры: Главное меню -> Создание персонажа -> Игровой мир.

const LAST_SANDBOX_CHAR_PATH: String = "user://last_sandbox_character.json"

enum State {
	MAIN_MENU,
	CHARACTER_CREATE,
	IN_GAME
}

var current_state: State = State.MAIN_MENU

var main_menu_scene: PackedScene = preload("res://scenes/menus/MainMenu.tscn")
var create_char_scene: PackedScene = preload("res://scenes/menus/CreateCharacterMenu.tscn")
var game_world_scene: PackedScene = preload("res://scenes/world/GameWorld.tscn")

var active_menu_node: Control = null
var active_world_node: GameWorld = null
var current_user_data: Dictionary = {}
var is_sandbox_session: bool = false

signal state_changed(new_state: State)
signal game_started(user_data: Dictionary, join_data: Dictionary)


func _ready() -> void:
	add_to_group("game_flow")


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_EXIT_TREE:
		save_active_sandbox_character()


static func has_last_sandbox_character() -> bool:
	if not FileAccess.file_exists(LAST_SANDBOX_CHAR_PATH):
		return false
	return not load_last_sandbox_character().is_empty()


static func load_last_sandbox_character() -> Dictionary:
	if not FileAccess.file_exists(LAST_SANDBOX_CHAR_PATH):
		return {}
	var file := FileAccess.open(LAST_SANDBOX_CHAR_PATH, FileAccess.READ)
	if file == null:
		return {}
	var text: String = file.get_as_text()
	file.close()
	if text.strip_edges().is_empty():
		return {}
	var parsed: Variant = JSON.parse_string(text)
	if not (parsed is Dictionary):
		return {}
	var dict: Dictionary = parsed as Dictionary
	var uname: String = str(dict.get("username", dict.get("name", ""))).strip_edges()
	var cls: String = str(dict.get("classType", dict.get("character_class", ""))).strip_edges()
	if uname.is_empty() and cls.is_empty():
		return {}
	return dict


static func save_last_sandbox_character_data(data: Dictionary) -> void:
	if data.is_empty():
		return
	var file := FileAccess.open(LAST_SANDBOX_CHAR_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify(data, "\t"))
	file.close()


static func clear_last_sandbox_character() -> void:
	if FileAccess.file_exists(LAST_SANDBOX_CHAR_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(LAST_SANDBOX_CHAR_PATH))


func setup_flow(root_node: Node) -> void:
	if get_parent() == null:
		root_node.add_child(self)
	show_main_menu(root_node)


func show_main_menu(parent_node: Node = null) -> void:
	var target_parent: Node = parent_node if parent_node != null else get_parent()
	_clear_active_menu()
	_clear_active_world()

	is_sandbox_session = false
	current_state = State.MAIN_MENU
	var menu: Control = main_menu_scene.instantiate() as Control
	active_menu_node = menu
	target_parent.add_child(menu)

	menu.character_create_requested.connect(func() -> void: show_create_character(target_parent, false))
	menu.offline_sandbox_requested.connect(func() -> void: _on_offline_sandbox_requested(target_parent))
	if menu.has_signal("offline_sandbox_continue_requested"):
		menu.offline_sandbox_continue_requested.connect(func(saved_data: Dictionary) -> void:
			_start_sandbox_continue(saved_data, target_parent)
		)
	menu.enter_game_requested.connect(func(user_data: Dictionary) -> void:
		current_user_data = user_data
		start_game(user_data, {}, target_parent)
	)
	state_changed.emit(current_state)


func _on_offline_sandbox_requested(parent_node: Node = null) -> void:
	is_sandbox_session = true
	show_create_character(parent_node, true)


func show_create_character(parent_node: Node = null, sandbox_mode: bool = false) -> void:
	var target_parent: Node = parent_node if parent_node != null else get_parent()
	_clear_active_menu()
	_clear_active_world()

	if sandbox_mode:
		is_sandbox_session = true
	current_state = State.CHARACTER_CREATE
	var create_menu: Control = create_char_scene.instantiate() as Control
	if "is_sandbox_mode" in create_menu:
		create_menu.set("is_sandbox_mode", sandbox_mode)
	active_menu_node = create_menu
	target_parent.add_child(create_menu)
	if create_menu.has_method("set_sandbox_mode"):
		create_menu.call("set_sandbox_mode", sandbox_mode)

	create_menu.back_to_main_menu.connect(func() -> void: show_main_menu(target_parent))
	create_menu.character_created.connect(func(join_data: Dictionary) -> void:
		if sandbox_mode:
			_start_sandbox_game(join_data, target_parent)
		else:
			start_game(current_user_data, join_data, target_parent)
	)
	state_changed.emit(current_state)


func _start_sandbox_game(char_data: Dictionary, parent_node: Node = null) -> void:
	is_sandbox_session = true
	var pio: Node = get_node_or_null("/root/PlayerIOClient")
	if pio == null and Engine.has_singleton("PlayerIOClient"):
		pio = Engine.get_singleton("PlayerIOClient")
	if pio != null:
		var po: Variant = pio.get("my_player_object")
		if po is Dictionary:
			po["stage"] = 1
			po["currentMap"] = 1
			po["unlockedMaps"] = [1]
		var pm: Variant = pio.get("my_player_misc")
		if pm is Dictionary:
			pm["maps"] = [1]
	var sandbox_user_data: Dictionary = {
		"name": str(char_data.get("username", "Hero")),
		"username": str(char_data.get("username", "Hero")),
		"skin": int(char_data.get("skin", 1)),
		"eyes": int(char_data.get("eyes", 1)),
		"hair": int(char_data.get("hair", 1)),
		"beard": int(char_data.get("beard", 1)),
		"gender": str(char_data.get("gender", "male")),
		"classType": str(char_data.get("classType", "warrior")),
		"stage": 1
	}
	current_user_data = sandbox_user_data
	start_game(sandbox_user_data, char_data, parent_node)


func _start_sandbox_continue(saved_data: Dictionary, parent_node: Node = null) -> void:
	var data: Dictionary = saved_data if not saved_data.is_empty() else load_last_sandbox_character()
	if data.is_empty():
		_on_offline_sandbox_requested(parent_node)
		return

	is_sandbox_session = true
	var uname: String = str(data.get("username", data.get("name", "Hero"))).strip_edges()
	if uname.is_empty():
		uname = "Hero"

	var pio: Node = get_node_or_null("/root/PlayerIOClient")
	if pio == null and Engine.has_singleton("PlayerIOClient"):
		pio = Engine.get_singleton("PlayerIOClient")
	if pio != null and pio.has_method("login_offline_sandbox"):
		pio.login_offline_sandbox(uname)

	var saved_stage: int = maxi(1, int(data.get("stage", 1)))
	var unlocked_arr: Array = []
	var raw_unlocked: Variant = data.get("unlocked_maps", [])
	if raw_unlocked is Array:
		for m: Variant in raw_unlocked:
			var sid: int = int(m)
			if sid > 0 and not unlocked_arr.has(sid):
				unlocked_arr.append(sid)
	if not unlocked_arr.has(saved_stage):
		unlocked_arr.append(saved_stage)
	if not unlocked_arr.has(1):
		unlocked_arr.append(1)

	var enemy_arr: Array = []
	var raw_enemies: Variant = data.get("enemy_list", [])
	if raw_enemies is Array:
		for e: Variant in raw_enemies:
			var es: String = str(e).strip_edges()
			if not es.is_empty() and not enemy_arr.has(es):
				enemy_arr.append(es)

	if pio != null:
		var po: Variant = pio.get("my_player_object")
		if po is Dictionary:
			po["stage"] = saved_stage
			po["currentMap"] = saved_stage
			po["unlockedMaps"] = unlocked_arr.duplicate()
			po["enemyList"] = ",".join(enemy_arr)
			po["coins"] = int(data.get("coins", 0))
		var pm: Variant = pio.get("my_player_misc")
		if pm is Dictionary:
			pm["maps"] = unlocked_arr.duplicate()

	var restore_data: Dictionary = data.duplicate(true)
	restore_data["is_sandbox_restore"] = true
	restore_data["username"] = uname
	restore_data["name"] = uname
	restore_data["stage"] = saved_stage

	current_user_data = restore_data.duplicate(true)
	start_game(restore_data, restore_data, parent_node)


func start_game(user_data: Dictionary, join_data: Dictionary, parent_node: Node = null) -> void:
	var target_parent: Node = parent_node if parent_node != null else get_parent()
	_clear_active_menu()
	_clear_active_world()

	current_state = State.IN_GAME
	print("[GameFlow] Starting game with user_data keys: %s, join_data: %s" % [str(user_data.keys()), str(join_data)])

	var start_stage: int = int(user_data.get("stage", join_data.get("stage", 1)))
	if start_stage <= 0:
		start_stage = 1

	# Инстанцируем игровой мир
	var world: GameWorld = game_world_scene.instantiate() as GameWorld
	world.current_stage_id = start_stage
	active_world_node = world
	target_parent.add_child(world)

	if world.current_map_dict.is_empty() or world.current_stage_id != start_stage:
		world.load_level(start_stage)

	if world.local_player != null:
		_apply_player_appearance_and_gear(world.local_player, user_data, join_data)
		_connect_sandbox_autosave(world, world.local_player)
		if is_sandbox_session:
			save_active_sandbox_character()

	game_started.emit(user_data, join_data)
	state_changed.emit(current_state)


func _connect_sandbox_autosave(world: GameWorld, player: PersonEntity) -> void:
	if not is_sandbox_session:
		return
	var save_cb := Callable(self, "save_active_sandbox_character")
	if world != null and world.has_signal("level_loaded") and not world.level_loaded.is_connected(_on_sandbox_world_event):
		world.level_loaded.connect(_on_sandbox_world_event)
	if player != null:
		if player.has_signal("stats_updated") and not player.stats_updated.is_connected(save_cb):
			player.stats_updated.connect(save_cb)
		if player.has_signal("inventory_updated") and not player.inventory_updated.is_connected(save_cb):
			player.inventory_updated.connect(save_cb)
		if player.has_signal("coins_changed") and not player.coins_changed.is_connected(_on_sandbox_coins_changed):
			player.coins_changed.connect(_on_sandbox_coins_changed)
		if player.has_signal("exp_changed") and not player.exp_changed.is_connected(_on_sandbox_exp_changed):
			player.exp_changed.connect(_on_sandbox_exp_changed)


func _on_sandbox_world_event(_stage_id: int) -> void:
	save_active_sandbox_character()


func _on_sandbox_coins_changed(_new_coins: int) -> void:
	save_active_sandbox_character()


func _on_sandbox_exp_changed(_new_exp: int, _max_exp: int, _current_lvl: int) -> void:
	save_active_sandbox_character()


func build_sandbox_character_snapshot() -> Dictionary:
	if active_world_node == null or not is_instance_valid(active_world_node):
		return {}
	var player: PersonEntity = active_world_node.local_player as PersonEntity
	if player == null or not is_instance_valid(player):
		return {}

	var p_name: String = player.character_name.strip_edges()
	if p_name.is_empty():
		p_name = str(current_user_data.get("username", current_user_data.get("name", "Hero")))

	var p_class: String = player.character_class.strip_edges().to_lower()
	if p_class.is_empty():
		p_class = str(current_user_data.get("classType", "warrior")).strip_edges().to_lower()

	var p_gender: String = "male"
	var p_skin: int = 1
	var p_eyes: int = 1
	var p_hair: int = 1
	var p_beard: int = 0
	if player.animator != null:
		p_gender = str(player.animator.gender)
		p_skin = int(player.animator.skin_id)
		p_eyes = int(player.animator.eyes_id)
		p_hair = int(player.animator.hair_id)
		p_beard = int(player.animator.beard_id)
	else:
		p_gender = str(current_user_data.get("gender", "male"))
		p_skin = int(current_user_data.get("skin", 1))
		p_eyes = int(current_user_data.get("eyes", 1))
		p_hair = int(current_user_data.get("hair", 1))
		p_beard = int(current_user_data.get("beard", 0))

	var stage_id: int = maxi(1, int(active_world_node.current_stage_id))
	var unlocked_maps: Array = []
	var enemy_list: Array = []

	var pio: Node = get_node_or_null("/root/PlayerIOClient")
	if pio == null and Engine.has_singleton("PlayerIOClient"):
		pio = Engine.get_singleton("PlayerIOClient")
	if pio != null:
		var pm: Variant = pio.get("my_player_misc")
		if pm is Dictionary and pm.get("maps") is Array:
			for m: Variant in pm["maps"]:
				var sid: int = int(m)
				if sid > 0 and not unlocked_maps.has(sid):
					unlocked_maps.append(sid)
		var po: Variant = pio.get("my_player_object")
		if po is Dictionary:
			if po.get("unlockedMaps") is Array:
				for m: Variant in po["unlockedMaps"]:
					var sid: int = int(m)
					if sid > 0 and not unlocked_maps.has(sid):
						unlocked_maps.append(sid)
			var raw_enemies: Variant = po.get("enemyList", "")
			if raw_enemies is String and not raw_enemies.is_empty():
				for part: String in raw_enemies.split(",", false):
					var clean: String = part.strip_edges()
					if not clean.is_empty() and not enemy_arr_has(enemy_list, clean):
						enemy_list.append(clean)
			elif raw_enemies is Array:
				for e: Variant in raw_enemies:
					var clean: String = str(e).strip_edges()
					if not clean.is_empty() and not enemy_list.has(clean):
						enemy_list.append(clean)

	if not unlocked_maps.has(stage_id):
		unlocked_maps.append(stage_id)

	var skill_dict: Dictionary = {}
	for k: Variant in player.skill_levels.keys():
		skill_dict[str(k)] = int(player.skill_levels[k])

	var eq_dict: Dictionary = {}
	for slot: Variant in player.equipment.keys():
		eq_dict[str(slot)] = str(player.equipment[slot])

	var inv_arr: Array = []
	for item_name: String in player.inventory:
		inv_arr.append(item_name)

	var orb_dict: Dictionary = player.get_orb_bonuses() if player.has_method("get_orb_bonuses") else player.orb_bonuses.duplicate()

	return {
		"username": p_name,
		"name": p_name,
		"classType": p_class,
		"character_class": p_class,
		"gender": p_gender,
		"skin": p_skin,
		"eyes": p_eyes,
		"hair": p_hair,
		"beard": p_beard,
		"stage": stage_id,
		"unlocked_maps": unlocked_maps,
		"enemy_list": enemy_list,
		"level": int(player.level),
		"exp": int(player.exp_points),
		"max_exp": int(player.max_exp_points),
		"coins": int(player.coins),
		"power_stat": int(player.power_stat),
		"dex_stat": int(player.dex_stat),
		"def_stat": int(player.def_stat),
		"range_stat": int(player.range_stat),
		"magic_stat": int(player.magic_stat),
		"artillery_stat": int(player.artillery_stat),
		"max_health": int(player.max_health),
		"health": int(player.health),
		"max_mana": int(player.max_mana),
		"mana": int(player.mana),
		"ability_points": int(player.ability_points),
		"skill_points": int(player.skill_points),
		"skill_levels": skill_dict,
		"dash_lvl": int(player.dash_lvl),
		"accel_down_lvl": int(player.accel_down_lvl),
		"shield_mastery_lvl": int(player.shield_mastery_lvl),
		"equipment": eq_dict,
		"inventory": inv_arr,
		"orb_bonuses": orb_dict
	}


static func enemy_arr_has(arr: Array, value: String) -> bool:
	return arr.has(value)


func save_active_sandbox_character() -> void:
	if not is_sandbox_session or current_state != State.IN_GAME:
		return
	var snap: Dictionary = build_sandbox_character_snapshot()
	if not snap.is_empty():
		save_last_sandbox_character_data(snap)


func _apply_player_appearance_and_gear(player: PersonEntity, user_data: Dictionary, join_data: Dictionary) -> void:
	var src: Dictionary = join_data if not join_data.is_empty() else user_data
	var is_saved_restore: bool = (src.get("is_sandbox_restore") == true) or (user_data.get("is_sandbox_restore") == true)
	var pname: String = str(src.get("username", src.get("name", user_data.get("name", "")))).strip_edges()
	if not pname.is_empty():
		player.character_name = pname

	# Декодирование пола и оттенка кожи (GameMain.as:648, 3761-3762)
	var raw_skin: int = int(src.get("skin", user_data.get("skin", 1)))
	var decoded_gender: String = "male"
	var decoded_skin: int = raw_skin
	var explicit_gender: String = str(src.get("gender", user_data.get("gender", ""))).strip_edges().to_lower()
	if not explicit_gender.is_empty():
		if explicit_gender == "girl":
			decoded_gender = "female"
		elif explicit_gender == "boy":
			decoded_gender = "male"
		else:
			decoded_gender = explicit_gender
	elif raw_skin > 4:
		decoded_gender = "female" if raw_skin != 9 else "male"
		decoded_skin = raw_skin - 4

	var class_type: String = str(src.get("classType", user_data.get("classType", "warrior"))).strip_edges().to_lower()
	if player.has_method("apply_class_starter_stats"):
		player.call("apply_class_starter_stats", class_type)

	# Инвентарь из src / user_data, если есть
	var saved_inv: Variant = src.get("inventory", user_data.get("inventory", null))
	if saved_inv is Array:
		if is_saved_restore:
			player.inventory.clear()
		for item_v: Variant in saved_inv:
			var item_s: String = str(item_v).strip_edges()
			if not item_s.is_empty():
				player.inventory.append(item_s)
	elif saved_inv is String and not str(saved_inv).strip_edges().is_empty():
		for item_s: String in str(saved_inv).split(","):
			var trimmed: String = item_s.strip_edges()
			if not trimmed.is_empty():
				player.inventory.append(trimmed)

	# Экипировка из src / user_data, если есть
	var has_saved_eq: bool = false
	var saved_eq: Variant = src.get("equipment", user_data.get("equipment", null))
	if saved_eq is Dictionary:
		for slot_key: String in player.equipment.keys():
			var eq_val: String = str(saved_eq.get(slot_key, "")).strip_edges()
			if eq_val == "none" or eq_val == "nothing":
				eq_val = ""
			if is_saved_restore:
				player.equipment[slot_key] = eq_val
				has_saved_eq = true
			elif not eq_val.is_empty():
				player.equipment[slot_key] = eq_val
				has_saved_eq = true

	# Стартовая экипировка нового персонажа (CreateMenu.as:347-408, GameMain.as:579-593)
	if not is_saved_restore and not has_saved_eq and player.inventory.is_empty():
		var starter_weapon: String = "stick"
		match class_type:
			"warrior":
				starter_weapon = "stick"
			"archer":
				starter_weapon = "slingshot"
			"mage", "wizard":
				starter_weapon = "basic wand"
			"cowboy":
				starter_weapon = "airsoft gun"
		player.equipment["shirt"] = "white shirt"
		player.equipment["legs"] = "green shorts"
		player.equipment["shoes"] = "white shoe"
		player.equipment["weapon"] = starter_weapon

	# Полное восстановление сохранённого прогресса Sandbox-персонажа
	if is_saved_restore:
		player.level = maxi(1, int(src.get("level", player.level)))
		player.exp_points = maxi(0, int(src.get("exp", player.exp_points)))
		player.max_exp_points = maxi(1, int(src.get("max_exp", player.max_exp_points)))
		player.coins = maxi(0, int(src.get("coins", player.coins)))
		player.power_stat = int(src.get("power_stat", player.power_stat))
		player.dex_stat = int(src.get("dex_stat", player.dex_stat))
		player.def_stat = int(src.get("def_stat", player.def_stat))
		player.range_stat = int(src.get("range_stat", player.range_stat))
		player.magic_stat = int(src.get("magic_stat", player.magic_stat))
		player.artillery_stat = int(src.get("artillery_stat", player.artillery_stat))
		player.ability_points = maxi(0, int(src.get("ability_points", player.ability_points)))
		player.skill_points = maxi(0, int(src.get("skill_points", player.skill_points)))

		var saved_skills: Variant = src.get("skill_levels", null)
		if saved_skills is Dictionary:
			player.skill_levels = (saved_skills as Dictionary).duplicate(true)
		player.dash_lvl = int(src.get("dash_lvl", player.get_skill_level("speed dash") if player.has_method("get_skill_level") else player.dash_lvl))
		player.accel_down_lvl = int(src.get("accel_down_lvl", player.get_skill_level("accel down") if player.has_method("get_skill_level") else player.accel_down_lvl))
		player.shield_mastery_lvl = int(src.get("shield_mastery_lvl", player.get_skill_level("shield mastery") if player.has_method("get_skill_level") else player.shield_mastery_lvl))

		var saved_orbs: Variant = src.get("orb_bonuses", null)
		if saved_orbs is Dictionary:
			for ok: String in ["pow", "rng", "mgc", "art"]:
				player.orb_bonuses[ok] = int((saved_orbs as Dictionary).get(ok, 0))

		player._calc_stats()
		player.max_health = maxi(1, int(src.get("max_health", player.max_health)))
		player.health = clampi(int(src.get("health", player.max_health)), 1, player.max_health)
		player.max_mana = maxi(0, int(src.get("max_mana", player.max_mana)))
		player.mana = clampi(int(src.get("mana", player.max_mana)), 0, player.max_mana)

	if player.animator != null:
		var p_anim: BodyAnimatorNode = player.animator
		p_anim.gender = decoded_gender
		p_anim.skin_id = decoded_skin
		p_anim.eyes_id = int(src.get("eyes", src.get("eye", user_data.get("eyes", user_data.get("eye", 1)))))
		p_anim.hair_id = int(src.get("hair", user_data.get("hair", 1)))
		p_anim.beard_id = int(src.get("beard", user_data.get("beard", 0)))
		p_anim.apply_equipment_from_person(player)

	player.health_changed.emit(player.health, player.max_health)
	player.mp_changed.emit(player.mana, player.max_mana)
	player.exp_changed.emit(player.exp_points, player.max_exp_points, player.level)
	player.coins_changed.emit(player.coins)
	player.inventory_updated.emit()
	player.stats_updated.emit()


func _clear_active_menu() -> void:
	if active_menu_node != null and is_instance_valid(active_menu_node):
		active_menu_node.queue_free()
		active_menu_node = null


func _clear_active_world() -> void:
	save_active_sandbox_character()
	if has_node("/root/AudioManager"):
		var am: Node = get_node("/root/AudioManager")
		if am.has_method("stop_music"):
			am.call("stop_music")
	if active_world_node != null and is_instance_valid(active_world_node):
		active_world_node.queue_free()
		active_world_node = null
