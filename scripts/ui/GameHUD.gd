extends CanvasLayer
class_name GameHUD
## GameHUD — Главный игровой HUD Helmet Heroes (порт com.ui.Controls.as).
## Содержит:
## 1. Верхний левый угол (Controls.as:179-240, 299-331, 546-592):
##    - Версия клиента (version_txt "9.50").
##    - Полоска здоровья (health BG + health bar, hpColon_txt, health_txt).
##    - Полоска маны (MP BG + MP bar, mpColon_txt, mp_txt; скрывается при max_mp == 0).
##    - Полоска опыта (XP BG + XP bar, level_txt, xp_txt).
##    - Счетчик монет (coin + money_txt).
## 2. Верхнее меню (Controls.as:421-515, 2 ряда при ширине 950):
##    - Ряд 1: pets, missions, character, social, items, map.
##    - Ряд 2: heropedia, payvault, options.
## 3. Нижняя часть (Controls.as:216, 241-244, 332-345):
##    - Панель чата (текстура "chat" 929x117 в (11, 577), chat_log 908x88 в (20, 579), chat_input 906x20 в (20, 667)).
## 4. Менеджер модальных/перетаскиваемых окон меню:
##    - CharacterMenu, ItemMenu, SkillsMenu, MapMenu, MissionMenu, TalkBox, FriendsMenu, PetMenu, OptionsMenu.
## 5. Горячая клавиша: 'K' переключает окно SkillsMenu (как в оригинальном Flash Helmet Heroes).

signal chat_message_submitted(text: String)

var local_player: PersonEntity = null

# Визуальные элементы верхнего левого HUD (Controls.as)
var version_label: Label = null
var hp_bg: TextureRect = null
var hp_bar: TextureProgressBar = null
var hp_colon_label: Label = null
var hp_label: Label = null
var mp_bg: TextureRect = null
var mp_bar: TextureProgressBar = null
var mp_colon_label: Label = null
var mp_label: Label = null
var xp_bg: TextureRect = null
var xp_bar: TextureProgressBar = null
var level_label: Label = null
var xp_label: Label = null
var coin_icon: TextureRect = null
var coins_label: Label = null
const AdminMenuScript = preload("res://scripts/ui/AdminMenu.gd")
const BugReportMenuScript = preload("res://scripts/ui/BugReportMenu.gd")

var sandbox_return_btn: Button = null
var sandbox_admin_btn: Button = null
var bug_report_btn: Button = null
var fix_log_btn: Button = null
var admin_menu: Control = null
var bug_report_menu: Control = null
var fix_log_menu: Control = null

# Кнопки верхнего меню (Controls.as:203-211, 428-482)
var pets_btn: TextureButton = null
var missions_btn: TextureButton = null
var character_btn: TextureButton = null
var social_btn: TextureButton = null
var items_btn: TextureButton = null
var map_btn: TextureButton = null
var heropedia_btn: TextureButton = null
var payvault_btn: TextureButton = null
var options_btn: TextureButton = null

# Алиасы для совместимости с внешними вызовами и тестами
var btn_pets: TextureButton = null
var btn_missions: TextureButton = null
var btn_char: TextureButton = null
var btn_social: TextureButton = null
var btn_skills: TextureButton = null
var btn_items: TextureButton = null
var btn_map: TextureButton = null
var btn_options: TextureButton = null

# Панель чата (Controls.as:216, 241-244, 332-345)
var chat_bg: TextureRect = null
var chat_log: RichTextLabel = null
var chat_log_history: Array[String] = []
var chat_input: LineEdit = null

# Инстансы окон меню
var character_menu: Control = null
var item_menu: Control = null
var skills_menu: Control = null
var map_menu: Control = null
var mission_menu: Control = null
var talk_box: Control = null
var shop_menu: Control = null
var pet_shop_menu: Control = null
var friends_menu: Control = null
var pet_menu: Control = null
var options_menu: Control = null
var heropedia_menu: Control = null
var payvault_menu: Control = null
var bank_menu: Control = null

var menus_container: Control = null
var blink_heropedia_button: bool = false
var _heropedia_blink_timer: float = 0.0

func _ready() -> void:
	layer = 10 # Поверх игрового мира
	_build_hud_elements()
	_create_menus()
	if local_player != null:
		bind_player(local_player)


func _process(delta: float) -> void:
	if heropedia_btn == null:
		return
	if blink_heropedia_button:
		_heropedia_blink_timer += delta
		# GameMain.as:11045: counter % 13 == 0 at 30fps (~0.43s) -> scale 1.1
		var phase: bool = fmod(_heropedia_blink_timer, 0.86) < 0.43
		heropedia_btn.scale = Vector2(1.1, 1.1) if phase else Vector2.ONE
	elif heropedia_btn.scale != Vector2.ONE:
		heropedia_btn.scale = Vector2.ONE
		_heropedia_blink_timer = 0.0


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		# Если игрок печатает в строке чата, не перехватываем символы как хоткеи
		if chat_input != null and chat_input.has_focus():
			return
		if event.keycode == KEY_K:
			toggle_skills_menu()
			get_viewport().set_input_as_handled()


