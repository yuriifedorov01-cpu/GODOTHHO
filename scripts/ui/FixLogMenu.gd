extends Control
class_name FixLogMenu
## FixLogMenu — Окно журнала обновлений и исправлений (Fix Log) с перетаскиванием за любой край.

const FIX_LOG_PATH: String = "res://docs/fix_log.json"
const PANEL_DEFAULT_SIZE: Vector2 = Vector2(600, 420)
const TIPS_PANEL_SIZE: Vector2 = Vector2(520, 340)
const DRAG_EDGE_MARGIN: float = 18.0

var panel: PanelContainer = null
var close_btn: Button = null
var updates_list: ItemList = null
var detail_title: Label = null
var detail_text: RichTextLabel = null
var test_tips_btn: Button = null

var tips_overlay: ColorRect = null
var tips_panel: PanelContainer = null
var tips_title: Label = null
var tips_text: RichTextLabel = null
var tips_close_btn: Button = null

var _updates: Array[Dictionary] = []
var _selected_index: int = -1
var _is_dragging: bool = false
var _drag_offset: Vector2 = Vector2.ZERO
var _has_been_dragged: bool = false


func _ready() -> void:
	visible = false
	anchors_preset = PRESET_FULL_RECT
	mouse_filter = MOUSE_FILTER_STOP
	_build_ui()
	load_fix_log()


func toggle_menu() -> void:
	if visible:
		close_menu()
	else:
		open_menu()


func _reset_panel_size() -> void:
	if panel != null:
		panel.custom_minimum_size = PANEL_DEFAULT_SIZE
		panel.size = PANEL_DEFAULT_SIZE
	if tips_panel != null:
		tips_panel.custom_minimum_size = TIPS_PANEL_SIZE
		tips_panel.size = TIPS_PANEL_SIZE


func open_menu() -> void:
	close_test_tips()
	load_fix_log()
	_reset_panel_size()
	visible = true
	if not _has_been_dragged:
		_center_panel()


func close_menu() -> void:
	_is_dragging = false
	close_test_tips()
	visible = false


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
	bg_dim.color = Color(0.0, 0.0, 0.0, 0.45)
	bg_dim.mouse_filter = MOUSE_FILTER_STOP
	add_child(bg_dim)

	panel = PanelContainer.new()
	panel.clip_contents = true
	panel.set_anchors_preset(PRESET_TOP_LEFT)
	panel.custom_minimum_size = PANEL_DEFAULT_SIZE
	panel.size = PANEL_DEFAULT_SIZE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.10, 0.14, 0.20, 0.97)
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
	title.text = "FIX LOG — История обновлений"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_color_override("font_color", Color(1.0, 0.88, 0.35, 1.0))
	title.add_theme_font_size_override("font_size", 18)
	header.add_child(title)

	close_btn = Button.new()
	close_btn.name = "CloseButton"
	close_btn.focus_mode = Control.FOCUS_NONE
	close_btn.text = "X"
	close_btn.custom_minimum_size = Vector2(30, 28)
	close_btn.pressed.connect(close_menu)
	header.add_child(close_btn)

	var split := HBoxContainer.new()
	split.size_flags_vertical = Control.SIZE_EXPAND_FILL
	split.add_theme_constant_override("separation", 12)
	vbox.add_child(split)

	updates_list = ItemList.new()
	updates_list.name = "UpdatesList"
	updates_list.focus_mode = Control.FOCUS_NONE
	updates_list.custom_minimum_size = Vector2(210, 0)
	updates_list.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	updates_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	updates_list.item_selected.connect(_on_update_selected)
	split.add_child(updates_list)

	var right_panel := PanelContainer.new()
	right_panel.clip_contents = true
	right_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var r_sb := StyleBoxFlat.new()
	r_sb.bg_color = Color(0.07, 0.10, 0.15, 0.92)
	r_sb.border_color = Color(0.35, 0.45, 0.60, 0.8)
	r_sb.set_border_width_all(1)
	r_sb.set_corner_radius_all(4)
	r_sb.set_content_margin_all(10)
	right_panel.add_theme_stylebox_override("panel", r_sb)
	split.add_child(right_panel)

	var right_vbox := VBoxContainer.new()
	right_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_vbox.add_theme_constant_override("separation", 8)
	right_panel.add_child(right_vbox)

	detail_title = Label.new()
	detail_title.name = "DetailTitle"
	detail_title.text = "Выберите обновление"
	detail_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	detail_title.custom_minimum_size = Vector2(100, 24)
	detail_title.autowrap_mode = TextServer.AUTOWRAP_OFF
	detail_title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	detail_title.add_theme_color_override("font_color", Color(0.55, 0.88, 1.0, 1.0))
	detail_title.add_theme_font_size_override("font_size", 15)
	right_vbox.add_child(detail_title)

	detail_text = RichTextLabel.new()
	detail_text.name = "DetailText"
	detail_text.focus_mode = Control.FOCUS_NONE
	detail_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	detail_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	detail_text.scroll_active = true
	detail_text.selection_enabled = true
	detail_text.fit_content = false
	detail_text.add_theme_color_override("default_color", Color(0.92, 0.94, 0.98, 1.0))
	detail_text.add_theme_font_size_override("normal_font_size", 14)
	right_vbox.add_child(detail_text)

	var footer := HBoxContainer.new()
	footer.alignment = BoxContainer.ALIGNMENT_END
	right_vbox.add_child(footer)

	test_tips_btn = Button.new()
	test_tips_btn.name = "TestTipsButton"
	test_tips_btn.focus_mode = Control.FOCUS_NONE
	test_tips_btn.text = "Советы по тестированию"
	test_tips_btn.custom_minimum_size = Vector2(190, 30)
	test_tips_btn.pressed.connect(open_test_tips)
	footer.add_child(test_tips_btn)

	_build_test_tips_popup()


