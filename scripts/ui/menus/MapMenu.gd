extends Control
class_name MapMenu
## MapMenu — Окно глобальной карты мира (порт com.menus.MapMenu.as).
## Размер окна и фона "panel": 858x528 (map menu.xml).
## Координаты маркеров перенесены из MapMenu.as:189-332 и переведены из системы
## относительно panel (-329, -173) в координаты от верхнего левого угла (329 + x, 173 + y).

signal closed()
signal area_selected(stage_id: int)

const PANEL_SIZE := Vector2(858, 528)
const PANEL_ORIGIN := Vector2(329.0, 173.0)
const MARKER_SIZE := Vector2(22, 23)
const MARKER_PIVOT := Vector2(11.0, 11.0)

const LINE_COLOR := Color(0.0627451, 0.0627451, 0.0627451, 0.9) # #101010, alpha 0.9
const LINE_WIDTH := 2.5
const CURRENT_RING_COLOR := Color(0.752941, 0.376471, 1.0, 1.0) # 0xC060FF
const ARROW_FILL_COLOR := Color(1.0, 0.886275, 0.117647, 1.0) # 0xFFE21E

## Полная таблица markerPos из com.menus.MapMenu.as:189-332 (143 локации).
## Ключ: stage_id (int), значение: { "x": float, "y": float, "s": float } в координатах Starling (относительно panel -329, -173).
const MARKER_POS: Dictionary = {
	1: {"x": -120.0, "y": 176.0, "s": 1.0},
	2: {"x": -94.0, "y": 169.0, "s": 1.0},
	4: {"x": -66.0, "y": 175.0, "s": 1.0},
	3: {"x": -88.0, "y": 143.0, "s": 1.0},
	5: {"x": -40.0, "y": 180.0, "s": 1.0},
	8: {"x": -15.0, "y": 184.0, "s": 1.0},
	6: {"x": -84.0, "y": 114.0, "s": 1.0},
	7: {"x": -33.0, "y": 207.0, "s": 1.0},
	44: {"x": 26.0, "y": 188.0, "s": 1.0},
	45: {"x": 50.0, "y": 176.0, "s": 1.0},
	46: {"x": 77.0, "y": 183.0, "s": 1.0},
	47: {"x": 105.0, "y": 174.0, "s": 1.0},
	48: {"x": 120.0, "y": 196.0, "s": 1.0},
	49: {"x": 74.0, "y": 208.0, "s": 1.0},
	50: {"x": 57.0, "y": 228.0, "s": 1.0},
	67: {"x": 143.0, "y": 239.0, "s": 1.0},
	68: {"x": 121.0, "y": 253.0, "s": 1.0},
	69: {"x": 96.0, "y": 260.0, "s": 1.0},
	70: {"x": 173.0, "y": 241.0, "s": 1.0},
	71: {"x": 197.0, "y": 255.0, "s": 1.0},
	72: {"x": 224.0, "y": 266.0, "s": 1.0},
	74: {"x": 190.0, "y": 276.0, "s": 0.649993896484375},
	73: {"x": 137.0, "y": 277.0, "s": 1.0},
	75: {"x": 58.0, "y": 283.0, "s": 1.0},
	76: {"x": 30.0, "y": 273.0, "s": 1.0},
	80: {"x": 16.0, "y": 302.0, "s": 1.0},
	77: {"x": 6.0, "y": 252.0, "s": 1.0},
	78: {"x": -21.0, "y": 257.0, "s": 1.0},
	79: {"x": 6.0, "y": 282.0, "s": 0.649993896484375},
	111: {"x": 97.0, "y": 130.0, "s": 1.0},
	114: {"x": 112.0, "y": 107.0, "s": 0.79998779296875},
	113: {"x": 78.0, "y": 107.0, "s": 0.79998779296875},
	112: {"x": 63.0, "y": 124.0, "s": 0.79998779296875},
	52: {"x": 141.0, "y": 154.0, "s": 1.0},
	53: {"x": 153.0, "y": 135.0, "s": 1.0},
	54: {"x": 178.0, "y": 130.0, "s": 1.0},
	64: {"x": 197.0, "y": 160.0, "s": 1.0},
	127: {"x": 218.0, "y": 143.0, "s": 1.0},
	57: {"x": 245.0, "y": 160.0, "s": 1.0},
	126: {"x": 243.0, "y": 124.0, "s": 1.0},
	56: {"x": 153.0, "y": 110.0, "s": 1.0},
	119: {"x": 178.0, "y": 107.0, "s": 0.649993896484375},
	120: {"x": 184.0, "y": 97.0, "s": 0.649993896484375},
	121: {"x": 197.0, "y": 95.0, "s": 0.649993896484375},
	122: {"x": 210.0, "y": 103.0, "s": 0.649993896484375},
	123: {"x": 218.0, "y": 114.0, "s": 0.649993896484375},
	9: {"x": -75.0, "y": 73.0, "s": 1.0},
	10: {"x": -70.0, "y": 47.0, "s": 1.0},
	14: {"x": -99.0, "y": 47.0, "s": 1.0},
	11: {"x": -73.0, "y": 19.0, "s": 1.0},
	12: {"x": -60.0, "y": -7.0, "s": 1.0},
	13: {"x": -40.0, "y": -26.0, "s": 1.0},
	15: {"x": -86.0, "y": -2.0, "s": 0.649993896484375},
	16: {"x": -87.0, "y": -20.0, "s": 0.649993896484375},
	17: {"x": -73.0, "y": -33.0, "s": 0.649993896484375},
	18: {"x": -5.0, "y": -40.0, "s": 1.0},
	19: {"x": 11.0, "y": -17.0, "s": 1.0},
	20: {"x": 5.0, "y": 9.0, "s": 1.0},
	21: {"x": -8.0, "y": 50.0, "s": 1.0},
	22: {"x": -1.0, "y": 76.0, "s": 1.0},
	26: {"x": -33.0, "y": 74.0, "s": 1.0},
	24: {"x": -5.0, "y": 106.0, "s": 1.0},
	25: {"x": -33.0, "y": 102.0, "s": 1.0},
	27: {"x": -43.0, "y": 128.0, "s": 0.79998779296875},
	23: {"x": 22.0, "y": 83.0, "s": 1.0},
	125: {"x": 51.0, "y": 87.0, "s": 1.0},
	109: {"x": 89.0, "y": 64.0, "s": 1.0},
	28: {"x": 113.0, "y": 60.0, "s": 1.0},
	29: {"x": 132.0, "y": 45.0, "s": 1.0},
	30: {"x": 157.0, "y": 33.0, "s": 1.0},
	31: {"x": 181.0, "y": 45.0, "s": 1.0},
	32: {"x": 185.0, "y": 14.0, "s": 1.0},
	124: {"x": 133.0, "y": 20.0, "s": 0.649993896484375},
	117: {"x": 141.0, "y": 8.0, "s": 0.649993896484375},
	118: {"x": 156.0, "y": 8.0, "s": 0.649993896484375},
	33: {"x": 216.0, "y": 26.0, "s": 1.0},
	34: {"x": 243.0, "y": 27.0, "s": 1.0},
	35: {"x": 265.0, "y": 16.0, "s": 1.0},
	36: {"x": 281.0, "y": -6.0, "s": 1.0},
	37: {"x": 290.0, "y": -35.0, "s": 1.0},
	38: {"x": 310.0, "y": -16.0, "s": 1.0},
	39: {"x": 288.0, "y": -57.0, "s": 0.649993896484375},
	116: {"x": 259.0, "y": -28.0, "s": 1.0},
	40: {"x": 240.0, "y": 2.0, "s": 1.0},
	41: {"x": 372.0, "y": 31.0, "s": 1.0},
	42: {"x": 394.0, "y": 14.0, "s": 1.0},
	43: {"x": 413.0, "y": 36.0, "s": 1.0},
	104: {"x": 449.0, "y": 68.0, "s": 1.0},
	105: {"x": 425.0, "y": 82.0, "s": 1.0},
	106: {"x": 399.0, "y": 75.0, "s": 1.0},
	107: {"x": 372.0, "y": 71.0, "s": 1.0},
	108: {"x": 347.0, "y": 72.0, "s": 1.0},
	58: {"x": 172.0, "y": 195.0, "s": 1.0},
	59: {"x": 200.0, "y": 198.0, "s": 1.0},
	60: {"x": 230.0, "y": 205.0, "s": 1.0},
	61: {"x": 261.0, "y": 210.0, "s": 1.0},
	62: {"x": 210.0, "y": 221.0, "s": 1.0},
	63: {"x": 282.0, "y": 176.0, "s": 1.0},
	115: {"x": 295.0, "y": 155.0, "s": 1.0},
	65: {"x": 291.0, "y": 127.0, "s": 1.0},
	66: {"x": 280.0, "y": 100.0, "s": 1.0},
	81: {"x": 272.0, "y": 250.0, "s": 1.0},
	82: {"x": 295.0, "y": 234.0, "s": 1.0},
	83: {"x": 309.0, "y": 214.0, "s": 1.0},
	84: {"x": 330.0, "y": 191.0, "s": 1.0},
	85: {"x": 341.0, "y": 165.0, "s": 1.0},
	86: {"x": 336.0, "y": 110.0, "s": 1.0},
	87: {"x": 362.0, "y": 123.0, "s": 1.0},
	88: {"x": 388.0, "y": 136.0, "s": 1.0},
	92: {"x": 393.0, "y": 114.0, "s": 0.649993896484375},
	89: {"x": 414.0, "y": 118.0, "s": 1.0},
	90: {"x": 417.0, "y": 147.0, "s": 1.0},
	91: {"x": 400.0, "y": 169.0, "s": 1.0},
	93: {"x": 479.0, "y": 87.0, "s": 1.0},
	94: {"x": 495.0, "y": 62.0, "s": 1.0},
	101: {"x": 493.0, "y": 10.0, "s": 1.0},
	102: {"x": 468.0, "y": -1.0, "s": 1.0},
	95: {"x": 440.0, "y": 3.0, "s": 1.0},
	96: {"x": 413.0, "y": -19.0, "s": 1.0},
	97: {"x": 386.0, "y": -37.0, "s": 1.0},
	98: {"x": 350.0, "y": -38.0, "s": 1.0},
	100: {"x": 325.0, "y": -55.0, "s": 1.0},
	130: {"x": 404.0, "y": -49.0, "s": 0.649993896484375},
	131: {"x": 405.0, "y": -68.0, "s": 0.649993896484375},
	132: {"x": 405.0, "y": -88.0, "s": 0.649993896484375},
	129: {"x": 379.0, "y": -55.0, "s": 0.649993896484375},
	128: {"x": 375.0, "y": -69.0, "s": 0.649993896484375},
	103: {"x": 440.0, "y": -29.0, "s": 1.0},
	110: {"x": 172.0, "y": 160.0, "s": 1.0},
	55: {"x": 199.0, "y": 129.0, "s": 1.0},
	134: {"x": 352.0, "y": 0.0, "s": 0.9999919688239433},
	135: {"x": 339.0, "y": 21.0, "s": 0.9999919688239433},
	136: {"x": 323.0, "y": 40.0, "s": 0.9999919688239433},
	137: {"x": 300.0, "y": 49.0, "s": 0.9999919688239433},
	99: {"x": 358.0, "y": -59.0, "s": 1.0},
	133: {"x": 392.0, "y": -62.0, "s": 0.649993896484375},
	138: {"x": 281.0, "y": 68.0, "s": 0.9999919688239433},
	139: {"x": 256.0, "y": 59.0, "s": 0.6499790838491556},
	140: {"x": 267.0, "y": 49.0, "s": 0.6499790838491556},
	141: {"x": 282.0, "y": 44.0, "s": 0.6499790838491556},
	142: {"x": 244.0, "y": 85.0, "s": 0.9999919688239433},
	143: {"x": 222.0, "y": 73.0, "s": 0.9999919688239433},
	144: {"x": 198.0, "y": 71.0, "s": 0.9999919688239433},
	145: {"x": 213.0, "y": 53.0, "s": 0.6499790838491556}
}

