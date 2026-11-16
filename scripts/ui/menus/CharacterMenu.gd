extends Control
class_name CharacterMenu
## CharacterMenu — Окно характеристик персонажа (порт com.menus.CharacterMenu.as).
## Точно воспроизводит Starling-версию:
## - Фоновая текстура "character menu" (606x353) из атласа character menu без дублирующих плашек
## - Статы (Power, Dexterity, Defense, Range, Magic, Artillery, HP, MP) по точным координатам Flash (x=190)
## - Кнопки прокачки "+" (more_btn_00 / more_btn_01) по точным координатам Flash (x=340)
## - Счетчик свободных очков характеристик AP (x=65, y=248)
## - Диапазон урона Damage span (x=376, y=53) и показатель защиты Defense span (x=376, y=101)
## - Кнопка перехода в меню навыков (skills_btn)

signal closed()
signal skills_menu_requested()

@export var is_draggable: bool = true

var person: Node = null
var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

# UI ноды
var panel_bg: TextureRect = null
var skills_panel: TextureRect = null
var close_btn: TextureButton = null
var ap_label: Label = null
var ap_title_label: Label = null
var name_label: Label = null
var title_label: Label = null
var level_label: Label = null
var damage_span_label: Label = null
var defense_span_label: Label = null
var skills_btn: TextureButton = null
var skills_txt_label: Label = null
var critical_label: Label = null
var speed_label: Label = null
var critical_info_btn: TextureButton = null
var fishing_bg: TextureRect = null
var fishing_bar: TextureRect = null
var fishing_lvl_label: Label = null
var fishing_xp_label: Label = null
var fishing_info_btn: TextureButton = null
var chopping_bg: TextureRect = null
var chopping_bar: TextureRect = null
var chopping_lvl_label: Label = null
var chopping_xp_label: Label = null
var chopping_info_btn: TextureButton = null
var skill_info_popup: PanelContainer = null
var skill_info_label: Label = null

const FISHING_INFO_TEXT: String = "Fishing xp is gained by catching fish..  Fish that are caught can yield several benefits.  Fish can be eaten for HP by you or your pets.  Shiny fish can also be eaten to gain special perks such as power, range, magic, or artillery.  Aside from being eaten, fish can also be sold for money.  Each fishing level you gain subtracts 1 from your natural reaction time for catching fish."
const CHOPPING_INFO_TEXT: String = "Gained by chopping trees.  Having a higher chopping level allows you to chop down tree faster.  The amount of damage you deal to trees is a result of your chopping level as well as your power/range/magic/artillery depending on the type of weapon you are using."

var stat_labels: Dictionary = {}
var plus_buttons: Dictionary = {}
var person_clone: BodyAnimatorNode = null

func _init(target_person: Node = null) -> void:
	person = target_person


func _ready() -> void:
	custom_minimum_size = Vector2(606, 353)
	size = Vector2(606, 353)
	_build_ui()
	if person != null:
		bind_person(person)


