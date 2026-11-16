extends Control
class_name AdminMenu
## AdminMenu — Панель администратора для Offline Sandbox-режима.

const PANEL_DEFAULT_SIZE: Vector2 = Vector2(560, 460)
const DRAG_EDGE_MARGIN: float = 18.0

var player: PersonEntity = null
var game_world: Node = null

var panel: PanelContainer = null
var close_btn: Button = null
var coins_input: SpinBox = null
var level_input: SpinBox = null
var category_select: OptionButton = null
var level_filter: OptionButton = null
var class_filter: OptionButton = null
var item_search: LineEdit = null
var item_list: ItemList = null
var mob_select: OptionButton = null
var zone_select: OptionButton = null
var npc_select: OptionButton = null
var status_label: Label = null
var max_preset_overlay: ColorRect = null

var _all_items: Array[Dictionary] = []
var _npc_entries: Array[Dictionary] = []
var _is_dragging: bool = false
var _drag_offset: Vector2 = Vector2.ZERO
var _has_been_dragged: bool = false


func _ready() -> void:
	visible = false
	anchors_preset = PRESET_FULL_RECT
	mouse_filter = MOUSE_FILTER_STOP
	_build_ui()
	_populate_data()
	_center_panel()


func setup(p_player: PersonEntity, p_world: Node) -> void:
	player = p_player
	game_world = p_world
	if player != null and coins_input != null and level_input != null:
		coins_input.value = player.coins
		level_input.value = player.level


func toggle_menu() -> void:
	visible = not visible
	_is_dragging = false
	if visible:
		_reset_panel_size()
		if not _has_been_dragged:
			_center_panel()
		if player != null:
			coins_input.value = player.coins
			level_input.value = player.level


func _reset_panel_size() -> void:
	if panel == null:
		return
	panel.custom_minimum_size = PANEL_DEFAULT_SIZE
	panel.reset_size()
	panel.size = Vector2(
		maxf(PANEL_DEFAULT_SIZE.x, panel.get_combined_minimum_size().x),
		maxf(PANEL_DEFAULT_SIZE.y, panel.get_combined_minimum_size().y)
	)


func _center_panel() -> void:
	if panel == null:
		return
	var vp_size: Vector2 = get_viewport_rect().size
	if vp_size.x <= 10.0 or vp_size.y <= 10.0:
		vp_size = Vector2(1000, 600)
	panel.position = Vector2(
		maxf(0.0, (vp_size.x - panel.size.x) * 0.5),
		maxf(0.0, (vp_size.y - panel.size.y) * 0.5)
	)


func _is_on_panel_edge(global_pos: Vector2) -> bool:
	if panel == null:
		return false
	var rect: Rect2 = panel.get_global_rect()
	if not rect.has_point(global_pos):
		return false
	if close_btn != null and close_btn.get_global_rect().has_point(global_pos):
		return false
	var local_pos: Vector2 = global_pos - rect.position
	return (
		local_pos.x <= DRAG_EDGE_MARGIN
		or local_pos.x >= rect.size.x - DRAG_EDGE_MARGIN
		or local_pos.y <= DRAG_EDGE_MARGIN
		or local_pos.y >= rect.size.y - DRAG_EDGE_MARGIN
	)


func _input(event: InputEvent) -> void:
	if not visible or panel == null:
		return
	if max_preset_overlay != null and max_preset_overlay.visible:
		return
	if event is InputEventMouseButton:
		var mb: InputEventMouseButton = event
		if mb.button_index == MOUSE_BUTTON_LEFT:
			if mb.pressed:
				if _is_on_panel_edge(mb.global_position):
					_is_dragging = true
					_drag_offset = panel.global_position - mb.global_position
					get_viewport().set_input_as_handled()
			else:
				if _is_dragging:
					_is_dragging = false
					get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion and _is_dragging:
		var mm: InputEventMouseMotion = event
		var vp_size: Vector2 = get_viewport_rect().size
		if vp_size.x <= 10.0 or vp_size.y <= 10.0:
			vp_size = Vector2(1000, 600)
		var target_pos: Vector2 = mm.global_position + _drag_offset
		target_pos.x = clampf(target_pos.x, 0.0, maxf(0.0, vp_size.x - panel.size.x))
		target_pos.y = clampf(target_pos.y, 0.0, maxf(0.0, vp_size.y - panel.size.y))
		panel.global_position = target_pos
		_has_been_dragged = true
		get_viewport().set_input_as_handled()