@export var is_draggable: bool = true

var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

var current_stage_id: int = 1
var teleport_target_stage_id: int = -1
var pending_teleport_stage_id: int = -1
var unlocked_maps: Array[int] = []
var unlocked_maps_fallback_used: bool = false
var _all_revealed: bool = false

var panel_bg: TextureRect = null
var close_btn: TextureButton = null
var area_info_label: Label = null
var confirm_panel: Control = null
var confirm_label: Label = null
var confirm_yes_btn: TextureButton = null
var confirm_no_btn: TextureButton = null

var map_container: Control = null
var lines_layer: Control = null
var markers_layer: Control = null
var rings_layer: Control = null
var arrow_layer: Control = null
var area_buttons: Dictionary = {}


func _init(start_stage: int = 1) -> void:
	current_stage_id = start_stage


func _ready() -> void:
	custom_minimum_size = PANEL_SIZE
	size = PANEL_SIZE
	_build_ui()
	set_current_area(current_stage_id)


func _build_ui() -> void:
	var atlas_loader: Node = _get_atlas_loader()
	atlas_loader.register_starling_atlas("map menu")
	var bg_tex: Texture2D = atlas_loader.get_starling_texture("map menu", "panel")

	panel_bg = TextureRect.new()
	panel_bg.name = "PanelBG"
	panel_bg.texture = bg_tex
	panel_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	panel_bg.size = PANEL_SIZE
	panel_bg.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(panel_bg)

	# Контейнер карты (в координатах panel 858x528)
	map_container = Control.new()
	map_container.name = "MapContainer"
	map_container.position = Vector2.ZERO
	map_container.size = PANEL_SIZE
	map_container.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(map_container)

	# Слой линий переходов под маркерами (MapMenu.as:335-387)
	lines_layer = Control.new()
	lines_layer.name = "LinesLayer"
	lines_layer.position = Vector2.ZERO
	lines_layer.size = PANEL_SIZE
	lines_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lines_layer.draw.connect(_on_lines_draw)
	map_container.add_child(lines_layer)

	# Слой кликабельных маркеров
	markers_layer = Control.new()
	markers_layer.name = "MarkersLayer"
	markers_layer.position = Vector2.ZERO
	markers_layer.size = PANEL_SIZE
	markers_layer.mouse_filter = Control.MOUSE_FILTER_PASS
	map_container.add_child(markers_layer)

	# Слой фиолетового кольца текущей локации (MapMenu.as:401-442)
	rings_layer = Control.new()
	rings_layer.name = "RingsLayer"
	rings_layer.position = Vector2.ZERO
	rings_layer.size = PANEL_SIZE
	rings_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rings_layer.draw.connect(_on_rings_draw)
	map_container.add_child(rings_layer)

	# Слой жёлтой стрелки телепорта над выбранным маркером (MapMenu.as:601-631)
	arrow_layer = Control.new()
	arrow_layer.name = "ArrowLayer"
	arrow_layer.position = Vector2.ZERO
	arrow_layer.size = PANEL_SIZE
	arrow_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	arrow_layer.draw.connect(_on_arrow_draw)
	map_container.add_child(arrow_layer)

	# Кнопка закрытия (MapMenu.as:76-82: x=513, y=-157, pivot=(30, 19))
	var close_tex: Texture2D = atlas_loader.get_starling_texture("map menu", "x_btn_00")
	var close_hover: Texture2D = atlas_loader.get_starling_texture("map menu", "x_btn_01")
	close_btn = TextureButton.new()
	close_btn.name = "CloseButton"
	close_btn.focus_mode = Control.FOCUS_NONE
	close_btn.texture_normal = close_tex
	close_btn.texture_hover = close_hover
	close_btn.position = Vector2(PANEL_ORIGIN.x + 513.0 - 30.0, PANEL_ORIGIN.y - 157.0 - 19.0)
	close_btn.pressed.connect(close_menu)
	add_child(close_btn)

	# Информация о текущей / наведённой локации
	area_info_label = Label.new()
	area_info_label.name = "AreaInfo"
	area_info_label.position = Vector2(20, 494)
	area_info_label.size = Vector2(818, 26)
	area_info_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(area_info_label)

	_create_map_locations()
	_build_confirm_dialog()