func _build_test_tips_popup() -> void:
	tips_overlay = ColorRect.new()
	tips_overlay.name = "TestTipsOverlay"
	tips_overlay.visible = false
	tips_overlay.set_anchors_preset(PRESET_FULL_RECT)
	tips_overlay.color = Color(0.0, 0.0, 0.0, 0.55)
	tips_overlay.mouse_filter = MOUSE_FILTER_STOP
	add_child(tips_overlay)

	tips_panel = PanelContainer.new()
	tips_panel.name = "TestTipsPanel"
	tips_panel.clip_contents = true
	tips_panel.set_anchors_preset(PRESET_TOP_LEFT)
	tips_panel.custom_minimum_size = TIPS_PANEL_SIZE
	tips_panel.size = TIPS_PANEL_SIZE
	var t_sb := StyleBoxFlat.new()
	t_sb.bg_color = Color(0.11, 0.16, 0.23, 0.98)
	t_sb.border_color = Color(0.45, 0.82, 1.0, 1.0)
	t_sb.set_border_width_all(2)
	t_sb.set_corner_radius_all(6)
	t_sb.set_content_margin_all(12)
	tips_panel.add_theme_stylebox_override("panel", t_sb)
	tips_overlay.add_child(tips_panel)

	var t_vbox := VBoxContainer.new()
	t_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	t_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	t_vbox.add_theme_constant_override("separation", 8)
	tips_panel.add_child(t_vbox)

	var t_header := HBoxContainer.new()
	t_header.add_theme_constant_override("separation", 8)
	t_vbox.add_child(t_header)

	tips_title = Label.new()
	tips_title.name = "TipsTitle"
	tips_title.text = "Советы по тестированию"
	tips_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tips_title.custom_minimum_size = Vector2(100, 24)
	tips_title.autowrap_mode = TextServer.AUTOWRAP_OFF
	tips_title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	tips_title.add_theme_color_override("font_color", Color(0.55, 0.88, 1.0, 1.0))
	tips_title.add_theme_font_size_override("font_size", 15)
	t_header.add_child(tips_title)

	tips_close_btn = Button.new()
	tips_close_btn.name = "TipsCloseButton"
	tips_close_btn.focus_mode = Control.FOCUS_NONE
	tips_close_btn.text = "X"
	tips_close_btn.custom_minimum_size = Vector2(30, 28)
	tips_close_btn.pressed.connect(close_test_tips)
	t_header.add_child(tips_close_btn)

	tips_text = RichTextLabel.new()
	tips_text.name = "TipsText"
	tips_text.focus_mode = Control.FOCUS_NONE
	tips_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tips_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tips_text.scroll_active = true
	tips_text.selection_enabled = true
	tips_text.fit_content = false
	tips_text.add_theme_color_override("default_color", Color(0.92, 0.96, 1.0, 1.0))
	tips_text.add_theme_font_size_override("normal_font_size", 14)
	t_vbox.add_child(tips_text)

	var t_footer := HBoxContainer.new()
	t_footer.alignment = BoxContainer.ALIGNMENT_END
	t_vbox.add_child(t_footer)

	var back_btn := Button.new()
	back_btn.name = "TipsBackButton"
	back_btn.focus_mode = Control.FOCUS_NONE
	back_btn.text = "Закрыть и вернуться"
	back_btn.custom_minimum_size = Vector2(160, 28)
	back_btn.pressed.connect(close_test_tips)
	t_footer.add_child(back_btn)


