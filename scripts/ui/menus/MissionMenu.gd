extends Control
class_name MissionMenu
## MissionMenu — Окно списка заданий / квестов (порт com.menus.MissionMenu.as).
## Точно воспроизводит Starling-версию:
## - Панель "mission menu panel" размером 501x491
## - Область списка (35, 47), размер (460, 361), строки mission panel_00 / mission panel_01 шагом 32px + checkmark / x mark
## - Выбранная миссия mission_txt в (53, 389) и описание desc_txt в (24, 415)

signal closed()

@export var is_draggable: bool = true

var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

var panel_bg: TextureRect = null
var close_btn: TextureButton = null
var scroll_btn: TextureButton = null

var mission_list_container: VBoxContainer = null
var row_buttons: Array[TextureButton] = []
var mission_title_label: Label = null
var mission_details_label: Label = null

func _ready() -> void:
	custom_minimum_size = Vector2(501, 491)
	size = Vector2(501, 491)
	_build_ui()
	_populate_missions()


func _build_ui() -> void:
	var atlas_loader: Node = _get_atlas_loader()
	atlas_loader.register_starling_atlas("item menu")
	var bg_tex: Texture2D = atlas_loader.get_starling_texture("item menu", "mission menu panel")
	if bg_tex == null:
		bg_tex = atlas_loader.get_starling_texture("item menu", "panel")

	panel_bg = TextureRect.new()
	panel_bg.name = "PanelBG"
	panel_bg.texture = bg_tex
	panel_bg.size = Vector2(501, 491)
	panel_bg.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(panel_bg)

	# Кнопка закрытия (MissionMenu.as:47-50: x=226, y=-193, pivotX=30, pivotY=19 -> (461, -4))
	var close_tex: Texture2D = atlas_loader.get_starling_texture("item menu", "x_btn_00")
	var close_hover: Texture2D = atlas_loader.get_starling_texture("item menu", "x_btn_01")
	close_btn = TextureButton.new()
	close_btn.name = "CloseButton"
	close_btn.texture_normal = close_tex
	close_btn.texture_hover = close_hover
	close_btn.position = Vector2(461, -4)
	close_btn.focus_mode = Control.FOCUS_NONE
	close_btn.pressed.connect(close_menu)
	add_child(close_btn)

	# Кнопка скролла (MissionMenu.as:53-56: x=208, y=-132, pivotX=15, pivotY=19 -> (458, 57))
	var scroll_tex: Texture2D = atlas_loader.get_starling_texture("item menu", "scroll")
	if scroll_tex != null:
		scroll_btn = TextureButton.new()
		scroll_btn.name = "ScrollBtn"
		scroll_btn.texture_normal = scroll_tex
		scroll_btn.position = Vector2(458, 57)
		scroll_btn.focus_mode = Control.FOCUS_NONE
		add_child(scroll_btn)

	# Область списка (MissionMenu.as:60: mask_canvas (-230, -161, 460, 361) -> (35, 47), (460, 361))
	var scroll: ScrollContainer = ScrollContainer.new()
	scroll.name = "MissionScroll"
	scroll.position = Vector2(35, 47)
	scroll.size = Vector2(460, 361)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.focus_mode = Control.FOCUS_NONE
	add_child(scroll)

	mission_list_container = VBoxContainer.new()
	mission_list_container.name = "MissionListContainer"
	mission_list_container.add_theme_constant_override("separation", 4) # 28px строка + 4px = шаг 32px
	mission_list_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(mission_list_container)

	# mission_txt (MissionMenu.as:22, 112-113: x=-212, y=181 -> (53, 389), 361x25)
	var stats_font: Font = atlas_loader.get_bitmap_font("stats_font.fnt")
	var readable_font: Font = atlas_loader.get_bitmap_font("readable_font.fnt")
	mission_title_label = Label.new()
	mission_title_label.name = "MissionTitle"
	mission_title_label.position = Vector2(53, 389)
	mission_title_label.size = Vector2(361, 25)
	mission_title_label.text = ""
	mission_title_label.add_theme_font_override("font", stats_font)
	mission_title_label.add_theme_font_size_override("font_size", 20)
	mission_title_label.add_theme_color_override("font_color", Color.WHITE)
	add_child(mission_title_label)

	# desc_txt (MissionMenu.as:24, 115-116: x=-241, y=207 -> (24, 415), 425x46)
	mission_details_label = Label.new()
	mission_details_label.name = "MissionDetails"
	mission_details_label.position = Vector2(24, 415)
	mission_details_label.size = Vector2(425, 46)
	mission_details_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	mission_details_label.text = ""
	mission_details_label.add_theme_font_override("font", readable_font)
	mission_details_label.add_theme_font_size_override("font_size", 13)
	add_child(mission_details_label)