func _build_hud_elements() -> void:
	var root_control: Control = Control.new()
	root_control.name = "RootHUD"
	root_control.anchor_right = 1.0
	root_control.anchor_bottom = 1.0
	root_control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root_control)

	var atlas_loader: Node = _get_atlas_loader()
	atlas_loader.register_starling_atlas("controls")
	var stats_font: Font = atlas_loader.get_bitmap_font("stats_font.fnt")
	var talk_font: Font = atlas_loader.get_bitmap_font("talk_font.fnt")

	# --- 1. ВЕРХНИЙ ЛЕВЫЙ УГОЛ (Controls.as:179-240, 299-331) ---
	var top_left_panel: Control = Control.new()
	top_left_panel.name = "TopLeftPanel"
	top_left_panel.position = Vector2.ZERO
	top_left_panel.size = Vector2(320, 228)
	top_left_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root_control.add_child(top_left_panel)

	# version_txt ("9.50", talk_font size 9, 0xFFFFFF, left) в (5, 4) — Controls.as:184, 195, 326-327
	version_label = Label.new()
	version_label.name = "VersionLabel"
	version_label.text = "9.50"
	version_label.position = Vector2(5, 4)
	version_label.size = Vector2(32, 13)
	version_label.add_theme_font_override("font", talk_font)
	version_label.add_theme_font_size_override("font_size", 9)
	version_label.add_theme_color_override("font_color", Color.WHITE)
	version_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	version_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_left_panel.add_child(version_label)

	# health BG (11, 23) и health bar (24, 28)
	var hp_bg_tex: Texture2D = atlas_loader.get_starling_texture("controls", "health BG")
	var hp_fill_tex: Texture2D = atlas_loader.get_starling_texture("controls", "health bar")

	hp_bg = TextureRect.new()
	hp_bg.name = "HealthBG"
	hp_bg.texture = hp_bg_tex
	hp_bg.position = Vector2(11, 23)
	hp_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_left_panel.add_child(hp_bg)

	hp_bar = TextureProgressBar.new()
	hp_bar.name = "HPBar"
	hp_bar.texture_progress = hp_fill_tex
	hp_bar.min_value = 0
	hp_bar.max_value = 100
	hp_bar.value = 100
	hp_bar.position = Vector2(24, 28)
	hp_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_left_panel.add_child(hp_bar)

	# MP BG (22, 65) и MP bar (32, 68)
	var mp_bg_tex: Texture2D = atlas_loader.get_starling_texture("controls", "MP BG")
	var mp_fill_tex: Texture2D = atlas_loader.get_starling_texture("controls", "MP bar")

	mp_bg = TextureRect.new()
	mp_bg.name = "MPBG"
	mp_bg.texture = mp_bg_tex
	mp_bg.position = Vector2(22, 65)
	mp_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_left_panel.add_child(mp_bg)

	mp_bar = TextureProgressBar.new()
	mp_bar.name = "MPBar"
	mp_bar.texture_progress = mp_fill_tex
	mp_bar.min_value = 0
	mp_bar.max_value = 50
	mp_bar.value = 50
	mp_bar.position = Vector2(32, 68)
	mp_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_left_panel.add_child(mp_bar)

	# XP BG (49, 96) и XP bar (59, 99)
	var xp_bg_tex: Texture2D = atlas_loader.get_starling_texture("controls", "XP BG")
	var xp_fill_tex: Texture2D = atlas_loader.get_starling_texture("controls", "XP bar")

	xp_bg = TextureRect.new()
	xp_bg.name = "XPBG"
	xp_bg.texture = xp_bg_tex
	xp_bg.position = Vector2(49, 96)
	xp_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_left_panel.add_child(xp_bg)

	xp_bar = TextureProgressBar.new()
	xp_bar.name = "XPBar"
	xp_bar.texture_progress = xp_fill_tex
	xp_bar.min_value = 0
	xp_bar.max_value = 51
	xp_bar.value = 0
	xp_bar.position = Vector2(59, 99)
	xp_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_left_panel.add_child(xp_bar)

	# coin (15, 128)
	var coin_tex: Texture2D = atlas_loader.get_starling_texture("controls", "coin")
	coin_icon = TextureRect.new()
	coin_icon.name = "CoinIcon"
	coin_icon.texture = coin_tex
	coin_icon.position = Vector2(15, 128)
	coin_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_left_panel.add_child(coin_icon)

	# Текстовые поля верхнего левого HUD (Controls.as:299-323)
	hp_label = Label.new()
	hp_label.name = "HPLabel"
	hp_label.text = "100 / 100"
	hp_label.position = Vector2(60, 10)
	hp_label.size = Vector2(200, 25)
	hp_label.add_theme_font_override("font", stats_font)
	hp_label.add_theme_font_size_override("font_size", 20)
	hp_label.add_theme_color_override("font_color", Color.WHITE)
	hp_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hp_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_left_panel.add_child(hp_label)

	mp_label = Label.new()
	mp_label.name = "MPLabel"
	mp_label.text = "50 / 50"
	mp_label.position = Vector2(53, 58)
	mp_label.size = Vector2(160, 19)
	mp_label.add_theme_font_override("font", stats_font)
	mp_label.add_theme_font_size_override("font_size", 14)
	mp_label.add_theme_color_override("font_color", Color.WHITE)
	mp_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	mp_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_left_panel.add_child(mp_label)

	xp_label = Label.new()
	xp_label.name = "XPLabel"
	xp_label.text = "0 / 51 (0%)"
	xp_label.position = Vector2(93, 89)
	xp_label.size = Vector2(225, 19)
	xp_label.add_theme_font_override("font", stats_font)
	xp_label.add_theme_font_size_override("font_size", 14)
	xp_label.add_theme_color_override("font_color", Color.WHITE)
	xp_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	xp_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_left_panel.add_child(xp_label)

	coins_label = Label.new()
	coins_label.name = "CoinsLabel"
	coins_label.text = "Money: $100"
	coins_label.position = Vector2(38, 126)
	coins_label.size = Vector2(213, 25)
	coins_label.add_theme_font_override("font", stats_font)
	coins_label.add_theme_font_size_override("font_size", 20)
	coins_label.add_theme_color_override("font_color", Color.WHITE)
	coins_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	coins_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_left_panel.add_child(coins_label)

	sandbox_return_btn = Button.new()
	sandbox_return_btn.name = "SandboxReturnBtn"
	sandbox_return_btn.focus_mode = Control.FOCUS_NONE
	sandbox_return_btn.text = "New Character"
	sandbox_return_btn.position = Vector2(38, 156)
	sandbox_return_btn.size = Vector2(213, 28)
	sandbox_return_btn.add_theme_font_override("font", stats_font)
	sandbox_return_btn.add_theme_font_size_override("font_size", 14)
	sandbox_return_btn.add_theme_color_override("font_color", Color(1.0, 0.94, 0.65, 1.0))
	var sb_norm := StyleBoxFlat.new()
	sb_norm.bg_color = Color(0.11, 0.15, 0.21, 0.88)
	sb_norm.border_color = Color(0.94, 0.77, 0.30, 0.9)
	sb_norm.set_border_width_all(2)
	sb_norm.set_corner_radius_all(4)
	var sb_hover := sb_norm.duplicate() as StyleBoxFlat
	sb_hover.bg_color = Color(0.18, 0.24, 0.33, 0.95)
	sandbox_return_btn.add_theme_stylebox_override("normal", sb_norm)
	sandbox_return_btn.add_theme_stylebox_override("hover", sb_hover)
	sandbox_return_btn.add_theme_stylebox_override("pressed", sb_hover)
	var gf: Node = _find_game_flow()
	sandbox_return_btn.visible = (gf != null and bool(gf.get("is_sandbox_session")))
	sandbox_return_btn.pressed.connect(func() -> void:
		var flow: Node = _find_game_flow()
		if flow != null and flow.has_method("show_create_character"):
			flow.call("show_create_character", null, true)
	)
	top_left_panel.add_child(sandbox_return_btn)

	sandbox_admin_btn = Button.new()
	sandbox_admin_btn.name = "SandboxAdminBtn"
	sandbox_admin_btn.focus_mode = Control.FOCUS_NONE
	sandbox_admin_btn.text = "Admin Menu"
	sandbox_admin_btn.position = Vector2(38, 188)
	sandbox_admin_btn.size = Vector2(213, 28)
	sandbox_admin_btn.add_theme_font_override("font", stats_font)
	sandbox_admin_btn.add_theme_font_size_override("font_size", 14)
	sandbox_admin_btn.add_theme_color_override("font_color", Color(1.0, 0.94, 0.65, 1.0))
	sandbox_admin_btn.add_theme_stylebox_override("normal", sb_norm)
	sandbox_admin_btn.add_theme_stylebox_override("hover", sb_hover)
	sandbox_admin_btn.add_theme_stylebox_override("pressed", sb_hover)
	sandbox_admin_btn.visible = sandbox_return_btn.visible
	sandbox_admin_btn.pressed.connect(func() -> void:
		if admin_menu != null:
			admin_menu.toggle_menu()
	)
	top_left_panel.add_child(sandbox_admin_btn)

	admin_menu = AdminMenuScript.new()
	admin_menu.name = "AdminMenu"
	add_child(admin_menu)

	bug_report_btn = Button.new()
	bug_report_btn.name = "BugReportBtn"
	bug_report_btn.focus_mode = Control.FOCUS_NONE
	bug_report_btn.text = "Bug Report"
	bug_report_btn.position = Vector2(38, 220)
	bug_report_btn.size = Vector2(213, 28)
	bug_report_btn.add_theme_font_override("font", stats_font)
	bug_report_btn.add_theme_font_size_override("font_size", 14)
	bug_report_btn.add_theme_color_override("font_color", Color(1.0, 0.94, 0.65, 1.0))
	bug_report_btn.add_theme_stylebox_override("normal", sb_norm)
	bug_report_btn.add_theme_stylebox_override("hover", sb_hover)
	bug_report_btn.add_theme_stylebox_override("pressed", sb_hover)
	bug_report_btn.visible = true
	bug_report_btn.pressed.connect(func() -> void:
		if bug_report_menu != null:
			bug_report_menu.toggle_menu()
	)
	top_left_panel.add_child(bug_report_btn)

	bug_report_menu = BugReportMenuScript.new()
	bug_report_menu.name = "BugReportMenu"
	add_child(bug_report_menu)

	fix_log_btn = Button.new()
	fix_log_btn.name = "FixLogBtn"
	fix_log_btn.focus_mode = Control.FOCUS_NONE
	fix_log_btn.text = "Fix Log"
	fix_log_btn.position = Vector2(38, 252)
	fix_log_btn.size = Vector2(213, 28)
	fix_log_btn.add_theme_font_override("font", stats_font)
	fix_log_btn.add_theme_font_size_override("font_size", 14)
	fix_log_btn.add_theme_color_override("font_color", Color(1.0, 0.94, 0.65, 1.0))
	fix_log_btn.add_theme_stylebox_override("normal", sb_norm)
	fix_log_btn.add_theme_stylebox_override("hover", sb_hover)
	fix_log_btn.add_theme_stylebox_override("pressed", sb_hover)
	fix_log_btn.visible = true
	fix_log_btn.pressed.connect(func() -> void:
		if fix_log_menu != null:
			fix_log_menu.toggle_menu()
	)
	top_left_panel.add_child(fix_log_btn)

	var fix_log_script: GDScript = load("res://scripts/ui/FixLogMenu.gd")
	fix_log_menu = fix_log_script.new()
	fix_log_menu.name = "FixLogMenu"
	add_child(fix_log_menu)

	hp_colon_label = Label.new()
	hp_colon_label.name = "HPColonLabel"
	hp_colon_label.text = "HP"
	hp_colon_label.position = Vector2(10, 17)
	hp_colon_label.size = Vector2(45, 38)
	hp_colon_label.add_theme_font_override("font", stats_font)
	hp_colon_label.add_theme_font_size_override("font_size", 32)
	hp_colon_label.add_theme_color_override("font_color", Color.WHITE)
	hp_colon_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hp_colon_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_left_panel.add_child(hp_colon_label)

	mp_colon_label = Label.new()
	mp_colon_label.name = "MPColonLabel"
	mp_colon_label.text = "MP"
	mp_colon_label.position = Vector2(12, 60)
	mp_colon_label.size = Vector2(36, 27)
	mp_colon_label.add_theme_font_override("font", stats_font)
	mp_colon_label.add_theme_font_size_override("font_size", 22)
	mp_colon_label.add_theme_color_override("font_color", Color.WHITE)
	mp_colon_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	mp_colon_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_left_panel.add_child(mp_colon_label)

	level_label = Label.new()
	level_label.name = "LevelLabel"
	level_label.text = "Lvl 1"
	level_label.position = Vector2(9, 94)
	level_label.size = Vector2(95, 27)
	level_label.add_theme_font_override("font", stats_font)
	level_label.add_theme_font_size_override("font_size", 22)
	level_label.add_theme_color_override("font_color", Color.WHITE)
	level_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	level_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_left_panel.add_child(level_label)

	# --- 2. ВЕРХНЕЕ МЕНЮ (2 ряда кнопок по Controls.as:425-515 при ширине 950) ---
	var top_menu_bar: Control = Control.new()
	top_menu_bar.name = "TopMenuBar"
	top_menu_bar.anchor_left = 1.0
	top_menu_bar.anchor_right = 1.0
	top_menu_bar.anchor_top = 0.0
	top_menu_bar.anchor_bottom = 0.0
	top_menu_bar.offset_left = -950.0
	top_menu_bar.offset_top = 0.0
	top_menu_bar.offset_right = 0.0
	top_menu_bar.offset_bottom = 85.0
	top_menu_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root_control.add_child(top_menu_bar)

	# Ряд 1: pets (289, 8), missions (381, 10), character (510, -1), social (654, 0), items (766, 7), map (868, 10)
	pets_btn = _create_menu_button(top_menu_bar, "pets", "PetsBtn", Vector2(289, 8), toggle_pet_menu)
	pets_btn.visible = false # Controls.as:433: visible = param2 != null && param2.pet_array.length > 0
	missions_btn = _create_menu_button(top_menu_bar, "missions", "MissionsBtn", Vector2(381, 10), toggle_mission_menu)
	character_btn = _create_menu_button(top_menu_bar, "character", "CharBtn", Vector2(510, -1), toggle_character_menu)
	social_btn = _create_menu_button(top_menu_bar, "social", "SocialBtn", Vector2(654, 0), toggle_friends_menu)
	items_btn = _create_menu_button(top_menu_bar, "items", "ItemsBtn", Vector2(766, 7), toggle_item_menu)
	map_btn = _create_menu_button(top_menu_bar, "map", "MapBtn", Vector2(868, 10), toggle_map_menu)

	# Ряд 2: heropedia (510, 43), payvault (679, 39), options (823, 41)
	heropedia_btn = _create_menu_button(top_menu_bar, "heropedia", "HeropediaBtn", Vector2(510, 43), _on_heropedia_pressed)
	payvault_btn = _create_menu_button(top_menu_bar, "payvault", "PayVaultBtn", Vector2(679, 39), _on_payvault_pressed)
	options_btn = _create_menu_button(top_menu_bar, "options", "OptionsBtn", Vector2(823, 41), toggle_options_menu)

	# Совместимые алиасы переменных
	btn_pets = pets_btn
	btn_missions = missions_btn
	btn_char = character_btn
	btn_social = social_btn
	btn_skills = social_btn # Алиас для совместимости с существующими тестами Stage 8
	btn_items = items_btn
	btn_map = map_btn
	btn_options = options_btn

	# --- 3. НИЖНЯЯ ПАНЕЛЬ ЧАТА (Controls.as:216, 241-244, 332-345) ---
	# Текстура "chat" (929x117) в (11, 577) = (11, viewport_height - 123)
	var bottom_panel: Control = Control.new()
	bottom_panel.name = "BottomPanel"
	bottom_panel.anchor_left = 0.0
	bottom_panel.anchor_right = 0.0
	bottom_panel.anchor_top = 1.0
	bottom_panel.anchor_bottom = 1.0
	bottom_panel.offset_left = 11.0
	bottom_panel.offset_top = -123.0
	bottom_panel.offset_right = 940.0
	bottom_panel.offset_bottom = -6.0
	bottom_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root_control.add_child(bottom_panel)

	var chat_tex: Texture2D = atlas_loader.get_starling_texture("controls", "chat")
	chat_bg = TextureRect.new()
	chat_bg.name = "ChatPanelBG"
	chat_bg.texture = chat_tex
	chat_bg.position = Vector2.ZERO
	chat_bg.size = Vector2(929, 117)
	chat_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bottom_panel.add_child(chat_bg)

	# chat_log (908x88 в (20, 579) -> относительно (11, 577) это (9, 2))
	chat_log = RichTextLabel.new()
	chat_log.name = "ChatLog"
	chat_log.position = Vector2(9, 2)
	chat_log.size = Vector2(908, 88)
	chat_log.scroll_following = true
	chat_log.bbcode_enabled = true
	chat_log.mouse_filter = Control.MOUSE_FILTER_IGNORE
	chat_log.add_theme_font_override("normal_font", talk_font)
	chat_log.add_theme_font_override("bold_font", talk_font)
	chat_log.add_theme_font_size_override("normal_font_size", 11)
	chat_log.add_theme_font_size_override("bold_font_size", 11)
	chat_log.add_theme_color_override("default_color", Color.WHITE)
	chat_log.text = "[color=yellow]System:[/color] Welcome to Helmet Heroes!\n"
	bottom_panel.add_child(chat_log)

	# chat_input (906x20 в (20, 667) -> относительно (11, 577) это (9, 90))
	# Controls.as:342-343: textEditorProperties.fontFamily = "Arial"; fontSize = 14
	var chat_input_font: SystemFont = SystemFont.new()
	chat_input_font.font_names = PackedStringArray(["Arial"])
	chat_input = LineEdit.new()
	chat_input.name = "ChatInput"
	chat_input.position = Vector2(9, 90)
	chat_input.size = Vector2(906, 20)
	chat_input.max_length = int(906.0 / 6.0)
	chat_input.add_theme_font_override("font", chat_input_font)
	chat_input.add_theme_font_size_override("font_size", 14)
	chat_input.placeholder_text = "Press Enter to chat..."
	chat_input.text_submitted.connect(_on_chat_submitted)
	bottom_panel.add_child(chat_input)

	# Контейнер для окон меню
	menus_container = Control.new()
	menus_container.name = "MenusContainer"
	menus_container.anchor_right = 1.0
	menus_container.anchor_bottom = 1.0
	menus_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root_control.add_child(menus_container)