func _build_confirm_dialog() -> void:
	var atlas_loader: Node = _get_atlas_loader()
	atlas_loader.register_starling_atlas("item menu")
	var backdrop_tex: Texture2D = atlas_loader.get_starling_texture("item menu", "confirm backdrop")
	var yes_tex: Texture2D = atlas_loader.get_starling_texture("item menu", "yes")
	var no_tex: Texture2D = atlas_loader.get_starling_texture("item menu", "no")

	confirm_panel = Control.new()
	confirm_panel.name = "ConfirmDialog"
	confirm_panel.position = Vector2((PANEL_SIZE.x - 428.0) * 0.5, (PANEL_SIZE.y - 164.0) * 0.5)
	confirm_panel.size = Vector2(428, 164)
	confirm_panel.visible = false
	confirm_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(confirm_panel)

	if backdrop_tex != null:
		var bg := TextureRect.new()
		bg.name = "Backdrop"
		bg.texture = backdrop_tex
		bg.position = Vector2.ZERO
		bg.size = Vector2(428, 164)
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		confirm_panel.add_child(bg)
	else:
		var fallback_bg := Panel.new()
		fallback_bg.size = Vector2(428, 164)
		fallback_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		confirm_panel.add_child(fallback_bg)

	confirm_label = Label.new()
	confirm_label.name = "ConfirmPrompt"
	confirm_label.position = Vector2(10, 18)
	confirm_label.size = Vector2(408, 56)
	confirm_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	confirm_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	confirm_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	confirm_label.add_theme_color_override("font_color", Color.WHITE)
	confirm_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	confirm_panel.add_child(confirm_label)

	confirm_no_btn = TextureButton.new()
	confirm_no_btn.name = "NoButton"
	confirm_no_btn.focus_mode = Control.FOCUS_NONE
	confirm_no_btn.texture_normal = no_tex
	confirm_no_btn.position = Vector2(85, 89)
	confirm_no_btn.size = Vector2(94, 46)
	confirm_no_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	confirm_no_btn.pressed.connect(confirm_teleport_no)
	confirm_panel.add_child(confirm_no_btn)

	confirm_yes_btn = TextureButton.new()
	confirm_yes_btn.name = "YesButton"
	confirm_yes_btn.focus_mode = Control.FOCUS_NONE
	confirm_yes_btn.texture_normal = yes_tex
	confirm_yes_btn.position = Vector2(254, 89)
	confirm_yes_btn.size = Vector2(94, 46)
	confirm_yes_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	confirm_yes_btn.pressed.connect(confirm_teleport_yes)
	confirm_panel.add_child(confirm_yes_btn)


