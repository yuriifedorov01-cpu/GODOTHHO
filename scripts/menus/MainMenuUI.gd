extends Control
class_name MainMenuUI
## MainMenuUI — Главное меню (порт MainMenu.as:9-176, GameMain.as:1134-1251, 14205-14252):
## Анимированное небо и облака, логотип/арт Helmet Heroes, панель входа, Remember Me,
## выбор сервера, восстановление пароля, настройки, титры, обновления,
## переход к созданию персонажа (Sign Up) и вход в локальную песочницу (Offline Sandbox).

signal login_requested(username: String, password: String)
signal recover_requested(username_or_email: String)
signal offline_sandbox_requested()
signal offline_sandbox_continue_requested(saved_char: Dictionary)
signal character_create_requested()
signal enter_game_requested(user_data: Dictionary)
signal server_selected(server_name: String)

const REMEMBER_ME_PATH: String = "user://remember_me.cfg"
const CLIENT_VERSION: String = "9.50"

var available_servers: Array[String] = [
	"Pve Server",
	"Pve Server 2",
	"Pve Server 3",
	"PvP Server"
]
var selected_server: String = "Pve Server"
var total_game_players: int = 0

@onready var bg_texture_rect: TextureRect = $Background
@onready var cloud1_rect: TextureRect = $CloudsLayer/Cloud1
@onready var cloud2_rect: TextureRect = $CloudsLayer/Cloud2
@onready var ground_art_rect: TextureRect = $GroundArt
@onready var fighter_art_rect: TextureRect = $HeroArtLayer/FighterArt
@onready var sword_art_rect: TextureRect = $HeroArtLayer/SwordArt
@onready var helmet_icon_rect: TextureRect = $HeroArtLayer/HelmetIcon
@onready var title_label: Label = $Title
@onready var subtitle_label: Label = $SubtitleLabel
@onready var online_label: Label = $OnlineLabel
@onready var version_label: Label = $VersionLabel
@onready var version_btn: Button = $VersionButton
@onready var status_label: Label = $StatusLabel

# Panels
@onready var login_panel: PanelContainer = $Panels/LoginPanel
@onready var register_panel: PanelContainer = $Panels/RegisterPanel
@onready var recover_panel: PanelContainer = $Panels/RecoverPanel
@onready var servers_panel: PanelContainer = $Panels/ServersPanel
@onready var options_panel: PanelContainer = $Panels/OptionsPanel
@onready var credits_panel: PanelContainer = $Panels/CreditsPanel
@onready var updates_panel: PanelContainer = $Panels/UpdatesPanel

# Login fields
@onready var login_user_input: LineEdit = $Panels/LoginPanel/VBox/UserField/LineEdit
@onready var login_pass_input: LineEdit = $Panels/LoginPanel/VBox/PassField/LineEdit
@onready var remember_checkbox: CheckBox = $Panels/LoginPanel/VBox/RememberCheckBox
@onready var login_btn: Button = $Panels/LoginPanel/VBox/Buttons/LoginButton
@onready var to_register_btn: Button = $Panels/LoginPanel/VBox/Buttons/ToRegisterButton
@onready var to_recover_btn: Button = $Panels/LoginPanel/VBox/SubButtons/ForgotButton
@onready var to_servers_btn: Button = $Panels/LoginPanel/VBox/SubButtons/ServersButton
@onready var to_options_btn: Button = $Panels/LoginPanel/VBox/SubButtons/OptionsButton
@onready var to_credits_btn: Button = $Panels/LoginPanel/VBox/SubButtons/CreditsButton
@onready var selected_server_label: Label = $Panels/LoginPanel/VBox/SelectedServerLabel
@onready var offline_btn: Button = $Panels/LoginPanel/VBox/OfflineSandboxButton

# Register panel fields
@onready var reg_proceed_btn: Button = $Panels/RegisterPanel/VBox/ProceedButton
@onready var reg_back_btn: Button = $Panels/RegisterPanel/VBox/BackButton

# Recover fields
@onready var rec_input: LineEdit = $Panels/RecoverPanel/VBox/Field/LineEdit
@onready var rec_submit_btn: Button = $Panels/RecoverPanel/VBox/Buttons/SubmitButton
@onready var rec_back_btn: Button = $Panels/RecoverPanel/VBox/Buttons/BackButton

