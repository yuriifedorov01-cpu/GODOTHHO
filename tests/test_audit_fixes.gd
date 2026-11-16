extends SceneTree
## Verification test for AS3-audited fixes:
## 1. CreateCharacterMenu layout, SWF textures, CenterPersonPreview scale & animation
## 2. Cowboy ("shoot gun") frame-exact firing, sRate hold, no double-shoot, upward skill gate
## 3. Archer ("shoot bow") frame-exact firing, ground/air movement rules
## 4. Sandbox return flow (GameHUD SandboxReturnBtn -> GameFlow -> CreateCharacterMenu -> new GameWorld)

const RangedProjectileType = preload("res://scripts/entities/RangedProjectile.gd")
const MagicProjectileType = preload("res://scripts/entities/MagicProjectile.gd")
const GameHUDType = preload("res://scripts/ui/GameHUD.gd")
const CharacterMenuType = preload("res://scripts/ui/menus/CharacterMenu.gd")
const ItemMenuType = preload("res://scripts/ui/menus/ItemMenu.gd")
const SkillsMenuType = preload("res://scripts/ui/menus/SkillsMenu.gd")
const MapMenuType = preload("res://scripts/ui/menus/MapMenu.gd")
const AdminMenuType = preload("res://scripts/ui/AdminMenu.gd")
const FixLogMenuType = preload("res://scripts/ui/FixLogMenu.gd")
const CoinBoxEntityType = preload("res://scripts/entities/CoinBoxEntity.gd")

var passed: int = 0
var failed: int = 0


func _assert(cond: bool, msg: String) -> void:
	if cond:
		print("  [PASS] %s" % msg)
		passed += 1
	else:
		push_error("  [FAIL] %s" % msg)
		print("  [FAIL] %s" % msg)
		failed += 1


func _init() -> void:
	print("\n=================================================================")
	print("[AUDIT FIXES VERIFICATION SUITE]")
	print("=================================================================")
	var had_user_save: bool = FileAccess.file_exists(GameFlow.LAST_SANDBOX_CHAR_PATH)
	var user_save_backup: String = ""
	if had_user_save:
		var rf := FileAccess.open(GameFlow.LAST_SANDBOX_CHAR_PATH, FileAccess.READ)
		if rf != null:
			user_save_backup = rf.get_as_text()
			rf.close()
	GameFlow.clear_last_sandbox_character()

	await process_frame
	await _test_create_character_menu()
	await _test_cowboy_combat()
	await _test_archer_combat()
	await _test_sandbox_return_flow()
	await _test_maps_portals_and_zones()
	await _test_admin_menu_items_mobs_and_filters()
	await _test_map_menu_and_space_focus_safety()
	await _test_mp_skills_and_consumables()
	await _test_cowboy_cooldown_and_dual_guns()
	await _test_magic_swing_and_projectile()
	await _test_dual_wield_crit_orb_mount_and_menus()
	await _test_sandbox_last_character_continue_flow()
	await _test_all_39_skills_functionality()
	await _test_audio_sliders_menu_music_and_admin_max_preset()
	await _test_enemy_hit_npcs_archer_filter_max_skills_and_dualhand()
	await _test_bug_report_feature()
	await _test_dash_dust_npc_alignment_enemy_hitboxes_and_admin_npc_tp()
	await _test_fix_log_and_draggable_windows()
	await _test_authentic_npc_talkbox_and_shop_menu()
	await _test_fix_log_size_enemy_speed_fall_vfx_and_weapon_sfx()
	await _test_talkbox_exit_wall_dust_camera_zoom_and_fix_tips()
	await _test_milestone1_tile_and_metadata_fixes()

	GameFlow.clear_last_sandbox_character()
	if had_user_save and not user_save_backup.is_empty():
		var wf := FileAccess.open(GameFlow.LAST_SANDBOX_CHAR_PATH, FileAccess.WRITE)
		if wf != null:
			wf.store_string(user_save_backup)
			wf.close()

	print("\n=================================================================")
	print("AUDIT FIXES SUMMARY: %d passed, %d failed" % [passed, failed])
	print("=================================================================")
	quit(1 if failed > 0 else 0)


func _test_create_character_menu() -> void:
	print("\n--- 1. CreateCharacterMenu AS3 Geometry, Textures & Animation ---")
	var scene: PackedScene = load("res://scenes/menus/CreateCharacterMenu.tscn")
	var menu: CreateCharacterMenu = scene.instantiate() as CreateCharacterMenu
	root.add_child(menu)
	await process_frame

	_assert(menu.non_change_frame.position == Vector2(-387, -320), "NonChangeFrame pos == (-387, -320)")
	_assert(menu.non_change_frame.size == Vector2(772, 550), "NonChangeFrame size == (772, 550)")
	_assert(menu.non_change_frame.z_index == 2, "NonChangeFrame z_index == 2")

	_assert(menu.preview_platform.position == Vector2(-230, -63), "Platform pos == (-230, -63)")
	_assert(menu.preview_platform.size == Vector2(77, 248), "Platform size == (77, 248)")
	_assert(menu.preview_platform.texture != null, "Platform has wooden platform texture")

	_assert(menu.center_person_holder.position == Vector2(-195, -85), "CenterPersonPreview pos == (-195, -85)")
	_assert(menu.center_person_holder.scale == Vector2(1, 1), "CenterPersonPreview scale == (1, 1)")
	_assert(menu.center_person_clone != null and menu.center_person_clone.current_anim_name == "standing", "CenterPersonClone playing 'standing'")

	var f0: int = menu.center_person_clone.current_frame
	menu._process(1.0 / 30.0 * 3.0)
	_assert(menu.center_person_clone.current_frame != f0, "CenterPersonClone advances standing frames over time")

	_assert(menu.left_person_holder.position == Vector2(-337, -92) and menu.left_person_holder.scale == Vector2(2, 2), "LeftPersonPreview pos/scale matches CreateMenu.as")
	_assert(menu.right_person_holder.position == Vector2(-60, -92) and menu.right_person_holder.scale == Vector2(-2, 2), "RightPersonPreview pos/scale matches CreateMenu.as")

	_assert(menu.class_title_label.z_index > menu.non_change_frame.z_index, "ClassTitleLabel renders above NonChangeFrame")
	_assert(menu.class_desc_label.z_index > menu.non_change_frame.z_index, "ClassDescLabel renders above NonChangeFrame")

	_assert(menu.back_btn.texture_normal != null, "BackBtn has SWF texture_normal")
	_assert(menu.finish_btn.texture_normal != null, "FinishBtn has SWF texture_normal")
	_assert(menu.terms_btn.texture_normal != null, "TermsBtn has SWF texture_normal")
	_assert(menu.gender_left.texture_normal != null and menu.gender_left.texture_hover != null, "Arrow buttons have left_00/left_01 textures")

	menu.queue_free()
	await process_frame


func _test_cowboy_combat() -> void:
	print("\n--- 2. Cowboy Combat ('shoot gun', frame 752/753, no double-shoot) ---")
	var world_node := Node2D.new()
	var entities := Node2D.new()
	entities.name = "EntitiesContainer"
	world_node.add_child(entities)
	root.add_child(world_node)

	var p := PersonEntity.new()
	p.is_local_player = false
	entities.add_child(p)
	p.apply_class_starter_stats("cowboy")
	p.equipment["weapon"] = "airsoft gun"
	p.animator.apply_equipment_from_person(p)

	p.execute_attack("attack")
	_assert(p.is_attacking, "Cowboy is_attacking == true on shoot start")
	_assert(p.animator.current_anim_name == "shoot gun", "Cowboy plays 'shoot gun'")
	_assert(p.animator.current_frame == 749, "Cowboy starts at frame 749")

	# No bullet before frame 752
	var proj_count_0: int = entities.get_children().filter(func(n): return is_instance_of(n, RangedProjectileType)).size()
	_assert(proj_count_0 == 0, "No bullet spawned immediately on frame 749")

	# Calling execute_attack again during active attack is blocked
	p.animator.current_frame = 750
	p.execute_attack("attack")
	_assert(p.animator.current_frame == 750, "Re-calling execute_attack during active shoot does not restart animation")

	# Advance to frame 752 (AS3 753) via physics ticks (airsoft gun has sr=11 -> 1 frame per 11 ticks)
	for _i in range(30):
		p._physics_process(1.0 / 30.0)
		if entities.get_children().filter(func(n): return is_instance_of(n, RangedProjectileType)).size() > 0:
			break
	var projs: Array = entities.get_children().filter(func(n): return is_instance_of(n, RangedProjectileType))
	_assert(projs.size() == 1, "Cowboy spawns exactly 1 bullet on frame 752 (AS3 753)")
	if projs.size() == 1:
		var b = projs[0]
		_assert(is_equal_approx(b.vel_x, 52.5), "Cowboy bullet vel_x == 52.5 (got %s)" % str(b.vel_x))
		_assert(b.life_span == 5, "Cowboy bullet life_span == 5 at bulletDistance=0 (got %d)" % b.life_span)

	world_node.queue_free()
	await process_frame


func _test_archer_combat() -> void:
	print("\n--- 3. Archer Combat ('shoot bow', frame 95/96, ground vs air movement) ---")
	var world_node := Node2D.new()
	var entities := Node2D.new()
	world_node.add_child(entities)
	root.add_child(world_node)

	var p := PersonEntity.new()
	p.is_local_player = false
	entities.add_child(p)
	p.apply_class_starter_stats("archer")
	p.equipment["weapon"] = "slingshot"
	p.animator.apply_equipment_from_person(p)

	p.execute_attack("attack")
	_assert(p.is_attacking, "Archer is_attacking == true on bow start")
	_assert(p.animator.current_anim_name == "shoot bow", "Archer plays 'shoot bow'")
	_assert(p.animator.current_frame == 87, "Archer starts at frame 87 (not skipped to 92)")
	_assert(entities.get_children().filter(func(n): return is_instance_of(n, RangedProjectileType)).size() == 0, "No arrow spawned at frame 87")

	# Advance to frame 95 (AS3 96)
	for _i in range(12):
		p._physics_process(1.0 / 30.0)
		if entities.get_children().filter(func(n): return is_instance_of(n, RangedProjectileType)).size() > 0:
			break
	var projs: Array = entities.get_children().filter(func(n): return is_instance_of(n, RangedProjectileType))
	_assert(projs.size() == 1, "Archer spawns 1 arrow on frame 95 (AS3 96)")
	if projs.size() == 1:
		var arrow = projs[0]
		_assert(is_equal_approx(arrow.vel_x, 45.0), "Archer arrow vel_x == 45.0")
		_assert(arrow.life_span == 30, "Archer arrow life_span == 30")

	world_node.queue_free()
	await process_frame


func _test_sandbox_return_flow() -> void:
	print("\n--- 4. Sandbox Return Flow (GameHUD -> GameFlow -> CreateCharacterMenu) ---")
	var container := Node.new()
	root.add_child(container)
	var flow := GameFlow.new()
	flow.setup_flow(container)
	await process_frame

	flow._on_offline_sandbox_requested(container)
	await process_frame
	_assert(flow.is_sandbox_session, "GameFlow is_sandbox_session == true")
	_assert(flow.current_state == GameFlow.State.CHARACTER_CREATE, "GameFlow in CHARACTER_CREATE")

	var create_menu: CreateCharacterMenu = flow.active_menu_node as CreateCharacterMenu
	create_menu._on_quick_start_pressed()
	await process_frame
	_assert(flow.current_state == GameFlow.State.IN_GAME, "GameFlow entered IN_GAME")
	_assert(flow.active_world_node != null and flow.active_world_node.hud != null, "GameWorld and GameHUD created")

	var hud = flow.active_world_node.hud
	_assert(hud.sandbox_return_btn != null and hud.sandbox_return_btn.visible, "SandboxReturnBtn is visible in Sandbox GameHUD")

	# Trigger return to character creation
	hud.sandbox_return_btn.pressed.emit()
	await process_frame
	_assert(flow.current_state == GameFlow.State.CHARACTER_CREATE, "SandboxReturnBtn returned GameFlow to CHARACTER_CREATE")
	_assert(flow.active_world_node == null, "Previous GameWorld cleaned up on return")
	_assert(flow.active_menu_node is CreateCharacterMenu, "CreateCharacterMenu active again")
	_assert(flow.is_sandbox_session, "is_sandbox_session preserved on return")

	# Re-enter world with new character
	var create_menu2: CreateCharacterMenu = flow.active_menu_node as CreateCharacterMenu
	create_menu2._cycle_class(1) # archer
	create_menu2.character_name = "ArcherTwo"
	create_menu2._on_finish_pressed()
	await process_frame
	_assert(flow.current_state == GameFlow.State.IN_GAME, "Re-entered IN_GAME with second Sandbox character")
	_assert(flow.active_world_node != null and flow.active_world_node.local_player.character_name == "ArcherTwo", "New character name applied in clean GameWorld")

	container.queue_free()
	await process_frame


func _collect_focusable_non_text_controls(node: Node, out: Array[String]) -> void:
	for ch: Node in node.get_children():
		if (ch is BaseButton or ch is OptionButton or ch is ItemList) and not (ch is LineEdit):
			var ctrl: Control = ch as Control
			if ctrl.focus_mode != Control.FOCUS_NONE:
				out.append("%s:%s" % [ch.name, str(ctrl.focus_mode)])
		_collect_focusable_non_text_controls(ch, out)


func _test_maps_portals_and_zones() -> void:
	print("\n--- 5. 144 Maps, S023/S024 Fix & Portal Parity ---")
	var sdb: Node = root.get_node_or_null("StatsDB")
	_assert(sdb != null, "StatsDB singleton available")
	if sdb == null:
		return

	var valid_stage_count: int = 0
	var bad_portals: Array[String] = []
	var missing_maps: Array[int] = []
	for s: int in range(1, 146):
		if s == 51:
			continue
		var mdata: Dictionary = sdb.call("get_map_data", s)
		if mdata.is_empty():
			missing_maps.append(s)
			continue
		valid_stage_count += 1
		var am: Dictionary = sdb.call("get_area_meta", s)
		var meta_portals: Dictionary = am.get("portals", {})
		var expected_targets: Array[int] = []
		for pk: Variant in meta_portals.values():
			var pid: int = int(pk)
			if pid > 0:
				expected_targets.append(pid)
		var p_arr: Variant = mdata.get("portals", [])
		var map_targets: Array[int] = []
		if p_arr is Array:
			for p_entry: Variant in p_arr:
				if p_entry is Array and p_entry.size() >= 3:
					var tgt: int = int(p_entry[2])
					if tgt > 0:
						map_targets.append(tgt)
						if tgt == 51 or tgt > 145:
							bad_portals.append("Stage %d invalid target %d" % [s, tgt])
		for exp_t: int in expected_targets:
			if not map_targets.has(exp_t):
				bad_portals.append("Stage %d missing StatsDB portal %d (map has %s)" % [s, exp_t, str(map_targets)])

	_assert(valid_stage_count == 144 and missing_maps.is_empty(), "All 144 playable stages load cleanly (missing=%s)" % str(missing_maps))
	_assert(bad_portals.is_empty(), "All map portals match StatsDB area metadata without invalid targets (%s)" % str(bad_portals))

	var m23: Dictionary = sdb.call("get_map_data", 23)
	var m24: Dictionary = sdb.call("get_map_data", 24)
	var am23: Dictionary = sdb.call("get_area_meta", 23)
	var am24: Dictionary = sdb.call("get_area_meta", 24)
	_assert(str(am23.get("name", "")) == "Goo Dungeon" and str(am24.get("name", "")) == "Brick Dungeon", "Stages 23/24 names match Goo Dungeon / Brick Dungeon")
	var s23_str: String = str(m23.get("spawns", []))
	var s24_str: String = str(m24.get("spawns", []))
	_assert(s23_str != s24_str, "S023 and S024 have distinct spawn tables after swap fix")