func _marker_center(stage_id: int) -> Vector2:
	var entry: Dictionary = MARKER_POS.get(stage_id, {})
	if entry.is_empty():
		return Vector2.ZERO
	return Vector2(PANEL_ORIGIN.x + float(entry["x"]), PANEL_ORIGIN.y + float(entry["y"]))


func _resolve_unlocked_maps() -> void:
	unlocked_maps.clear()
	unlocked_maps_fallback_used = false

	if _all_revealed:
		for k: Variant in MARKER_POS.keys():
			var sid: int = int(k)
			if sid > 0 and sid != 51 and not unlocked_maps.has(sid):
				unlocked_maps.append(sid)
		unlocked_maps.sort()
		return

	var pio: Node = _get_player_io_client()
	if pio != null:
		var po: Variant = pio.get("my_player_object")
		if po is Dictionary:
			var raw_unlocked: Variant = po.get("unlockedMaps", [])
			if raw_unlocked is Array:
				for item: Variant in raw_unlocked:
					var sid: int = int(item)
					if sid > 0 and sid != 51 and MARKER_POS.has(sid) and not unlocked_maps.has(sid):
						unlocked_maps.append(sid)

	# Fallback при пустом unlockedMaps: только текущая стартовая локация (в оригинале [1])
	if unlocked_maps.is_empty():
		unlocked_maps_fallback_used = true
		if MARKER_POS.has(current_stage_id):
			unlocked_maps.append(current_stage_id)
		elif MARKER_POS.has(1):
			unlocked_maps.append(1)


