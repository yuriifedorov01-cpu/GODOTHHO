extends Control
class_name OptionsMenu
## OptionsMenu — Окно настроек игры (порт com.menus.OptionMenu.as).
## Все переключатели выполнены в виде кликабельных текстовых меток:
## - Music: OFF / ON
## - Sound: OFF / ON
## - Fullscreen: OFF / ON
## - Cutscenes: 1 .. 8
## - Quality: LOW / MEDIUM / HIGH
## - Ignore Trades: OFF / ON
## - Ignore PMs: OFF / ON
## - Controller: OFF / ON, defineButtons, controller_txt, buttons_txt

signal closed()
signal cutscene_requested(cutscene_index: int)
signal define_buttons_requested()

const COLOR_OFF: Color = Color(1.0, 1.0, 1.0) # #FFFFFF
const COLOR_ON: Color = Color(1.0, 1.0, 0.0)  # #FFFF00

@export var is_draggable: bool = true

var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

var panel_bg: TextureRect = null
var close_btn: TextureButton = null
var define_buttons_btn: TextureButton = null

var music_slider: HSlider = null
var sfx_slider: HSlider = null
var music_pct_label: Label = null
var sfx_pct_label: Label = null
var fullscreen_off_btn: Button = null
var fullscreen_on_btn: Button = null

var cutscene_btns: Array[Button] = []

var quality_low_btn: Button = null
var quality_med_btn: Button = null
var quality_high_btn: Button = null

var ignore_trade_off_btn: Button = null
var ignore_trade_on_btn: Button = null
var ignore_pms_off_btn: Button = null
var ignore_pms_on_btn: Button = null
var controller_off_btn: Button = null
var controller_on_btn: Button = null

var controller_txt: Label = null
var buttons_txt: Label = null

# Переменные состояния
var ignore_trades: bool = false
var ignore_pms: bool = false
var controller_on: bool = true
var current_quality: String = "HIGH"

func _ready() -> void:
	custom_minimum_size = Vector2(453, 484)
	size = Vector2(453, 484)
	_build_ui()
	_update_ui_state()