func _build_ui() -> void:
	var bg_dim := ColorRect.new()
	bg_dim.set_anchors_preset(PRESET_FULL_RECT)
	bg_dim.color = Color(0, 0, 0, 0.45)
	bg_dim.mouse_filter = MOUSE_FILTER_STOP
	add_child(bg_dim)

	panel = PanelContainer.new()
	panel.set_anchors_preset(PRESET_TOP_LEFT)
	panel.custom_minimum_size = PANEL_DEFAULT_SIZE
	panel.size = PANEL_DEFAULT_SIZE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.10, 0.14, 0.20, 0.96)
	sb.border_color = Color(0.94, 0.77, 0.30, 1.0)
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(6)
	sb.set_content_margin_all(14)
	panel.add_theme_stylebox_override("panel", sb)
	add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	panel.add_child(vbox)

	var header := HBoxContainer.new()
	vbox.add_child(header)
	var title := Label.new()
	title.text = "SANDBOX ADMIN MENU"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_color_override("font_color", Color(1.0, 0.88, 0.35, 1.0))
	title.add_theme_font_size_override("font_size", 18)
	header.add_child(title)
	close_btn = Button.new()
	close_btn.name = "CloseButton"
	close_btn.focus_mode = Control.FOCUS_NONE
	close_btn.text = "X"
	close_btn.custom_minimum_size = Vector2(30, 28)
	close_btn.tooltip_text = "Закрыть"
	close_btn.pressed.connect(func() -> void:
		_is_dragging = false
		visible = false
	)
	header.add_child(close_btn)

	# 1. Coins
	var coins_row := HBoxContainer.new()
	vbox.add_child(coins_row)
	var c_lbl := Label.new()
	c_lbl.text = "Coins:"
	c_lbl.custom_minimum_size = Vector2(95, 0)
	coins_row.add_child(c_lbl)
	coins_input = SpinBox.new()
	coins_input.min_value = 0
	coins_input.max_value = 999999999
	coins_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	coins_row.add_child(coins_input)
	var c_btn := Button.new()
	c_btn.focus_mode = Control.FOCUS_NONE
	c_btn.text = "Set"
	c_btn.pressed.connect(_on_set_coins)
	coins_row.add_child(c_btn)

	# 2. Level (+AP/SP)
	var lvl_row := HBoxContainer.new()
	vbox.add_child(lvl_row)
	var l_lbl := Label.new()
	l_lbl.text = "Level:"
	l_lbl.custom_minimum_size = Vector2(95, 0)
	lvl_row.add_child(l_lbl)
	level_input = SpinBox.new()
	level_input.min_value = 1
	level_input.max_value = 999
	level_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lvl_row.add_child(level_input)
	var l_btn := Button.new()
	l_btn.focus_mode = Control.FOCUS_NONE
	l_btn.text = "Set"
	l_btn.pressed.connect(_on_set_level)
	lvl_row.add_child(l_btn)

	# 3. Give Item (Type Filter + Level Filter + Class Filter + Search + Icon List)
	var cat_row := HBoxContainer.new()
	vbox.add_child(cat_row)
	var cat_lbl := Label.new()
	cat_lbl.text = "Filter:"
	cat_lbl.custom_minimum_size = Vector2(95, 0)
	cat_row.add_child(cat_lbl)
	category_select = OptionButton.new()
	category_select.focus_mode = Control.FOCUS_NONE
	category_select.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for cat in ["All", "weapon", "helmet", "shirt", "legs", "shoes", "acc", "item", "pet", "pet_helmet"]:
		category_select.add_item(cat)
	category_select.item_selected.connect(func(_idx: int) -> void: _refresh_item_list())
	cat_row.add_child(category_select)
	level_filter = OptionButton.new()
	level_filter.focus_mode = Control.FOCUS_NONE
	level_filter.add_item("Lvl: All")
	for r_start in range(0, 1100, 100):
		level_filter.add_item("%d-%d" % [r_start, r_start + 100])
	level_filter.item_selected.connect(func(_idx: int) -> void: _refresh_item_list())
	cat_row.add_child(level_filter)
	class_filter = OptionButton.new()
	class_filter.focus_mode = Control.FOCUS_NONE
	for cls_name in ["Class: All", "Warrior", "Archer", "Mage", "Cowboy"]:
		class_filter.add_item(cls_name)
	class_filter.item_selected.connect(func(_idx: int) -> void: _refresh_item_list())
	cat_row.add_child(class_filter)

	var search_row := HBoxContainer.new()
	vbox.add_child(search_row)
	var s_lbl := Label.new()
	s_lbl.text = "Search:"
	s_lbl.custom_minimum_size = Vector2(95, 0)
	search_row.add_child(s_lbl)
	item_search = LineEdit.new()
	item_search.placeholder_text = "Type item name..."
	item_search.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	item_search.text_changed.connect(func(_t: String) -> void: _refresh_item_list())
	search_row.add_child(item_search)
	var i_btn := Button.new()
	i_btn.focus_mode = Control.FOCUS_NONE
	i_btn.text = "Give"
	i_btn.pressed.connect(_on_give_item)
	search_row.add_child(i_btn)

	item_list = ItemList.new()
	item_list.focus_mode = Control.FOCUS_NONE
	item_list.custom_minimum_size = Vector2(0, 140)
	item_list.fixed_icon_size = Vector2i(24, 24)
	vbox.add_child(item_list)

	# 4. Spawn Mob
	var mob_row := HBoxContainer.new()
	vbox.add_child(mob_row)
	var m_lbl := Label.new()
	m_lbl.text = "Spawn Mob:"
	m_lbl.custom_minimum_size = Vector2(95, 0)
	mob_row.add_child(m_lbl)
	mob_select = OptionButton.new()
	mob_select.focus_mode = Control.FOCUS_NONE
	mob_select.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mob_row.add_child(mob_select)
	var m_btn := Button.new()
	m_btn.focus_mode = Control.FOCUS_NONE
	m_btn.text = "Spawn"
	m_btn.pressed.connect(_on_spawn_mob)
	mob_row.add_child(m_btn)

	# 5. Teleport Zone
	var zone_row := HBoxContainer.new()
	vbox.add_child(zone_row)
	var z_lbl := Label.new()
	z_lbl.text = "Zone:"
	z_lbl.custom_minimum_size = Vector2(95, 0)
	zone_row.add_child(z_lbl)
	zone_select = OptionButton.new()
	zone_select.focus_mode = Control.FOCUS_NONE
	zone_select.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	zone_row.add_child(zone_select)
	var z_btn := Button.new()
	z_btn.focus_mode = Control.FOCUS_NONE
	z_btn.text = "Teleport"
	z_btn.pressed.connect(_on_teleport_zone)
	zone_row.add_child(z_btn)

	# 5b. Teleport NPC
	var npc_row := HBoxContainer.new()
	vbox.add_child(npc_row)
	var n_lbl := Label.new()
	n_lbl.text = "NPC:"
	n_lbl.custom_minimum_size = Vector2(95, 0)
	npc_row.add_child(n_lbl)
	npc_select = OptionButton.new()
	npc_select.focus_mode = Control.FOCUS_NONE
	npc_select.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	npc_row.add_child(npc_select)
	var n_btn := Button.new()
	n_btn.focus_mode = Control.FOCUS_NONE
	n_btn.text = "Teleport"
	n_btn.pressed.connect(_on_teleport_npc)
	npc_row.add_child(n_btn)

	# 6. Reveal Map & MAX Preset
	var action_row := HBoxContainer.new()
	action_row.add_theme_constant_override("separation", 10)
	vbox.add_child(action_row)
	var map_btn := Button.new()
	map_btn.focus_mode = Control.FOCUS_NONE
	map_btn.text = "Reveal Full Map"
	map_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map_btn.pressed.connect(_on_reveal_full_map)
	action_row.add_child(map_btn)
	var max_btn := Button.new()
	max_btn.focus_mode = Control.FOCUS_NONE
	max_btn.text = "MAX Preset"
	max_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	max_btn.pressed.connect(_on_max_preset)
	action_row.add_child(max_btn)
	var restore_btn := Button.new()
	restore_btn.name = "RestoreHPMPBtn"
	restore_btn.focus_mode = Control.FOCUS_NONE
	restore_btn.text = "Restore HP/MP"
	restore_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	restore_btn.pressed.connect(_on_restore_hp_mp)
	action_row.add_child(restore_btn)

	var bank_btn := Button.new()
	bank_btn.name = "OpenBankBtn"
	bank_btn.focus_mode = Control.FOCUS_NONE
	bank_btn.text = "Open Bank (ATM)"
	bank_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bank_btn.pressed.connect(func() -> void:
		var hud_node: Node = get_parent().get_parent() if get_parent() != null else null
		if hud_node != null and hud_node.has_method("toggle_bank_menu"):
			hud_node.call("toggle_bank_menu")
	)
	action_row.add_child(bank_btn)

	status_label = Label.new()
	status_label.text = ""
	status_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	status_label.custom_minimum_size = Vector2(0, 22)
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.clip_text = true
	status_label.add_theme_color_override("font_color", Color(0.65, 1.0, 0.65, 1.0))
	vbox.add_child(status_label)

	_build_max_preset_modal()