func _create_map_locations() -> void:
	for child: Node in markers_layer.get_children():
		child.queue_free()
	area_buttons.clear()

	_resolve_unlocked_maps()

	var atlas_loader: Node = _get_atlas_loader()
	var marker_tex: Texture2D = atlas_loader.get_starling_texture("map menu", "map marker")
	var sdb: Node = _get_stats_db()

	for stage_id: int in unlocked_maps:
		var entry: Dictionary = MARKER_POS.get(stage_id, {})
		if entry.is_empty():
			continue

		var center: Vector2 = _marker_center(stage_id)
		var scale_val: float = float(entry.get("s", 1.0))
		var meta: Dictionary = _get_level_data(sdb, stage_id)
		var area_name: String = _get_area_display_name(meta, stage_id)

		var marker_btn: TextureButton = TextureButton.new()
		marker_btn.name = "level_%d" % stage_id
		marker_btn.focus_mode = Control.FOCUS_NONE
		marker_btn.texture_normal = marker_tex
		marker_btn.ignore_texture_size = true
		marker_btn.stretch_mode = TextureButton.STRETCH_SCALE
		marker_btn.size = MARKER_SIZE
		marker_btn.pivot_offset = MARKER_PIVOT
		marker_btn.position = center - MARKER_PIVOT
		marker_btn.scale = Vector2(scale_val, scale_val)
		marker_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		marker_btn.tooltip_text = "%s (#%d)" % [area_name, stage_id]
		marker_btn.mouse_entered.connect(_on_marker_hovered.bind(stage_id, area_name))
		marker_btn.mouse_exited.connect(_on_marker_unhovered)
		marker_btn.pressed.connect(_on_area_clicked.bind(stage_id, area_name))

		markers_layer.add_child(marker_btn)
		area_buttons[stage_id] = marker_btn

	lines_layer.queue_redraw()
	rings_layer.queue_redraw()
	arrow_layer.queue_redraw()