# Servers fields
@onready var server1_btn: Button = $Panels/ServersPanel/VBox/Server1Button
@onready var server2_btn: Button = $Panels/ServersPanel/VBox/Server2Button
@onready var server3_btn: Button = $Panels/ServersPanel/VBox/Server3Button
@onready var server_pvp_btn: Button = $Panels/ServersPanel/VBox/ServerPVPButton
@onready var servers_back_btn: Button = $Panels/ServersPanel/VBox/BackButton

# Options fields
@onready var fullscreen_btn: Button = $Panels/OptionsPanel/VBox/FullscreenButton
@onready var sound_value_label: Label = $Panels/OptionsPanel/VBox/SoundVolumeRow/SoundLabel
@onready var sound_slider: HSlider = $Panels/OptionsPanel/VBox/SoundVolumeRow/SoundSlider
@onready var music_value_label: Label = $Panels/OptionsPanel/VBox/MusicVolumeRow/MusicLabel
@onready var music_slider: HSlider = $Panels/OptionsPanel/VBox/MusicVolumeRow/MusicSlider
@onready var options_back_btn: Button = $Panels/OptionsPanel/VBox/BackButton

# Credits & Updates fields
@onready var credits_back_btn: Button = $Panels/CreditsPanel/VBox/BackButton
@onready var updates_back_btn: Button = $Panels/UpdatesPanel/VBox/BackButton

var _is_connecting: bool = false
var sandbox_continue_overlay: ColorRect = null
var sandbox_continue_summary_label: Label = null
var sandbox_continue_yes_btn: Button = null
var sandbox_continue_no_btn: Button = null
var _pending_sandbox_save: Dictionary = {}


func _get_atlas_loader() -> Node:
	if has_node("/root/StarlingAtlasLoader"):
		return get_node("/root/StarlingAtlasLoader")
	return null


func _get_pio_client() -> Node:
	if has_node("/root/PlayerIOClient"):
		return get_node("/root/PlayerIOClient")
	return null


func get_selected_server() -> String:
	return selected_server


func set_selected_server(server_name: String) -> void:
	selected_server = server_name
	if selected_server_label:
		selected_server_label.text = "Server: %s" % selected_server
	server_selected.emit(selected_server)


func _ready() -> void:
	_init_textures_and_fonts()
	_init_version_and_online()
	_load_remember_me()
	_connect_signals()
	_sync_audio_sliders()
	_play_intro_animations()
	_play_main_menu_music()
	show_panel("login")


func _play_main_menu_music() -> void:
	var am: Node = get_node_or_null("/root/AudioManager")
	if am == null and Engine.has_singleton("AudioManager"):
		am = Engine.get_singleton("AudioManager")
	if am != null and am.has_method("play_music"):
		am.call("play_music", "main menu music")


func _process(delta: float) -> void:
	# MainMenu.as:196-208 — cloud1.x += 1, cloud2.x += 0.5 per frame (~60fps), wrap at > 1100 to -500
	var frame_scale: float = delta * 60.0
	if cloud1_rect:
		cloud1_rect.position.x += 1.0 * frame_scale
		if cloud1_rect.position.x > 1100.0:
			cloud1_rect.position.x = -500.0
	if cloud2_rect:
		cloud2_rect.position.x += 0.5 * frame_scale
		if cloud2_rect.position.x > 1100.0:
			cloud2_rect.position.x = -500.0