func _build_max_preset_modal() -> void:
	max_preset_overlay = ColorRect.new()
	max_preset_overlay.name = "MaxPresetOverlay"
	max_preset_overlay.visible = false
	max_preset_overlay.set_anchors_preset(PRESET_FULL_RECT)
	max_preset_overlay.color = Color(0.0, 0.0, 0.0, 0.6)
	max_preset_overlay.mouse_filter = MOUSE_FILTER_STOP
	add_child(max_preset_overlay)

	var modal := PanelContainer.new()
	modal.name = "MaxPresetModal"
	modal.set_anchors_preset(PRESET_CENTER)
	modal.custom_minimum_size = Vector2(320, 260)
	modal.offset_left = -160
	modal.offset_top = -130
	modal.offset_right = 160
	modal.offset_bottom = 130
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.14, 0.14, 0.18, 0.98)
	sb.border_color = Color(0.95, 0.78, 0.30, 1.0)
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(8)
	sb.set_content_margin_all(14)
	modal.add_theme_stylebox_override("panel", sb)
	max_preset_overlay.add_child(modal)

	var mvbox := VBoxContainer.new()
	mvbox.add_theme_constant_override("separation", 8)
	modal.add_child(mvbox)

	var mtitle := Label.new()
	mtitle.text = "MAX Preset — выберите класс"
	mtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mtitle.add_theme_font_size_override("font_size", 16)
	mtitle.add_theme_color_override("font_color", Color(1.0, 0.85, 0.35, 1.0))
	mvbox.add_child(mtitle)

	var class_defs: Array[Array] = [
		["Воин (Warrior)", "warrior"],
		["Лучник (Archer)", "archer"],
		["Маг (Mage)", "mage"],
		["Ковбой (Cowboy)", "cowboy"],
	]
	for cdef: Array in class_defs:
		var cbtn := Button.new()
		cbtn.name = "MaxClassBtn_" + str(cdef[1])
		cbtn.focus_mode = Control.FOCUS_NONE
		cbtn.text = str(cdef[0])
		cbtn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var cid: String = str(cdef[1])
		cbtn.pressed.connect(func() -> void:
			max_preset_overlay.visible = false
			apply_max_preset_for_class(cid)
		)
		mvbox.add_child(cbtn)

	var cancel_btn := Button.new()
	cancel_btn.name = "MaxClassCancelBtn"
	cancel_btn.focus_mode = Control.FOCUS_NONE
	cancel_btn.text = "Отмена"
	cancel_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cancel_btn.pressed.connect(func() -> void: max_preset_overlay.visible = false)
	mvbox.add_child(cancel_btn)


