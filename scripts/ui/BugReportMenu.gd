extends Control
class_name BugReportMenu
## BugReportMenu — Окно сбора и экспорта баг-репортов (глобальное сохранение между перезапусками и персонажами).

const DRAFT_PATH: String = "user://bug_report_draft.json"
const REPORTS_DIR: String = "res://bug_reports"
const PANEL_DEFAULT_SIZE: Vector2 = Vector2(560, 460)
const DRAG_EDGE_MARGIN: float = 18.0

var panel: PanelContainer = null
var close_btn: Button = null
var scroll_container: ScrollContainer = null
var fields_vbox: VBoxContainer = null
var add_field_btn: Button = null
var save_btn: Button = null
var download_btn: Button = null
var clear_btn: Button = null
var status_label: Label = null

var _bug_edits: Array[TextEdit] = []
var _bug_labels: Array[Label] = []
var _loading_draft: bool = false
var _is_dragging: bool = false
var _drag_offset: Vector2 = Vector2.ZERO
var _has_been_dragged: bool = false


func _ready() -> void:
	visible = false
	anchors_preset = PRESET_FULL_RECT
	mouse_filter = MOUSE_FILTER_STOP
	_build_ui()
	load_draft()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_EXIT_TREE:
		if not _bug_edits.is_empty():
			save_draft()


func toggle_menu() -> void:
	if visible:
		close_menu()
	else:
		open_menu()


func open_menu() -> void:
	load_draft()
	visible = true
	if not _has_been_dragged:
		_center_panel()


func close_menu() -> void:
	_is_dragging = false
	save_draft()
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
	title.text = "BUG REPORT"
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

	scroll_container = ScrollContainer.new()
	scroll_container.name = "BugScrollContainer"
	scroll_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll_container.custom_minimum_size = Vector2(0, 300)
	vbox.add_child(scroll_container)

	fields_vbox = VBoxContainer.new()
	fields_vbox.name = "FieldsVBox"
	fields_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fields_vbox.add_theme_constant_override("separation", 8)
	scroll_container.add_child(fields_vbox)

	var btn_row := HBoxContainer.new()
	btn_row.add_theme_constant_override("separation", 8)
	vbox.add_child(btn_row)

	add_field_btn = Button.new()
	add_field_btn.name = "AddFieldBtn"
	add_field_btn.focus_mode = Control.FOCUS_NONE
	add_field_btn.text = "+ Добавить поле"
	add_field_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_field_btn.pressed.connect(func() -> void:
		add_bug_field("")
		save_draft()
	)
	btn_row.add_child(add_field_btn)

	save_btn = Button.new()
	save_btn.name = "SaveDraftBtn"
	save_btn.focus_mode = Control.FOCUS_NONE
	save_btn.text = "Сохранить"
	save_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	save_btn.pressed.connect(func() -> void:
		save_draft()
		if status_label != null:
			status_label.text = "Черновик сохранён (%d пол.)." % _bug_edits.size()
	)
	btn_row.add_child(save_btn)

	download_btn = Button.new()
	download_btn.name = "DownloadReportBtn"
	download_btn.focus_mode = Control.FOCUS_NONE
	download_btn.text = "Скачать репорт"
	download_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	download_btn.pressed.connect(_on_download_report)
	btn_row.add_child(download_btn)

	clear_btn = Button.new()
	clear_btn.name = "ClearAllBtn"
	clear_btn.focus_mode = Control.FOCUS_NONE
	clear_btn.text = "Стереть всё"
	clear_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	clear_btn.pressed.connect(clear_all_bugs)
	btn_row.add_child(clear_btn)

	status_label = Label.new()
	status_label.text = ""
	status_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.add_theme_color_override("font_color", Color(0.65, 1.0, 0.65, 1.0))
	vbox.add_child(status_label)