func _init_textures_and_fonts() -> void:
	var loader: Node = _get_atlas_loader()
	if not loader:
		return

	loader.register_starling_atlas("backgrounds1", "res://assets/client_data/dynamic_content/backgrounds/")
	loader.register_starling_atlas("items_pets_bodies")

	if bg_texture_rect:
		var sky_tex: Texture2D = loader.get_texture("sky", "backgrounds1")
		if sky_tex:
			bg_texture_rect.texture = sky_tex

	if ground_art_rect:
		var bg1_tex: Texture2D = loader.get_texture("background 1", "backgrounds1")
		if bg1_tex:
			ground_art_rect.texture = bg1_tex

	var cloud_tex: Texture2D = loader.get_texture("cloud", "backgrounds1")
	if cloud_tex:
		if cloud1_rect:
			cloud1_rect.texture = cloud_tex
			cloud1_rect.position = Vector2(-600.0 + randf() * 700.0, randf() * 150.0)
		if cloud2_rect:
			cloud2_rect.texture = cloud_tex
			cloud2_rect.position = Vector2(-600.0 + randf() * 700.0, randf() * 150.0)

	if helmet_icon_rect:
		var helm_tex: Texture2D = loader.get_texture("steel helm", "items_pets_bodies")
		if helm_tex == null:
			helm_tex = loader.get_texture("bronze helm", "items_pets_bodies")
		if helm_tex:
			helmet_icon_rect.texture = helm_tex
			helmet_icon_rect.visible = true
	if sword_art_rect:
		var sword_tex: Texture2D = loader.get_texture("beholder sword", "items_pets_bodies")
		if sword_tex:
			sword_art_rect.texture = sword_tex
			sword_art_rect.visible = true
	if fighter_art_rect:
		var main_art_path := "res://assets/extracted/main_menu/DefineSprite_1594_com.menus.MainMenu/1.png"
		if ResourceLoader.exists(main_art_path):
			fighter_art_rect.texture = load(main_art_path)
			fighter_art_rect.visible = true

	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.11, 0.28, 0.08, 0.92)
	panel_style.border_color = Color(0.75, 0.60, 0.22, 1.0)
	panel_style.set_border_width_all(3)
	panel_style.set_corner_radius_all(8)
	panel_style.set_content_margin_all(12)
	for p in [login_panel, register_panel, servers_panel, recover_panel, options_panel, credits_panel, updates_panel]:
		if p:
			p.add_theme_stylebox_override("panel", panel_style)

	var stats_font: Font = loader.get_bitmap_font("stats_font.fnt")
	var readable_font: Font = loader.get_bitmap_font("readable_font.fnt")
	var ui_font: Font = readable_font if readable_font != null else stats_font
	if stats_font:
		if title_label:
			title_label.add_theme_font_override("font", stats_font)
		if version_label:
			version_label.add_theme_font_override("font", stats_font)
		if online_label:
			online_label.add_theme_font_override("font", stats_font)
	if ui_font:
		_apply_font_to_labels(ui_font)


func _apply_font_to_labels(font: Font) -> void:
	var labels: Array[Control] = [
		subtitle_label,
		status_label,
		remember_checkbox,
		selected_server_label,
		$Panels/LoginPanel/VBox/Header as Label,
		$Panels/LoginPanel/VBox/UserField/Label as Label,
		$Panels/LoginPanel/VBox/PassField/Label as Label,
		$Panels/RegisterPanel/VBox/Header as Label,
		$Panels/RecoverPanel/VBox/Header as Label,
		$Panels/RecoverPanel/VBox/Field/Label as Label,
		$Panels/ServersPanel/VBox/Header as Label,
		$Panels/OptionsPanel/VBox/Header as Label,
		$Panels/CreditsPanel/VBox/Header as Label,
		$Panels/UpdatesPanel/VBox/Header as Label,
	]
	for ctrl in labels:
		if ctrl:
			ctrl.add_theme_font_override("font", font)


func _init_version_and_online() -> void:
	if version_label:
		version_label.text = CLIENT_VERSION
	if version_btn:
		version_btn.text = "v%s Updates" % CLIENT_VERSION
	if online_label:
		online_label.text = "Players Online: %d" % total_game_players
	if selected_server_label:
		selected_server_label.text = "Server: %s" % selected_server


func _play_intro_animations() -> void:
	# GameMain.as:14205-14252 — легкие входные анимации заголовка и иконок
	if DisplayServer.get_name() == "headless":
		return
	if title_label:
		title_label.pivot_offset = title_label.size * 0.5
		title_label.scale = Vector2(2.0, 2.0)
		var tw: Tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tw.tween_property(title_label, "scale", Vector2.ONE, 0.55)
	if helmet_icon_rect:
		helmet_icon_rect.pivot_offset = helmet_icon_rect.size * 0.5
		helmet_icon_rect.scale = Vector2(0.1, 0.1)
		var tw_h: Tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tw_h.tween_interval(0.35)
		tw_h.tween_property(helmet_icon_rect, "scale", Vector2.ONE, 0.45)


func _load_remember_me() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(REMEMBER_ME_PATH) != OK:
		return
	var saved_user: String = str(cfg.get_value("auth", "username", ""))
	var saved_pass: String = str(cfg.get_value("auth", "password", ""))
	if not saved_user.is_empty() and not saved_pass.is_empty():
		if remember_checkbox:
			remember_checkbox.button_pressed = true
		if login_user_input:
			login_user_input.text = saved_user
		if login_pass_input:
			login_pass_input.text = saved_pass