func _create_menu_button(parent: Control, texture_name: String, btn_name: String, pos: Vector2, on_click: Callable) -> TextureButton:
	var atlas_loader: Node = _get_atlas_loader()
	var tex: Texture2D = atlas_loader.get_starling_texture("controls", texture_name)
	var btn: TextureButton = TextureButton.new()
	btn.name = btn_name
	btn.focus_mode = Control.FOCUS_NONE
	btn.texture_normal = tex
	btn.position = pos
	btn.pressed.connect(on_click)
	parent.add_child(btn)
	return btn


func _create_menus() -> void:
	# CharacterMenu
	var char_script: GDScript = load("res://scripts/ui/menus/CharacterMenu.gd")
	character_menu = char_script.new(local_player)
	character_menu.visible = false
	character_menu.position = Vector2(250, 150)
	if character_menu.has_signal("skills_menu_requested"):
		character_menu.connect("skills_menu_requested", toggle_skills_menu)
	menus_container.add_child(character_menu)

	# ItemMenu
	var item_script: GDScript = load("res://scripts/ui/menus/ItemMenu.gd")
	item_menu = item_script.new(local_player)
	item_menu.visible = false
	item_menu.position = Vector2(200, 120)
	menus_container.add_child(item_menu)

	# SkillsMenu (открывается по хоткею 'K' или из CharacterMenu)
	var skills_script: GDScript = load("res://scripts/ui/menus/SkillsMenu.gd")
	skills_menu = skills_script.new(local_player)
	skills_menu.visible = false
	skills_menu.position = Vector2(180, 100)
	menus_container.add_child(skills_menu)

	# MapMenu
	var map_script: GDScript = load("res://scripts/ui/menus/MapMenu.gd")
	map_menu = map_script.new(1)
	map_menu.visible = false
	map_menu.position = Vector2(72, 40)
	if map_menu.has_signal("area_selected"):
		map_menu.connect("area_selected", _on_map_area_selected)
	menus_container.add_child(map_menu)

	# MissionMenu
	var mission_script: GDScript = load("res://scripts/ui/menus/MissionMenu.gd")
	mission_menu = mission_script.new()
	mission_menu.visible = false
	mission_menu.position = Vector2(220, 110)
	menus_container.add_child(mission_menu)

	# FriendsMenu (Social / Friends / Guild / Ignore)
	var friends_script: GDScript = load("res://scripts/ui/menus/FriendsMenu.gd")
	friends_menu = friends_script.new()
	friends_menu.visible = false
	friends_menu.position = Vector2(240, 100)
	menus_container.add_child(friends_menu)

	# PetMenu
	var pet_script: GDScript = load("res://scripts/ui/menus/PetMenu.gd")
	pet_menu = pet_script.new(local_player)
	pet_menu.visible = false
	pet_menu.position = Vector2(120, 90)
	menus_container.add_child(pet_menu)

	# OptionsMenu
	var opt_script: GDScript = load("res://scripts/ui/menus/OptionsMenu.gd")
	options_menu = opt_script.new()
	options_menu.visible = false
	options_menu.position = Vector2(280, 90)
	menus_container.add_child(options_menu)

	# TalkBox
	var talk_script: GDScript = load("res://scripts/ui/menus/TalkBox.gd")
	talk_box = talk_script.new()
	talk_box.visible = false
	talk_box.position = Vector2(86, 171)
	menus_container.add_child(talk_box)

	# ShopMenu (порт ItemMenu "buy"/"sale")
	var shop_script: GDScript = load("res://scripts/ui/menus/ShopMenu.gd")
	shop_menu = shop_script.new()
	shop_menu.visible = false
	shop_menu.position = Vector2(200, 120)
	menus_container.add_child(shop_menu)

	# PetShopMenu (порт PetShopMenu.as)
	var pet_shop_script: GDScript = load("res://scripts/ui/menus/PetShopMenu.gd")
	pet_shop_menu = pet_shop_script.new()
	pet_shop_menu.visible = false
	pet_shop_menu.position = Vector2(77, 140)
	menus_container.add_child(pet_shop_menu)

	talk_box.shop_requested.connect(func(nd: Dictionary) -> void:
		if shop_menu != null and shop_menu.has_method("open_buy"):
			shop_menu.call("open_buy", nd, local_player)
	)
	talk_box.sell_requested.connect(func(nd: Dictionary) -> void:
		if shop_menu != null and shop_menu.has_method("open_sell"):
			shop_menu.call("open_sell", nd, local_player)
	)
	talk_box.talk_action_triggered.connect(_on_npc_talk_action)

	# HeropediaMenu
	var hero_script: GDScript = load("res://scripts/ui/menus/HeropediaMenu.gd")
	heropedia_menu = hero_script.new()
	heropedia_menu.visible = false
	heropedia_menu.position = Vector2(80, 60)
	menus_container.add_child(heropedia_menu)

	# PayVaultMenu
	var pv_script: GDScript = load("res://scripts/ui/menus/PayVaultMenu.gd")
	payvault_menu = pv_script.new()
	payvault_menu.visible = false
	payvault_menu.position = Vector2(74, 89)
	menus_container.add_child(payvault_menu)

	# BankMenu
	var bank_script: GDScript = load("res://scripts/ui/menus/BankMenu.gd")
	bank_menu = bank_script.new()
	bank_menu.visible = false
	bank_menu.position = Vector2(20, 30)
	menus_container.add_child(bank_menu)

	if item_menu != null and item_menu.has_signal("store_item_requested"):
		item_menu.store_item_requested.connect(func(inv_idx: int) -> void:
			if bank_menu != null and bank_menu.has_method("deposit_item"):
				if bool(bank_menu.call("deposit_item", inv_idx)) and item_menu.has_method("update_display"):
					item_menu.call("update_display")
		)
	if bank_menu != null and bank_menu.has_signal("closed"):
		bank_menu.closed.connect(func() -> void:
			if item_menu != null and item_menu.has_method("set_bank_store_mode"):
				item_menu.call("set_bank_store_mode", false)
				item_menu.visible = false
		)

	if pet_shop_menu != null and pet_shop_menu.has_signal("pet_purchased"):
		pet_shop_menu.pet_purchased.connect(func(_pd: Dictionary) -> void:
			if pet_menu != null and pet_menu.has_method("reload_from_profile"):
				pet_menu.call("reload_from_profile")
			if pets_btn != null:
				pets_btn.visible = true
		)