func _build_ui() -> void:
	var atlas_loader: Node = _get_atlas_loader()
	atlas_loader.register_starling_atlas("character menu")
	var stats_font: Font = atlas_loader.get_bitmap_font("stats_font.fnt")

	# 0. Подложка панели навыков (CharacterMenu.as:394-400: x=-156, y=167, pivot=(207, 25) -> (8, 344))
	var skills_panel_tex: Texture2D = atlas_loader.get_starling_texture("character menu", "skills panel")
	if skills_panel_tex != null:
		skills_panel = TextureRect.new()
		skills_panel.name = "SkillsPanelBG"
		skills_panel.texture = skills_panel_tex
		skills_panel.position = Vector2(8, 344)
		skills_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(skills_panel)

	# 1. Фоновая текстура оригинального меню (606x353) — содержит весь арт и плашки слотов
	var bg_tex: Texture2D = atlas_loader.get_starling_texture("character menu", "character menu")
	panel_bg = TextureRect.new()
	panel_bg.name = "PanelBG"
	panel_bg.texture = bg_tex
	panel_bg.size = Vector2(606, 353)
	panel_bg.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(panel_bg)

	# 2. Кнопка закрытия (CharacterMenu.as:141-144: x=229, y=-191, pivot=(30, 19) -> (570, -8))
	var close_tex: Texture2D = atlas_loader.get_starling_texture("character menu", "close button_00")
	var close_hover: Texture2D = atlas_loader.get_starling_texture("character menu", "close button_01")
	close_btn = TextureButton.new()
	close_btn.name = "CloseButton"
	close_btn.texture_normal = close_tex
	close_btn.texture_hover = close_hover
	close_btn.position = Vector2(570, -8)
	close_btn.focus_mode = Control.FOCUS_NONE
	close_btn.pressed.connect(close_menu)
	add_child(close_btn)

	# 3. Заголовок "<NAME> INFO" (CharacterMenu.as:274-277: x=-173, y=-203 -> (198, -1))
	title_label = Label.new()
	title_label.name = "TitleLabel"
	title_label.position = Vector2(198, -1)
	title_label.size = Vector2(248, 34)
	title_label.text = "HERO INFO"
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_label.add_theme_font_override("font", stats_font)
	title_label.add_theme_font_size_override("font_size", 28)
	title_label.add_theme_color_override("font_color", Color.WHITE)
	title_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(title_label)

	# 3b. Имя персонажа (CharacterMenu.as:256-259: x=-359, y=-168 -> (12, 34))
	name_label = Label.new()
	name_label.name = "HeroNameLabel"
	name_label.position = Vector2(12, 34)
	name_label.size = Vector2(180, 25)
	name_label.text = "Player"
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	name_label.add_theme_font_override("font", stats_font)
	name_label.add_theme_font_size_override("font_size", 18)
	name_label.add_theme_color_override("font_color", Color.WHITE)
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(name_label)

	# 3c. Уровень персонажа (CharacterMenu.as:385-388: x=-181, y=-163 -> (190, 39))
	level_label = Label.new()
	level_label.name = "LevelLabel"
	level_label.position = Vector2(190, 39)
	level_label.size = Vector2(133, 33)
	level_label.text = "Level: 1"
	level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	level_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	level_label.add_theme_font_override("font", stats_font)
	level_label.add_theme_font_size_override("font_size", 24)
	level_label.add_theme_color_override("font_color", Color.WHITE)
	level_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(level_label)

	# 4. Счетчик AP (CharacterMenu.as:262-272: "Ability Points:" (24, 233), aPoints_txt (65, 250))
	ap_title_label = Label.new()
	ap_title_label.name = "APTitleLabel"
	ap_title_label.text = "Ability Points:"
	ap_title_label.position = Vector2(24, 233)
	ap_title_label.size = Vector2(143, 25)
	ap_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ap_title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	ap_title_label.add_theme_font_override("font", stats_font)
	ap_title_label.add_theme_font_size_override("font_size", 18)
	ap_title_label.add_theme_color_override("font_color", Color.WHITE)
	ap_title_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(ap_title_label)

	ap_label = Label.new()
	ap_label.name = "APLabel"
	ap_label.text = "0"
	ap_label.position = Vector2(65, 250)
	ap_label.size = Vector2(85, 54)
	ap_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ap_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	ap_label.add_theme_font_override("font", stats_font)
	ap_label.add_theme_font_size_override("font_size", 42)
	ap_label.add_theme_color_override("font_color", Color.WHITE)
	ap_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(ap_label)

	# 5. Диапазон урона (Damage span: CharacterMenu.as:65, 295-298 -> (376, 53), 209x26)
	damage_span_label = Label.new()
	damage_span_label.name = "DamageSpanLabel"
	damage_span_label.position = Vector2(376, 53)
	damage_span_label.size = Vector2(209, 26)
	damage_span_label.text = "0-0"
	damage_span_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	damage_span_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	damage_span_label.add_theme_font_override("font", stats_font)
	damage_span_label.add_theme_font_size_override("font_size", 20)
	damage_span_label.add_theme_color_override("font_color", Color.WHITE)
	damage_span_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(damage_span_label)

	# 6. Показатель брони/защиты (Defense span: CharacterMenu.as:67, 297-299 -> (376, 101), 209x26)
	defense_span_label = Label.new()
	defense_span_label.name = "DefenseSpanLabel"
	defense_span_label.position = Vector2(376, 101)
	defense_span_label.size = Vector2(209, 26)
	defense_span_label.text = "0"
	defense_span_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	defense_span_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	defense_span_label.add_theme_font_override("font", stats_font)
	defense_span_label.add_theme_font_size_override("font_size", 20)
	defense_span_label.add_theme_color_override("font_color", Color.WHITE)
	defense_span_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(defense_span_label)

	# 7. Текстуры кнопки "+" (more_btn_00 / more_btn_01)
	var more_tex: Texture2D = atlas_loader.get_starling_texture("character menu", "more_btn_00")
	var more_hover: Texture2D = atlas_loader.get_starling_texture("character menu", "more_btn_01")

	# 8. Точные координаты слотов характеристик из com.menus.CharacterMenu.as:
	# Flash x=-181 -> rel x = 190. Кнопки "+" Flash x=-22 -> rel x = 340.
	# hp_txt: y=-122 -> rel y=80
	# mp_txt: y=-89 -> rel y=113
	# dex_txt: y=-55 -> rel y=147
	# power_txt: y=-20 -> rel y=182
	# range_txt: y=13 -> rel y=215
	# magic_txt: y=47 -> rel y=249
	# artillery_txt: y=81 -> rel y=283
	# defense_txt: y=116 -> rel y=318
	var stats_config: Array[Dictionary] = [
		{"id": "hp", "name": "HP", "y": 80, "plus_y": 80, "is_core": false},
		{"id": "mp", "name": "MP", "y": 113, "plus_y": 113, "is_core": false},
		{"id": "dexterity", "name": "Dexterity", "y": 147, "plus_y": 147, "is_core": true},
		{"id": "power", "name": "Power", "y": 182, "plus_y": 182, "is_core": true},
		{"id": "range", "name": "Range", "y": 215, "plus_y": 216, "is_core": true},
		{"id": "magic", "name": "Magic", "y": 249, "plus_y": 249, "is_core": true},
		{"id": "artillery", "name": "Artillery", "y": 283, "plus_y": 283, "is_core": true},
		{"id": "defense", "name": "Defense", "y": 318, "plus_y": 316, "is_core": true}
	]

	for cfg: Dictionary in stats_config:
		var stat_id: String = cfg["id"]
		var stat_name: String = cfg["name"]
		var pos_y: int = cfg["y"]
		var plus_y: int = cfg["plus_y"]

		# Текстовая метка внутри темной полосы стата (CharacterMenu.as:49-63: 192x25, stats_font 18, left/top)
		var lbl: Label = Label.new()
		lbl.name = "Label_%s" % stat_id
		lbl.position = Vector2(190, pos_y)
		lbl.size = Vector2(192, 25)
		lbl.text = "%s: 0" % stat_name
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		lbl.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		lbl.add_theme_font_override("font", stats_font)
		lbl.add_theme_font_size_override("font_size", 18)
		lbl.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
		lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(lbl)
		stat_labels[stat_id] = lbl

		# Кнопка "+" в конце полосы стата (Flash: x=-22, pivotX=9, pivotY=9 -> rel x=340)
		var btn: TextureButton = TextureButton.new()
		btn.name = "Plus_%s" % stat_id
		btn.texture_normal = more_tex
		btn.texture_hover = more_hover
		btn.position = Vector2(340, plus_y)
		btn.focus_mode = Control.FOCUS_NONE
		btn.pressed.connect(func() -> void: _on_upgrade_pressed(stat_id))
		add_child(btn)
		plus_buttons[stat_id] = btn

	# 9. Кнопка навыков skills_btn (CharacterMenu.as:203-206: x=-309, y=166, pivot=(42, 15) -> (20, 353))
	var sk_tex: Texture2D = atlas_loader.get_starling_texture("character menu", "skills_btn")
	if sk_tex != null:
		skills_btn = TextureButton.new()
		skills_btn.name = "SkillsBtn"
		skills_btn.texture_normal = sk_tex
		skills_btn.position = Vector2(20, 353)
		skills_btn.focus_mode = Control.FOCUS_NONE
		skills_btn.pressed.connect(func() -> void: skills_menu_requested.emit())
		add_child(skills_btn)

	# 9b. Текст "Special Skill points: X" (CharacterMenu.as:311-316: x=-265, y=156 -> (106, 358))
	skills_txt_label = Label.new()
	skills_txt_label.name = "SkillsPointsLabel"
	skills_txt_label.position = Vector2(106, 358)
	skills_txt_label.size = Vector2(184, 25)
	skills_txt_label.text = "Special Skill points: 0"
	skills_txt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	skills_txt_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	skills_txt_label.add_theme_font_override("font", stats_font)
	skills_txt_label.add_theme_font_size_override("font_size", 17)
	skills_txt_label.add_theme_color_override("font_color", Color.WHITE)
	skills_txt_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(skills_txt_label)

	# 9c. Правая колонка: Critical/Speed (CharacterMenu.as:240-254, 381-390)
	var info_tex: Texture2D = atlas_loader.get_starling_texture("character menu", "info_btn")
	critical_label = Label.new()
	critical_label.name = "CriticalLabel"
	critical_label.position = Vector2(389, 148)
	critical_label.size = Vector2(142, 23)
	critical_label.text = "Critical hit: 0%"
	critical_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	critical_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	critical_label.add_theme_font_override("font", stats_font)
	critical_label.add_theme_font_size_override("font_size", 16)
	critical_label.add_theme_color_override("font_color", Color.WHITE)
	critical_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(critical_label)

	speed_label = Label.new()
	speed_label.name = "SpeedLabel"
	speed_label.position = Vector2(389, 176)
	speed_label.size = Vector2(142, 23)
	speed_label.text = "Speed: 7 mph"
	speed_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	speed_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	speed_label.add_theme_font_override("font", stats_font)
	speed_label.add_theme_font_size_override("font_size", 16)
	speed_label.add_theme_color_override("font_color", Color.WHITE)
	speed_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(speed_label)

	if info_tex != null:
		critical_info_btn = TextureButton.new()
		critical_info_btn.name = "CriticalInfoBtn"
		critical_info_btn.texture_normal = info_tex
		critical_info_btn.position = Vector2(514, 149)
		critical_info_btn.focus_mode = Control.FOCUS_NONE
		add_child(critical_info_btn)

	# 9d. Правая колонка: Fishing и Chopping (CharacterMenu.as:118-137, 245-254, 320-340)
	var dark_px_tex: Texture2D = atlas_loader.get_starling_texture("character menu", "dark pixel")
	var green_px_tex: Texture2D = atlas_loader.get_starling_texture("character menu", "greenish pixel")

	fishing_bg = TextureRect.new()
	fishing_bg.name = "FishingBG"
	fishing_bg.texture = dark_px_tex
	fishing_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	fishing_bg.position = Vector2(389, 250)
	fishing_bg.size = Vector2(192, 28)
	fishing_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(fishing_bg)

	fishing_bar = TextureRect.new()
	fishing_bar.name = "FishingBar"
	fishing_bar.texture = green_px_tex
	fishing_bar.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	fishing_bar.position = Vector2(393, 253)
	fishing_bar.size = Vector2(0, 22)
	fishing_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(fishing_bar)

	fishing_lvl_label = Label.new()
	fishing_lvl_label.name = "FishingLvlLabel"
	fishing_lvl_label.position = Vector2(389, 232)
	fishing_lvl_label.size = Vector2(106, 21)
	fishing_lvl_label.text = "Fishing lvl: 1"
	fishing_lvl_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	fishing_lvl_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	fishing_lvl_label.add_theme_font_override("font", stats_font)
	fishing_lvl_label.add_theme_font_size_override("font_size", 16)
	fishing_lvl_label.add_theme_color_override("font_color", Color.WHITE)
	fishing_lvl_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(fishing_lvl_label)

	fishing_xp_label = Label.new()
	fishing_xp_label.name = "FishingXPLabel"
	fishing_xp_label.position = Vector2(394, 252)
	fishing_xp_label.size = Vector2(180, 23)
	fishing_xp_label.text = "0 / 51"
	fishing_xp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	fishing_xp_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	fishing_xp_label.add_theme_font_override("font", stats_font)
	fishing_xp_label.add_theme_font_size_override("font_size", 18)
	fishing_xp_label.add_theme_color_override("font_color", Color.WHITE)
	fishing_xp_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(fishing_xp_label)

	if info_tex != null:
		fishing_info_btn = TextureButton.new()
		fishing_info_btn.name = "FishingInfoBtn"
		fishing_info_btn.texture_normal = info_tex
		fishing_info_btn.position = Vector2(539, 230)
		fishing_info_btn.focus_mode = Control.FOCUS_NONE
		fishing_info_btn.mouse_entered.connect(func() -> void: _show_skill_info(FISHING_INFO_TEXT, Vector2(275, 110)))
		fishing_info_btn.mouse_exited.connect(_hide_skill_info)
		add_child(fishing_info_btn)

	chopping_bg = TextureRect.new()
	chopping_bg.name = "ChoppingBG"
	chopping_bg.texture = dark_px_tex
	chopping_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	chopping_bg.position = Vector2(389, 304)
	chopping_bg.size = Vector2(192, 28)
	chopping_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(chopping_bg)

	chopping_bar = TextureRect.new()
	chopping_bar.name = "ChoppingBar"
	chopping_bar.texture = green_px_tex
	chopping_bar.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	chopping_bar.position = Vector2(393, 307)
	chopping_bar.size = Vector2(0, 22)
	chopping_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(chopping_bar)

	chopping_lvl_label = Label.new()
	chopping_lvl_label.name = "ChoppingLvlLabel"
	chopping_lvl_label.position = Vector2(389, 286)
	chopping_lvl_label.size = Vector2(140, 21)
	chopping_lvl_label.text = "Chopping lvl: 1"
	chopping_lvl_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	chopping_lvl_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	chopping_lvl_label.add_theme_font_override("font", stats_font)
	chopping_lvl_label.add_theme_font_size_override("font_size", 16)
	chopping_lvl_label.add_theme_color_override("font_color", Color.WHITE)
	chopping_lvl_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(chopping_lvl_label)

	chopping_xp_label = Label.new()
	chopping_xp_label.name = "ChoppingXPLabel"
	chopping_xp_label.position = Vector2(394, 306)
	chopping_xp_label.size = Vector2(180, 23)
	chopping_xp_label.text = "0 / 51"
	chopping_xp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	chopping_xp_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	chopping_xp_label.add_theme_font_override("font", stats_font)
	chopping_xp_label.add_theme_font_size_override("font_size", 18)
	chopping_xp_label.add_theme_color_override("font_color", Color.WHITE)
	chopping_xp_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(chopping_xp_label)

	if info_tex != null:
		chopping_info_btn = TextureButton.new()
		chopping_info_btn.name = "ChoppingInfoBtn"
		chopping_info_btn.texture_normal = info_tex
		chopping_info_btn.position = Vector2(539, 283)
		chopping_info_btn.focus_mode = Control.FOCUS_NONE
		chopping_info_btn.mouse_entered.connect(func() -> void: _show_skill_info(CHOPPING_INFO_TEXT, Vector2(275, 175)))
		chopping_info_btn.mouse_exited.connect(_hide_skill_info)
		add_child(chopping_info_btn)

	# 10. Живое анимированное превью персонажа (CharacterMenu.as:402-405: x=-282, y=-35 -> rel (89, 167))
	person_clone = BodyAnimatorNode.new()
	person_clone.name = "PersonClone"
	person_clone.position = Vector2(89, 167)
	add_child(person_clone)
	person_clone.play("standing")

	# 11. Всплывающая подсказка InfoMenu при наведении на значки Fishing / Chopping (MainStarlingStage.as:2721-2726)
	skill_info_popup = PanelContainer.new()
	skill_info_popup.name = "SkillInfoPopup"
	skill_info_popup.visible = false
	skill_info_popup.z_index = 20
	skill_info_popup.mouse_filter = Control.MOUSE_FILTER_IGNORE
	skill_info_popup.custom_minimum_size = Vector2(290, 0)
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.08, 0.09, 0.12, 0.94)
	sb.border_width_left = 2
	sb.border_width_top = 2
	sb.border_width_right = 2
	sb.border_width_bottom = 2
	sb.border_color = Color(0.75, 0.62, 0.32, 1.0)
	sb.set_corner_radius_all(4)
	sb.content_margin_left = 10
	sb.content_margin_right = 10
	sb.content_margin_top = 8
	sb.content_margin_bottom = 8
	skill_info_popup.add_theme_stylebox_override("panel", sb)
	skill_info_label = Label.new()
	skill_info_label.name = "SkillInfoLabel"
	skill_info_label.custom_minimum_size = Vector2(270, 0)
	skill_info_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	skill_info_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var readable_font: Font = atlas_loader.get_bitmap_font("readable_font.fnt")
	if readable_font != null:
		skill_info_label.add_theme_font_override("font", readable_font)
	elif stats_font != null:
		skill_info_label.add_theme_font_override("font", stats_font)
	skill_info_label.add_theme_font_size_override("font_size", 13)
	skill_info_label.add_theme_color_override("font_color", Color.WHITE)
	skill_info_popup.add_child(skill_info_label)
	add_child(skill_info_popup)