func _test_admin_menu_items_mobs_and_filters() -> void:
	print("\n--- 6. AdminMenu Item Coverage, Class Filters, Sorted Mobs & Icons ---")
	var sdb: Node = root.get_node_or_null("StatsDB")
	_assert(sdb != null, "StatsDB singleton present")
	if sdb == null:
		return

	var all_items: Array = sdb.call("get_all_unique_items")
	var item_keys: Array[String] = []
	for rec: Variant in all_items:
		if rec is Dictionary:
			item_keys.append(str(rec.get("_key", rec.get("key", ""))).to_lower())
	_assert(item_keys.has("maple wood") and item_keys.has("cloud tree wood"), "All craft wood materials included in unique item list")
	_assert(item_keys.has("ticket") and item_keys.has("sliver"), "Ticket and fish items included in unique item list")

	var all_mobs: Array = sdb.call("get_all_unique_enemies")
	_assert(all_mobs.size() == 46, "StatsDB returns exactly 46 unique mobs (got %d)" % all_mobs.size())
	var xp_sorted: bool = true
	var numeric_mob: bool = false
	var prev_xp: int = -1
	for mob: Variant in all_mobs:
		if mob is Dictionary:
			var mname: String = str(mob.get("_key", mob.get("key", "")))
			var mxp: int = int(mob.get("xp", 0))
			if mname.is_valid_int() or mname.is_empty():
				numeric_mob = true
			if mxp < prev_xp:
				xp_sorted = false
			prev_xp = mxp
	_assert(xp_sorted and not numeric_mob, "46 unique mobs sorted ascending by XP with zero numeric keys")

	var world_node := Node2D.new()
	var p := PersonEntity.new()
	world_node.add_child(p)
	var admin: Node = AdminMenuType.new()
	admin.call("setup", p, world_node)
	root.add_child(world_node)
	root.add_child(admin)
	await process_frame

	var mob_sel: OptionButton = admin.get("mob_select") as OptionButton
	_assert(mob_sel != null and mob_sel.item_count == 46, "AdminMenu mob_select populated with 46 mobs")
	if mob_sel != null and mob_sel.item_count > 0:
		var has_icon: bool = mob_sel.get_item_icon(0) != null
		var first_is_text: bool = not mob_sel.get_item_text(0).is_valid_int()
		_assert(has_icon and first_is_text, "AdminMenu mob_select renders mob icons and text names")

	var class_flt: OptionButton = admin.get("class_filter") as OptionButton
	var ilist: ItemList = admin.get("item_list") as ItemList
	var listed_names := func() -> Array[String]:
		var names: Array[String] = []
		for i: int in range(ilist.item_count):
			names.append(ilist.get_item_text(i))
		return names

	class_flt.select(0) # Class: All
	admin.call("_refresh_item_list")
	var all_names: Array[String] = listed_names.call()
	_assert(all_names.has("apple") and all_names.has("maple wood") and all_names.has("ticket"), "AdminMenu Class: All shows consumables, craft woods and tickets")
	var numeric_item: bool = false
	for n_str: String in all_names:
		if n_str.is_valid_int() or n_str.contains("[") or n_str.contains("("):
			numeric_item = true
			break
	_assert(not numeric_item, "AdminMenu item_list shows clean item names without category/id decorations")

	class_flt.select(1) # Warrior
	admin.call("_refresh_item_list")
	var w_names: Array[String] = listed_names.call()
	_assert(w_names.has("short sword") and not w_names.has("basic wand") and not w_names.has("apple"), "Warrior filter shows Warrior gear only")

	class_flt.select(2) # Archer
	admin.call("_refresh_item_list")
	var a_names: Array[String] = listed_names.call()
	_assert(a_names.has("slingshot") and not a_names.has("basic wand") and not a_names.has("short sword"), "Archer filter shows Archer gear only")

	class_flt.select(3) # Mage
	admin.call("_refresh_item_list")
	var m_names: Array[String] = listed_names.call()
	_assert(m_names.has("basic wand") and not m_names.has("airsoft gun") and not m_names.has("short sword"), "Mage filter shows Mage gear only")

	class_flt.select(4) # Cowboy
	admin.call("_refresh_item_list")
	var c_names: Array[String] = listed_names.call()
	_assert(c_names.has("airsoft gun") and not c_names.has("basic wand") and not c_names.has("slingshot"), "Cowboy filter shows Cowboy gear only")

	var bad_focus: Array[String] = []
	_collect_focusable_non_text_controls(admin, bad_focus)
	_assert(bad_focus.is_empty(), "AdminMenu interactive buttons/dropdowns have FOCUS_NONE (bad=%s)" % str(bad_focus))

	admin.queue_free()
	world_node.queue_free()
	await process_frame


func _test_map_menu_and_space_focus_safety() -> void:
	print("\n--- 7. MapMenu Unlock/Reveal/Confirm & Space Focus Isolation ---")
	var pio: Node = root.get_node_or_null("PlayerIOClient")
	if pio != null and pio.get("my_player_object") is Dictionary:
		pio.my_player_object["unlockedMaps"] = [1]

	var map_menu: Control = MapMenuType.new(1)
	root.add_child(map_menu)
	await process_frame

	_assert(bool(map_menu.call("is_stage_unlocked", 1)) and not bool(map_menu.call("is_stage_unlocked", 55)), "MapMenu starts with Stage 1 unlocked only")
	map_menu.call("_on_area_clicked", 2, "Wooden Clearing")
	var conf: Control = map_menu.get("confirm_panel") as Control
	_assert(conf != null and conf.visible, "Clicking MapMenu marker shows teleport ConfirmDialog")
	var emitted_stage: Array[int] = [-1]
	map_menu.connect("area_selected", func(sid: int) -> void: emitted_stage[0] = sid)
	map_menu.call("confirm_teleport_yes")
	_assert(emitted_stage[0] == 2 and not conf.visible, "ConfirmDialog Yes emits area_selected(2) and closes dialog")

	var revealed: Array = map_menu.call("reveal_all_map")
	_assert(revealed.size() >= 100 and bool(map_menu.call("is_stage_unlocked", 55)), "reveal_all_map() unlocks all world stages including Stage 55")

	var player := PersonEntity.new()
	player.is_local_player = false
	root.add_child(player)
	var char_menu: Control = CharacterMenuType.new(player)
	var item_menu: Control = ItemMenuType.new(player)
	var skills_menu: Control = SkillsMenuType.new(player)
	var hud = GameHUDType.new()
	root.add_child(char_menu)
	root.add_child(item_menu)
	root.add_child(skills_menu)
	root.add_child(hud)
	await process_frame

	var bad_focus: Array[String] = []
	for ui_node: Node in [map_menu, char_menu, item_menu, skills_menu, hud]:
		_collect_focusable_non_text_controls(ui_node, bad_focus)
	_assert(bad_focus.is_empty(), "No UI button/select takes Space focus across menus or HUD (bad=%s)" % str(bad_focus))

	hud.visible = true
	hud.bind_player(player)
	hud.toggle_character_menu()
	_assert(hud.character_menu.visible, "CharacterMenu opened via GameHUD")
	var focus_owner: Control = hud.get_viewport().gui_get_focus_owner() if hud.get_viewport() != null else null
	_assert(focus_owner == null, "Opening CharacterMenu leaves gui_focus_owner == null")
	var ev_space := InputEventKey.new()
	ev_space.keycode = KEY_SPACE
	ev_space.pressed = true
	hud._unhandled_input(ev_space)
	_assert(hud.character_menu.visible, "Pressing Space with open CharacterMenu does not close/toggle CharacterMenu")

	map_menu.queue_free()
	char_menu.queue_free()
	item_menu.queue_free()
	skills_menu.queue_free()
	hud.queue_free()
	player.queue_free()
	await process_frame


func _test_mp_skills_and_consumables() -> void:
	print("\n--- 8. MP Calculations, Skills & Consumables ---")
	var p := PersonEntity.new()
	p.is_local_player = false
	p.level = 5
	p.max_mana = 500
	p.mana = 400
	p.max_health = 300
	p.health = 100
	p.skill_points = 50
	root.add_child(p)
	await process_frame

	_assert(int(p.call("level_mp", 15)) == 15, "level_mp(15) at lvl 5 == 15 (Person.as:1164)")
	p.level = 101
	_assert(int(p.call("level_mp", 15)) == 30, "level_mp(15) at lvl 101 == 30 (ceil(101/100)=2)")
	p.level = 5

	# mp restore: only active when lvl > 1, restores lvl * 3 every 30s
	p.skill_levels["mp restore"] = 1
	p._mp_regen_timer = 30.0
	p._physics_process(0.0)
	_assert(p.mana == 400, "mp restore lvl 1 restores 0 MP")
	p.skill_levels["mp restore"] = 3
	p._mp_regen_timer = 30.0
	p._physics_process(0.0)
	_assert(p.mana == 409, "mp restore lvl 3 restores 9 MP (expected 409, got %d)" % p.mana)

	# self heal requires magic weapon and uses level_mp(15)
	p.equipment["weapon"] = "stick"
	p.skill_levels["self heal"] = 2
	_assert(not p.use_skill("self heal"), "self heal blocked without magic weapon")
	p.equipment["weapon"] = "basic wand"
	var mp_before: int = p.mana
	var hp_before: int = p.health
	var sh_cost: int = int(p.call("level_mp", 15))
	_assert(p.use_skill("self heal"), "self heal succeeds with magic weapon")
	_assert(p.mana == mp_before - sh_cost and p.health == hp_before + 45, "self heal spends level_mp(15) and heals 35+2*5=45 HP")

	# guild heal uses flat 19 MP and heals 20+lvl*5
	p.skill_levels["guild heal"] = 2
	mp_before = p.mana
	hp_before = p.health
	_assert(p.use_skill("guild heal"), "guild heal succeeds with magic weapon")
	_assert(p.mana == mp_before - 19 and p.health == hp_before + 30, "guild heal spends flat 19 MP and heals 20+2*5=30 HP")

	# self rage costs 0 MP
	p.skill_levels["self rage"] = 2
	mp_before = p.mana
	_assert(p.use_skill("self rage") and p.mana == mp_before, "self rage costs 0 MP")

	# guild rage requires lvl > 1
	p.skill_levels["guild rage"] = 1
	_assert(not p.use_skill("guild rage"), "guild rage blocked at lvl 1")
	p.skill_levels["guild rage"] = 2
	mp_before = p.mana
	_assert(p.use_skill("guild rage") and p.mana == mp_before - int(p.call("level_mp", 45)), "guild rage succeeds at lvl 2 and spends level_mp(45)")

	# cowboy shotgun attack & upward shoot
	p.equipment["weapon"] = "airsoft gun"
	p.skill_levels["shotgun attack"] = 2
	mp_before = p.mana
	_assert(p.use_skill("shotgun attack") and p.mana == mp_before - 100, "shotgun attack spends 50 * lvl = 100 MP")
	p.skill_levels["upward shoot"] = 1
	_assert(not p.use_skill("upward shoot"), "upward shoot blocked at lvl 1")
	p.skill_levels["upward shoot"] = 2
	mp_before = p.mana
	_assert(p.use_skill("upward shoot") and p.mana == mp_before - int(p.call("level_mp", 2)), "upward shoot succeeds at lvl 2 and spends single level_mp(2)")

	# training grants +1 core stats & +10 HP/MP
	var pow0: int = p.power_stat
	var mhp0: int = p.max_health
	var mmp0: int = p.max_mana
	_assert(p.upgrade_skill("training"), "training skill upgraded")
	_assert(p.power_stat == pow0 + 1 and p.max_health == mhp0 + 10 and p.max_mana == mmp0 + 10, "training adds +1 attack/def stats and +10 max HP/MP")

	# consumables (banana, watermelon, turkey, book of power)
	p.mana = 10
	p.health = 50
	p.use_item("banana")
	_assert(p.health == 70 and p.mana == 110, "banana heals 20 HP and restores 100 MP")
	p.use_item("book of power")
	_assert(p.power_stat == pow0 + 2, "book of power grants +1 power")

	# SkillsMenu MP display
	var sm: Control = SkillsMenuType.new(p)
	root.add_child(sm)
	await process_frame
	sm.call("display_skills", "basic")
	var rage_mp_lbl: Label = (sm.get("skill_cards") as Dictionary)["self rage"]["mp_label"] as Label
	_assert(rage_mp_lbl.text == "MP: 0", "SkillsMenu shows 'MP: 0' for self rage (got %s)" % rage_mp_lbl.text)
	sm.call("display_skills", "wizard")
	var heal_mp_lbl: Label = (sm.get("skill_cards") as Dictionary)["self heal"]["mp_label"] as Label
	var lvl5_mp_text: String = heal_mp_lbl.text
	p.level = 101
	p.exp_changed.emit(p.exp_points, p.max_exp_points, p.level)
	_assert(heal_mp_lbl.text != lvl5_mp_text and heal_mp_lbl.text == "MP: 30", "SkillsMenu dynamically updates MP label when person levels up (%s -> %s)" % [lvl5_mp_text, heal_mp_lbl.text])

	sm.queue_free()
	p.queue_free()
	await process_frame


func _test_cowboy_cooldown_and_dual_guns() -> void:
	print("\n--- 9. Cowboy sr Cooldown (Rapid Tap) & Dual Guns ---")
	var world_node := Node2D.new()
	var entities := Node2D.new()
	entities.name = "EntitiesContainer"
	world_node.add_child(entities)
	root.add_child(world_node)

	var p := PersonEntity.new()
	p.is_local_player = false
	entities.add_child(p)
	p.apply_class_starter_stats("cowboy")
	p.equipment["weapon"] = "airsoft gun"
	p.equipment["weapon2"] = "airsoft gun"
	p.animator.apply_equipment_from_person(p)

	_assert(bool(p.call("is_dual_gun_weapon", "airsoft gun")), "airsoft gun recognized in DUAL_GUNS_ARRAY")
	p.execute_attack("attack")
	var first_projs: Array = []
	for _i in range(15):
		p._physics_process(1.0 / 30.0)
		first_projs = entities.get_children().filter(func(n): return is_instance_of(n, RangedProjectileType))
		if not first_projs.is_empty():
			break
	_assert(first_projs.size() == 2, "Dual wielding two airsoft guns spawns primary + secondary bullets (got %d)" % first_projs.size())
	_assert(p._cowboy_cooldown_ticks > 0, "Cowboy sets _cowboy_cooldown_ticks from weapon sr after shot")

	# Clear projectiles & test rapid-tap gate while cooldown active
	for pr: Node in first_projs:
		pr.free()
	p.is_attacking = false
	p.execute_attack("attack")
	_assert(not p.is_attacking, "Rapid re-tap execute_attack blocked while _cowboy_cooldown_ticks > 0")

	# Continuous hold: animation stays in 'shoot gun', never resets to 'standing' or frame 749, holds on aim frame 752 between shots
	p._cowboy_cooldown_ticks = 0
	p._con_bullets_shot = 0
	p._hold_attack_override = true
	p.execute_attack("attack")
	var reset_to_standing_or_start: bool = false
	var saw_hold_pause: bool = false
	for tick_i in range(30):
		p._physics_process(1.0 / 30.0)
		if p.animator.current_anim_name != "shoot gun" or not p.is_attacking:
			reset_to_standing_or_start = true
		if tick_i > 3 and p.animator.current_frame == 749:
			reset_to_standing_or_start = true
		if p.animator.current_frame == 752 and not p.animator.is_playing:
			saw_hold_pause = true
	var held_projs: Array = entities.get_children().filter(func(n): return is_instance_of(n, RangedProjectileType))
	_assert(not reset_to_standing_or_start and saw_hold_pause, "Continuous Cowboy hold keeps 'shoot gun' without restarting and pauses on aim frame 752")
	_assert(held_projs.size() >= 4, "Continuous Cowboy hold keeps firing multiple shots (%d bullets)" % held_projs.size())
	p._hold_attack_override = false
	for _i in range(15):
		p._physics_process(1.0 / 30.0)
	_assert(not p.is_attacking, "Releasing attack lets Cowboy finish 'shoot gun' back to locomotion")

	world_node.queue_free()
	await process_frame