func _find_game_flow() -> Node:
	if is_inside_tree():
		var grouped: Node = get_tree().get_first_node_in_group("game_flow")
		if grouped != null:
			return grouped
	var main_flow: Node = get_node_or_null("/root/Main/GameFlow")
	if main_flow != null:
		return main_flow
	return get_node_or_null("/root/GameFlow")


func bind_player(player: Node) -> void:
	if sandbox_return_btn != null:
		var gf: Node = _find_game_flow()
		var is_sb: bool = (gf != null and bool(gf.get("is_sandbox_session")))
		sandbox_return_btn.visible = is_sb
		if sandbox_admin_btn != null:
			sandbox_admin_btn.visible = is_sb
	if admin_menu != null and player is PersonEntity:
		admin_menu.setup(player as PersonEntity, get_parent())
	local_player = player as PersonEntity
	if local_player == null:
		return

	# Привязываем сигналы игрока к HUD
	if not local_player.health_changed.is_connected(on_player_health_changed):
		local_player.health_changed.connect(on_player_health_changed)
	if not local_player.mp_changed.is_connected(on_player_mp_changed):
		local_player.mp_changed.connect(on_player_mp_changed)
	if not local_player.exp_changed.is_connected(on_player_exp_changed):
		local_player.exp_changed.connect(on_player_exp_changed)
	if not local_player.coins_changed.is_connected(on_player_coins_changed):
		local_player.coins_changed.connect(on_player_coins_changed)

	# Первичная инициализация
	on_player_health_changed(local_player.health, local_player.max_health)
	on_player_mp_changed(local_player.mana, local_player.max_mana)
	on_player_exp_changed(local_player.exp_points, local_player.max_exp_points, local_player.level)
	on_player_coins_changed(local_player.coins)

	# Controls.as:433: pets_btn.visible = param2 != null && param2.pet_array.length > 0
	var pet_arr: Variant = local_player.get("pet_array")
	if pets_btn != null:
		pets_btn.visible = pet_arr is Array and (pet_arr as Array).size() > 0

	if character_menu != null and character_menu.has_method("bind_person"):
		character_menu.bind_person(local_player)
	if bank_menu != null and bank_menu.has_method("bind_person"):
		bank_menu.call("bind_person", local_player)
	if pet_menu != null and pet_menu.has_method("bind_person"):
		pet_menu.call("bind_person", local_player)
	if item_menu != null and item_menu.has_method("bind_person"):
		item_menu.bind_person(local_player)
	if skills_menu != null and skills_menu.has_method("bind_person"):
		skills_menu.bind_person(local_player)
	if pet_menu != null and pet_menu.has_method("bind_person"):
		pet_menu.bind_person(local_player)

	var gw: Node = get_parent()
	if gw == null or not gw.has_signal("npc_talk_requested"):
		gw = get_tree().get_first_node_in_group("game_world") if is_inside_tree() else null
	if gw != null and gw.has_signal("npc_talk_requested"):
		var cb := Callable(self, "_on_world_npc_talk_requested")
		if not gw.is_connected("npc_talk_requested", cb):
			gw.connect("npc_talk_requested", cb)