func _populate_missions() -> void:
	var pio: Node = get_node_or_null("/root/PlayerIOClient")
	var active_missions: Array = []
	if pio != null and pio.get("my_player_object") is Dictionary:
		var m_val: Variant = pio.my_player_object.get("missions", [])
		if m_val is Array:
			active_missions = m_val

	if active_missions.is_empty():
		mission_details_label.text = ""
		return

	var atlas_loader: Node = _get_atlas_loader()
	var row_tex_normal: Texture2D = atlas_loader.get_starling_texture("item menu", "mission panel_00")
	var row_tex_selected: Texture2D = atlas_loader.get_starling_texture("item menu", "mission panel_01")
	var check_tex: Texture2D = atlas_loader.get_starling_texture("item menu", "checkmark")
	var xmark_tex: Texture2D = atlas_loader.get_starling_texture("item menu", "x mark")

	var sdb: Node = _get_stats_db()
	var all_missions: Array = []
	if sdb != null and sdb.missions_data.has("missions") and sdb.missions_data["missions"] is Array:
		all_missions = sdb.missions_data["missions"]

	for active_id: Variant in active_missions:
		for m_val: Variant in all_missions:
			if m_val is Dictionary and (m_val.get("id") == active_id or m_val.get("name") == active_id):
				var m_dict: Dictionary = m_val
				var m_name: String = str(m_dict.get("name", "Mission"))
				var m_desc: String = str(m_dict.get("description", m_dict.get("desc", "")))
				var m_xp: int = int(m_dict.get("worthXP", m_dict.get("worth", 0)))
				var is_completed: bool = bool(m_dict.get("completed", false))

				var row_btn: TextureButton = TextureButton.new()
				row_btn.texture_normal = row_tex_normal
				row_btn.custom_minimum_size = Vector2(442, 28)
				row_btn.focus_mode = Control.FOCUS_NONE

				var row_lbl: Label = Label.new()
				row_lbl.position = Vector2(9, 2)
				row_lbl.size = Vector2(390, 24)
				row_lbl.text = m_name
				row_lbl.add_theme_font_override("font", atlas_loader.get_bitmap_font("stats_font.fnt"))
				row_lbl.add_theme_font_size_override("font_size", 20)
				row_lbl.add_theme_color_override("font_color", Color.WHITE)
				row_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
				row_btn.add_child(row_lbl)

				var status_icon: TextureRect = TextureRect.new()
				status_icon.texture = check_tex if is_completed else xmark_tex
				status_icon.position = Vector2(402, 1)
				status_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
				row_btn.add_child(status_icon)

				var captured_btn: TextureButton = row_btn
				row_btn.pressed.connect(func() -> void:
					for b: TextureButton in row_buttons:
						b.texture_normal = row_tex_normal
					captured_btn.texture_normal = row_tex_selected
					mission_title_label.text = m_name
					mission_details_label.text = "%s (%dxp)" % [m_desc, m_xp]
				)
				mission_list_container.add_child(row_btn)
				row_buttons.append(row_btn)
				break


func close_menu() -> void:
	visible = false
	closed.emit()


func _gui_input(event: InputEvent) -> void:
	if not is_draggable:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = get_global_mouse_position() - global_position
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset


static func _get_atlas_loader() -> Node:
	if Engine.has_singleton("StarlingAtlasLoader"):
		return Engine.get_singleton("StarlingAtlasLoader")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("StarlingAtlasLoader"):
		return tree.root.get_node("StarlingAtlasLoader")
	return load("res://scripts/autoload/StarlingAtlasLoader.gd").new()


static func _get_stats_db() -> Node:
	if Engine.has_singleton("StatsDB"):
		return Engine.get_singleton("StatsDB")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("StatsDB"):
		return tree.root.get_node("StatsDB")
	return load("res://scripts/autoload/StatsDB.gd").new()