func _test_magic_swing_and_projectile() -> void:
	print("\n--- 10. Magic Swing-Frame Casting & Projectile Hit Burst ---")
	var world_node := Node2D.new()
	var entities := Node2D.new()
	entities.name = "EntitiesContainer"
	world_node.add_child(entities)
	root.add_child(world_node)

	var p := PersonEntity.new()
	p.is_local_player = false
	p.level = 5
	p.mana = 200
	p.max_mana = 200
	entities.add_child(p)
	p.apply_class_starter_stats("wizard")
	p.skill_levels["magic distance"] = 3
	p.equipment["weapon"] = "basic wand"
	p.equipment["weapon2"] = "basic wand"
	p.animator.apply_equipment_from_person(p)

	p.execute_attack("attack")
	_assert(p.is_attacking, "Wizard starts attack state")
	var projs0: Array = entities.get_children().filter(func(n): return is_instance_of(n, MagicProjectileType))
	_assert(projs0.is_empty(), "No MagicProjectile spawned immediately on frame 0")

	# Step physics frames naturally: 'attack single' starts at 155 -> hits 156 (main) and 160 (offhand)
	p._physics_process(1.0 / 30.0)
	var projs_main: Array = entities.get_children().filter(func(n): return is_instance_of(n, MagicProjectileType))
	_assert(projs_main.size() == 1 and not bool(projs_main[0].is_magic_secondary), "Main wand spawns primary MagicProjectile on swing frame 156 (got %d)" % projs_main.size())
	if projs_main.size() == 1:
		var mproj = projs_main[0]
		_assert(mproj.life_span == 7, "MagicProjectile life_span == 4 + magic_distance(3) == 7 (got %d)" % mproj.life_span)
		var oval_children: int = 0
		for c: Node in mproj.get_children():
			if c is Sprite2D and c != mproj.sprite:
				oval_children += 1
		_assert(mproj.sprite != null and oval_children == 0, "MagicProjectile has no extra orbiting ovals in flight (extra_sprites=%d)" % oval_children)
		var dummy_enemy := Node2D.new()
		dummy_enemy.global_position = Vector2(40, 0)
		entities.add_child(dummy_enemy)
		mproj._spawn_hit_burst(dummy_enemy.global_position)
		var bursts: Array = entities.get_children().filter(func(n): return is_instance_of(n, MagicProjectileType.MagicBurstEffect))
		_assert(bursts.size() == 1, "MagicBurstEffect spawns on enemy hit")

	for _i in range(4):
		p._physics_process(1.0 / 30.0)
	var projs_both: Array = entities.get_children().filter(func(n): return is_instance_of(n, MagicProjectileType))
	_assert(projs_both.size() == 2 and bool(projs_both[1].is_magic_secondary), "Offhand wand spawns secondary MagicProjectile on offhand swing frame 160 (got %d)" % projs_both.size())

	world_node.queue_free()
	await process_frame


func _test_dual_wield_crit_orb_mount_and_menus() -> void:
	print("\n--- 11. Dual-Wield Rules, Crit/Orb/Mount Formulas & Character/ItemMenus ---")
	var p := PersonEntity.new()
	p.is_local_player = false
	p.level = 30
	p.power_stat = 20
	p.magic_stat = 20
	p.dex_stat = 30
	p.inventory = ["short sword", "wood scrap shield", "two handed mace", "basic wand", "pet archer hat", "apple"]
	p.equipment["shirt"] = "white shirt"
	p.equipment["weapon"] = "short sword"
	p.equipment["weapon2"] = ""
	root.add_child(p)
	await process_frame

	# Shield goes to "weapon" and moves 1H sword to "weapon2"
	_assert(p.equip_item("wood scrap shield", "weapon"), "Equipping shield with 1H sword succeeds")
	_assert(p.equipment["weapon"] == "wood scrap shield" and p.equipment["weapon2"] == "short sword", "Shield placed in 'weapon' and 1H sword moved to 'weapon2'")

	# Cannot unequip secondary under shield or shirt
	_assert(not p.unequip_item("shirt") and not p.last_equip_error.is_empty(), "Unequipping shirt blocked with alert error")
	_assert(not p.unequip_item("weapon2") and not p.last_equip_error.is_empty(), "Unequipping secondary weapon under shield blocked")

	# Equipping shield with 2H weapon blocked
	_assert(p.equip_item("two handed mace", "weapon"), "Equipping 2H mace clears offhand")
	_assert(not p.equip_item("wood scrap shield", "weapon") and p.last_equip_error.contains("two handed"), "Equipping shield with 2H mace blocked with AS3 message")

	# Crit multiplier formula (2.0 + crit_lvl / 8.0) + orb + mount bonuses
	p.skill_levels["critical hit"] = 8
	p.dex_stat = 300 # 100% crit chance
	var base_rng: Vector2i = p.get_attack_damage_range("main")
	p.orb_bonuses = {"pow": 10, "rng": 0, "mgc": 0, "art": 0}
	p.riding_pet_power = 25 # +10 bonus (int(25 * 0.4))
	var boosted_rng: Vector2i = p.get_attack_damage_range("main")
	_assert(boosted_rng.x > base_rng.x, "Orb and +40%% riding pet bonuses increase attack damage range (%s -> %s)" % [str(base_rng), str(boosted_rng)])
	var rolled: int = p._roll_attack_damage(Vector2i(10, 10))
	_assert(p.is_last_attack_crit and rolled == 30, "Crit lvl 8 multiplies damage by 2.0 + 8/8 = 3.0x (expected 30, got %d)" % rolled)

	# Shield in weapon + wand in weapon2 in CharacterMenu uses active_w (wand) + orb/mount stats
	p.orb_bonuses = {"pow": 0, "rng": 0, "mgc": 5, "art": 0}
	p.equipment["weapon"] = "wood scrap shield"
	p.equipment["weapon2"] = "basic wand"
	var cm: Control = CharacterMenuType.new(p)
	root.add_child(cm)
	await process_frame
	var mag_lbl: Label = cm.get("stat_labels")["magic"] as Label
	var dmg_lbl: Label = cm.get("damage_span_label") as Label
	# magic = 20 + orb(5) + mount(10) = 35; wand = 4..9 -> int(35*4/2) = 70, int(35*9/2) = 157
	_assert(mag_lbl.text == "Magic: 35", "CharacterMenu Magic reflects orb + 40%% mount (%s)" % mag_lbl.text)
	_assert(dmg_lbl.text == "70-157", "CharacterMenu Damage uses active_w (wand in weapon2) under shield (%s)" % dmg_lbl.text)

	# ItemMenu: pet_helmet stats ('l' -> Luck), compare panels (weapon + weapon2), dual_wield_panel
	var im: Control = ItemMenuType.new(p)
	root.add_child(im)
	await process_frame
	var entries: Array = im.get("_display_entries")
	var ph_idx: int = -1
	var sword_idx: int = -1
	for i: int in range(entries.size()):
		var n: String = str(entries[i]["name"])
		if n == "pet archer hat":
			ph_idx = i
		elif n == "short sword":
			sword_idx = i
	im.call("select_item", ph_idx)
	_assert((im.get("item_stats_label") as Label).text.contains("Luck: 2"), "ItemMenu reads pet_helmet 'l' key as Luck stat")
	im.call("select_item", sword_idx)
	_assert((im.get("your_item_panel") as Control).visible and (im.get("your_item2_panel") as Control).visible, "ItemMenu shows primary and secondary weapon compare panels")
	_assert((im.get("your_item2_type_label") as Label).text == "secondary weapon", "ItemMenu labels secondary compare card cleanly")
	im.call("_on_equip_clicked")
	_assert((im.get("dual_wield_panel") as Control).visible, "ItemMenu opens dual_wield_panel when equipping 1H weapon")

	cm.queue_free()
	im.queue_free()
	p.queue_free()
	await process_frame


func _test_sandbox_last_character_continue_flow() -> void:
	print("\n--- 12. MainMenu Sandbox Continue Dialog & Full Character Save/Restore ---")
	var had_prev_save: bool = FileAccess.file_exists(GameFlow.LAST_SANDBOX_CHAR_PATH)
	var prev_save_bytes: String = ""
	if had_prev_save:
		var rf := FileAccess.open(GameFlow.LAST_SANDBOX_CHAR_PATH, FileAccess.READ)
		if rf != null:
			prev_save_bytes = rf.get_as_text()
			rf.close()
	GameFlow.clear_last_sandbox_character()

	var container := Node2D.new()
	root.add_child(container)
	var flow := GameFlow.new()
	flow.setup_flow(container)
	await process_frame

	# Без сохранения нажатие Offline Sandbox сразу переводит в CreateCharacterMenu
	var mm: MainMenuUI = flow.active_menu_node as MainMenuUI
	mm._on_offline_pressed()
	await process_frame
	_assert(flow.current_state == GameFlow.State.CHARACTER_CREATE, "Without saved sandbox char, Offline opens CreateCharacterMenu")

	# Создаём и прокачиваем Sandbox-персонажа, имитируя прогресс игрока
	flow._start_sandbox_game({
		"username": "SavedHero",
		"skin": 2,
		"eyes": 3,
		"hair": 4,
		"beard": 1,
		"classType": "warrior",
		"gender": "male"
	}, container)
	await process_frame

	var gw: GameWorld = flow.active_world_node
	var player: PersonEntity = gw.local_player as PersonEntity
	player.level = 12
	player.exp_points = 420
	player.max_exp_points = 758
	player.coins = 777
	player.power_stat = 42
	player.ability_points = 5
	player.skill_points = 3
	player.skill_levels["power attack"] = 4
	player.skill_levels["block"] = 3
	player.equipment["weapon"] = "iron sword"
	player.equipment["helmet"] = "leather helm"
	player.inventory = ["apple", "banana"]
	gw.load_level(5)
	await process_frame
	flow.save_active_sandbox_character()

	_assert(GameFlow.has_last_sandbox_character(), "Saved sandbox character exists on disk")

	# Возвращаемся в главное меню (is_sandbox_session сохранил прогресс)
	flow.show_main_menu(container)
	await process_frame
	var mm2: MainMenuUI = flow.active_menu_node as MainMenuUI
	mm2._on_offline_pressed()
	await process_frame
	_assert(mm2.sandbox_continue_overlay != null and mm2.sandbox_continue_overlay.visible, "Sandbox continue prompt appears when last character exists")
	_assert(flow.current_state == GameFlow.State.MAIN_MENU, "GameFlow stays on MAIN_MENU until player chooses Yes or No")
	_assert(mm2.sandbox_continue_yes_btn.focus_mode == Control.FOCUS_NONE and mm2.sandbox_continue_no_btn.focus_mode == Control.FOCUS_NONE, "Sandbox continue Yes/No buttons use FOCUS_NONE")

	# Выбор "Да": пропускает CreateCharacterMenu и полностью восстанавливает персонажа
	mm2._on_sandbox_continue_yes()
	await process_frame
	_assert(flow.current_state == GameFlow.State.IN_GAME, "Clicking Yes jumps straight to IN_GAME skipping CreateCharacterMenu")
	_assert(flow.active_world_node != null and flow.active_world_node.current_stage_id == 5, "Restored character spawns on saved stage 5 (got %s)" % str(flow.active_world_node.current_stage_id if flow.active_world_node else -1))
	var rp: PersonEntity = flow.active_world_node.local_player as PersonEntity
	_assert(rp.character_name == "SavedHero" and rp.character_class == "warrior", "Restored character name and class match")
	_assert(rp.level == 12 and rp.coins == 777 and rp.power_stat == 42, "Restored level(12), coins(777), power(42) match")
	_assert(rp.get_skill_level("power attack") == 4 and rp.get_skill_level("block") == 3, "Restored skill levels match")
	_assert(rp.equipment.get("weapon", "") == "iron sword" and rp.inventory == ["apple", "banana"], "Restored equipment and inventory match")

	# Возвращаемся и выбираем "Нет": переходим в CreateCharacterMenu
	flow.show_main_menu(container)
	await process_frame
	var mm3: MainMenuUI = flow.active_menu_node as MainMenuUI
	mm3._on_offline_pressed()
	await process_frame
	mm3._on_sandbox_continue_no()
	await process_frame
	_assert(flow.current_state == GameFlow.State.CHARACTER_CREATE, "Clicking No opens CreateCharacterMenu")

	container.queue_free()
	await process_frame
	GameFlow.clear_last_sandbox_character()
	if had_prev_save and not prev_save_bytes.is_empty():
		var wf := FileAccess.open(GameFlow.LAST_SANDBOX_CHAR_PATH, FileAccess.WRITE)
		if wf != null:
			wf.store_string(prev_save_bytes)
			wf.close()