func _build_ui() -> void:
	var atlas_loader: Node = _get_atlas_loader()
	atlas_loader.register_starling_atlas("item menu")

	# Фоновая панель из item menu.xml ("options panel": 453x484, Flash x=-215, y=-164)
	var bg_tex: Texture2D = atlas_loader.get_starling_texture("item menu", "options panel")
	panel_bg = TextureRect.new()
	panel_bg.name = "PanelBG"
	panel_bg.texture = bg_tex
	panel_bg.size = Vector2(453, 484)
	panel_bg.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(panel_bg)

	# Кнопка закрытия (OptionMenu.as:87-90: x=235, y=-148, pivotX=30, pivotY=19 -> (420, -3))
	var close_tex: Texture2D = atlas_loader.get_starling_texture("item menu", "x_btn_00")
	var close_hover: Texture2D = atlas_loader.get_starling_texture("item menu", "x_btn_01")
	close_btn = TextureButton.new()
	close_btn.name = "CloseButton"
	close_btn.texture_normal = close_tex
	close_btn.texture_hover = close_hover
	close_btn.position = Vector2(420, -3)
	close_btn.focus_mode = Control.FOCUS_NONE
	close_btn.pressed.connect(close_menu)
	add_child(close_btn)

	# Кнопка defineButtons (OptionMenu.as:93-96: x=-135, y=248, pivotX=62, pivotY=11 -> (18, 401))
	var def_btn_tex: Texture2D = atlas_loader.get_starling_texture("item menu", "defineButtons")
	if def_btn_tex != null:
		define_buttons_btn = TextureButton.new()
		define_buttons_btn.name = "DefineButtonsBtn"
		define_buttons_btn.texture_normal = def_btn_tex
		define_buttons_btn.position = Vector2(18, 401)
		define_buttons_btn.focus_mode = Control.FOCUS_NONE
		define_buttons_btn.pressed.connect(func() -> void: define_buttons_requested.emit())
		add_child(define_buttons_btn)

	# Cover pre-drawn "OFF   ON" text on options panel background (x=260..442, y=36..108)
	var audio_cover := ColorRect.new()
	audio_cover.name = "AudioToggleCover"
	audio_cover.position = Vector2(260, 36)
	audio_cover.size = Vector2(182, 72)
	audio_cover.color = Color(0.11, 0.11, 0.13, 1.0)
	add_child(audio_cover)

	# --- 1. MUSIC VOLUME SLIDER ---
	music_slider = HSlider.new()
	music_slider.name = "MusicSlider"
	music_slider.focus_mode = Control.FOCUS_NONE
	music_slider.position = Vector2(266, 44)
	music_slider.size = Vector2(126, 20)
	music_slider.min_value = 0.0
	music_slider.max_value = 1.0
	music_slider.step = 0.01
	music_slider.value = 0.2
	music_slider.value_changed.connect(_on_music_volume_changed)
	add_child(music_slider)

	music_pct_label = Label.new()
	music_pct_label.name = "MusicPctLabel"
	music_pct_label.position = Vector2(396, 41)
	music_pct_label.size = Vector2(44, 24)
	music_pct_label.text = "20%"
	music_pct_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	music_pct_label.add_theme_font_size_override("font_size", 16)
	music_pct_label.add_theme_color_override("font_color", COLOR_ON)
	add_child(music_pct_label)

	# --- 2. SOUND VOLUME SLIDER ---
	sfx_slider = HSlider.new()
	sfx_slider.name = "SoundSlider"
	sfx_slider.focus_mode = Control.FOCUS_NONE
	sfx_slider.position = Vector2(266, 82)
	sfx_slider.size = Vector2(126, 20)
	sfx_slider.min_value = 0.0
	sfx_slider.max_value = 1.0
	sfx_slider.step = 0.01
	sfx_slider.value = 0.2
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	add_child(sfx_slider)

	sfx_pct_label = Label.new()
	sfx_pct_label.name = "SoundPctLabel"
	sfx_pct_label.position = Vector2(396, 79)
	sfx_pct_label.size = Vector2(44, 24)
	sfx_pct_label.text = "20%"
	sfx_pct_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	sfx_pct_label.add_theme_font_size_override("font_size", 16)
	sfx_pct_label.add_theme_color_override("font_color", COLOR_ON)
	add_child(sfx_pct_label)

	# --- 3. FULLSCREEN (OptionMenu.as:143-150) ---
	fullscreen_off_btn = _create_text_btn("FullscreenOff", "OFF", Vector2(313, 117), Vector2(38, 30), 22)
	fullscreen_off_btn.pressed.connect(func() -> void: _set_fullscreen(false))
	add_child(fullscreen_off_btn)

	fullscreen_on_btn = _create_text_btn("FullscreenOn", "ON", Vector2(400, 117), Vector2(34, 27), 22)
	fullscreen_on_btn.pressed.connect(func() -> void: _set_fullscreen(true))
	add_child(fullscreen_on_btn)

	# --- 4. CUTSCENES 1..8 (OptionMenu.as:102-125, 175) ---
	var cutscene_x: Array[int] = [187, 220, 256, 287, 321, 359, 390, 421]
	for i: int in range(8):
		var idx: int = i + 1
		var c_btn: Button = _create_text_btn("Cutscene%d" % idx, str(idx), Vector2(cutscene_x[i], 197), Vector2(20, 25), 22)
		c_btn.pressed.connect(func() -> void: cutscene_requested.emit(idx))
		add_child(c_btn)
		cutscene_btns.append(c_btn)

	# --- 5. QUALITY (OptionMenu.as:177-188) ---
	quality_low_btn = _create_text_btn("QualityLow", "LOW", Vector2(241, 239), Vector2(44, 25), 20)
	quality_low_btn.pressed.connect(func() -> void: _set_quality("LOW"))
	add_child(quality_low_btn)

	quality_med_btn = _create_text_btn("QualityMedium", "MEDIUM", Vector2(304, 239), Vector2(75, 25), 20)
	quality_med_btn.pressed.connect(func() -> void: _set_quality("MEDIUM"))
	add_child(quality_med_btn)

	quality_high_btn = _create_text_btn("QualityHigh", "HIGH", Vector2(393, 239), Vector2(46, 25), 20)
	quality_high_btn.pressed.connect(func() -> void: _set_quality("HIGH"))
	add_child(quality_high_btn)

	# --- 6. IGNORE TRADES (OptionMenu.as:152-158) ---
	ignore_trade_off_btn = _create_text_btn("IgnoreTradeOff", "OFF", Vector2(309, 272), Vector2(38, 30), 22)
	ignore_trade_off_btn.pressed.connect(func() -> void: _set_ignore_trades(false))
	add_child(ignore_trade_off_btn)

	ignore_trade_on_btn = _create_text_btn("IgnoreTradeOn", "ON", Vector2(396, 272), Vector2(34, 27), 22)
	ignore_trade_on_btn.pressed.connect(func() -> void: _set_ignore_trades(true))
	add_child(ignore_trade_on_btn)

	# --- 7. IGNORE PMS (OptionMenu.as:159-165) ---
	ignore_pms_off_btn = _create_text_btn("IgnorePMsOff", "OFF", Vector2(309, 299), Vector2(38, 30), 22)
	ignore_pms_off_btn.pressed.connect(func() -> void: _set_ignore_pms(false))
	add_child(ignore_pms_off_btn)

	ignore_pms_on_btn = _create_text_btn("IgnorePMsOn", "ON", Vector2(395, 299), Vector2(34, 27), 22)
	ignore_pms_on_btn.pressed.connect(func() -> void: _set_ignore_pms(true))
	add_child(ignore_pms_on_btn)

	# --- 8. CONTROLLER (OptionMenu.as:166-172) ---
	controller_off_btn = _create_text_btn("ControllerOff", "OFF", Vector2(309, 334), Vector2(38, 30), 22)
	controller_off_btn.pressed.connect(func() -> void: _set_controller_on(false))
	add_child(controller_off_btn)

	controller_on_btn = _create_text_btn("ControllerOn", "ON", Vector2(396, 334), Vector2(34, 27), 22)
	controller_on_btn.pressed.connect(func() -> void: _set_controller_on(true))
	add_child(controller_on_btn)

	# --- 9. CONTROLLER INFO & BUTTONS TEXT (OptionMenu.as:190-197) ---
	var stats_font: Font = atlas_loader.get_bitmap_font("stats_font.fnt")
	controller_txt = Label.new()
	controller_txt.name = "ControllerTxt"
	controller_txt.position = Vector2(78, 373)
	controller_txt.size = Vector2(364, 20)
	controller_txt.text = "not found"
	controller_txt.add_theme_font_override("font", stats_font)
	controller_txt.add_theme_font_size_override("font_size", 14)
	controller_txt.add_theme_color_override("font_color", COLOR_OFF)
	add_child(controller_txt)

	buttons_txt = Label.new()
	buttons_txt.name = "ButtonsTxt"
	buttons_txt.position = Vector2(170, 402)
	buttons_txt.size = Vector2(265, 19)
	buttons_txt.text = ""
	buttons_txt.add_theme_font_override("font", stats_font)
	buttons_txt.add_theme_font_size_override("font_size", 14)
	buttons_txt.add_theme_color_override("font_color", COLOR_OFF)
	add_child(buttons_txt)