func _save_or_clear_remember_me(username: String, password: String) -> void:
	if remember_checkbox and remember_checkbox.button_pressed:
		var cfg := ConfigFile.new()
		cfg.set_value("auth", "username", username)
		cfg.set_value("auth", "password", password)
		cfg.save(REMEMBER_ME_PATH)
	elif FileAccess.file_exists(REMEMBER_ME_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REMEMBER_ME_PATH))


func _connect_signals() -> void:
	if login_btn:
		login_btn.pressed.connect(_on_login_pressed)
	if to_register_btn:
		to_register_btn.pressed.connect(_on_sign_up_pressed)
	if to_recover_btn:
		to_recover_btn.pressed.connect(func() -> void: show_panel("recover"))
	if to_servers_btn:
		to_servers_btn.pressed.connect(func() -> void: show_panel("servers"))
	if to_options_btn:
		to_options_btn.pressed.connect(func() -> void: show_panel("options"))
	if to_credits_btn:
		to_credits_btn.pressed.connect(func() -> void: show_panel("credits"))
	if version_btn:
		version_btn.pressed.connect(func() -> void: show_panel("updates"))
	if offline_btn:
		offline_btn.pressed.connect(_on_offline_pressed)

	if reg_proceed_btn:
		reg_proceed_btn.pressed.connect(_on_sign_up_pressed)
	if reg_back_btn:
		reg_back_btn.pressed.connect(func() -> void: show_panel("login"))

	if rec_submit_btn:
		rec_submit_btn.pressed.connect(_on_recover_pressed)
	if rec_back_btn:
		rec_back_btn.pressed.connect(func() -> void: show_panel("login"))

	if server1_btn:
		server1_btn.pressed.connect(func() -> void: _choose_server("Pve Server"))
	if server2_btn:
		server2_btn.pressed.connect(func() -> void: _choose_server("Pve Server 2"))
	if server3_btn:
		server3_btn.pressed.connect(func() -> void: _choose_server("Pve Server 3"))
	if server_pvp_btn:
		server_pvp_btn.pressed.connect(func() -> void: _choose_server("PvP Server"))
	if servers_back_btn:
		servers_back_btn.pressed.connect(func() -> void: show_panel("login"))

	if fullscreen_btn:
		fullscreen_btn.pressed.connect(_on_toggle_fullscreen)
	if sound_slider:
		sound_slider.value_changed.connect(_on_sound_volume_changed)
	if music_slider:
		music_slider.value_changed.connect(_on_music_volume_changed)
	if options_back_btn:
		options_back_btn.pressed.connect(func() -> void: show_panel("login"))

	if credits_back_btn:
		credits_back_btn.pressed.connect(func() -> void: show_panel("login"))
	if updates_back_btn:
		updates_back_btn.pressed.connect(func() -> void: show_panel("login"))


func _choose_server(srv_name: String) -> void:
	set_selected_server(srv_name)
	show_panel("login")


func _on_toggle_fullscreen() -> void:
	var mode: int = DisplayServer.window_get_mode()
	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _sync_audio_sliders() -> void:
	var am: Node = get_node_or_null("/root/AudioManager")
	if am == null and Engine.has_singleton("AudioManager"):
		am = Engine.get_singleton("AudioManager")
	var s_vol: float = float(am.get("sfx_volume")) if am != null and am.get("sfx_volume") != null else 0.2
	var m_vol: float = float(am.get("music_volume")) if am != null and am.get("music_volume") != null else 0.2
	if sound_slider:
		sound_slider.set_value_no_signal(clampf(s_vol, 0.0, 1.0))
	if music_slider:
		music_slider.set_value_no_signal(clampf(m_vol, 0.0, 1.0))
	if sound_value_label:
		sound_value_label.text = "Sound Volume: %d%%" % roundi(clampf(s_vol, 0.0, 1.0) * 100.0)
	if music_value_label:
		music_value_label.text = "Music Volume: %d%%" % roundi(clampf(m_vol, 0.0, 1.0) * 100.0)