func _test_all_39_skills_functionality() -> void:
	print("\n--- 13. All 39 Skills Functional Verification ---")
	# InputMap: block должен быть на KEY_Q (81), а не KEY_V (86)
	var block_events: Array[InputEvent] = InputMap.action_get_events("block")
	var block_is_q: bool = false
	for ev: InputEvent in block_events:
		if ev is InputEventKey and (ev as InputEventKey).keycode == KEY_Q:
			block_is_q = true
	_assert(block_is_q, "InputMap 'block' mapped to KEY_Q (81)")

	var world_stub := Node2D.new()
	var entities := Node2D.new()
	world_stub.set_script(null)
	root.add_child(world_stub)
	world_stub.add_child(entities)

	var p := PersonEntity.new()
	p.is_local_player = false
	entities.add_child(p)
	await process_frame
	p.position = Vector2(200, 300)
	p.on_ground = true

	# 1. Пассивки: expert warrior/archer/wizard/cowboy + damage tightening, training XP, jump height, shield mastery, block, loot steal, bullet distance
	p.skill_points = 50
	var pow_before: int = p.power_stat
	_assert(p.upgrade_skill("expert warrior", 1, 10) and p.power_stat == pow_before + 1, "expert warrior grants +1 power_stat")
	var rng_before: int = p.range_stat
	_assert(p.upgrade_skill("expert archer", 1, 10) and p.range_stat == rng_before + 1, "expert archer grants +1 range_stat")
	var mag_before: int = p.magic_stat
	_assert(p.upgrade_skill("expert wizard", 1, 10) and p.magic_stat == mag_before + 1, "expert wizard grants +1 magic_stat")
	var art_before: int = p.artillery_stat
	_assert(p.upgrade_skill("expert cowboy", 1, 10) and p.artillery_stat == art_before + 1, "expert cowboy grants +1 artillery_stat")

	var j_before: float = p.jump_power_stat
	_assert(p.upgrade_skill("jump height", 1, 10) and p.jump_power_stat > j_before, "jump height increases jump_power_stat")

	p.skill_levels["training"] = 4
	var exp_before: int = p.exp_points
	p.add_exp(40)
	_assert(p.exp_points - exp_before == 44, "training lvl 4 boosts 40 XP gain by +10%% to 44 (got +%d)" % (p.exp_points - exp_before))

	p.equipment["weapon"] = "wood scrap shield"
	p.def_stat = 0
	var def_no_sm: int = p.get_total_defense()
	for _s: int in range(5):
		p.upgrade_skill("shield mastery", 1, 35)
	_assert(p.get_total_defense() > def_no_sm, "shield mastery increases defense while shield equipped (%d -> %d)" % [def_no_sm, p.get_total_defense()])

	p.skill_levels["block"] = 10 # reduction = 0.50 + 0.10 = 0.60
	p.is_blocking = true
	p.skill_levels["avoidability"] = 0
	p.max_health = 500
	p.health = 500
	p.def_stat = 0
	p.equipment["weapon"] = "stick"
	p.take_damage(100)
	_assert(p.health == 460, "block lvl 10 reduces 100 raw dmg by 60%% to 40 dmg (hp=%d)" % p.health)
	p.is_blocking = false

	# Loot steal wait timer
	var loot := LootItemEntity.new()
	loot.owner_name = "OtherPlayer"
	loot._age_seconds = 5.0
	p.is_local_player = true
	p.character_name = "Tester"
	p.skill_levels["loot steal"] = 0
	_assert(not loot.can_be_picked_up_by(p), "Foreign loot blocked at 5.0s without loot steal")
	p.skill_levels["loot steal"] = 18
	_assert(loot.can_be_picked_up_by(p), "loot steal lvl 18 allows foreign loot pickup at 5.0s (wait=%.1fs)" % p.get_loot_steal_wait_seconds())
	loot.queue_free()

	# 2. Warrior actives + animations + crescent air slash projectile + dash attack
	p.is_local_player = false
	p.character_class = "warrior"
	p.equipment["weapon"] = "short sword"
	p.power_stat = 30
	p.max_mana = 1000
	p.mana = 1000
	p.facing_dir = 1
	p.skill_levels["power attack"] = 3
	p.skill_levels["multi attack"] = 3
	p.skill_levels["air slash"] = 3
	p.skill_levels["spin attack"] = 3
	p.skill_levels["speed dash"] = 3
	p.dash_lvl = 3

	var enemy1 := EnemyEntity.new()
	enemy1.enemy_type = "green goo"
	entities.add_child(enemy1)
	var enemy2 := EnemyEntity.new()
	enemy2.enemy_type = "green goo"
	entities.add_child(enemy2)
	await process_frame
	enemy1.max_health = 2000
	enemy1.health = 2000
	enemy2.max_health = 2000
	enemy2.health = 2000

	# Mock minimal enemies list in world_stub via helper container or attach to a GameWorld? Use PersonEntity on entities + custom test targets:
	enemy1.position = p.position + Vector2(55.0, 0.0)
	enemy2.position = p.position + Vector2(140.0, 0.0)
	p.is_attacking = false
	_assert(p.use_skill("power attack") and p.is_attacking and p.animator.current_anim_name == "lunge attack", "power attack plays 'lunge attack' and sets is_attacking")
	p.is_attacking = false
	p.current_attack_move = ""
	_assert(p.use_skill("multi attack") and p.animator.current_anim_name == "ground stab", "multi attack plays 'ground stab'")
	p.is_attacking = false
	p.current_attack_move = ""
	_assert(p.use_skill("spin attack") and p.animator.current_anim_name == "spin attack", "spin attack plays 'spin attack'")
	p.is_attacking = false
	p.current_attack_move = ""

	# Air slash spawns piercing wave
	var pre_projs: int = entities.get_children().filter(func(n): return is_instance_of(n, RangedProjectileType)).size()
	p._air_slash_charge_ticks = 20
	_assert(p.use_skill("air slash") and p.animator.current_anim_name == "down slash", "air slash plays 'down slash'")
	var post_waves: Array = entities.get_children().filter(func(n): return is_instance_of(n, RangedProjectileType))
	_assert(post_waves.size() == pre_projs + 1 and (post_waves.back().get("piercing") == true), "air slash spawns piercing wave projectile")
	for tick in range(12):
		for w: Node in post_waves:
			if is_instance_valid(w) and w.has_method("_step_30hz"):
				w.call("_step_30hz")
		await physics_frame
	_assert(enemy2.health < 2000, "air slash wave travels and damages distant enemy2 (%d)" % enemy2.health)

	# Dash attack
	p.is_attacking = false
	p.current_attack_move = ""
	p.is_dashing = true
	p.vel_y = 0.0
	p.execute_attack("attack")
	_assert(p.animator.current_anim_name == "dash attack" and p.vel_y < 0.0, "dashing attack triggers 'dash attack' lunge hop")

	# 3. Archer actives + piercing arrow hitting two enemies
	p.is_attacking = false
	p.current_attack_move = ""
	p.character_class = "archer"
	p.equipment["weapon"] = "short bow"
	p.range_stat = 30
	p.skill_levels["arrow barrage"] = 4
	p.skill_levels["triple shot"] = 3
	p.skill_levels["arrow rain"] = 3
	p.skill_levels["piercing arrow"] = 3
	p.skill_levels["down crush"] = 3

	for c: Node in entities.get_children():
		if is_instance_of(c, RangedProjectileType):
			c.queue_free()
	await process_frame

	_assert(p.use_skill("arrow barrage") and p.animator.current_anim_name == "shoot bow", "arrow barrage plays 'shoot bow'")
	_assert(entities.get_children().filter(func(n): return is_instance_of(n, RangedProjectileType)).size() >= 4, "arrow barrage lvl 4 spawns >=4 arrows")
	p.is_attacking = false
	p.current_attack_move = ""
	for c: Node in entities.get_children():
		if is_instance_of(c, RangedProjectileType):
			c.queue_free()
	await process_frame

	_assert(p.use_skill("triple shot") and p.animator.current_anim_name == "triple shot", "triple shot plays 'triple shot'")
	_assert(entities.get_children().filter(func(n): return is_instance_of(n, RangedProjectileType)).size() == 3, "triple shot spawns 3 arrows")
	p.is_attacking = false
	p.current_attack_move = ""
	for c: Node in entities.get_children():
		if is_instance_of(c, RangedProjectileType):
			c.queue_free()
	await process_frame

	_assert(p.use_skill("arrow rain") and p.animator.current_anim_name == "rain attack", "arrow rain plays 'rain attack'")
	_assert(entities.get_children().filter(func(n): return is_instance_of(n, RangedProjectileType)).size() >= 7, "arrow rain spawns 4+lvl arrows")
	p.is_attacking = false
	p.current_attack_move = ""
	for c: Node in entities.get_children():
		if is_instance_of(c, RangedProjectileType):
			c.queue_free()
	await process_frame

	p.vel_x = 0.0
	p.vel_y = 0.0
	p.do_apply_gravity = false
	enemy1.health = 2000
	enemy2.health = 2000
	enemy1.vel_x = 0.0
	enemy1.vel_y = 0.0
	enemy1.do_apply_gravity = false
	enemy1.move_dir = 0
	enemy1.dir_change_interval = 10.0
	enemy2.vel_x = 0.0
	enemy2.vel_y = 0.0
	enemy2.do_apply_gravity = false
	enemy2.move_dir = 0
	enemy2.dir_change_interval = 10.0
	enemy1.position = p.position + Vector2(120.0, 0.0)
	enemy2.position = p.position + Vector2(175.0, 0.0)
	_assert(p.use_skill("piercing arrow") and p.animator.current_anim_name == "shoot bow", "piercing arrow plays 'shoot bow'")
	var p_arrows: Array = entities.get_children().filter(func(n): return is_instance_of(n, RangedProjectileType))
	_assert(p_arrows.size() == 1 and (p_arrows[0].get("piercing") == true), "piercing arrow spawns piercing projectile")
	for tick in range(10):
		await physics_frame
	_assert(enemy1.health < 2000 and enemy2.health < 2000, "piercing arrow pierces enemy1 (%d) and hits enemy2 (%d)" % [enemy1.health, enemy2.health])
	p.do_apply_gravity = true
	enemy1.do_apply_gravity = true
	enemy2.do_apply_gravity = true

	p.is_attacking = false
	p.current_attack_move = ""
	p.vel_y = 0.0
	_assert(p.use_skill("down crush") and p.animator.current_anim_name == "down stab" and p.vel_y > 0.0, "down crush plays 'down stab' and dives")

	# 4. Wizard actives (circular attack -> summon beam + VFX, thunder attack -> summon thunder + VFX)
	p.is_attacking = false
	p.current_attack_move = ""
	p.character_class = "wizard"
	p.equipment["weapon"] = "basic wand"
	p.magic_stat = 30
	p.skill_levels["circular attack"] = 3
	p.skill_levels["thunder attack"] = 3
	_assert(p.use_skill("circular attack") and p.animator.current_anim_name == "summon beam", "circular attack plays 'summon beam'")
	_assert(entities.get_children().filter(func(n): return n is PersonEntity.SkillEffectNode).size() >= 1, "circular attack spawns beam VFX")
	p.is_attacking = false
	p.current_attack_move = ""
	_assert(p.use_skill("thunder attack") and p.animator.current_anim_name == "summon thunder", "thunder attack plays 'summon thunder'")

	# 5. Cowboy actives (bullet distance > 1, shotgun attack, upward shoot, grenade attack, jump grenade)
	p.is_attacking = false
	p.current_attack_move = ""
	p.character_class = "cowboy"
	p.equipment["weapon"] = "airsoft gun"
	p.artillery_stat = 30
	p.skill_levels["bullet distance"] = 10
	p.skill_levels["shotgun attack"] = 2
	p.skill_levels["upward shoot"] = 2
	p.skill_levels["grenade attack"] = 2
	p.skill_levels["jump grenade"] = 2
	for c: Node in entities.get_children():
		if is_instance_of(c, RangedProjectileType) or c is PersonEntity.GrenadeProjectileVFX:
			c.queue_free()
	await process_frame

	p._spawn_single_bullet("airsoft gun", "main", false)
	var b_list: Array = entities.get_children().filter(func(n): return is_instance_of(n, RangedProjectileType))
	_assert(b_list.size() == 1 and int(b_list[0].get("life_span")) > 5, "bullet distance lvl 10 increases bullet life_span > 5 (got %d)" % (int(b_list[0].get("life_span")) if b_list.size() > 0 else -1))
	for c: Node in b_list:
		c.queue_free()
	await process_frame

	_assert(p.use_skill("shotgun attack") and entities.get_children().filter(func(n): return is_instance_of(n, RangedProjectileType)).size() >= 4, "shotgun attack spawns >=4 pellets")
	p.is_attacking = false
	p.current_attack_move = ""
	for c: Node in entities.get_children():
		if is_instance_of(c, RangedProjectileType):
			c.queue_free()
	await process_frame

	_assert(p.use_skill("upward shoot") and p.animator.current_anim_name == "gun shoot upward", "upward shoot plays 'gun shoot upward'")
	var up_b: Array = entities.get_children().filter(func(n): return is_instance_of(n, RangedProjectileType))
	_assert(up_b.size() == 1 and float(up_b[0].get("vel_y")) < 0.0, "upward shoot spawns upward projectile")
	p.is_attacking = false
	p.current_attack_move = ""

	_assert(p.use_skill("grenade attack"), "grenade attack succeeds")
	_assert(entities.get_children().filter(func(n): return n is PersonEntity.GrenadeProjectileVFX).size() == 1, "grenade attack spawns GrenadeProjectileVFX")
	p.is_attacking = false
	p.current_attack_move = ""
	p.on_ground = true
	p.vel_y = 0.0
	_assert(p.use_skill("jump grenade") and p.vel_y < 0.0, "jump grenade leaps backward and spawns downward grenade")
	_assert(entities.get_children().filter(func(n): return n is PersonEntity.GrenadeProjectileVFX).size() == 2, "jump grenade spawns second GrenadeProjectileVFX")

	# 6. Hotkeys routing (_trigger_class_hotkey + _trigger_directional_attack)
	p.is_attacking = false
	p.current_attack_move = ""
	p.character_class = "warrior"
	p.equipment["weapon"] = "short sword"
	p.on_ground = true
	p._trigger_class_hotkey("c")
	_assert(p.animator.current_anim_name == "lunge attack", "Hotkey C on ground triggers Warrior power attack")
	p.is_attacking = false
	p.current_attack_move = ""
	p._trigger_class_hotkey("v")
	_assert(p.animator.current_anim_name == "ground stab", "Hotkey V on ground triggers Warrior multi attack")
	p.is_attacking = false
	p.current_attack_move = ""
	p._trigger_directional_attack("up")
	_assert(p.animator.current_anim_name == "spin attack", "Up+Attack triggers Warrior spin attack cleanly")

	world_stub.queue_free()
	await process_frame