func _create_text_btn(node_name: String, label_text: String, pos: Vector2, btn_size: Vector2, font_sz: int) -> Button:
	var btn: Button = Button.new()
	btn.name = node_name
	btn.text = label_text
	btn.flat = true
	btn.position = pos
	btn.size = btn_size
	btn.focus_mode = Control.FOCUS_NONE
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	btn.add_theme_font_override("font", _get_atlas_loader().get_bitmap_font("stats_font.fnt"))
	btn.add_theme_font_size_override("font_size", font_sz)
	var empty_sb: StyleBoxEmpty = StyleBoxEmpty.new()
	btn.add_theme_stylebox_override("normal", empty_sb)
	btn.add_theme_stylebox_override("hover", empty_sb)
	btn.add_theme_stylebox_override("pressed", empty_sb)
	btn.add_theme_stylebox_override("focus", empty_sb)
	btn.add_theme_stylebox_override("disabled", empty_sb)
	_apply_text_btn_color(btn, COLOR_OFF)
	return btn


func _apply_text_btn_color(btn: Button, color: Color) -> void:
	if btn == null:
		return
	btn.add_theme_color_override("font_color", color)
	btn.add_theme_color_override("font_hover_color", color)
	btn.add_theme_color_override("font_pressed_color", color)
	btn.add_theme_color_override("font_focus_color", color)