func _populate_data() -> void:
	_all_items.clear()
	mob_select.clear()
	zone_select.clear()
	var loader: Node = get_node_or_null("/root/StarlingAtlasLoader")
	if loader != null and loader.has_method("register_starling_atlas"):
		loader.call("register_starling_atlas", "items_pets_bodies")
		loader.call("register_starling_atlas", "trees_fish")
	var sdb: Node = get_node_or_null("/root/StatsDB")
	if sdb != null:
		var raw_items: Array = []
		if sdb.has_method("get_all_unique_items"):
			raw_items = sdb.call("get_all_unique_items", "")
		if raw_items is Array:
			for rec_v: Variant in raw_items:
				if not (rec_v is Dictionary):
					continue
				var idata: Dictionary = rec_v
				var s_name: String = str(idata.get("_key", idata.get("key", ""))).strip_edges()
				if s_name.is_empty() or s_name.begins_with("_") or s_name.is_valid_int() or s_name.to_lower() == "none":
					continue
				var cat_key: String = str(idata.get("_category", "item"))
				var req_lvl: int = int(idata.get("lvl", 0))
				var item_classes: Array[String] = _detect_item_classes(idata, cat_key)
				_all_items.append({
					"name": s_name,
					"cat": cat_key,
					"lvl": req_lvl,
					"classes": item_classes,
					"rec": idata
				})
		_all_items.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
			return str(a["name"]).to_lower() < str(b["name"]).to_lower()
		)

		var mob_entries: Array = []
		if sdb.has_method("get_all_unique_enemies"):
			mob_entries = sdb.call("get_all_unique_enemies")
		mob_select.expand_icon = true
		var mob_popup: PopupMenu = mob_select.get_popup()
		var swf: Node = get_node_or_null("/root/SwfSpriteLoader")
		for idx: int in range(mob_entries.size()):
			var ed_v: Variant = mob_entries[idx]
			if not (ed_v is Dictionary):
				continue
			var ed: Dictionary = ed_v
			var mn: String = str(ed.get("key", ed.get("name", ""))).strip_edges()
			if mn.is_empty() or mn.begins_with("_") or mn.is_valid_int():
				continue
			var mob_tex: Texture2D = null
			if swf != null and swf.has_method("get_enemy_sprite_frames"):
				var frames: SpriteFrames = swf.call("get_enemy_sprite_frames", mn) as SpriteFrames
				if frames != null:
					var anims: PackedStringArray = frames.get_animation_names()
					for anim_name: String in anims:
						if frames.get_frame_count(anim_name) > 0:
							mob_tex = frames.get_frame_texture(anim_name, 0)
							if mob_tex != null:
								break
			if mob_tex != null:
				mob_select.add_icon_item(mob_tex, mn)
				var item_idx: int = mob_select.item_count - 1
				if mob_popup != null:
					mob_popup.set_item_icon_max_width(item_idx, 28)
			else:
				mob_select.add_item(mn)
	_refresh_item_list()

	for s: int in range(1, 146):
		if s == 51:
			continue
		var area_label: String = "Stage %d" % s
		if sdb != null and sdb.has_method("get_area_meta"):
			var am: Variant = sdb.call("get_area_meta", s)
			if am is Dictionary:
				var fname: String = str((am as Dictionary).get("fname", (am as Dictionary).get("name", ""))).strip_edges()
				if not fname.is_empty():
					area_label = "Stage %d: %s" % [s, fname]
		zone_select.add_item(area_label, s)

	_populate_npc_select(sdb)