func on_player_health_changed(new_hp: int, max_hp: int) -> void:
	hp_bar.max_value = max(1, max_hp)
	hp_bar.value = max(0, new_hp)
	hp_label.text = "%d / %d" % [new_hp, max_hp] if new_hp >= 0 else "0"


func on_player_mp_changed(new_mp: int, max_mp: int) -> void:
	mp_bar.max_value = max(1, max_mp)
	mp_bar.value = max(0, new_mp)
	mp_label.text = "%d / %d" % [new_mp, max_mp]

	# Controls.as:573-592: при totalMP == 0 скрываем MP и сдвигаем XP, Level, Coin вверх на -32 px
	var has_mp: bool = max_mp > 0
	mp_bg.visible = has_mp
	mp_bar.visible = has_mp
	mp_label.visible = has_mp
	mp_colon_label.visible = has_mp
	var y_offset: float = 0.0 if has_mp else -32.0
	level_label.position.y = 94.0 + y_offset
	xp_bg.position.y = 96.0 + y_offset
	xp_bar.position.y = 99.0 + y_offset
	coin_icon.position.y = 128.0 + y_offset
	xp_label.position.y = 89.0 + y_offset
	coins_label.position.y = 126.0 + y_offset
	if sandbox_return_btn != null:
		sandbox_return_btn.position.y = 156.0 + y_offset
	if sandbox_admin_btn != null:
		sandbox_admin_btn.position.y = 188.0 + y_offset
	if bug_report_btn != null:
		bug_report_btn.position.y = 220.0 + y_offset
	if fix_log_btn != null:
		fix_log_btn.position.y = 252.0 + y_offset