func _on_lines_draw() -> void:
	var sdb: Node = _get_stats_db()
	var drawn_edges: Dictionary = {}

	for stage_id: int in unlocked_maps:
		if not area_buttons.has(stage_id):
			continue
		var meta: Dictionary = _get_level_data(sdb, stage_id)
		if meta.is_empty():
			continue
		var from_pos: Vector2 = _marker_center(stage_id)
		for lead_id: int in _extract_portal_leads(meta):
			if lead_id <= 0 or not area_buttons.has(lead_id):
				continue
			var edge_key: String = "%d_%d" % [mini(stage_id, lead_id), maxi(stage_id, lead_id)]
			if drawn_edges.has(edge_key):
				continue
			drawn_edges[edge_key] = true
			var to_pos: Vector2 = _marker_center(lead_id)
			lines_layer.draw_line(from_pos, to_pos, LINE_COLOR, LINE_WIDTH, true)


func _on_rings_draw() -> void:
	if not MARKER_POS.has(current_stage_id):
		return
	var entry: Dictionary = MARKER_POS[current_stage_id]
	var scale_val: float = float(entry.get("s", 1.0))
	if scale_val <= 0.0:
		scale_val = 1.0
	var radius: float = 11.5 * scale_val
	var center: Vector2 = _marker_center(current_stage_id)

	# MapMenu.as:412-417: внешняя чёрная обводка, кольцо 0xC060FF (4px), внутренняя чёрная обводка
	rings_layer.draw_arc(center, radius + 2.0, 0.0, TAU, 32, Color.BLACK, 1.0, true)
	rings_layer.draw_arc(center, radius, 0.0, TAU, 32, CURRENT_RING_COLOR, 4.0, true)
	rings_layer.draw_arc(center, maxf(1.0, radius - 2.0), 0.0, TAU, 32, Color.BLACK, 1.0, true)