func _on_sound_volume_changed(value: float) -> void:
	var clamped: float = clampf(value, 0.0, 1.0)
	if sound_value_label:
		sound_value_label.text = "Sound Volume: %d%%" % roundi(clamped * 100.0)
	var am: Node = get_node_or_null("/root/AudioManager")
	if am == null and Engine.has_singleton("AudioManager"):
		am = Engine.get_singleton("AudioManager")
	if am != null:
		am.set("sfx_volume", clamped)


func _on_music_volume_changed(value: float) -> void:
	var clamped: float = clampf(value, 0.0, 1.0)
	if music_value_label:
		music_value_label.text = "Music Volume: %d%%" % roundi(clamped * 100.0)
	var am: Node = get_node_or_null("/root/AudioManager")
	if am == null and Engine.has_singleton("AudioManager"):
		am = Engine.get_singleton("AudioManager")
	if am != null:
		am.set("music_volume", clamped)


func show_panel(panel_name: String) -> void:
	if login_panel:
		login_panel.visible = (panel_name == "login")
	if register_panel:
		register_panel.visible = (panel_name == "register")
	if recover_panel:
		recover_panel.visible = (panel_name == "recover")
	if servers_panel:
		servers_panel.visible = (panel_name == "servers")
	if options_panel:
		options_panel.visible = (panel_name == "options")
		if options_panel.visible:
			_sync_audio_sliders()
	if credits_panel:
		credits_panel.visible = (panel_name == "credits")
	if updates_panel:
		updates_panel.visible = (panel_name == "updates")
	if not _is_connecting:
		set_status("")


func set_status(msg: String, is_error: bool = false) -> void:
	if status_label:
		status_label.text = msg
		status_label.visible = not msg.is_empty()
		status_label.modulate = Color.RED if is_error else Color.YELLOW


func _on_sign_up_pressed() -> void:
	# GameMain.as:1145-1148 — signUp_btn переводит сразу в CreateCharacterMenu
	character_create_requested.emit()


func _on_login_pressed() -> void:
	var user: String = login_user_input.text.strip_edges() if login_user_input else ""
	var pass_str: String = login_pass_input.text.strip_edges() if login_pass_input else ""

	if user.is_empty():
		set_status("Please enter a username.", true)
		return

	_is_connecting = true
	set_status("Connecting to %s..." % selected_server)
	login_requested.emit(user, pass_str)

	var pio: Node = _get_pio_client()
	if not pio:
		_is_connecting = false
		return

	var res: Dictionary = await pio.simple_connect(user, pass_str)
	if res.get("success", false):
		_save_or_clear_remember_me(user, pass_str)
		set_status("Connected! Loading player data...")
		var po: Dictionary = await pio.load_my_player_object()
		_is_connecting = false
		if po.is_empty() or not po.has("stage") or int(po.get("stage", 0)) <= 0:
			character_create_requested.emit()
		else:
			enter_game_requested.emit(po)
	else:
		_is_connecting = false
		var err_msg: String = str(res.get("error_message", "Login failed. Check credentials."))
		set_status(err_msg, true)


func _on_recover_pressed() -> void:
	var target: String = rec_input.text.strip_edges() if rec_input else ""
	if target.is_empty():
		set_status("Please enter username or email.", true)
		return

	_is_connecting = true
	set_status("Sending recovery request...")
	recover_requested.emit(target)

	var pio: Node = _get_pio_client()
	if not pio:
		_is_connecting = false
		return

	var res: Dictionary = await pio.simple_recover_password(target)
	_is_connecting = false
	if res.get("success", false):
		set_status("Password recovery instructions sent!")
	else:
		set_status(str(res.get("error_message", "Recovery failed.")), true)


func _on_offline_pressed() -> void:
	if GameFlow.has_last_sandbox_character():
		var saved_char: Dictionary = GameFlow.load_last_sandbox_character()
		if not saved_char.is_empty():
			_show_sandbox_continue_dialog(saved_char)
			return

	_proceed_new_sandbox_character()


func _proceed_new_sandbox_character() -> void:
	var user: String = login_user_input.text.strip_edges() if login_user_input else ""
	if user.is_empty():
		user = "Hero"

	_is_connecting = true
	set_status("Opening Sandbox Character Creator...")

	var pio: Node = _get_pio_client()
	if pio:
		pio.login_offline_sandbox(user)

	_is_connecting = false
	offline_sandbox_requested.emit()