func _test_audio_sliders_menu_music_and_admin_max_preset() -> void:
	print("\n--- [14] Audio Volume Sliders (20% default), Main Menu Music & Admin MAX Preset Class Gear ---")
	var amgr: Node = root.get_node_or_null("AudioManager")
	_assert(amgr != null, "AudioManager autoload is present")
	if amgr != null:
		_assert(is_equal_approx(float(amgr.get("music_volume")), 0.2), "AudioManager default music_volume == 0.2 (20%%)")
		_assert(is_equal_approx(float(amgr.get("sfx_volume")), 0.2), "AudioManager default sfx_volume == 0.2 (20%%)")
		_assert(str(amgr.SOUND_ALIASES.get("main menu music", "")) == "Glory_Glory_full_mix", "AudioManager maps 'main menu music' -> Glory_Glory_full_mix")

	# 1. MainMenuUI: sliders instead of checkboxes, default 20%, plays main menu music
	var main_menu_scene: PackedScene = load("res://scenes/menus/MainMenu.tscn")
	_assert(main_menu_scene != null, "MainMenu.tscn loads")
	var mm: Control = main_menu_scene.instantiate()
	root.add_child(mm)
	await process_frame
	_assert(mm.get_node_or_null("OptionsPanel/VBox/SoundCheckBox") == null, "MainMenu SoundCheckBox removed")
	_assert(mm.get_node_or_null("OptionsPanel/VBox/MusicCheckBox") == null, "MainMenu MusicCheckBox removed")
	var mm_sfx_slider: HSlider = mm.get("sound_slider") as HSlider
	var mm_mus_slider: HSlider = mm.get("music_slider") as HSlider
	_assert(mm_sfx_slider != null and mm_mus_slider != null, "MainMenu has sound_slider & music_slider HSliders")
	if mm_sfx_slider != null and mm_mus_slider != null:
		_assert(mm_sfx_slider.focus_mode == Control.FOCUS_NONE and mm_mus_slider.focus_mode == Control.FOCUS_NONE, "MainMenu volume sliders have FOCUS_NONE")
		_assert(is_equal_approx(mm_sfx_slider.value, 0.2) and is_equal_approx(mm_mus_slider.value, 0.2), "MainMenu sliders initialize at 0.2 (20%%)")
		mm_mus_slider.value = 0.65
		mm_sfx_slider.value = 0.40
		await process_frame
		_assert(is_equal_approx(float(amgr.get("music_volume")), 0.65) and is_equal_approx(float(amgr.get("sfx_volume")), 0.40), "MainMenu sliders smoothly update AudioManager volumes")
		mm_mus_slider.value = 0.0
		await process_frame
		var m_player: AudioStreamPlayer = amgr.get("_music_player") as AudioStreamPlayer
		_assert(bool(amgr.get("music_muted")) == true and (m_player == null or m_player.volume_db <= -79.0), "Setting music slider to 0%% mutes music (-80 dB)")
		mm_mus_slider.value = 0.2
		mm_sfx_slider.value = 0.2
		await process_frame
	if amgr != null:
		_assert(str(amgr.get("_current_music_name")) == "Glory_Glory_full_mix", "MainMenuUI starts 'main menu music' (Glory_Glory_full_mix) on _ready()")
		var m_player2: AudioStreamPlayer = amgr.get("_music_player") as AudioStreamPlayer
		_assert(m_player2 != null and m_player2.stream != null, "MainMenu music stream (Glory_Glory_full_mix.mp3) loaded into AudioStreamPlayer")
	mm.queue_free()
	await process_frame

	# 2. OptionsMenu: OFF/ON buttons replaced with HSliders
	var opt_script: GDScript = load("res://scripts/ui/menus/OptionsMenu.gd")
	var opt: Control = opt_script.new()
	root.add_child(opt)
	await process_frame
	_assert(opt.get_node_or_null("MusicOff") == null and opt.get_node_or_null("MusicOn") == null, "OptionsMenu MusicOff/MusicOn toggles removed")
	_assert(opt.get_node_or_null("SoundOff") == null and opt.get_node_or_null("SoundOn") == null, "OptionsMenu SoundOff/SoundOn toggles removed")
	var opt_m: HSlider = opt.get("music_slider") as HSlider
	var opt_s: HSlider = opt.get("sfx_slider") as HSlider
	_assert(opt_m != null and opt_s != null, "OptionsMenu has music_slider & sfx_slider HSliders")
	if opt_m != null and opt_s != null:
		_assert(opt_m.focus_mode == Control.FOCUS_NONE and opt_s.focus_mode == Control.FOCUS_NONE, "OptionsMenu volume sliders have FOCUS_NONE")
		_assert(is_equal_approx(opt_m.value, 0.2) and is_equal_approx(opt_s.value, 0.2), "OptionsMenu sliders sync to 0.2 (20%%)")
		opt_m.value = 0.75
		opt_s.value = 0.55
		await process_frame
		_assert(is_equal_approx(float(amgr.get("music_volume")), 0.75) and is_equal_approx(float(amgr.get("sfx_volume")), 0.55), "OptionsMenu sliders smoothly control AudioManager")
		opt_m.value = 0.2
		opt_s.value = 0.2
		await process_frame
	opt.queue_free()
	await process_frame

	# 3. AdminMenu MAX Preset class popup & best gear per class
	var p_test := PersonEntity.new()
	root.add_child(p_test)
	var adm: Control = AdminMenuType.new()
	root.add_child(adm)
	await process_frame
	adm.call("setup", p_test, null)
	var initial_panel_size: Vector2 = (adm.get("panel") as PanelContainer).size
	adm.call("_on_max_preset")
	var overlay: ColorRect = adm.get("max_preset_overlay") as ColorRect
	_assert(overlay != null and overlay.visible, "AdminMenu MAX Preset opens 4-class choice popup")
	if overlay != null:
		for cid in ["warrior", "archer", "mage", "cowboy"]:
			var cbtn: Button = overlay.find_child("MaxClassBtn_" + cid, true, false) as Button
			_assert(cbtn != null and cbtn.focus_mode == Control.FOCUS_NONE, "MAX Preset modal has %s button with FOCUS_NONE" % cid)

	var expected_gear: Dictionary = {
		"warrior": ["god helmet", "god armor", "god legs", "magma boot", "god blade", "god scimitar"],
		"archer": ["angelic helmet", "angelic armor", "angelic legs", "millennium boot", "angelic bow", ""],
		"mage": ["gemstone helmet", "gemstone armor", "gemstone legs", "empowered boot", "gemstone staff", "gemstone wand"],
		"cowboy": ["neoplasti helmet", "neoplasti armor", "wrangler legs", "corruption boot", "neoplasti blaster", "corruptor"],
	}
	for cid in ["warrior", "archer", "mage", "cowboy"]:
		p_test.inventory.clear()
		adm.call("apply_max_preset_for_class", cid)
		_assert(p_test.level == 5000 and p_test.power_stat >= 1500 and p_test.max_health >= 10000 and p_test.character_class == cid, "MAX Preset [%s] sets Lvl 5000, stats >=1500, HP >=10000 and class" % cid)
		var exp_arr: Array = expected_gear[cid]
		for i in range(5):
			_assert(p_test.inventory.has(exp_arr[i]), "MAX Preset [%s] grants best %s" % [cid, exp_arr[i]])
		var exp_1h: String = str(exp_arr[5])
		if not exp_1h.is_empty():
			var count_1h: int = p_test.inventory.filter(func(x): return str(x) == exp_1h).size()
			_assert(count_1h == 2, "MAX Preset [%s] grants 2x best dualhanded 1H weapon '%s' (got %d)" % [cid, exp_1h, count_1h])

	# 4. AdminMenu size preservation, top-right close button, and edge-dragging
	await process_frame
	var adm_panel: PanelContainer = adm.get("panel") as PanelContainer
	_assert(adm_panel != null and adm_panel.size == initial_panel_size, "AdminMenu panel returns to normal size %s after MAX Preset (got %s)" % [str(initial_panel_size), str(adm_panel.size if adm_panel != null else Vector2.ZERO)])
	if overlay != null:
		overlay.visible = false
	adm.visible = true
	await process_frame
	var start_pos: Vector2 = adm_panel.global_position
	var edge_pos: Vector2 = start_pos + Vector2(6.0, 6.0)
	_assert(bool(adm.call("_is_on_panel_edge", edge_pos)), "Left-top edge detected for dragging")
	var mb_down := InputEventMouseButton.new()
	mb_down.button_index = MOUSE_BUTTON_LEFT
	mb_down.pressed = true
	mb_down.global_position = edge_pos
	adm.call("_input", mb_down)
	var mm_drag := InputEventMouseMotion.new()
	mm_drag.global_position = edge_pos + Vector2(45.0, 30.0)
	adm.call("_input", mm_drag)
	var mb_up := InputEventMouseButton.new()
	mb_up.button_index = MOUSE_BUTTON_LEFT
	mb_up.pressed = false
	mb_up.global_position = mm_drag.global_position
	adm.call("_input", mb_up)
	_assert(adm_panel.global_position.distance_to(start_pos + Vector2(45.0, 30.0)) < 1.0, "Holding LMB on edge drags AdminMenu panel")

	var x_btn: Button = adm.get("close_btn") as Button
	_assert(x_btn != null and x_btn.focus_mode == Control.FOCUS_NONE, "AdminMenu has top-right CloseButton with FOCUS_NONE")
	if x_btn != null:
		x_btn.pressed.emit()
		_assert(not adm.visible, "AdminMenu CloseButton closes AdminMenu")

	adm.queue_free()
	p_test.queue_free()
	await process_frame


func _test_enemy_hit_npcs_archer_filter_max_skills_and_dualhand() -> void:
	print("\n--- [15] Enemy Hit Anims, 110 NPCs Placement/Functions, Archer Filter, MAX Skills (200) & Dualhanded Fix ---")

	# 1. Enemy hit animation clips & Bounce squash
	var swf: Node = root.get_node_or_null("SwfSpriteLoader")
	_assert(swf != null, "SwfSpriteLoader available")
	if swf != null:
		var gb_frames: SpriteFrames = swf.call("get_enemy_sprite_frames", "green bouncer") as SpriteFrames
		_assert(gb_frames != null and gb_frames.has_animation("walk") and gb_frames.has_animation("jump") and gb_frames.has_animation("hit"), "green bouncer has separate walk/jump/hit animations")
		if gb_frames != null and gb_frames.has_animation("hit"):
			_assert(not gb_frames.get_animation_loop("hit"), "green bouncer 'hit' animation is non-looping")
	var e_hit := EnemyEntity.new()
	e_hit.enemy_type = "green bouncer"
	root.add_child(e_hit)
	await process_frame
	e_hit.max_health = 500
	e_hit.health = 500
	e_hit.take_damage(25, null, false, false, 0.0)
	var e_spr: AnimatedSprite2D = e_hit.get("sprite") as AnimatedSprite2D
	_assert(e_spr != null and e_spr.animation == "hit" and bool(e_hit.get("_is_playing_hit")), "EnemyEntity plays 'hit' animation when attacked")
	_assert(e_spr != null and is_equal_approx(e_spr.scale.y, 1.3), "EnemyEntity applies Bounce squash scale.y=1.3 on hit")
	e_hit.queue_free()
	await process_frame

	# 2. All 110 NPCs in StatsDB + GameWorld spawning + TalkBox/Shop/Heal/Quest
	var sdb: Node = root.get_node_or_null("StatsDB")
	_assert(sdb != null and (sdb.get("npcs_list") as Array).size() == 113, "StatsDB loads all 113 NPCs (110 world + 3 virtual)")
	var npcs_s1: Array = sdb.call("get_npcs_for_area", 1)
	_assert(npcs_s1.size() == 3, "Stage 1 has 3 NPCs (Ronald, William, Ralph) (got %d)" % npcs_s1.size())
	var npcs_s79: Array = sdb.call("get_npcs_for_area", 79)
	var npcs_s140: Array = sdb.call("get_npcs_for_area", 140)
	_assert(npcs_s79.any(func(x): return str(x.get("name", "")) == "Tanya") and npcs_s140.any(func(x): return str(x.get("name", "")) == "Tanya"), "Duplicate-named NPCs (Tanya on Stage 79 and Stage 140) both preserved")

	var gw: GameWorld = GameWorld.new()
	root.add_child(gw)
	await process_frame
	var hud_script: GDScript = load("res://scripts/ui/GameHUD.gd")
	var hud: CanvasLayer = hud_script.new()
	gw.add_child(hud)
	await process_frame
	gw.load_level(1)
	await process_frame
	hud.call("bind_player", gw.local_player)
	await process_frame
	_assert(gw.npcs.size() == 3, "GameWorld Stage 1 spawns 3 NPCEntity nodes")
	var william: Node2D = null
	for n: Variant in gw.npcs:
		if n is Node2D and str(n.get("npc_name")) == "William":
			william = n as Node2D
	_assert(william != null and is_equal_approx(william.position.x, 506.0) and is_equal_approx(william.position.y, 749.0 + 50.0 + 30.0), "Stage 1 William placed at (506, 829) lying unconscious")

	gw.load_level(7)
	await process_frame
	_assert(gw.npcs.size() == 4, "GameWorld Stage 7 spawns 4 NPCs (Sales Man, Heath, Mizon, Anoop)")
	var salesman: Node2D = null
	var heath: Node2D = null
	for n: Variant in gw.npcs:
		if n is Node2D:
			if str(n.get("npc_name")) == "Sales Man":
				salesman = n as Node2D
			elif str(n.get("npc_name")) == "Heath":
				heath = n as Node2D
	_assert(salesman != null and heath != null, "Stage 7 has Sales Man and Heath")
	if salesman != null:
		salesman.call("interact")
		await process_frame
		var tb: Control = hud.get("talk_box") as Control
		_assert(tb != null and tb.visible and (tb.get("btn_shop") as BaseButton).visible and (tb.get("btn_sell") as BaseButton).visible, "Sales Man opens TalkBox with Shop and Sell buttons")
		if tb != null:
			(tb.get("btn_shop") as BaseButton).pressed.emit()
			await process_frame
			var smenu: Control = hud.get("shop_menu") as Control
			var s_entries: Array = smenu.get("_shop_entries") if smenu != null else []
			_assert(smenu != null and smenu.visible and s_entries.size() == 30, "Sales Man ShopMenu opens with 30 items")
			gw.local_player.coins = 50000
			var pre_inv: int = gw.local_player.inventory.size()
			smenu.call("select_item", 0)
			smenu.call("_on_action_pressed")
			_assert(gw.local_player.inventory.size() == pre_inv + 1 and gw.local_player.coins < 50000, "ShopMenu buys item and deducts coins")
			smenu.call("close_menu")
			tb.call("close_dialogue")
	if heath != null:
		gw.local_player.max_health = 500
		gw.local_player.health = 100
		gw.local_player.max_mana = 200
		gw.local_player.mana = 20
		heath.call("interact")
		await process_frame
		var tb2: Control = hud.get("talk_box") as Control
		var h_act: Variant = tb2.get("current_action") if tb2 != null else {}
		_assert(tb2 != null and tb2.visible and h_act is Dictionary and str((h_act as Dictionary).get("action", "")) == "heal", "Heath opens TalkBox with Heal action")
		if tb2 != null:
			(tb2.get("btn_next") as BaseButton).pressed.emit()
			(tb2.get("btn_next") as BaseButton).pressed.emit()
			await process_frame
			_assert(gw.local_player.health == 500 and gw.local_player.mana == 200, "Heath heals player to full HP & MP")
	gw.queue_free()
	await process_frame

	# 3. Archer filter in AdminMenu excludes Cowboy guns & Cowboy-primary armor
	var p3 := PersonEntity.new()
	root.add_child(p3)
	var adm3: Control = AdminMenuType.new()
	root.add_child(adm3)
	await process_frame
	adm3.call("setup", p3, null)
	var cf: OptionButton = adm3.get("class_filter") as OptionButton
	var archer_idx: int = -1
	for i in range(cf.item_count):
		if cf.get_item_text(i) == "Archer":
			archer_idx = i
			break
	_assert(archer_idx != -1, "AdminMenu has Archer class filter")
	cf.select(archer_idx)
	adm3.call("_refresh_item_list")
	var ilist: ItemList = adm3.get("item_list") as ItemList
	var archer_names: Array[String] = []
	for i in range(ilist.item_count):
		archer_names.append(ilist.get_item_text(i))
	_assert(archer_names.has("angelic bow") and archer_names.has("small bow"), "Archer filter includes bows")
	_assert(not archer_names.has("airsoft gun") and not archer_names.has("neoplasti blaster") and not archer_names.has("corruptor"), "Archer filter excludes Cowboy guns")
	_assert(not archer_names.has("neoplasti helmet") and not archer_names.has("chemical mask"), "Archer filter excludes Cowboy-primary armor")

	# 4. MAX Preset maxes all class + basic skills (infinite -> 200)
	adm3.call("apply_max_preset_for_class", "warrior")
	_assert(p3.get_skill_level("training") == 200, "MAX Preset sets infinite 'training' skill to 200")
	_assert(p3.get_skill_level("expert warrior") == 200, "MAX Preset sets infinite 'expert warrior' skill to 200")
	_assert(p3.get_skill_level("power attack") == 225, "MAX Preset sets 'power attack' to maxLvl 225")
	_assert(p3.get_skill_level("speed dash") == 15 and p3.dash_lvl == 15, "MAX Preset sets 'speed dash' to 15 and updates dash_lvl")

	# 5. Dualhanded weapons: 2x identical 1H weapon in inventory, equip 1 -> 2nd stays visible & equippable!
	p3.inventory.clear()
	p3.equipment["weapon"] = "short sword"
	p3.equipment["weapon2"] = ""
	p3.add_inventory_item("god scimitar")
	p3.add_inventory_item("god scimitar")
	var im_dual: Control = ItemMenuType.new(p3)
	root.add_child(im_dual)
	await process_frame
	p3.equip_item("god scimitar", "weapon")
	await process_frame
	var entries: Array = im_dual.get("_display_entries")
	var unequipped_scimitars: int = 0
	var equipped_scimitars: int = 0
	for e_v: Variant in entries:
		if e_v is Dictionary and str((e_v as Dictionary).get("name", "")) == "god scimitar":
			if bool((e_v as Dictionary).get("equipped", false)):
				equipped_scimitars += 1
			else:
				unequipped_scimitars += 1
	_assert(equipped_scimitars == 1 and unequipped_scimitars == 1, "Equipping 1st of 2x 'god scimitar' keeps 2nd copy unequipped in ItemMenu (eq=%d, inv=%d)" % [equipped_scimitars, unequipped_scimitars])
	p3.equip_item("god scimitar", "weapon2")
	_assert(str(p3.equipment.get("weapon", "")) == "god scimitar" and str(p3.equipment.get("weapon2", "")) == "god scimitar", "2nd 'god scimitar' equips cleanly into weapon2 (dual-wield)")

	im_dual.queue_free()
	adm3.queue_free()
	p3.queue_free()
	await process_frame