func _populate_npc_select(sdb: Node) -> void:
	if npc_select == null:
		return
	npc_select.clear()
	_npc_entries.clear()
	if sdb == null:
		return
	var raw_npcs: Variant = sdb.get("npcs_list")
	if not (raw_npcs is Array):
		return
	var valid_npcs: Array[Dictionary] = []
	for nv: Variant in raw_npcs:
		if not (nv is Dictionary):
			continue
		var nd: Dictionary = nv
		var origin: Variant = nd.get("origin", {})
		if not (origin is Dictionary):
			continue
		var area_id: int = int((origin as Dictionary).get("area", 0))
		if area_id <= 0:
			continue
		valid_npcs.append(nd)

	valid_npcs.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var oa: Dictionary = a.get("origin", {})
		var ob: Dictionary = b.get("origin", {})
		var aa: int = int(oa.get("area", 0))
		var ab: int = int(ob.get("area", 0))
		if aa != ab:
			return aa < ab
		return str(a.get("name", "")).to_lower() < str(b.get("name", "")).to_lower()
	)

	npc_select.expand_icon = true
	var npc_popup: PopupMenu = npc_select.get_popup()
	var atlas: Node = get_node_or_null("/root/StarlingAtlasLoader")
	for nd: Dictionary in valid_npcs:
		var n_name: String = str(nd.get("name", "NPC")).strip_edges()
		var origin: Dictionary = nd.get("origin", {})
		var area_id: int = int(origin.get("area", 1))
		var app: Dictionary = nd.get("appearance", {}) if nd.get("appearance") is Dictionary else {}
		var npc_tex: Texture2D = null
		if atlas != null and atlas.has_method("get_starling_texture"):
			var helmet_name: String = str(app.get("helmet", "none")).strip_edges()
			if not helmet_name.is_empty() and helmet_name != "none":
				npc_tex = atlas.call("get_starling_texture", "items_pets_bodies", helmet_name) as Texture2D
			if npc_tex == null:
				var skin_id: int = maxi(1, int(app.get("skin", 1)))
				var gender: String = str(app.get("gender", "male")).to_lower()
				if gender != "female":
					gender = "male"
				var head_name: String = "zombie head" if skin_id == 5 else "%s head %d" % [gender, skin_id]
				npc_tex = atlas.call("get_starling_texture", "items_pets_bodies", head_name) as Texture2D
				if npc_tex == null:
					npc_tex = atlas.call("get_starling_texture", "items_pets_bodies", "male head 1") as Texture2D
		var label: String = "%s (Zone %d)" % [n_name, area_id]
		if npc_tex != null:
			npc_select.add_icon_item(npc_tex, label)
			if npc_popup != null:
				npc_popup.set_item_icon_max_width(npc_select.item_count - 1, 24)
		else:
			npc_select.add_item(label)
		_npc_entries.append({
			"name": n_name,
			"area": area_id,
			"x": float(origin.get("x", 0.0)),
			"y": float(origin.get("y", 0.0)),
		})


func _detect_item_classes(idata: Dictionary, cat_key: String) -> Array[String]:
	var classes: Array[String] = []
	# Питомцы, шлемы питомцев и расходники/материалы не привязаны к классу героя
	if cat_key in ["pet", "pet_helmet", "item"]:
		return classes
	if cat_key == "weapon":
		if int(idata.get("mgc", 0)) > 0:
			classes.append("Mage")
		elif int(idata.get("sr", 0)) > 0:
			classes.append("Cowboy")
		elif int(idata.get("rng", 0)) > 0:
			classes.append("Archer")
		elif int(idata.get("min", 0)) > 0 or int(idata.get("max", 0)) > 0 or int(idata.get("def", 0)) > 0:
			classes.append("Warrior")
		return classes
	var p_v: int = int(idata.get("pow", 0))
	var r_v: int = int(idata.get("rng", 0))
	var m_v: int = int(idata.get("mgc", 0))
	var a_v: int = int(idata.get("art", 0))
	var max_stat: int = maxi(maxi(p_v, r_v), maxi(m_v, a_v))
	if max_stat <= 0:
		return classes
	if m_v == max_stat:
		classes.append("Mage")
	if a_v == max_stat:
		classes.append("Cowboy")
	if r_v == max_stat:
		classes.append("Archer")
	if p_v == max_stat:
		classes.append("Warrior")
	return classes


func _resolve_item_icon(loader: Node, entry: Dictionary) -> Texture2D:
	if loader == null:
		return null
	var iname: String = str(entry.get("name", ""))
	var cat_key: String = str(entry.get("cat", "item"))
	var rec: Dictionary = entry.get("rec", {})
	var tex: Texture2D = null
	if loader.has_method("get_texture"):
		if cat_key == "pet":
			tex = loader.call("get_texture", "%s head" % iname.to_lower(), "items_pets_bodies") as Texture2D
			if tex == null:
				tex = loader.call("get_texture", iname, "items_pets_bodies") as Texture2D
		elif cat_key == "item" and str(rec.get("_item_kind", "")) == "fish":
			tex = loader.call("get_texture", iname, "trees_fish") as Texture2D
			if tex == null:
				tex = loader.call("get_texture", iname, "items_pets_bodies") as Texture2D
		else:
			tex = loader.call("get_texture", iname, "items_pets_bodies") as Texture2D
			if tex == null:
				tex = loader.call("get_texture", "%s_00" % iname, "items_pets_bodies") as Texture2D
			if tex == null:
				tex = loader.call("get_texture", iname, "trees_fish") as Texture2D
	return tex