func add_bug_field(initial_text: String = "") -> TextEdit:
	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 8)
	fields_vbox.add_child(row)

	var idx: int = _bug_edits.size() + 1
	var num_lbl := Label.new()
	num_lbl.text = "%d." % idx
	num_lbl.custom_minimum_size = Vector2(28, 0)
	num_lbl.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	num_lbl.add_theme_color_override("font_color", Color(1.0, 0.88, 0.35, 1.0))
	row.add_child(num_lbl)
	_bug_labels.append(num_lbl)

	var te := TextEdit.new()
	te.name = "BugEdit_%d" % idx
	te.text = initial_text
	te.placeholder_text = "Опишите баг #%d..." % idx
	te.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	te.custom_minimum_size = Vector2(0, 68)
	te.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	te.text_changed.connect(_on_any_text_changed)
	row.add_child(te)
	_bug_edits.append(te)
	return te


func _on_any_text_changed() -> void:
	if not _loading_draft:
		save_draft()


func _clear_ui_fields() -> void:
	_bug_edits.clear()
	_bug_labels.clear()
	if fields_vbox != null:
		for child: Node in fields_vbox.get_children():
			fields_vbox.remove_child(child)
			child.queue_free()


func get_bug_texts() -> Array[String]:
	var out: Array[String] = []
	for te: TextEdit in _bug_edits:
		if is_instance_valid(te):
			out.append(te.text)
	return out


func save_draft() -> void:
	var entries: Array[String] = get_bug_texts()
	if entries.is_empty():
		entries = [""]
	var f := FileAccess.open(DRAFT_PATH, FileAccess.WRITE)
	if f != null:
		f.store_string(JSON.stringify({"entries": entries}, "\t"))
		f.close()


func load_draft() -> void:
	_loading_draft = true
	_clear_ui_fields()
	var loaded_entries: Array[String] = []
	if FileAccess.file_exists(DRAFT_PATH):
		var f := FileAccess.open(DRAFT_PATH, FileAccess.READ)
		if f != null:
			var parsed: Variant = JSON.parse_string(f.get_as_text())
			f.close()
			if parsed is Dictionary and (parsed as Dictionary).get("entries") is Array:
				for item_v: Variant in (parsed as Dictionary)["entries"]:
					loaded_entries.append(str(item_v))
	if loaded_entries.is_empty():
		loaded_entries.append("")
	for txt: String in loaded_entries:
		add_bug_field(txt)
	_loading_draft = false


func clear_all_bugs() -> void:
	_loading_draft = true
	_clear_ui_fields()
	add_bug_field("")
	_loading_draft = false
	save_draft()
	if status_label != null:
		status_label.text = "Все поля очищены."


func export_report_to_folder(target_dir_override: String = "") -> String:
	save_draft()
	var non_empty: Array[String] = []
	for raw_txt: String in get_bug_texts():
		var trimmed: String = raw_txt.strip_edges()
		if not trimmed.is_empty():
			non_empty.append(trimmed)
	if non_empty.is_empty():
		if status_label != null:
			status_label.text = "Нет записанных багов для скачивания."
		return ""

	var dir_path: String = target_dir_override if not target_dir_override.is_empty() else ProjectSettings.globalize_path(REPORTS_DIR)
	DirAccess.make_dir_recursive_absolute(dir_path)

	var dt: Dictionary = Time.get_datetime_dict_from_system()
	var stamp: String = "%04d-%02d-%02d_%02d-%02d-%02d" % [
		int(dt.get("year", 2026)),
		int(dt.get("month", 1)),
		int(dt.get("day", 1)),
		int(dt.get("hour", 0)),
		int(dt.get("minute", 0)),
		int(dt.get("second", 0)),
	]
	var file_path: String = dir_path.path_join("bug_report_%s.txt" % stamp)
	var suffix: int = 1
	while FileAccess.file_exists(file_path):
		suffix += 1
		file_path = dir_path.path_join("bug_report_%s_%d.txt" % [stamp, suffix])

	var lines: Array[String] = []
	for i: int in range(non_empty.size()):
		lines.append("%d. %s" % [i + 1, non_empty[i]])

	var f := FileAccess.open(file_path, FileAccess.WRITE)
	if f == null:
		if status_label != null:
			status_label.text = "Ошибка записи файла."
		return ""
	f.store_string("\n".join(lines) + "\n\nУзнай источники этих проблем и исправь эти баги\n")
	f.close()
	if status_label != null:
		status_label.text = "Репорт сохранён: %s" % file_path.get_file()
	return file_path


func _on_download_report() -> void:
	export_report_to_folder()