func _on_arrow_draw() -> void:
	if teleport_target_stage_id <= 0 or not MARKER_POS.has(teleport_target_stage_id):
		return
	# MapMenu.as:613-628: треугольник 26x18, fill 0xFFE21E, outline 2px black
	var center: Vector2 = _marker_center(teleport_target_stage_id)
	var w: float = 26.0
	var h: float = 18.0
	var top_left := Vector2(center.x - w * 0.5, center.y - h - 16.0)
	var pts := PackedVector2Array([
		top_left,
		top_left + Vector2(w, 0.0),
		top_left + Vector2(w * 0.5, h)
	])
	arrow_layer.draw_colored_polygon(pts, ARROW_FILL_COLOR)
	var outline := PackedVector2Array([pts[0], pts[1], pts[2], pts[0]])
	arrow_layer.draw_polyline(outline, Color.BLACK, 2.0, true)


func show_teleport_arrow(stage_id: int) -> void:
	if not MARKER_POS.has(stage_id):
		return
	teleport_target_stage_id = stage_id
	if arrow_layer != null:
		arrow_layer.queue_redraw()


func hide_teleport_arrow() -> void:
	teleport_target_stage_id = -1
	if arrow_layer != null:
		arrow_layer.queue_redraw()


func _on_marker_hovered(stage_id: int, area_name: String) -> void:
	if area_info_label != null:
		area_info_label.text = "%s (#%d)" % [area_name, stage_id]


func _on_marker_unhovered() -> void:
	_update_current_area_label()


func _on_area_clicked(stage_id: int, area_name: String) -> void:
	if stage_id != current_stage_id:
		show_teleport_arrow(stage_id)
		pending_teleport_stage_id = stage_id
		if area_info_label != null:
			area_info_label.text = "Teleport to %s (#%d)?" % [area_name, stage_id]
		if confirm_panel != null and confirm_label != null:
			confirm_label.text = "Do you wish to teleport to %s?" % area_name
			confirm_panel.visible = true
			confirm_panel.move_to_front()
		else:
			area_selected.emit(stage_id)
	else:
		confirm_teleport_no()
		if area_info_label != null:
			area_info_label.text = "You are already in this area"


func confirm_teleport_yes() -> void:
	var target: int = pending_teleport_stage_id
	pending_teleport_stage_id = -1
	if confirm_panel != null:
		confirm_panel.visible = false
	hide_teleport_arrow()
	if target > 0 and target != current_stage_id:
		area_selected.emit(target)


func confirm_teleport_no() -> void:
	pending_teleport_stage_id = -1
	if confirm_panel != null:
		confirm_panel.visible = false
	hide_teleport_arrow()
	_update_current_area_label()


func set_current_area(stage_id: int) -> void:
	var changed: bool = current_stage_id != stage_id
	current_stage_id = stage_id
	if unlocked_maps_fallback_used and changed and markers_layer != null:
		_create_map_locations()
	_update_current_area_label()
	if rings_layer != null:
		rings_layer.queue_redraw()