func _refresh_item_list() -> void:
	if item_list == null:
		return
	item_list.clear()
	var selected_cat: String = category_select.get_item_text(category_select.selected) if category_select.selected >= 0 else "All"
	var lvl_idx: int = level_filter.selected if level_filter != null else 0
	var min_lvl: int = (lvl_idx - 1) * 100 if lvl_idx > 0 else -1
	var max_lvl: int = min_lvl + 100 if lvl_idx > 0 else 999999
	var cls_idx: int = class_filter.selected if class_filter != null else 0
	var selected_cls: String = class_filter.get_item_text(cls_idx) if (class_filter != null and cls_idx > 0) else "All"
	var query: String = item_search.text.strip_edges().to_lower() if item_search != null else ""
	var loader: Node = get_node_or_null("/root/StarlingAtlasLoader")
	for entry in _all_items:
		if selected_cat != "All" and entry["cat"] != selected_cat:
			continue
		if selected_cls != "All":
			var item_classes: Array = entry.get("classes", [])
			if not item_classes.has(selected_cls):
				continue
		var ilvl: int = int(entry.get("lvl", 0))
		if lvl_idx > 0 and (ilvl < min_lvl or ilvl > max_lvl):
			continue
		var iname: String = entry["name"]
		if not query.is_empty() and not iname.to_lower().contains(query):
			continue
		var tex: Texture2D = _resolve_item_icon(loader, entry)
		item_list.add_item(iname, tex)


func _on_set_coins() -> void:
	if player == null:
		return
	player.coins = int(coins_input.value)
	player.coins_changed.emit(player.coins)
	status_label.text = "Coins set to $%d" % player.coins


func _on_set_level() -> void:
	if player == null:
		return
	var target_lvl: int = maxi(1, int(level_input.value))
	var delta_lvl: int = target_lvl - player.level
	player.level = target_lvl
	if delta_lvl > 0:
		player.ability_points += delta_lvl * 3
		player.skill_points += delta_lvl * 1
		player.max_health += delta_lvl * 15
		player.health = player.max_health
	player.exp_to_next = 51 * target_lvl * target_lvl
	player.exp = 0
	player.exp_changed.emit(player.exp, player.exp_to_next, player.level)
	player.health_changed.emit(player.health, player.max_health)
	player.stats_updated.emit()
	status_label.text = "Level set to %d (AP: %d, SP: %d)" % [player.level, player.ability_points, player.skill_points]


func _on_give_item() -> void:
	if player == null or item_list == null:
		return
	var sel: PackedInt32Array = item_list.get_selected_items()
	if sel.is_empty():
		return
	var item_name: String = item_list.get_item_text(sel[0])
	if player.has_method("add_item_to_bag"):
		player.add_item_to_bag(item_name, 1)
	else:
		player.inventory.append(item_name)
		player.inventory_updated.emit()
	status_label.text = "Added '%s' to inventory" % item_name


func _on_spawn_mob() -> void:
	if player == null or game_world == null or mob_select.selected < 0:
		return
	var mob_name: String = mob_select.get_item_text(mob_select.selected)
	var container: Node = game_world.get("entities_container") as Node
	if container == null:
		return
	var enemy := EnemyEntity.new()
	enemy.enemy_type = mob_name
	enemy.game_world = game_world
	enemy.position = player.global_position + Vector2(float(player.facing_dir) * 90.0, -20.0)
	if game_world.has_method("_on_enemy_died"):
		enemy.enemy_died.connect(Callable(game_world, "_on_enemy_died"))
	container.add_child(enemy)
	if "enemies" in game_world and game_world.enemies is Array:
		game_world.enemies.append(enemy)
	status_label.text = "Spawned '%s'" % mob_name


func _on_reveal_full_map() -> void:
	var all_stages: Array = []
	for s: int in range(1, 146):
		if s != 51:
			all_stages.append(s)
	var pio: Node = get_node_or_null("/root/PlayerIOClient")
	if pio != null:
		var po: Variant = pio.get("my_player_object")
		if po is Dictionary:
			po["unlockedMaps"] = all_stages.duplicate()
			if pio.has_method("bigdb_save_changes"):
				pio.call("bigdb_save_changes", "PlayerObjects", str(pio.get("connect_user_id")), po)
		if "my_player_misc" in pio and pio.my_player_misc is Dictionary:
			pio.my_player_misc["maps"] = all_stages.duplicate()
	var hud: Node = get_parent()
	if hud != null and "map_menu" in hud and hud.map_menu != null and hud.map_menu.has_method("reveal_all_map"):
		hud.map_menu.call("reveal_all_map")
	status_label.text = "Full map revealed (all %d zones)" % all_stages.size()


func _on_max_preset() -> void:
	if player == null:
		return
	if max_preset_overlay != null:
		max_preset_overlay.visible = true
	else:
		apply_max_preset_for_class("warrior")