func _test_bug_report_feature() -> void:
	print("\n--- [16] Bug Report Feature (Folder, Button Placement, Scroll Fields, Persistence & Export) ---")
	var reports_dir: String = ProjectSettings.globalize_path("res://bug_reports")
	_assert(DirAccess.dir_exists_absolute(reports_dir), "bug_reports directory exists at client root")

	var draft_path: String = "user://bug_report_draft.json"
	var had_draft: bool = FileAccess.file_exists(draft_path)
	var draft_backup: String = ""
	if had_draft:
		var rf := FileAccess.open(draft_path, FileAccess.READ)
		if rf != null:
			draft_backup = rf.get_as_text()
			rf.close()
		var ud := DirAccess.open("user://")
		if ud != null and ud.file_exists("bug_report_draft.json"):
			ud.remove("bug_report_draft.json")

	var hud_script: GDScript = load("res://scripts/ui/GameHUD.gd")
	var hud: CanvasLayer = hud_script.new()
	root.add_child(hud)
	await process_frame

	var admin_btn: Button = hud.get("sandbox_admin_btn") as Button
	var br_btn: Button = hud.get("bug_report_btn") as Button
	var br_menu: Control = hud.get("bug_report_menu") as Control
	_assert(admin_btn != null and br_btn != null and br_menu != null, "GameHUD creates bug_report_btn and bug_report_menu")
	if admin_btn != null and br_btn != null:
		_assert(br_btn.focus_mode == Control.FOCUS_NONE, "bug_report_btn has FOCUS_NONE")
		_assert(is_equal_approx(br_btn.position.x, admin_btn.position.x) and br_btn.position.y > admin_btn.position.y, "bug_report_btn is positioned directly below sandbox_admin_btn")

	br_btn.pressed.emit()
	await process_frame
	_assert(br_menu.visible, "Clicking Bug Report button opens BugReportMenu")
	_assert(br_menu.get("scroll_container") is ScrollContainer, "BugReportMenu has ScrollContainer for long bug lists")

	var edits: Array = br_menu.get("_bug_edits")
	_assert(edits.size() == 1, "BugReportMenu starts with 1 bug input field")
	(edits[0] as TextEdit).text = "Первый тестовый баг"
	br_menu.call("_on_any_text_changed")
	(br_menu.get("add_field_btn") as Button).pressed.emit()
	await process_frame
	edits = br_menu.get("_bug_edits")
	_assert(edits.size() == 2, "Add field button creates a 2nd separate bug TextEdit")
	(edits[1] as TextEdit).text = "Второй тестовый баг"
	br_menu.call("save_draft")
	br_menu.call("close_menu")
	_assert(not br_menu.visible, "close_menu hides BugReportMenu")

	# Simulate game restart / new character / sandbox by instantiating a fresh BugReportMenu
	var br_script: GDScript = load("res://scripts/ui/BugReportMenu.gd")
	var br_restarted: Control = br_script.new()
	root.add_child(br_restarted)
	await process_frame
	var loaded_texts: Array = br_restarted.call("get_bug_texts")
	_assert(loaded_texts.size() == 2 and loaded_texts[0] == "Первый тестовый баг" and loaded_texts[1] == "Второй тестовый баг", "Bug report draft persists across restarts/characters without downloading")

	# Export numbered .txt to bug_reports/
	var exported_path: String = str(br_restarted.call("export_report_to_folder"))
	_assert(not exported_path.is_empty() and exported_path.begins_with(reports_dir) and FileAccess.file_exists(exported_path), "Download Report saves .txt file into bug_reports/")
	if FileAccess.file_exists(exported_path):
		var ef := FileAccess.open(exported_path, FileAccess.READ)
		var content: String = ef.get_as_text() if ef != null else ""
		if ef != null:
			ef.close()
		_assert(content.contains("1. Первый тестовый баг") and content.contains("2. Второй тестовый баг") and content.strip_edges().ends_with("Узнай источники этих проблем и исправь эти баги"), "Exported .txt numbers each bug and ends with fix instruction")
		DirAccess.remove_absolute(exported_path)

	# Clear all bugs
	br_restarted.call("clear_all_bugs")
	await process_frame
	var after_clear: Array = br_restarted.call("get_bug_texts")
	_assert(after_clear.size() == 1 and str(after_clear[0]).is_empty(), "Clear All resets fields to 1 empty field and clears saved draft")

	br_restarted.queue_free()
	hud.queue_free()
	await process_frame

	if had_draft and not draft_backup.is_empty():
		var wf := FileAccess.open(draft_path, FileAccess.WRITE)
		if wf != null:
			wf.store_string(draft_backup)
			wf.close()
	elif FileAccess.file_exists(draft_path):
		var ud2 := DirAccess.open("user://")
		if ud2 != null and ud2.file_exists("bug_report_draft.json"):
			ud2.remove("bug_report_draft.json")


func _test_dash_dust_npc_alignment_enemy_hitboxes_and_admin_npc_tp() -> void:
	print("\n--- [17] Dash Dust, NPC Alignment/Animation, Enemy Grounding/Hitboxes & Admin NPC Teleport ---")
	var world_stub := Node2D.new()
	var entities := Node2D.new()
	entities.name = "Entities"
	world_stub.add_child(entities)
	root.add_child(world_stub)
	await process_frame

	# 1. Dash Dust
	var p := PersonEntity.new()
	p.is_local_player = false
	p.dash_lvl = 12
	p.facing_dir = 1
	entities.add_child(p)
	await process_frame
	var cloud: Sprite2D = p.spawn_dash_cloud(Vector2(100.0, 200.0), -1.0, 0.0)
	_assert(cloud != null and cloud.texture != null and cloud.centered == false and is_equal_approx(cloud.scale.x, -1.0), "PersonEntity.spawn_dash_cloud creates dash cloud 1..4 sprite with bottom-center pivot and -facing_dir scale")
	if cloud != null:
		cloud.queue_free()
	p.queue_free()
	await process_frame

	# 2. NPCEntity position/animator/frame advance
	var npc_script: GDScript = load("res://scripts/entities/NPCEntity.gd")
	var npc: Node2D = npc_script.new()
	entities.add_child(npc)
	npc.call("setup", {
		"name": "Ronald",
		"origin": {"area": 1, "x": 351, "y": 747, "trigger": 1},
		"appearance": {"hair": "bald", "helmet": "archer hat", "shirt": "archer shirt", "legs": "archer pants", "weapon1": "medium bow", "weapon2": "none", "skin": 2, "scaleX": 1, "eyeFrame": 3, "gender": "male"}
	})
	await process_frame
	var npc_anim: Node2D = npc.get("animator") as Node2D
	_assert(npc_anim != null and is_equal_approx(npc_anim.position.y, 7.0), "NPCEntity sets BodyAnimatorNode.position.y == 7.0 matching PersonEntity")
	_assert(npc.get("shadow_sprite") != null, "NPCEntity creates DropShadow")
	var f0: int = int(npc_anim.get("current_frame")) if npc_anim != null else -1
	npc.call("_physics_process", 1.0 / 30.0)
	var f1: int = int(npc_anim.get("current_frame")) if npc_anim != null else -1
	_assert(f1 != f0, "NPCEntity._physics_process advances BodyAnimatorNode standing frame (%d -> %d)" % [f0, f1])
	npc.queue_free()
	await process_frame

	# 3. Enemy Grounding + Melee/Magic Hitboxes
	var gw_script: GDScript = load("res://scripts/world/GameWorld.gd")
	var gw: Node2D = gw_script.new()
	root.add_child(gw)
	await process_frame
	var goo := EnemyEntity.new()
	goo.enemy_type = "GiantGooCube"
	goo.game_world = gw
	goo.position = Vector2(500.0, 500.0)
	var gw_entities: Node2D = gw.get("entities_container") as Node2D
	gw_entities.add_child(goo)
	(gw.get("enemies") as Array).append(goo)
	await process_frame
	var goo_sprite: AnimatedSprite2D = goo.get("sprite") as AnimatedSprite2D
	var goo_shadow: Sprite2D = goo.get("shadow_sprite") as Sprite2D
	var goo_hb_bottom: float = goo.hit_offset.y + goo.body_height
	var goo_tex_h: float = 0.0
	if goo_sprite != null and goo_sprite.sprite_frames != null:
		var anims: PackedStringArray = goo_sprite.sprite_frames.get_animation_names()
		if anims.size() > 0 and goo_sprite.sprite_frames.get_frame_count(anims[0]) > 0:
			var t: Texture2D = goo_sprite.sprite_frames.get_frame_texture(anims[0], 0)
			if t != null:
				goo_tex_h = t.get_size().y
	_assert(goo_sprite != null and is_equal_approx(goo_sprite.position.y + goo_tex_h * 0.5, goo_hb_bottom), "GiantGooCube sprite bottom aligns with hitbox bottom (no tile sinking)")
	_assert(goo_shadow != null and is_equal_approx(goo_shadow.position.y, goo_hb_bottom), "GiantGooCube DropShadow aligns with hitbox bottom")

	# Edge of GiantGooCube hitbox is ~135px left of center (outside radius=40 from center, inside edge)
	var hp_before: int = goo.health
	gw.call("damage_enemies_in_range", goo.global_position + Vector2(-125.0, 0.0), 40.0, 10, null, false)
	_assert(goo.health < hp_before, "GameWorld.damage_enemies_in_range hits large enemy hitbox edge (not just center point)")

	# MagicProjectile checks full enemy hitbox instead of hardcoded 44x64
	var mp_node: Area2D = MagicProjectileType.new()
	mp_node.set("game_world", gw)
	mp_node.set("damage", 10)
	mp_node.global_position = goo.global_position + Vector2(-120.0, 0.0)
	gw_entities.add_child(mp_node)
	var hp_before_magic: int = goo.health
	mp_node.call("_check_enemy_hits")
	_assert(goo.health < hp_before_magic, "MagicProjectile._check_enemy_hits uses full enemy hitbox instead of 44x64")
	mp_node.queue_free()

	# 4. AdminMenu NPC Teleport across zones with name, numeric zone ID & icon
	var adm: Control = AdminMenuType.new()
	root.add_child(adm)
	await process_frame
	var p_tp: PersonEntity = gw.get("player") as PersonEntity
	adm.call("setup", p_tp, gw)
	var npc_sel: OptionButton = adm.get("npc_select") as OptionButton
	_assert(npc_sel != null and npc_sel.focus_mode == Control.FOCUS_NONE and npc_sel.item_count >= 50, "AdminMenu npc_select populated with all world NPCs and FOCUS_NONE (%d)" % (npc_sel.item_count if npc_sel != null else 0))
	if npc_sel != null and npc_sel.item_count > 0:
		var first_text: String = npc_sel.get_item_text(0)
		_assert(first_text.contains("(Zone ") and npc_sel.get_item_icon(0) != null, "AdminMenu npc_select shows NPC name, numeric Zone ID and icon ('%s')" % first_text)
		# Pick an NPC in Zone != current_stage_id
		var cur_stage: int = int(gw.get("current_stage_id"))
		var entries: Array = adm.get("_npc_entries")
		var picked_idx: int = -1
		for ei: int in range(entries.size()):
			if int(entries[ei].get("area", cur_stage)) != cur_stage:
				picked_idx = ei
				break
		if picked_idx >= 0:
			npc_sel.select(picked_idx)
			adm.call("_on_teleport_npc")
			await process_frame
			var target_area: int = int(entries[picked_idx].get("area", -1))
			_assert(int(gw.get("current_stage_id")) == target_area, "AdminMenu _on_teleport_npc loads NPC's target zone (%d)" % target_area)
			if p_tp != null:
				var exp_pos := Vector2(float(entries[picked_idx].get("x", 0.0)), float(entries[picked_idx].get("y", 0.0)) + 50.0)
				_assert(p_tp.global_position.distance_to(exp_pos) < 1.0, "AdminMenu _on_teleport_npc places player at NPC coordinates")

	adm.queue_free()
	gw.queue_free()
	world_stub.queue_free()
	await process_frame


func _test_fix_log_and_draggable_windows() -> void:
	print("\n--- [18] Fix Log Menu, Button Placement & Draggable BugReport/FixLog Windows ---")
	var hud: CanvasLayer = GameHUDType.new()
	root.add_child(hud)
	await process_frame

	var br_btn: Button = hud.get("bug_report_btn") as Button
	var fl_btn: Button = hud.get("fix_log_btn") as Button
	var br_menu: Control = hud.get("bug_report_menu") as Control
	var fl_menu: Control = hud.get("fix_log_menu") as Control
	_assert(fl_btn != null and fl_menu != null, "GameHUD creates fix_log_btn and fix_log_menu")
	if br_btn != null and fl_btn != null:
		_assert(fl_btn.focus_mode == Control.FOCUS_NONE, "fix_log_btn has FOCUS_NONE")
		_assert(is_equal_approx(fl_btn.position.x, br_btn.position.x) and fl_btn.position.y > br_btn.position.y, "fix_log_btn is positioned directly below bug_report_btn")

	fl_btn.pressed.emit()
	await process_frame
	_assert(fl_menu.visible, "Clicking Fix Log button opens FixLogMenu")
	var u_list: ItemList = fl_menu.get("updates_list") as ItemList
	var d_title: Label = fl_menu.get("detail_title") as Label
	var d_text: RichTextLabel = fl_menu.get("detail_text") as RichTextLabel
	_assert(u_list != null and u_list.item_count >= 1, "FixLogMenu loads grouped updates from fix_log.json (count=%d)" % (u_list.item_count if u_list != null else 0))
	if u_list != null and u_list.item_count >= 1:
		u_list.select(0)
		fl_menu.call("_on_update_selected", 0)
		_assert(d_title != null and not d_title.text.is_empty() and d_text != null and not d_text.text.is_empty(), "Selecting a Fix Log update displays its title and full overview")

	# Edge dragging for FixLogMenu
	var fl_panel: PanelContainer = fl_menu.get("panel") as PanelContainer
	var fl_start: Vector2 = fl_panel.global_position
	var fl_edge: Vector2 = fl_start + Vector2(4.0, 4.0)
	_assert(bool(fl_menu.call("_is_on_panel_edge", fl_edge)), "FixLogMenu detects left-top edge for dragging")
	var mb_press := InputEventMouseButton.new()
	mb_press.button_index = MOUSE_BUTTON_LEFT
	mb_press.pressed = true
	mb_press.global_position = fl_edge
	fl_menu.call("_input", mb_press)
	var mm_move := InputEventMouseMotion.new()
	mm_move.global_position = fl_edge + Vector2(35.0, 20.0)
	fl_menu.call("_input", mm_move)
	var mb_rel := InputEventMouseButton.new()
	mb_rel.button_index = MOUSE_BUTTON_LEFT
	mb_rel.pressed = false
	mb_rel.global_position = fl_edge + Vector2(35.0, 20.0)
	fl_menu.call("_input", mb_rel)
	_assert(fl_panel.global_position.distance_to(fl_start) > 10.0, "Holding LMB on edge drags FixLogMenu panel")

	fl_menu.call("close_menu")
	await process_frame
	_assert(not fl_menu.visible, "FixLogMenu close_menu hides window")

	# Edge dragging for BugReportMenu
	br_menu.call("open_menu")
	await process_frame
	var br_panel: PanelContainer = br_menu.get("panel") as PanelContainer
	var br_start: Vector2 = br_panel.global_position
	var br_edge: Vector2 = br_start + Vector2(4.0, 4.0)
	_assert(bool(br_menu.call("_is_on_panel_edge", br_edge)), "BugReportMenu detects left-top edge for dragging")
	var mb_press2 := InputEventMouseButton.new()
	mb_press2.button_index = MOUSE_BUTTON_LEFT
	mb_press2.pressed = true
	mb_press2.global_position = br_edge
	br_menu.call("_input", mb_press2)
	var mm_move2 := InputEventMouseMotion.new()
	mm_move2.global_position = br_edge + Vector2(30.0, 25.0)
	br_menu.call("_input", mm_move2)
	var mb_rel2 := InputEventMouseButton.new()
	mb_rel2.button_index = MOUSE_BUTTON_LEFT
	mb_rel2.pressed = false
	mb_rel2.global_position = br_edge + Vector2(30.0, 25.0)
	br_menu.call("_input", mb_rel2)
	_assert(br_panel.global_position.distance_to(br_start) > 10.0, "Holding LMB on edge drags BugReportMenu panel")
	br_menu.call("close_menu")

	hud.queue_free()
	await process_frame