func is_stage_unlocked(stage_id: int) -> bool:
	return unlocked_maps.has(stage_id)


func reveal_all_map() -> Array[int]:
	_all_revealed = true
	var all_stages: Array[int] = []
	for k: Variant in MARKER_POS.keys():
		var sid: int = int(k)
		if sid > 0 and sid != 51 and not all_stages.has(sid):
			all_stages.append(sid)
	all_stages.sort()

	var pio: Node = _get_player_io_client()
	if pio != null:
		var po: Variant = pio.get("my_player_object")
		if po is Dictionary:
			var arr: Array = []
			for sid: int in all_stages:
				arr.append(sid)
			po["unlockedMaps"] = arr
			if pio.has_method("bigdb_save_changes"):
				pio.call("bigdb_save_changes", "PlayerObjects", str(pio.get("connect_user_id")), po)

	if markers_layer != null:
		_create_map_locations()
	else:
		_resolve_unlocked_maps()
	_update_current_area_label()
	return all_stages


func refresh_unlocked_maps() -> void:
	var pio: Node = _get_player_io_client()
	if pio != null:
		var po: Variant = pio.get("my_player_object")
		if po is Dictionary and po.get("unlockedMaps") is Array:
			_all_revealed = false
	if markers_layer != null:
		_create_map_locations()
	else:
		_resolve_unlocked_maps()
	_update_current_area_label()


func _update_current_area_label() -> void:
	if area_info_label == null:
		return
	var sdb: Node = _get_stats_db()
	var meta: Dictionary = _get_level_data(sdb, current_stage_id)
	var area_name: String = _get_area_display_name(meta, current_stage_id)
	var pvp: bool = bool(meta.get("isPvpArea", false))
	var suffix: String = " (PvP)" if pvp else ""
	area_info_label.text = "Stage %d: %s%s" % [current_stage_id, area_name, suffix]


func close_menu() -> void:
	pending_teleport_stage_id = -1
	if confirm_panel != null:
		confirm_panel.visible = false
	hide_teleport_arrow()
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


static func _get_level_data(sdb: Node, stage_id: int) -> Dictionary:
	if sdb == null:
		return {}
	var levels_dict: Variant = sdb.get("levels_data")
	if levels_dict is Dictionary:
		if levels_dict.has(stage_id) and levels_dict[stage_id] is Dictionary:
			return levels_dict[stage_id]
		var key_str: String = str(stage_id)
		if levels_dict.has(key_str) and levels_dict[key_str] is Dictionary:
			return levels_dict[key_str]
	if sdb.has_method("get_area_meta"):
		var meta: Variant = sdb.call("get_area_meta", stage_id)
		if meta is Dictionary:
			return meta
	return {}


static func _get_area_display_name(meta: Dictionary, stage_id: int) -> String:
	var fname: String = str(meta.get("fname", ""))
	if not fname.is_empty():
		return fname
	var area_name: String = str(meta.get("name", ""))
	if not area_name.is_empty():
		return area_name
	return "Stage %d" % stage_id


static func _extract_portal_leads(meta: Dictionary) -> Array[int]:
	var leads: Array[int] = []
	if meta.is_empty():
		return leads
	var portals_dict: Variant = meta.get("portals", {})
	for i: int in range(1, 8):
		var key: String = "portal%dLead" % i
		var lead_val: int = 0
		if portals_dict is Dictionary and portals_dict.has(key):
			lead_val = int(portals_dict.get(key, 0))
		elif meta.has(key):
			lead_val = int(meta.get(key, 0))
		if lead_val > 0:
			leads.append(lead_val)
	return leads


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


static func _get_player_io_client() -> Node:
	if Engine.has_singleton("PlayerIOClient"):
		return Engine.get_singleton("PlayerIOClient")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("PlayerIOClient"):
		return tree.root.get_node("PlayerIOClient")
	return null