func _show_skill_info(info_text: String, anchor_pos: Vector2) -> void:
	if skill_info_popup == null or skill_info_label == null:
		return
	skill_info_label.text = info_text
	skill_info_popup.position = anchor_pos
	skill_info_popup.reset_size()
	skill_info_popup.visible = true


func _hide_skill_info() -> void:
	if skill_info_popup != null:
		skill_info_popup.visible = false


func _physics_process(_delta: float) -> void:
	if visible and person_clone != null:
		if person_clone.current_anim_name != "standing":
			person_clone.play("standing")
		elif person_clone.is_playing:
			person_clone.advance_frame()


func bind_person(target_person: Node) -> void:
	if person != null and person.stats_updated.is_connected(update_display):
		person.stats_updated.disconnect(update_display)

	person = target_person
	if person != null:
		person.stats_updated.connect(update_display)
		update_display()


func update_display() -> void:
	if person == null:
		return

	# Имя, заголовок и уровень игрока
	var c_name_val: Variant = person.get("character_name")
	var c_name: String = str(c_name_val if c_name_val != null else "Hero")
	if name_label != null:
		name_label.text = c_name
	if title_label != null:
		title_label.text = "%s INFO" % c_name.to_upper()
	var lvl_val: Variant = person.get("level")
	var p_lvl: int = int(lvl_val if lvl_val != null else 1)
	if level_label != null:
		level_label.text = "Level: %d" % p_lvl

	# Очки характеристик и навыков
	var ap_val: Variant = person.get("ability_points")
	var ap: int = int(ap_val if ap_val != null else 0)
	if ap_label != null:
		ap_label.text = str(ap)
	var sp_val: Variant = person.get("skill_points")
	var sp: int = int(sp_val if sp_val != null else 0)
	if skills_txt_label != null:
		skills_txt_label.text = "Special Skill points: %d" % sp

	# Чтение базовых статов
	var p_pow_val: Variant = person.get("power_stat")
	var p_pow: int = int(p_pow_val if p_pow_val != null else 5)
	var p_dex_val: Variant = person.get("dex_stat")
	var p_dex: int = int(p_dex_val if p_dex_val != null else 5)
	var p_def_val: Variant = person.get("def_stat")
	var p_def: int = int(p_def_val if p_def_val != null else 5)
	var p_rng_val: Variant = person.get("range_stat")
	var p_rng: int = int(p_rng_val if p_rng_val != null else 5)
	var p_mag_val: Variant = person.get("magic_stat")
	var p_mag: int = int(p_mag_val if p_mag_val != null else 5)
	var p_art_val: Variant = person.get("artillery_stat")
	var p_art: int = int(p_art_val if p_art_val != null else 5)

	var p_hp_val: Variant = person.get("health")
	var p_hp: int = int(p_hp_val if p_hp_val != null else 100)
	var p_max_hp_val: Variant = person.get("max_health")
	var p_max_hp: int = int(p_max_hp_val if p_max_hp_val != null else 100)
	var p_mp_val: Variant = person.get("mana")
	var p_mp: int = int(p_mp_val if p_mp_val != null else 50)
	var p_max_mp_val: Variant = person.get("max_mana")
	var p_max_mp: int = int(p_max_mp_val if p_max_mp_val != null else 50)

	# Бонусы орбов и верхового питомца (CharacterMenu.as:465-502, 515-558)
	var orbs: Dictionary = person.call("get_orb_bonuses") if person.has_method("get_orb_bonuses") else {}
	var mount_bonus: int = int(person.call("get_riding_pet_power_bonus")) if person.has_method("get_riding_pet_power_bonus") else 0
	var eff_pow: int = p_pow + _safe_int(orbs.get("pow", 0)) + mount_bonus
	var eff_rng: int = p_rng + _safe_int(orbs.get("rng", 0)) + mount_bonus
	var eff_mag: int = p_mag + _safe_int(orbs.get("mgc", 0)) + mount_bonus
	var eff_art: int = p_art + _safe_int(orbs.get("art", 0)) + mount_bonus

	# Обновление текста меток
	if stat_labels.has("power"):
		stat_labels["power"].text = "Power: %d" % eff_pow
	if stat_labels.has("dexterity"):
		stat_labels["dexterity"].text = "Dexterity: %d" % p_dex
	if stat_labels.has("defense"):
		stat_labels["defense"].text = "Defense: %d" % p_def
	if stat_labels.has("range"):
		stat_labels["range"].text = "Range: %d" % eff_rng
	if stat_labels.has("magic"):
		stat_labels["magic"].text = "Magic: %d" % eff_mag
	if stat_labels.has("artillery"):
		stat_labels["artillery"].text = "Artillery: %d" % eff_art
	if stat_labels.has("hp"):
		stat_labels["hp"].text = "HP: %d/%d" % [p_hp, p_max_hp]
	if stat_labels.has("mp"):
		stat_labels["mp"].text = "MP: %d/%d" % [p_mp, p_max_mp]

	# Видимость кнопок прокачки "+" (только при AP > 0)
	for stat_id: String in plus_buttons.keys():
		plus_buttons[stat_id].visible = (ap > 0)

	# Расчет урона и защиты для верхних плашек (CharacterMenu.as:504-561)
	var armor_pow: int = 0
	var armor_rng: int = 0
	var armor_mag: int = 0
	var armor_art: int = 0
	var armor_def: int = 0
	var w1_info: Dictionary = {}
	var w2_info: Dictionary = {}

	var eq: Variant = person.get("equipment")
	if eq is Dictionary:
		var eq_dict: Dictionary = eq
		var sdb: Node = _get_stats_db()
		if sdb != null:
			for slot: String in ["helmet", "shirt", "legs", "shoes"]:
				var itm_name: String = str(eq_dict.get(slot, ""))
				if not itm_name.is_empty():
					var info: Dictionary = _lookup_item_stats(sdb, itm_name, slot)
					armor_pow += _safe_int(info.get("pow", 0))
					armor_rng += _safe_int(info.get("rng", 0))
					armor_mag += _safe_int(info.get("mgc", 0))
					armor_art += _safe_int(info.get("art", 0))
					armor_def += _safe_int(info.get("def", 0))
			var acc_name: String = str(eq_dict.get("accessory", ""))
			if not acc_name.is_empty():
				var acc_info: Dictionary = _lookup_item_stats(sdb, acc_name, "accessory")
				armor_def += _safe_int(acc_info.get("def", 0))
			var w1_name: String = str(eq_dict.get("weapon", ""))
			if not w1_name.is_empty():
				w1_info = _lookup_item_stats(sdb, w1_name, "weapon")
			var w2_name: String = str(eq_dict.get("weapon2", ""))
			if not w2_name.is_empty():
				w2_info = _lookup_item_stats(sdb, w2_name, "weapon2")

	var active_w: Dictionary = w2_info if _safe_int(w1_info.get("def", 0)) > 0 else w1_info
	var w_min: int = _safe_int(active_w.get("min", 0))
	var w_max: int = _safe_int(active_w.get("max", 0))
	var min_dmg: int = 0
	var max_dmg: int = 0
	if _safe_int(active_w.get("sr", 0)) > 0:
		min_dmg = eff_art * (w_min + armor_art)
		max_dmg = eff_art * (w_max + armor_art)
	elif bool(active_w.get("mgc", false)):
		min_dmg = eff_mag * (w_min + armor_mag)
		max_dmg = eff_mag * (w_max + armor_mag)
	elif bool(active_w.get("rng", false)):
		min_dmg = eff_rng * (w_min + armor_rng)
		max_dmg = eff_rng * (w_max + armor_rng)
	else:
		min_dmg = eff_pow * (w_min + armor_pow)
		max_dmg = eff_pow * (w_max + armor_pow)
	min_dmg = int(min_dmg / 2.0)
	max_dmg = int(max_dmg / 2.0)

	var shield_mastery_lvl: int = 0
	var sm_val: Variant = person.get("shield_mastery_lvl")
	if sm_val != null:
		shield_mastery_lvl = int(sm_val)
	var w1_def_bonus: int = int(float(_safe_int(w1_info.get("def", 0))) * (float(shield_mastery_lvl) / 50.0 + 1.0))
	var total_def: int = p_def + armor_def + w1_def_bonus

	if damage_span_label != null:
		damage_span_label.text = "%d-%d" % [min_dmg, max_dmg]

	if defense_span_label != null:
		defense_span_label.text = "%d" % total_def

	# Critical hit & Speed (CharacterMenu.as:503, 568)
	if critical_label != null:
		var crit_pct: float = roundf((float(p_dex) / 300.0 * 100.0) * 10.0) / 10.0
		var crit_str: String = str(int(crit_pct)) if is_equal_approx(crit_pct, float(int(crit_pct))) else str(crit_pct)
		critical_label.text = "Critical hit: %s%%" % crit_str
	if speed_label != null:
		var spd_val: Variant = person.get("move_speed_stat")
		var spd: float = float(spd_val if spd_val != null else 7.0)
		var spd_rounded: float = roundf(spd * 100.0) / 100.0
		var spd_str: String = str(int(spd_rounded)) if is_equal_approx(spd_rounded, float(int(spd_rounded))) else str(spd_rounded)
		speed_label.text = "Speed: %s mph" % spd_str

	# Fishing & Chopping (CharacterMenu.as:129-135, 320-339)
	var f_lvl_val: Variant = person.get("fishing_lvl")
	var f_lvl: int = maxi(1, int(f_lvl_val if f_lvl_val != null else 1))
	var f_xp_val: Variant = person.get("fish_xp")
	var f_xp: int = int(f_xp_val if f_xp_val != null else 0)
	var f_cur_base: int = _get_total_xp_for_level(f_lvl)
	var f_next_base: int = _get_total_xp_for_level(f_lvl + 1)
	var f_span: int = maxi(1, f_next_base - f_cur_base)
	var f_rel: int = maxi(0, f_xp - f_cur_base)
	if fishing_lvl_label != null:
		fishing_lvl_label.text = "Fishing lvl: %d" % f_lvl
	if fishing_xp_label != null:
		fishing_xp_label.text = "%d / %d" % [f_rel, f_span]
	if fishing_bar != null:
		fishing_bar.size.x = clampf(float(f_rel) / float(f_span), 0.0, 1.0) * 184.0

	var c_lvl_val: Variant = person.get("chopping_lvl")
	var c_lvl: int = maxi(1, int(c_lvl_val if c_lvl_val != null else 1))
	var c_xp_val: Variant = person.get("chop_xp")
	var c_xp: int = int(c_xp_val if c_xp_val != null else 0)
	var c_cur_base: int = _get_total_xp_for_level(c_lvl)
	var c_next_base: int = _get_total_xp_for_level(c_lvl + 1)
	var c_span: int = maxi(1, c_next_base - c_cur_base)
	var c_rel: int = maxi(0, c_xp - c_cur_base)
	if chopping_lvl_label != null:
		chopping_lvl_label.text = "Chopping lvl: %d" % c_lvl
	if chopping_xp_label != null:
		chopping_xp_label.text = "%d / %d" % [c_rel, c_span]
	if chopping_bar != null:
		chopping_bar.size.x = clampf(float(c_rel) / float(c_span), 0.0, 1.0) * 184.0

	_sync_person_clone()