func get_best_gear_for_class(cls_id: String) -> Dictionary:
	var stat_map: Dictionary = {
		"warrior": "pow",
		"archer": "rng",
		"mage": "mgc",
		"cowboy": "art",
	}
	var norm_cls: String = cls_id.strip_edges().to_lower()
	var stat_key: String = str(stat_map.get(norm_cls, "pow"))
	var result: Dictionary = {
		"helmet": "",
		"shirt": "",
		"legs": "",
		"shoes": "",
		"weapon_2h": "",
		"weapons_1h": [] as Array[String],
	}
	var sdb: Node = get_node_or_null("/root/StatsDB")
	if sdb == null:
		return result

	result["helmet"] = _pick_best_armor_for_stat(sdb.get("helmet_stats"), stat_key)
	result["shirt"] = _pick_best_armor_for_stat(sdb.get("shirt_stats"), stat_key)
	result["legs"] = _pick_best_armor_for_stat(sdb.get("leg_stats"), stat_key)
	result["shoes"] = _pick_best_armor_for_stat(sdb.get("shoe_stats"), stat_key)

	var weapon_dict: Variant = sdb.get("weapon_stats")
	if weapon_dict is Dictionary:
		var best_2h: String = ""
		var best_2h_score: Array[int] = [-1, -1, -1]
		var best_1h: String = ""
		var best_1h_score: Array[int] = [-1, -1, -1]
		for k_v: Variant in (weapon_dict as Dictionary).keys():
			var k: String = str(k_v)
			if k.begins_with("_") or k.to_lower() == "none" or k.is_valid_int():
				continue
			var rec_v: Variant = (weapon_dict as Dictionary)[k_v]
			if not (rec_v is Dictionary):
				continue
			var rec: Dictionary = rec_v
			if int(rec.get("def", 0)) > 0:
				continue
			var is_rng: bool = bool(rec.get("rng", false))
			var is_mgc: bool = bool(rec.get("mgc", false))
			var sr_val: int = int(rec.get("sr", 0))
			var matches_class: bool = false
			match norm_cls:
				"warrior":
					matches_class = (not is_rng) and (not is_mgc)
				"archer":
					matches_class = is_rng and sr_val == 0
				"mage":
					matches_class = is_mgc
				"cowboy":
					matches_class = is_rng and sr_val > 0
			if not matches_class:
				continue
			var kl: String = k.to_lower()
			var is_2h: bool = bool(rec.get("two", false))
			if norm_cls == "cowboy" and PersonEntity.DUAL_GUNS_ARRAY.has(kl):
				is_2h = false
			var dmg_sum: int = int(rec.get("min", 0)) + int(rec.get("max", 0))
			var score: Array[int] = [dmg_sum, int(rec.get("lvl", 0)), int(rec.get("max", 0))]
			if is_2h:
				if _score_gt(score, best_2h_score):
					best_2h_score = score
					best_2h = k
			else:
				if _score_gt(score, best_1h_score):
					best_1h_score = score
					best_1h = k
		result["weapon_2h"] = best_2h
		if not best_1h.is_empty():
			var pair_1h: Array[String] = [best_1h, best_1h]
			result["weapons_1h"] = pair_1h
	return result


func _pick_best_armor_for_stat(cat_dict_v: Variant, stat_key: String) -> String:
	if not (cat_dict_v is Dictionary):
		return ""
	var cat_dict: Dictionary = cat_dict_v
	var best_name: String = ""
	var best_score: Array[int] = [-1, -1, -1]
	for k_v: Variant in cat_dict.keys():
		var k: String = str(k_v)
		if k.begins_with("_") or k.to_lower() == "none" or k.is_valid_int():
			continue
		var rec_v: Variant = cat_dict[k_v]
		if not (rec_v is Dictionary):
			continue
		var rec: Dictionary = rec_v
		var main_val: int = int(rec.get(stat_key, 0))
		if main_val <= 0:
			continue
		var score: Array[int] = [main_val, int(rec.get("def", 0)), int(rec.get("lvl", 0))]
		if _score_gt(score, best_score):
			best_score = score
			best_name = k
	return best_name


func _score_gt(a: Array[int], b: Array[int]) -> bool:
	for i in range(mini(a.size(), b.size())):
		if a[i] != b[i]:
			return a[i] > b[i]
	return false


func apply_max_preset_for_class(cls_id: String) -> void:
	if player == null:
		return
	var norm_cls: String = cls_id.strip_edges().to_lower()
	player.level = 5000
	player.ability_points = 14997
	player.skill_points = 4999
	player.def_stat = 1500
	player.power_stat = 1500
	player.range_stat = 1500
	player.magic_stat = 1500
	player.artillery_stat = 1500
	player.dex_stat = 300
	player.max_health = 10000
	player.health = 10000
	player.max_mana = 10000
	player.mana = 10000
	if "character_class" in player:
		player.character_class = norm_cls
	if "max_exp_points" in player:
		player.max_exp_points = 51 * 5000 * 5000
	if "exp_points" in player:
		player.exp_points = 0
	if player.has_method("_calc_stats"):
		player.call("_calc_stats")
	player.health_changed.emit(player.health, player.max_health)
	player.mp_changed.emit(player.mana, player.max_mana)
	var cur_exp: int = int(player.get("exp_points")) if "exp_points" in player else 0
	var max_exp: int = int(player.get("max_exp_points")) if "max_exp_points" in player else (51 * 5000 * 5000)
	player.exp_changed.emit(cur_exp, max_exp, player.level)
	player.stats_updated.emit()

	var gear: Dictionary = get_best_gear_for_class(norm_cls)
	var granted: Array[String] = []
	for slot_key in ["helmet", "shirt", "legs", "shoes", "weapon_2h"]:
		var item_name: String = str(gear.get(slot_key, ""))
		if not item_name.is_empty():
			_grant_preset_item(item_name)
			granted.append(item_name)
	for w1_v: Variant in gear.get("weapons_1h", []):
		var w1: String = str(w1_v)
		if not w1.is_empty():
			_grant_preset_item(w1)
			granted.append(w1)
	if "inventory_updated" in player:
		player.inventory_updated.emit()

	_max_out_skills_for_class(norm_cls)

	if level_input != null:
		level_input.value = 5000
	if status_label != null:
		status_label.text = "MAX Preset [%s]: статы, скиллы + %d предм." % [norm_cls.to_upper(), granted.size()]
	_reset_panel_size()
	if not _has_been_dragged:
		_center_panel()