func _test_authentic_npc_talkbox_and_shop_menu() -> void:
	print("\n--- [19] Authentic NPC, TalkBox (Portrait/Fonts/3 Buttons) & ItemMenu Shop/Sell ---")
	var gw_script: GDScript = load("res://scripts/world/GameWorld.gd")
	var gw: Node2D = gw_script.new()
	root.add_child(gw)
	await process_frame
	gw.call("load_level", 1)
	await process_frame

	# 1. Stage 1 William body rotated -90, NameLabel NOT rotated, Ronald uses talk bubble & brown shoe
	var william: Node2D = null
	var ronald: Node2D = null
	for n: Variant in gw.npcs:
		if n is Node2D:
			if str(n.get("npc_name")) == "William":
				william = n as Node2D
			elif str(n.get("npc_name")) == "Ronald":
				ronald = n as Node2D
	_assert(william != null and is_equal_approx(william.rotation, 0.0) and is_equal_approx((william.get("animator") as Node2D).rotation, deg_to_rad(-90.0)) and is_equal_approx((william.get("name_label") as Label).rotation, 0.0), "Stage 1 William rotates animator -90 deg while keeping NameLabel upright")
	if ronald != null:
		var r_anim: Node2D = ronald.get("animator") as Node2D
		var r_tb: BaseButton = ronald.get("talk_bubble_btn") as BaseButton
		_assert(r_anim != null and str(r_anim.get("shoe_name")) == "brown shoe", "NPCEntity defaults shoe_name to 'brown shoe'")
		_assert(r_tb is TextureButton and (r_tb as TextureButton).texture_normal != null, "NPCEntity uses authentic 'talk bubble' TextureButton")

	# 2. TalkBox AS3 parity (828x242, PortraitAnimator, readable_font, only Next/Shop/Sell buttons)
	gw.call("load_level", 7)
	await process_frame
	var hud: CanvasLayer = gw.get("hud") as CanvasLayer
	var salesman: Node2D = null
	for n: Variant in gw.npcs:
		if n is Node2D and str(n.get("npc_name")) == "Sales Man":
			salesman = n as Node2D
			break
	_assert(salesman != null, "Stage 7 Sales Man found")
	if salesman != null and hud != null:
		salesman.call("interact")
		await process_frame
		var tb: Control = hud.get("talk_box") as Control
		_assert(tb != null and tb.size == Vector2(828, 242), "TalkBox uses authentic 828x242 panel size")
		_assert(tb.get("close_btn") == null and tb.get("btn_quests") == null, "TalkBox has NO fake CloseButton or QuestsBtn")
		var portrait: Node2D = tb.get("portrait_animator") as Node2D
		_assert(portrait != null and str(portrait.get("shirt_name")) != "", "TalkBox renders live PortraitAnimator for NPC")
		var d_lbl: Label = tb.get("dialogue_label") as Label
		_assert(d_lbl != null and d_lbl.get_theme_font("font") != null, "TalkBox DialogueText uses readable_font.fnt")

		# 3. ShopMenu AS3 ItemMenu parity, real items/stats, coin check
		(tb.get("btn_shop") as BaseButton).pressed.emit()
		await process_frame
		var smenu: Control = hud.get("shop_menu") as Control
		_assert(smenu != null and smenu.visible and smenu.size == Vector2(500, 487), "ShopMenu uses authentic 500x487 ItemMenu panel")
		_assert(smenu.get("btn_buy") is TextureButton and smenu.get("btn_sell") is TextureButton, "ShopMenu uses buy_btn and sell_btn_00 TextureButtons")
		var entries: Array = smenu.get("_shop_entries")
		_assert(entries.size() == 30 and not str(entries[0].get("name", "")).begins_with("{"), "ShopMenu parses real item names from npcs.json (got '%s')" % str(entries[0].get("name", "")))
		smenu.call("select_item", 0)
		await process_frame
		var stats_lbl: Label = smenu.get("item_stats_label") as Label
		_assert(stats_lbl != null and stats_lbl.text.contains("Cost: $"), "ShopMenu displays item stats and 'Cost: $...'")

		# Insufficient coins MUST block purchase
		gw.local_player.coins = 0
		var inv_before: int = gw.local_player.inventory.size()
		smenu.call("_on_action_pressed")
		_assert(gw.local_player.coins == 0 and gw.local_player.inventory.size() == inv_before, "ShopMenu blocks purchase when player has insufficient coins")

		# Sufficient coins succeeds and deducts exact price
		var item_price: int = int(entries[0].get("price", 0))
		gw.local_player.coins = item_price + 500
		smenu.call("_on_action_pressed")
		_assert(gw.local_player.coins == 500 and gw.local_player.inventory.size() == inv_before + 1, "ShopMenu deducts exact item price and adds item when coins suffice")

		# Sell mode (35% price)
		smenu.call("open_sell", salesman.get("npc_data"), gw.local_player)
		await process_frame
		var sell_entries: Array = smenu.get("_shop_entries")
		_assert(sell_entries.size() >= 1, "ShopMenu open_sell lists player inventory items")
		if sell_entries.size() >= 1:
			smenu.call("select_item", 0)
			var sell_stats: Label = smenu.get("item_stats_label") as Label
			_assert(sell_stats != null and sell_stats.text.contains("Sell for $"), "ShopMenu sell mode shows 'Sell for $...'")

	gw.queue_free()
	await process_frame


func _test_fix_log_size_enemy_speed_fall_vfx_and_weapon_sfx() -> void:
	print("\n--- [20] FixLog Size, Numbered Log, Enemy Speed, Fall VFX & Weapon SFX ---")
	var fl_menu: Control = FixLogMenuType.new()
	root.add_child(fl_menu)
	await process_frame
	fl_menu.call("open_menu")
	await process_frame
	var fl_panel: PanelContainer = fl_menu.get("panel") as PanelContainer
	_assert(fl_panel != null and fl_panel.size == Vector2(600, 420), "FixLogMenu uses compact 600x420 panel size (got %s)" % str(fl_panel.size if fl_panel != null else Vector2.ZERO))
	var fl_updates: Array = fl_menu.get("_updates")
	var first_u: Dictionary = fl_updates[fl_updates.size() - 1] if fl_updates.size() > 0 else {}
	_assert(fl_updates.size() >= 1 and str(first_u.get("id", "")) == "1" and str(first_u.get("title", "")).begins_with("1."), "fix_log.json starts from sequential #1 entry")
	fl_menu.queue_free()
	await process_frame

	# EnemyEntity AS3 movement speed (no /4.5 divisor, no 1.5*s clamp)
	var enemy := EnemyEntity.new()
	enemy.enemy_type = "green walker"
	enemy.move_speed_stat = 3.0
	enemy.on_ground = true
	enemy.move_dir = 1
	enemy.vel_x = 6.0
	root.add_child(enemy)
	await process_frame
	enemy.vel_x = 6.0
	enemy.on_ground = true
	enemy.move_dir = 1
	enemy.call("_process_ai", 1.0 / 30.0)
	_assert(enemy.vel_x > 7.5, "EnemyEntity accelerates by full move_speed_stat without /4.5 or 1.5x clamp (vel_x=%.2f)" % enemy.vel_x)
	enemy.queue_free()
	await process_frame

	# PersonEntity falling VFX (handleDownAccel white pixel streaks)
	var p := PersonEntity.new()
	var fx_container := Node2D.new()
	root.add_child(fx_container)
	fx_container.add_child(p)
	p.on_ground = false
	p.accel_down_multiplier = 1.5
	p.set("_fall_vfx_tick", 6)
	p.call("_update_fall_vfx")
	_assert(fx_container.get_child_count() == 4, "PersonEntity spawns 3 white fall streaks when accel_down_multiplier > 1.1 (got %d)" % (fx_container.get_child_count() - 1))
	fx_container.queue_free()
	await process_frame

	# AudioManager subfolder & AS3 SFX alias resolution + weapon sound lookup
	var am: Node = root.get_node_or_null("AudioManager")
	_assert(am != null, "AudioManager autoload is present")
	if am != null:
		_assert(am.call("_resolve_sound_name", "slash") == "sword swoosh 1", "AudioManager maps AS3 'slash' -> 'sword swoosh 1'")
		_assert(am.call("_resolve_sound_name", "bow fire") == "bow_fire", "AudioManager maps AS3 'bow fire' -> 'bow_fire'")
		_assert(am.call("get_audio_stream", "sword swoosh 1", false) != null, "AudioManager loads SFX/sword swoosh 1.mp3")
		_assert(am.call("get_audio_stream", "bow_fire", false) != null, "AudioManager loads SFX/bow_fire.mp3")
		_assert(am.call("get_audio_stream", "pistol", false) != null, "AudioManager loads gun sounds/pistol.mp3")
		_assert(am.call("get_audio_stream", "magic swing", false) != null, "AudioManager loads SFX/magic swing.mp3")
	var p_snd := PersonEntity.new()
	root.add_child(p_snd)
	_assert(str(p_snd.call("_get_weapon_sound_name", "pistol")) == "pistol", "PersonEntity resolves weapon sound name from StatsDB/item ('pistol')")
	p_snd.queue_free()
	await process_frame