static func _get_total_xp_for_level(lvl: int) -> int:
	var total: int = 0
	for i: int in range(1, lvl):
		total += int(float(i) * (float(i) * 1.1 + 50.0))
	return total


func _sync_person_clone() -> void:
	if person_clone == null or person == null:
		return
	var src_anim: BodyAnimatorNode = person.get("animator") as BodyAnimatorNode
	if src_anim != null:
		person_clone.gender = src_anim.gender
		person_clone.skin_id = src_anim.skin_id
		person_clone.eyes_id = src_anim.eyes_id
		person_clone.hair_id = src_anim.hair_id
		person_clone.beard_id = src_anim.beard_id
		person_clone.helmet_name = src_anim.helmet_name
		person_clone.shirt_name = src_anim.shirt_name
		person_clone.pants_name = src_anim.pants_name
		person_clone.shoe_name = src_anim.shoe_name
		person_clone.weapon_main_name = src_anim.weapon_main_name
		person_clone.weapon_off_name = src_anim.weapon_off_name
		person_clone.accessory_name = src_anim.accessory_name
	person_clone.apply_appearance()
	person_clone.play("standing")


static func _safe_int(val: Variant) -> int:
	if val is int or val is float:
		return int(val)
	if val is String and str(val).is_valid_int():
		return str(val).to_int()
	return 0


static func _lookup_item_stats(sdb: Node, item_name: String, slot_hint: String = "") -> Dictionary:
	if sdb == null or item_name.is_empty():
		return {}
	if not slot_hint.is_empty():
		match slot_hint:
			"helmet": return sdb.get_helmet_data(item_name)
			"shirt": return sdb.get_shirt_data(item_name)
			"legs": return sdb.get_leg_data(item_name)
			"shoes": return sdb.get_shoe_data(item_name)
			"weapon", "weapon2": return sdb.get_weapon_data(item_name)
			"accessory", "acc": return sdb.get_acc_data(item_name)
	if sdb.has_method("get_item_data"):
		return sdb.get_item_data(item_name)
	for cat in ["helmet", "shirt", "legs", "shoes", "weapon", "acc", "item"]:
		var d: Dictionary = sdb.get_item_stats_data(cat, item_name)
		if not d.is_empty():
			return d
	return {}


func _on_upgrade_pressed(stat_id: String) -> void:
	if person != null:
		person.call("upgrade_stat", stat_id)


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
	return null