func _ensure_sandbox_continue_dialog() -> void:
	if sandbox_continue_overlay != null and is_instance_valid(sandbox_continue_overlay):
		return

	sandbox_continue_overlay = ColorRect.new()
	sandbox_continue_overlay.name = "SandboxContinueDialog"
	sandbox_continue_overlay.color = Color(0.0, 0.0, 0.0, 0.58)
	sandbox_continue_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	sandbox_continue_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	sandbox_continue_overlay.z_index = 60
	sandbox_continue_overlay.visible = false
	add_child(sandbox_continue_overlay)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	sandbox_continue_overlay.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(460, 210)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.14, 0.16, 0.22, 0.96)
	style.border_color = Color(0.86, 0.72, 0.34, 1.0)
	style.set_border_width_all(3)
	style.set_corner_radius_all(10)
	style.set_content_margin_all(20)
	panel.add_theme_stylebox_override("panel", style)
	center.add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	panel.add_child(vbox)

	var title := Label.new()
	title.name = "QuestionLabel"
	title.text = "Хотите ли вы продолжить играть на последнем персонаже?"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(1.0, 0.94, 0.76))
	vbox.add_child(title)

	sandbox_continue_summary_label = Label.new()
	sandbox_continue_summary_label.name = "SummaryLabel"
	sandbox_continue_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sandbox_continue_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	sandbox_continue_summary_label.add_theme_font_size_override("font_size", 14)
	sandbox_continue_summary_label.add_theme_color_override("font_color", Color(0.85, 0.9, 0.96))
	vbox.add_child(sandbox_continue_summary_label)

	var hbox := HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 24)
	vbox.add_child(hbox)

	sandbox_continue_yes_btn = Button.new()
	sandbox_continue_yes_btn.name = "YesButton"
	sandbox_continue_yes_btn.text = "Да"
	sandbox_continue_yes_btn.custom_minimum_size = Vector2(140, 40)
	sandbox_continue_yes_btn.focus_mode = Control.FOCUS_NONE
	sandbox_continue_yes_btn.pressed.connect(_on_sandbox_continue_yes)
	hbox.add_child(sandbox_continue_yes_btn)

	sandbox_continue_no_btn = Button.new()
	sandbox_continue_no_btn.name = "NoButton"
	sandbox_continue_no_btn.text = "Нет"
	sandbox_continue_no_btn.custom_minimum_size = Vector2(140, 40)
	sandbox_continue_no_btn.focus_mode = Control.FOCUS_NONE
	sandbox_continue_no_btn.pressed.connect(_on_sandbox_continue_no)
	hbox.add_child(sandbox_continue_no_btn)


func _show_sandbox_continue_dialog(saved_char: Dictionary) -> void:
	_pending_sandbox_save = saved_char.duplicate(true)
	_ensure_sandbox_continue_dialog()
	var pname: String = str(saved_char.get("username", saved_char.get("name", "Hero")))
	var pclass: String = str(saved_char.get("classType", saved_char.get("character_class", "warrior"))).capitalize()
	var plvl: int = int(saved_char.get("level", 1))
	var pstage: int = int(saved_char.get("stage", 1))
	if sandbox_continue_summary_label != null:
		sandbox_continue_summary_label.text = "%s (%s, ур. %d, зона %d)" % [pname, pclass, plvl, pstage]
	if sandbox_continue_overlay != null:
		sandbox_continue_overlay.visible = true


func _on_sandbox_continue_yes() -> void:
	if sandbox_continue_overlay != null:
		sandbox_continue_overlay.visible = false
	var saved_copy: Dictionary = _pending_sandbox_save.duplicate(true)
	if saved_copy.is_empty():
		saved_copy = GameFlow.load_last_sandbox_character()
	_pending_sandbox_save.clear()
	if saved_copy.is_empty():
		_proceed_new_sandbox_character()
		return

	var uname: String = str(saved_copy.get("username", saved_copy.get("name", "Hero"))).strip_edges()
	if uname.is_empty():
		uname = "Hero"
	set_status("Loading last sandbox character...")
	var pio: Node = _get_pio_client()
	if pio:
		pio.login_offline_sandbox(uname)
	offline_sandbox_continue_requested.emit(saved_copy)


func _on_sandbox_continue_no() -> void:
	if sandbox_continue_overlay != null:
		sandbox_continue_overlay.visible = false
	_pending_sandbox_save.clear()
	_proceed_new_sandbox_character()