func _test_talkbox_exit_wall_dust_camera_zoom_and_fix_tips() -> void:
	print("\n--- [21] TalkBox Exit Button, Wall Slide Dust Cleanup, Camera Zoom & FixLog Tips ---")
	# 1. TalkBox Exit button
	var tb: Control = load("res://scripts/ui/menus/TalkBox.gd").new()
	root.add_child(tb)
	await process_frame
	var b_next: TextureButton = tb.get("btn_next") as TextureButton
	var exit_lbl: Label = b_next.get_node_or_null("ExitLabel") as Label if b_next != null else null
	_assert(b_next != null and b_next.name == "ExitBtn" and exit_lbl != null and exit_lbl.text == "exit", "TalkBox renames Next button to 'exit' while keeping btn_next API")
	tb.queue_free()
	await process_frame

	# 2. PersonEntity dash dust does not spawn on wall/air and clears on wall slide
	var container := Node2D.new()
	root.add_child(container)
	var p := PersonEntity.new()
	container.add_child(p)
	p.on_ground = true
	p.on_wall = false
	p.dash_lvl = 12
	p.spawn_dash_cloud(Vector2.ZERO, 1.0, 0.0, 0, "dash_run_dust")
	_assert(container.get_child_count() == 2, "Dash run cloud spawned into world container")
	p.call("_clear_run_dash_dust")
	await process_frame
	_assert(container.get_child_count() == 1, "_clear_run_dash_dust removes lingering dash clouds on wall slide")
	p.on_ground = false
	p.on_wall = true
	if p.animator != null:
		p.animator.current_anim_name = "dashing"
	p.set("_dash_dust_tick", 9)
	p.set("_previous_dust_pos", Vector2(100, 0))
	p.call("_update_dash_dust")
	_assert(container.get_child_count() == 1, "No dash run dust spawns while in air / on wall")
	container.queue_free()
	await process_frame

	# 3. GameWorld camera zoom (+/-) and window/map normalization
	var gw: Node = load("res://scripts/world/GameWorld.gd").new()
	root.add_child(gw)
	await process_frame
	gw.call("load_level", 1)
	await process_frame
	var cam: Camera2D = gw.get("camera") as Camera2D
	_assert(cam != null and cam.zoom == Vector2(1.0, 1.0), "GameWorld camera defaults to 1.0 zoom (950x700 original)")
	var k_plus := InputEventKey.new()
	k_plus.keycode = KEY_EQUAL
	k_plus.pressed = true
	gw.call("_unhandled_input", k_plus)
	_assert(is_equal_approx(cam.zoom.x, 1.1), "Pressing '+' zooms camera in to 1.1 (got %.2f)" % cam.zoom.x)
	var k_minus := InputEventKey.new()
	k_minus.keycode = KEY_MINUS
	k_minus.pressed = true
	gw.call("_unhandled_input", k_minus)
	gw.call("_unhandled_input", k_minus)
	_assert(is_equal_approx(cam.zoom.x, 0.9), "Pressing '-' zooms camera out to 0.9 (got %.2f)" % cam.zoom.x)
	gw.queue_free()
	await process_frame

	# 4. FixLogMenu test tips popup open/close & sizing
	var fl: Control = FixLogMenuType.new()
	root.add_child(fl)
	await process_frame
	fl.call("open_menu")
	await process_frame
	var tips_btn: Button = fl.get("test_tips_btn") as Button
	var tips_overlay: ColorRect = fl.get("tips_overlay") as ColorRect
	var tips_panel: PanelContainer = fl.get("tips_panel") as PanelContainer
	var tips_text: RichTextLabel = fl.get("tips_text") as RichTextLabel
	var tips_close: Button = fl.get("tips_close_btn") as Button
	_assert(tips_btn != null and tips_btn.focus_mode == Control.FOCUS_NONE, "FixLogMenu creates TestTipsButton with FOCUS_NONE")
	tips_btn.pressed.emit()
	await process_frame
	_assert(tips_overlay != null and tips_overlay.visible and tips_panel != null and tips_panel.size == Vector2(520, 340), "TestTipsPanel opens with compact 520x340 size")
	_assert(tips_text != null and not tips_text.text.is_empty(), "TestTipsPanel displays testing tips for selected update")
	tips_close.pressed.emit()
	await process_frame
	_assert(not tips_overlay.visible and fl.visible, "Closing TestTipsPanel returns cleanly to FixLogMenu")
	fl.queue_free()
	await process_frame

	print("\n[22] Enemy Speed, Loot Collision, TalkBox Buttons/Dialogs & Tile Collisions:")
	# 1. EnemyEntity speed does not exceed player pace (~9.05 px/tick) on normal walk
	var mob := EnemyEntity.new()
	mob.enemy_type = "green walker"
	root.add_child(mob)
	mob.on_ground = true
	mob.move_dir = 1
	mob.dir_change_interval = 10.0
	for _t: int in range(60):
		mob.call("_process_ai", 1.0 / 30.0)
	_assert(absf(mob.vel_x) <= 8.85, "Green walker ground vel_x stays <= 8.85 px/tick (got %.2f)" % mob.vel_x)
	mob.queue_free()
	await process_frame

	var crab := EnemyEntity.new()
	crab.enemy_type = "crab"
	root.add_child(crab)
	crab.on_ground = true
	crab.move_dir = 1
	crab.dir_change_interval = 10.0
	for _t: int in range(60):
		crab.call("_process_ai", 1.0 / 30.0)
	_assert(absf(crab.vel_x) <= 8.85, "High-stat crab normal walk vel_x stays <= 8.85 px/tick (got %.2f)" % crab.vel_x)
	crab.queue_free()
	await process_frame

	# 2. LootItemEntity has collision_layer == 0 so it never blocks players/enemies
	var loot := LootItemEntity.new()
	root.add_child(loot)
	_assert(loot.collision_layer == 0 and loot.collision_mask == 9, "LootItemEntity has collision_layer=0 and collision_mask=1|8 (got layer=%d mask=%d)" % [loot.collision_layer, loot.collision_mask])
	loot.queue_free()
	await process_frame

	# 3. TalkBox ExitBtn matches 112x44 ShopBtn/SellBtn, SellBtn visible on merchants, authentic NPC dialogs
	var tb2: Control = load("res://scripts/ui/menus/TalkBox.gd").new()
	root.add_child(tb2)
	await process_frame
	var b2_next: TextureButton = tb2.get("btn_next") as TextureButton
	var b2_shop: TextureButton = tb2.get("btn_shop") as TextureButton
	var b2_sell: TextureButton = tb2.get("btn_sell") as TextureButton
	_assert(b2_next != null and b2_shop != null and b2_sell != null, "TalkBox builds ExitBtn, ShopBtn, SellBtn")
	_assert(is_equal_approx(b2_next.position.y, b2_shop.position.y) and is_equal_approx(b2_shop.position.y, b2_sell.position.y), "TalkBox buttons share the exact same Y alignment")
	if b2_next.texture_normal != null and b2_shop.texture_normal != null:
		_assert(b2_next.texture_normal.get_size() == b2_shop.texture_normal.get_size(), "ExitBtn texture size matches ShopBtn (112x44)")
	tb2.call("start_dialogue", {"name": "Bob", "origin": {"trigger": 1, "buy": true, "sell": true}}, null)
	_assert(b2_shop.visible and b2_sell.visible and b2_next.visible, "Shopkeeper dialog shows ShopBtn, SellBtn and ExitBtn")
	var sdb_node: Node = root.get_node_or_null("StatsDB")
	var dlg_lottery: Dictionary = sdb_node.call("get_npc_dialog_for_trigger", 83, {"name": "Lottery Man", "origin": {"trigger": 83}}, null)
	_assert(str(dlg_lottery.get("text", "")).contains("lottery"), "Lottery Man (trigger 83) uses authentic AS3 lottery dialog")
	var dlg_vendor: Dictionary = sdb_node.call("get_npc_dialog_for_trigger", -1, {"name": "Item Vendor", "origin": {"trigger": -1}}, null)
	_assert(bool(dlg_vendor.get("hasShop", false)) and bool(dlg_vendor.get("hasSell", false)), "Item Vendor (-1 trigger) enables Shop and Sell buttons")
	tb2.queue_free()
	await process_frame

	# 4. TileMapRenderer does not assign collision to non-colliding decorative tiles, while maps 1-8 ground/slope tiles retain shapes
	var non_solid_decor: Array[int] = [2, 24, 32, 61, 66, 84, 85, 89, 92, 93, 96, 100, 101, 112]
	var any_bad_tile_col: bool = false
	for tid: int in non_solid_decor:
		if not TileMapRenderer.get_source_collision_shapes(tid, "mapMain", 1).is_empty():
			any_bad_tile_col = true
			break
	_assert(not any_bad_tile_col, "Decorative textured tiles (2,24,32,61,66,84..112) have 0 collision shapes")
	for tid_solid: int in [1, 3, 5, 6, 7, 8, 11, 12, 13, 17, 23]:
		_assert(not TileMapRenderer.get_source_collision_shapes(tid_solid, "mapMain", 1).is_empty(), "Maps 1-8 ground/slope tile %d has collision on mapMain" % tid_solid)
	_assert(not TileMapRenderer.get_source_collision_shapes(1, "mapG2", 1).is_empty() and not TileMapRenderer.get_source_collision_shapes(7, "mapG2", 1).is_empty(), "Platform edge tiles (1, 7) have one-way collision on mapG2")
	_assert(not TileMapRenderer.get_source_collision_shapes(38, "mapMain", 1).is_empty() and not TileMapRenderer.get_source_collision_shapes(0, "mapMain", 1).is_empty(), "AS3 solid tiles (38, 0) retain collision on mapMain")

	print("[23] Update 4 fixes (backgrounds, loot drop/pickup, PetShopMenu, FloatingDamage bitmap glyphs, AdminMenu Restore, Skills/Character UI)")
	# 5. GameWorld background: 1x1 placeholders skipped, narrow layers tiled >= 2800px
	var gw_bg := GameWorld.new()
	root.add_child(gw_bg)
	await process_frame
	gw_bg.call("_setup_background", {"backgroundAtlas": "backgrounds18"})
	_assert(gw_bg.parallax_layer_sky.get_child_count() == 0, "1x1 placeholder sky (backgrounds18) is skipped instead of stretched")
	gw_bg.call("_setup_background", {"backgroundAtlas": "backgrounds1"})
	await process_frame
	_assert(gw_bg.parallax_layer_far.motion_mirroring.x >= 2800.0 and gw_bg.parallax_layer_far.get_child_count() >= 4, "Narrow background 3 (479px) repeats enough mirrored pairs to cover >= 2800px")

	# 7 & 12. Loot drop from world + E-key pickup & coin auto-pickup
	var drop_player := PersonEntity.new()
	drop_player.is_local_player = true
	drop_player.character_name = "LootTester"
	gw_bg.entities_container.add_child(drop_player)
	await process_frame
	drop_player.global_position = Vector2(100, 100)
	var dropped: LootItemEntity = gw_bg.call("spawn_dropped_item", "apple", Vector2(120, 100), "LootTester") as LootItemEntity
	await process_frame
	_assert(dropped != null and dropped.sprite != null and dropped.sprite.texture != null, "Dropped apple resolves texture and aligns on ground")
	var inv_before: int = drop_player.inventory.size()
	_assert(gw_bg.call("try_pickup_nearest_loot", drop_player) and drop_player.inventory.size() == inv_before + 1, "E-key pickup (try_pickup_nearest_loot) adds dropped item back to inventory")
	gw_bg.queue_free()
	await process_frame

	# 8. AdminMenu Restore HP/MP button
	var adm: Control = load("res://scripts/ui/AdminMenu.gd").new()
	root.add_child(adm)
	await process_frame
	var adm_player := PersonEntity.new()
	adm_player.max_health = 500
	adm_player.health = 10
	adm_player.max_mana = 200
	adm_player.mana = 5
	root.add_child(adm_player)
	await process_frame
	adm.set("player", adm_player)
	adm.call("_on_restore_hp_mp")
	_assert(adm_player.health == 500 and adm_player.mana == 200, "AdminMenu Restore HP/MP refills health and mana to max")
	adm.queue_free()
	adm_player.queue_free()
	await process_frame

	# 9. PetShopMenu opens with vendor pets and allows purchase
	var pshop: Control = load("res://scripts/ui/menus/PetShopMenu.gd").new()
	root.add_child(pshop)
	await process_frame
	var pet_buyer := PersonEntity.new()
	pet_buyer.character_name = "PetBuyer"
	pet_buyer.coins = 500000
	root.add_child(pet_buyer)
	await process_frame
	var purchased_pets: Array = []
	pshop.connect("pet_purchased", func(pd: Dictionary) -> void: purchased_pets.append(pd))
	pshop.call("open_pet_shop", {"talkID": 42}, pet_buyer)
	_assert(pshop.visible and pshop.get("_current_pets").size() == 6, "PetShopMenu loads 6 pets for talkID 42")
	pshop.call("_on_buy_pressed")
	_assert(pet_buyer.coins == 300000 and purchased_pets.size() == 1, "PetShopMenu deducts coins (500k -> 300k for Tebra) and emits pet_purchased")
	pshop.queue_free()
	pet_buyer.queue_free()
	await process_frame

	# 11. FloatingDamage renders damage and avoided with original bitmap font glyphs (Sprite2D)
	var fd_cls: Script = load("res://scripts/effects/FloatingDamage.gd") as Script
	var fd_node: Node2D = fd_cls.call("spawn_damage", root, 123, Vector2(50, 50), false, false, false) as Node2D
	var fd_av: Node2D = fd_cls.call("spawn_damage", root, 0, Vector2(50, 50), false, false, true) as Node2D
	_assert(fd_node != null and fd_node.get_child_count() > 0 and fd_node.get_child(0) is Node2D and fd_node.get_child(0).get_child_count() == 3, "FloatingDamage renders 3 bitmap glyph sprites for '123'")
	_assert(fd_av != null and fd_av.get_child_count() > 0 and fd_av.get_child(0) is Node2D and fd_av.get_child(0).get_child_count() == 7, "FloatingDamage renders 7 bitmap glyph sprites for 'avoided'")
	fd_node.queue_free()
	fd_av.queue_free()
	await process_frame

	# 13. CharacterMenu Fishing & Chopping info popup
	var cmenu: Control = load("res://scripts/ui/menus/CharacterMenu.gd").new()
	root.add_child(cmenu)
	await process_frame
	var finfo: TextureButton = cmenu.get("fishing_info_btn") as TextureButton
	_assert(finfo != null, "CharacterMenu creates FishingInfoBtn")
	finfo.emit_signal("mouse_entered")
	var pop: PanelContainer = cmenu.get("skill_info_popup") as PanelContainer
	var pop_lbl: Label = cmenu.get("skill_info_label") as Label
	_assert(pop != null and pop.visible and pop_lbl != null and pop_lbl.text.contains("Fishing"), "CharacterMenu shows Fishing info tooltip on hover")
	finfo.emit_signal("mouse_exited")
	_assert(not pop.visible, "CharacterMenu hides skill info tooltip on mouse exit")
	cmenu.queue_free()
	await process_frame


func _test_milestone1_tile_and_metadata_fixes() -> void:
	print("\n--- [24] Milestone 1: Foreground Metadata, CoinBox Spawning & Collision Parity ---")
	var sdb: Node = root.get_node_or_null("StatsDB")
	var meta_142: Dictionary = sdb.get_area_meta(142)
	_assert(meta_142.get("foregroundTilesClass") == "CloudForegroundTiles", "map_142 uses CloudForegroundTiles for Theme 29")
	var meta_119: Dictionary = sdb.get_area_meta(119)
	_assert(meta_119.get("foregroundTilesClass") == "MushroomHouseForegroundTiles", "map_119 uses MushroomHouseForegroundTiles for Theme 22")
	var meta_117: Dictionary = sdb.get_area_meta(117)
	_assert(meta_117.get("foregroundTilesClass") == "RobotHouseForegroundTiles", "map_117 uses RobotHouseForegroundTiles for Theme 24")
	var meta_124: Dictionary = sdb.get_area_meta(124)
	_assert(meta_124.get("foregroundTilesClass") == "RobotHouseForegroundTiles", "map_124 uses RobotHouseForegroundTiles for Theme 24")
	var meta_92: Dictionary = sdb.get_area_meta(92)
	_assert(meta_92.get("foregroundTilesClass") == "AquaHouseForegroundTiles", "map_92 uses AquaHouseForegroundTiles for Theme 28")

	# GameWorld CoinBox spawning on Stage 1
	var gw := GameWorld.new()
	root.add_child(gw)
	gw.load_level(1)
	await process_frame
	var coinboxes: Array = []
	if gw.props_container != null:
		for ch: Node in gw.props_container.get_children():
			if ch.get_script() == CoinBoxEntityType:
				coinboxes.append(ch)
	_assert(coinboxes.size() == 5, "GameWorld._spawn_coin_boxes spawns exactly 5 CoinBoxEntity instances on Stage 1 (found %d)" % coinboxes.size())
	if not coinboxes.is_empty():
		var cb: Node = coinboxes[0]
		var before_loot: int = 0
		for ch: Node in gw.entities_container.get_children():
			if ch is LootItemEntity and (ch as LootItemEntity).is_coin:
				before_loot += 1
		cb.call("_on_jump_hit", gw.local_player)
		var after_loot: int = 0
		var coin_val_ok: bool = false
		for ch: Node in gw.entities_container.get_children():
			if ch is LootItemEntity and (ch as LootItemEntity).is_coin:
				after_loot += 1
				if (ch as LootItemEntity).coin_amount == 2:
					coin_val_ok = true
		_assert(after_loot == before_loot + 3 and coin_val_ok, "CoinBoxEntity jump hit spawns 3 coins of value 2 on Stage 1 (GameCode.Items.cs)")
		cb.call("_on_jump_hit", gw.local_player)
		cb.call("_on_jump_hit", gw.local_player)
		_assert(not cb.visible, "CoinBoxEntity empties and hides after 3rd hit")

	# TreeEntity & FishEntity on Stage 1
	_assert(not gw.trees.is_empty(), "GameWorld spawns TreeEntity instances on Stage 1")
	if not gw.trees.is_empty():
		var tree_ent: Node = gw.trees[0]
		var res_chop: Dictionary = tree_ent.call("take_chop_damage", 200, gw.local_player)
		_assert(bool(res_chop.get("died", false)), "TreeEntity chops down when HP reaches 0 and emits drop")
	_assert(not gw.fishes.is_empty(), "GameWorld spawns FishEntity instances in water on Stage 1")
	if not gw.fishes.is_empty():
		var fish_ent: Node = gw.fishes[0]
		var caught_name: String = str(fish_ent.call("catch_fish"))
		_assert(not caught_name.is_empty(), "FishEntity catch_fish returns fish item name (%s)" % caught_name)

	# BankMenu deposit/withdraw money & items
	var bm_script: GDScript = load("res://scripts/ui/menus/BankMenu.gd")
	var bm: Control = bm_script.new()
	root.add_child(bm)
	bm.call("bind_person", gw.local_player)
	gw.local_player.coins = 500
	_assert(bm.call("deposit_money", 200) and gw.local_player.coins == 300 and int(bm.get("bank_money")) == 200, "BankMenu deposits coins into bank account")
	_assert(bm.call("withdraw_money", 50) and gw.local_player.coins == 350 and int(bm.get("bank_money")) == 150, "BankMenu withdraws coins from bank account")
	gw.local_player.add_inventory_item("apple")
	var inv_idx: int = gw.local_player.inventory.find("apple")
	_assert(inv_idx >= 0 and bm.call("deposit_item", inv_idx) and bm.get("bank_items").has("apple"), "BankMenu stores inventory item in bank storage")
	var b_idx: int = (bm.get("bank_items") as Array).find("apple")
	_assert(b_idx >= 0 and bm.call("withdraw_item", b_idx) and gw.local_player.inventory.has("apple"), "BankMenu withdraws item back to inventory")
	bm.queue_free()

	# PayVaultMenu buy/grant
	var pv_script: GDScript = load("res://scripts/ui/menus/PayVaultMenu.gd")
	var pv: Control = pv_script.new()
	root.add_child(pv)
	pv.call("_on_buy_payvault_item", "chainsaw", 0)
	_assert(gw.local_player.inventory.has("chainsaw"), "PayVaultMenu grants 'chainsaw' into player inventory")
	pv.queue_free()

	gw.queue_free()
	await process_frame

	# Direct test of 2D array and flat 1D array parsing
	var test_gw := GameWorld.new()
	root.add_child(test_gw)
	await process_frame
	test_gw.call("_clear_level_entities")
	await process_frame
	var dummy_2d: Dictionary = {
		"width": 3,
		"height": 2,
		"mapMain": [[255, 31, 255], [31, 255, 255]]
	}
	test_gw.call("_spawn_coin_boxes", dummy_2d)
	var count_2d: int = 0
	for ch: Node in test_gw.props_container.get_children():
		if ch.get_script() == CoinBoxEntityType:
			count_2d += 1
	_assert(count_2d == 2, "_spawn_coin_boxes correctly parses 2D layer arrays (found %d)" % count_2d)
	test_gw.queue_free()
	await process_frame

	# Tile collision parity
	_assert(not TileMapRenderer.get_source_collision_shapes(36, "mapG2", 1).is_empty(), "Tile 36 has one-way platform shape on mapG2")
	_assert(not TileMapRenderer.get_source_collision_shapes(14, "mapG3", 1).is_empty(), "Tile 14 has one-way platform shape on mapG3")
	_assert(not TileMapRenderer.get_source_collision_shapes(30, "mapG2", 1).is_empty(), "Tile 30 has one-way platform shape on mapG2")
	_assert(TileMapRenderer.get_source_collision_shapes(128, "mapG2", 1).is_empty(), "Decorative tile 128 has 0 collision on mapG2")
	_assert(TileMapRenderer.get_source_collision_shapes(38, "mapG2", 1).is_empty(), "Tile 38 has 0 collision on mapG2 (only solid on mapMain)")
	_assert(TileMapRenderer.get_source_collision_shapes(52, "mapG3", 1).is_empty(), "Tile 52 has 0 collision on mapG3")
	var cb_shapes: Array = TileMapRenderer.get_source_collision_shapes(31, "mapMain", 1)
	_assert(cb_shapes.size() == 1 and cb_shapes[0]["type"] == "rect", "Tile 31 has rect collision shape on mapMain")