func open_test_tips() -> void:
	if tips_overlay == null or tips_panel == null:
		return
	var u_title: String = "Обновление"
	var tips_str: String = "Советы по тестированию для этого обновления не указаны."
	if _selected_index >= 0 and _selected_index < _updates.size():
		var u: Dictionary = _updates[_selected_index]
		u_title = str(u.get("title", "Обновление")).strip_edges()
		var raw_tips: String = str(u.get("test_tips", "")).strip_edges()
		if not raw_tips.is_empty():
			tips_str = raw_tips
	if tips_title != null:
		tips_title.text = "Тестирование: %s" % u_title
	if tips_text != null:
		tips_text.text = tips_str
	tips_panel.custom_minimum_size = TIPS_PANEL_SIZE
	tips_panel.size = TIPS_PANEL_SIZE
	var vp_size: Vector2 = get_viewport_rect().size
	if vp_size.x <= 10.0 or vp_size.y <= 10.0:
		vp_size = Vector2(950, 700)
	tips_panel.position = ((vp_size - TIPS_PANEL_SIZE) * 0.5).round()
	tips_overlay.visible = true


func close_test_tips() -> void:
	if tips_overlay != null:
		tips_overlay.visible = false


func load_fix_log() -> void:
	_updates.clear()
	if updates_list != null:
		updates_list.clear()
	if FileAccess.file_exists(FIX_LOG_PATH):
		var f := FileAccess.open(FIX_LOG_PATH, FileAccess.READ)
		if f != null:
			var parsed: Variant = JSON.parse_string(f.get_as_text())
			f.close()
			if parsed is Dictionary and (parsed as Dictionary).get("updates") is Array:
				for u_v: Variant in (parsed as Dictionary).get("updates"):
					if u_v is Dictionary:
						_updates.append(u_v as Dictionary)
	for u: Dictionary in _updates:
		var u_date: String = str(u.get("date", "")).strip_edges()
		var u_title: String = str(u.get("title", "Обновление")).strip_edges()
		var item_label: String = "%s (%s)" % [u_title, u_date] if not u_date.is_empty() else u_title
		if updates_list != null:
			updates_list.add_item(item_label)
	if _updates.size() > 0 and updates_list != null:
		updates_list.select(0)
		_on_update_selected(0)
	elif detail_title != null and detail_text != null:
		detail_title.text = "Нет записей"
		detail_text.text = "Список обновлений пока пуст."


func _on_update_selected(index: int) -> void:
	if index < 0 or index >= _updates.size():
		return
	_selected_index = index
	var u: Dictionary = _updates[index]
	var u_date: String = str(u.get("date", "")).strip_edges()
	var u_title: String = str(u.get("title", "Обновление")).strip_edges()
	if detail_title != null:
		detail_title.text = "%s — %s" % [u_date, u_title] if not u_date.is_empty() else u_title
	if detail_text != null:
		detail_text.text = str(u.get("summary", ""))