func on_player_exp_changed(new_exp: int, max_exp: int, cur_lvl: int) -> void:
	xp_bar.max_value = max(1, max_exp)
	xp_bar.value = max(0, new_exp)
	var ratio: float = clampf(float(new_exp) / float(max_exp), 0.0, 1.0) if max_exp > 0 else 0.0
	var pct_rounded: float = roundf(ratio * 1000.0) / 10.0
	var pct_str: String = str(int(pct_rounded)) if is_equal_approx(pct_rounded, float(int(pct_rounded))) else str(pct_rounded)
	xp_label.text = "%d / %d (%s%%)" % [new_exp, max_exp, pct_str]
	level_label.text = "Lvl %d" % cur_lvl


func on_player_energy_changed(_new_energy: int, _max_energy: int) -> void:
	pass


func on_player_coins_changed(new_coins: int) -> void:
	coins_label.text = "Money: $%s" % _format_with_commas(new_coins)


static func _format_with_commas(value: int) -> String:
	var neg: bool = value < 0
	var s: String = str(abs(value))
	var out: String = ""
	var count: int = 0
	for i: int in range(s.length() - 1, -1, -1):
		if count > 0 and count % 3 == 0:
			out = "," + out
		out = s[i] + out
		count += 1
	return ("-" + out) if neg else out