func _update_ui_state() -> void:
	var audio_mgr: Node = _get_audio_manager()
	var m_vol: float = 0.2 if audio_mgr == null else clampf(float(audio_mgr.music_volume), 0.0, 1.0)
	var s_vol: float = 0.2 if audio_mgr == null else clampf(float(audio_mgr.sfx_volume), 0.0, 1.0)
	if audio_mgr != null and bool(audio_mgr.music_muted):
		m_vol = 0.0
	if audio_mgr != null and bool(audio_mgr.sfx_muted):
		s_vol = 0.0

	if music_slider != null:
		music_slider.set_value_no_signal(m_vol)
	if music_pct_label != null:
		music_pct_label.text = "%d%%" % int(round(m_vol * 100.0))

	if sfx_slider != null:
		sfx_slider.set_value_no_signal(s_vol)
	if sfx_pct_label != null:
		sfx_pct_label.text = "%d%%" % int(round(s_vol * 100.0))

	var is_fullscreen: bool = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	_apply_text_btn_color(fullscreen_on_btn, COLOR_ON if is_fullscreen else COLOR_OFF)
	_apply_text_btn_color(fullscreen_off_btn, COLOR_OFF if is_fullscreen else COLOR_ON)

	_apply_text_btn_color(quality_low_btn, COLOR_ON if current_quality == "LOW" else COLOR_OFF)
	_apply_text_btn_color(quality_med_btn, COLOR_ON if current_quality == "MEDIUM" else COLOR_OFF)
	_apply_text_btn_color(quality_high_btn, COLOR_ON if current_quality == "HIGH" else COLOR_OFF)

	_apply_text_btn_color(ignore_trade_on_btn, COLOR_ON if ignore_trades else COLOR_OFF)
	_apply_text_btn_color(ignore_trade_off_btn, COLOR_OFF if ignore_trades else COLOR_ON)

	_apply_text_btn_color(ignore_pms_on_btn, COLOR_ON if ignore_pms else COLOR_OFF)
	_apply_text_btn_color(ignore_pms_off_btn, COLOR_OFF if ignore_pms else COLOR_ON)

	_apply_text_btn_color(controller_on_btn, COLOR_ON if controller_on else COLOR_OFF)
	_apply_text_btn_color(controller_off_btn, COLOR_OFF if controller_on else COLOR_ON)

	if define_buttons_btn != null:
		define_buttons_btn.visible = (controller_txt != null and controller_txt.text != "not found")


func _on_music_volume_changed(val: float) -> void:
	var audio_mgr: Node = _get_audio_manager()
	var clamped: float = clampf(val, 0.0, 1.0)
	if audio_mgr != null:
		if audio_mgr.has_method("set_music_volume"):
			audio_mgr.call("set_music_volume", clamped)
		else:
			audio_mgr.music_volume = clamped
	if music_pct_label != null:
		music_pct_label.text = "%d%%" % int(round(clamped * 100.0))


func _on_sfx_volume_changed(val: float) -> void:
	var audio_mgr: Node = _get_audio_manager()
	var clamped: float = clampf(val, 0.0, 1.0)
	if audio_mgr != null:
		if audio_mgr.has_method("set_sfx_volume"):
			audio_mgr.call("set_sfx_volume", clamped)
		else:
			audio_mgr.sfx_volume = clamped
	if sfx_pct_label != null:
		sfx_pct_label.text = "%d%%" % int(round(clamped * 100.0))


func _set_fullscreen(enabled: bool) -> void:
	if enabled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	_update_ui_state()


func _set_quality(q: String) -> void:
	current_quality = q
	match q:
		"LOW":
			get_viewport().scaling_3d_scale = 0.75
		"MEDIUM":
			get_viewport().scaling_3d_scale = 1.0
		"HIGH":
			get_viewport().scaling_3d_scale = 1.0
	_update_ui_state()


func _set_ignore_trades(enabled: bool) -> void:
	ignore_trades = enabled
	_update_ui_state()


func _set_ignore_pms(enabled: bool) -> void:
	ignore_pms = enabled
	_update_ui_state()


func _set_controller_on(enabled: bool) -> void:
	controller_on = enabled
	_update_ui_state()


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


static func _get_audio_manager() -> Node:
	if Engine.has_singleton("AudioManager"):
		return Engine.get_singleton("AudioManager")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("AudioManager"):
		return tree.root.get_node("AudioManager")
	return null