func _max_out_skills_for_class(norm_cls: String) -> void:
	if player == null:
		return
	var meta_path: String = "res://assets/extracted/skills_meta.json"
	if not FileAccess.file_exists(meta_path):
		return
	var f := FileAccess.open(meta_path, FileAccess.READ)
	if f == null:
		return
	var parsed: Variant = JSON.parse_string(f.get_as_text())
	f.close()
	if not (parsed is Dictionary):
		return
	var skills_arr: Variant = (parsed as Dictionary).get("skills", [])
	if not (skills_arr is Array):
		return

	var skill_cat: String = "wizard" if norm_cls == "mage" else norm_cls
	player.skill_points = 999999
	for s_v: Variant in skills_arr:
		if not (s_v is Dictionary):
			continue
		var s: Dictionary = s_v
		var cat: String = str(s.get("category", "")).to_lower()
		if cat != "basic" and cat != skill_cat:
			continue
		var sid: String = str(s.get("id", ""))
		if sid.is_empty():
			continue
		var raw_max: int = int(s.get("maxLvl", 10))
		var target_lvl: int = 200 if raw_max >= 1000000 else maxi(1, raw_max)
		if player.has_method("upgrade_skill"):
			var cur_lvl: int = int(player.skill_levels.get(sid, 0))
			while cur_lvl < target_lvl:
				if not bool(player.call("upgrade_skill", sid, 1, target_lvl)):
					break
				cur_lvl = int(player.skill_levels.get(sid, 0))
		else:
			player.skill_levels[sid] = target_lvl
	player.skill_points = 4999
	if player.has_method("_calc_stats"):
		player.call("_calc_stats")
	player.stats_updated.emit()


func _on_restore_hp_mp() -> void:
	if player == null:
		status_label.text = "Ошибка: игрок не найден!"
		return
	player.health = player.max_health
	player.mana = player.max_mana
	player.health_changed.emit(player.health, player.max_health)
	player.mp_changed.emit(player.mana, player.max_mana)
	status_label.text = "HP (%d/%d) и MP (%d/%d) полностью восстановлены." % [player.health, player.max_health, player.mana, player.max_mana]


func _grant_preset_item(item_name: String) -> void:
	if player == null or item_name.is_empty():
		return
	if player.has_method("add_inventory_item"):
		if player.call("add_inventory_item", item_name):
			return
	if "inventory" in player and player.inventory is Array:
		player.inventory.append(item_name)


func _on_teleport_zone() -> void:
	if game_world == null or zone_select.selected < 0:
		return
	var stage_id: int = zone_select.get_item_id(zone_select.selected)
	var target_portal_slot: int = 1
	var sdb: Node = get_node_or_null("/root/StatsDB")
	if sdb != null and sdb.has_method("get_area_meta"):
		var am: Variant = sdb.call("get_area_meta", stage_id)
		if am is Dictionary:
			var portals_dict: Variant = (am as Dictionary).get("portals", {})
			for slot: int in range(1, 9):
				var key: String = "portal%dLead" % slot
				var lead: int = int(portals_dict.get(key, 0)) if portals_dict is Dictionary else int((am as Dictionary).get(key, 0))
				if lead > 0:
					target_portal_slot = slot
					break
	if game_world.has_method("change_level"):
		game_world.call("change_level", stage_id, target_portal_slot)
		visible = false
	elif game_world.has_method("load_level"):
		game_world.call("load_level", stage_id)
		visible = false


func _on_teleport_npc() -> void:
	if game_world == null or npc_select == null or npc_select.selected < 0:
		return
	var idx: int = npc_select.selected
	if idx >= _npc_entries.size():
		return
	var entry: Dictionary = _npc_entries[idx]
	var target_area: int = int(entry.get("area", 1))
	var target_pos := Vector2(float(entry.get("x", 0.0)), float(entry.get("y", 0.0)) + 50.0)
	var cur_area: int = int(game_world.get("current_stage_id")) if "current_stage_id" in game_world else -1
	if cur_area != target_area:
		if game_world.has_method("load_level"):
			game_world.call("load_level", target_area)
		elif game_world.has_method("change_level"):
			game_world.call("change_level", target_area, 1)
	if player != null:
		player.global_position = target_pos
		player.velocity = Vector2.ZERO
		if "vel_x" in player:
			player.vel_x = 0.0
		if "vel_y" in player:
			player.vel_y = 0.0
	if status_label != null:
		status_label.text = "Teleported to %s (Zone %d)" % [str(entry.get("name", "NPC")), target_area]
	visible = false