func add_chat_message(sender: String, message: String) -> void:
	var entry: String = "%s: %s" % [sender, message]
	chat_log_history.append(entry)
	chat_log.append_text("[color=aqua]%s:[/color] %s\n" % [sender, message])


func _on_chat_submitted(text: String) -> void:
	if text.strip_edges().is_empty():
		return
	add_chat_message(local_player.character_name if local_player != null else "You", text)
	chat_input.text = ""
	chat_message_submitted.emit(text)


func _on_heropedia_pressed() -> void:
	toggle_heropedia_menu()


func _on_payvault_pressed() -> void:
	toggle_payvault_menu()


func on_heropedia_unlocked(_enemy_type: String = "") -> void:
	blink_heropedia_button = true
	_heropedia_blink_timer = 0.0
	if heropedia_menu != null and heropedia_menu.has_method("update_display"):
		heropedia_menu.update_display()


func toggle_heropedia_menu() -> void:
	if heropedia_menu == null:
		return
	heropedia_menu.visible = not heropedia_menu.visible
	if heropedia_menu.visible:
		blink_heropedia_button = false
		_heropedia_blink_timer = 0.0
		if heropedia_btn != null:
			heropedia_btn.scale = Vector2.ONE
		if heropedia_menu.has_method("show_menu"):
			heropedia_menu.show_menu()
		elif heropedia_menu.has_method("goto_main"):
			heropedia_menu.goto_main()
		heropedia_menu.move_to_front()


func toggle_payvault_menu() -> void:
	if payvault_menu == null:
		return
	payvault_menu.visible = not payvault_menu.visible
	if payvault_menu.visible:
		if payvault_menu.has_method("refresh"):
			payvault_menu.refresh()
		payvault_menu.move_to_front()


func toggle_bank_menu() -> void:
	if bank_menu == null:
		return
	bank_menu.visible = not bank_menu.visible
	if bank_menu.visible:
		bank_menu.position = Vector2(20, 30)
		if bank_menu.has_method("refresh"):
			bank_menu.call("refresh")
		bank_menu.move_to_front()
		if item_menu != null:
			item_menu.position = Vector2(470, 260)
			if item_menu.has_method("set_bank_store_mode"):
				item_menu.call("set_bank_store_mode", true)
			item_menu.visible = true
			item_menu.move_to_front()
	else:
		if item_menu != null and item_menu.has_method("set_bank_store_mode"):
			item_menu.call("set_bank_store_mode", false)
			item_menu.visible = false


func toggle_character_menu() -> void:
	character_menu.visible = not character_menu.visible
	if character_menu.visible and character_menu.has_method("update_display"):
		character_menu.update_display()


func toggle_item_menu() -> void:
	item_menu.visible = not item_menu.visible
	if item_menu.visible and item_menu.has_method("update_display"):
		item_menu.update_display()


func toggle_skills_menu() -> void:
	skills_menu.visible = not skills_menu.visible
	if skills_menu.visible and skills_menu.has_method("update_display"):
		skills_menu.update_display()


func toggle_map_menu() -> void:
	map_menu.visible = not map_menu.visible
	if map_menu.visible:
		var gw: Node = local_player.game_world if (local_player != null and local_player.game_world != null) else get_parent()
		if gw != null and "current_stage_id" in gw and map_menu.has_method("set_current_area"):
			map_menu.call("set_current_area", int(gw.get("current_stage_id")))
		if map_menu.has_method("refresh_unlocked_maps"):
			map_menu.call("refresh_unlocked_maps")


func _on_map_area_selected(stage_id: int) -> void:
	if local_player != null and local_player.is_dead:
		return
	if local_player != null and local_player.get("is_controlling_pet") == true:
		return
	if map_menu != null and map_menu.has_method("is_stage_unlocked") and not map_menu.call("is_stage_unlocked", stage_id):
		return
	var target_portal_slot: int = 1
	var sdb: Node = get_node_or_null("/root/StatsDB")
	if sdb != null and sdb.has_method("get_area_meta"):
		var meta: Variant = sdb.call("get_area_meta", stage_id)
		if meta is Dictionary:
			var portals_dict: Variant = (meta as Dictionary).get("portals", {})
			for slot: int in range(1, 9):
				var key: String = "portal%dLead" % slot
				var lead: int = 0
				if portals_dict is Dictionary and (portals_dict as Dictionary).has(key):
					lead = int((portals_dict as Dictionary).get(key, 0))
				elif (meta as Dictionary).has(key):
					lead = int((meta as Dictionary).get(key, 0))
				if lead > 0:
					target_portal_slot = slot
					break
	var gw: Node = local_player.game_world if (local_player != null and local_player.game_world != null) else get_parent()
	if gw != null and gw.has_method("change_level"):
		gw.call("change_level", stage_id, target_portal_slot)
	elif gw != null and gw.has_method("load_level"):
		gw.call("load_level", stage_id)
	if map_menu != null:
		if map_menu.has_method("close_menu"):
			map_menu.call("close_menu")
		else:
			map_menu.visible = false


func toggle_mission_menu() -> void:
	mission_menu.visible = not mission_menu.visible


func toggle_friends_menu() -> void:
	friends_menu.visible = not friends_menu.visible


func toggle_pet_menu() -> void:
	pet_menu.visible = not pet_menu.visible
	if pet_menu.visible and pet_menu.has_method("update_display"):
		pet_menu.update_display()


func toggle_options_menu() -> void:
	options_menu.visible = not options_menu.visible


func _on_world_npc_talk_requested(npc_data: Dictionary, _npc_node: Node2D = null) -> void:
	open_talk_box(npc_data)


func open_talk_box(npc_data: Dictionary) -> void:
	if talk_box != null and talk_box.has_method("start_dialogue"):
		talk_box.call("start_dialogue", npc_data, local_player)
		talk_box.visible = true


func _on_npc_talk_action(_talk_id: int, action_dict: Dictionary, npc_data: Dictionary) -> void:
	var act: String = str(action_dict.get("action", "dialog"))
	var npc_name: String = str(npc_data.get("name", "NPC"))
	match act:
		"heal":
			if local_player != null:
				local_player.health = local_player.max_health
				local_player.mana = local_player.max_mana
				local_player.health_changed.emit(local_player.health, local_player.max_health)
				local_player.mp_changed.emit(local_player.mana, local_player.max_mana)
			var amgr: Node = get_node_or_null("/root/AudioManager")
			if amgr != null and amgr.has_method("play_sfx"):
				amgr.call("play_sfx", "heal")
			add_chat_message("System", "%s полностью восстановил здоровье и ману!" % npc_name)
		"mission_start":
			var m_name: String = str(action_dict.get("mission", ""))
			if local_player != null and not m_name.is_empty():
				if not local_player.active_missions.has(m_name) and not local_player.completed_missions.has(m_name):
					local_player.active_missions.append(m_name)
				if mission_menu != null and mission_menu.has_method("refresh_missions"):
					mission_menu.call("refresh_missions")
				add_chat_message("Quest", "Начата миссия: %s" % m_name)
		"mission_complete":
			var m_name: String = str(action_dict.get("mission", ""))
			if local_player != null and not m_name.is_empty():
				local_player.active_missions.erase(m_name)
				if not local_player.completed_missions.has(m_name):
					local_player.completed_missions.append(m_name)
				if mission_menu != null and mission_menu.has_method("refresh_missions"):
					mission_menu.call("refresh_missions")
				add_chat_message("Quest", "Завершена миссия: %s" % m_name)
		"craft":
			if shop_menu != null and shop_menu.has_method("open_buy"):
				shop_menu.call("open_buy", npc_data, local_player)
		"pet_shop":
			if pet_shop_menu != null and pet_shop_menu.has_method("open_pet_shop"):
				pet_shop_menu.call("open_pet_shop", npc_data, local_player)
		"guild", "lottery", "tutorial":
			add_chat_message(npc_name, "Функция (%s) активирована." % act)
		_:
			var next_txt: String = str(action_dict.get("text", ""))
			if not next_txt.is_empty():
				add_chat_message(npc_name, next_txt)


static func _get_atlas_loader() -> Node:
	if Engine.has_singleton("StarlingAtlasLoader"):
		return Engine.get_singleton("StarlingAtlasLoader")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("StarlingAtlasLoader"):
		return tree.root.get_node("StarlingAtlasLoader")
	return load("res://scripts/autoload/StarlingAtlasLoader.gd").new()
