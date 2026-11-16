extends Control
class_name SkillsMenu
## SkillsMenu — Окно навыков и способностей игрока (порт com.menus.SkillsMenu.as).
## Точно воспроизводит Starling-версию:
## - Панель "panel" 735x442 из атласа "skills menu"
## - 5 классовых вкладок-кнопок (basicSkills_btn..cowboySkills_btn)
## - Счетчик SP skillPoints_txt (13, 205, 92x48, stats_font 42)
## - Прокручиваемая область 603x357 в (123, 78) с фоном "skills backdrop" (616x426) и карточками "skill images" (251x126)

signal closed()

const SKILL_IMAGE_MAP: Dictionary = {
	"jump height": "jump-height",
	"critical hit": "critical",
	"loot steal": "loot",
	"training": "training",
	"self rage": "rage",
	"guild rage": "guild-rage",
	"mp restore": "mp-restore",
	"avoidability": "avoidance",
	"speed dash": "dash",
	"accel down": "accel-down",
	"block": "block",
	"power attack": "power-attack",
	"expert warrior": "expert-warrior",
	"multi attack": "multi-attack",
	"air slash": "multi-attack-distance",
	"shield mastery": "shield-mastery",
	"melee knockback": "melee-knockback",
	"spin attack": "spin-attack",
	"arrow barrage": "arrow-barrage",
	"arrow knockback": "arrow-knockback",
	"expert archer": "expert-archer",
	"triple shot": "arrow-triple-shot",
	"arrow rain": "arrow-rain",
	"piercing arrow": "piercing-arrow",
	"down crush": "archer-down",
	"magic shots": "magic-projectiles",
	"expert wizard": "expert-wizard",
	"circular attack": "light-beam",
	"magic distance": "magic-distance",
	"thunder attack": "thunder-attack",
	"self heal": "self-heal",
	"guild heal": "pet-guild-heal",
	"grenade attack": "grenades",
	"upward shoot": "upward-shoot",
	"expert cowboy": "expert-cowboy",
	"bullet distance": "bullet-distance",
	"shotgun attack": "shotgun-attack",
	"bullet knockback": "bullet-knockback",
	"jump grenade": "jump-grenade",
}

const ACTIVATABLE_SKILLS: Array[String] = [
	"self rage",
	"guild rage",
	"self heal",
	"guild heal",
	"power attack",
	"multi attack",
	"air slash",
	"spin attack",
	"arrow barrage",
	"triple shot",
	"arrow rain",
	"piercing arrow",
	"down crush",
	"circular attack",
	"thunder attack",
	"grenade attack",
	"upward shoot",
	"shotgun attack",
	"jump grenade",
]

const CLASS_TINTS: Dictionary = {
	"basic": Color(1.0, 1.0, 1.0, 1.0),
	"warrior": Color(1.0, 0.3, 0.3, 1.0),
	"archer": Color(0.25, 1.0, 0.25, 1.0),
	"wizard": Color(0.196, 0.525, 0.969, 1.0),
	"cowboy": Color(0.969, 0.694, 0.322, 1.0),
}

@export var is_draggable: bool = true

var person: Node = null
var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var current_display: String = "basic"

var panel_bg: TextureRect = null
var close_btn: TextureButton = null
var scroll_btn: TextureButton = null
var mp_usage_btn: TextureButton = null
var mp_info_popup: Panel = null
var sp_label: Label = null
var scroll_container: ScrollContainer = null
var scroll_content: Control = null

# Совместимость с тестами и внешними скриптами
var tab_container: TabContainer = null
var tab_buttons: Dictionary = {}
var skill_cards: Dictionary = {} # skill_id -> { lvl_label, plus_btn, stat_label, dict }

# Уровни изученных навыков игрока { skill_id: current_level }
var learned_skills: Dictionary = {}

func _init(target_person: Node = null) -> void:
	person = target_person


func _ready() -> void:
	custom_minimum_size = Vector2(735, 442)
	size = Vector2(735, 442)
	_build_ui()
	if person != null:
		bind_person(person)


func _build_ui() -> void:
	var atlas_loader: Node = _get_atlas_loader()
	atlas_loader.register_starling_atlas("skills menu")
	atlas_loader.register_starling_atlas("skill images")
	atlas_loader.register_starling_atlas("item menu")
	atlas_loader.register_starling_atlas("character menu")
	var stats_font: Font = atlas_loader.get_bitmap_font("stats_font.fnt")

	# 1. Панель фона "panel" (735x442) — SkillsMenu.as:419-422 (-431, -205)
	var bg_tex: Texture2D = atlas_loader.get_starling_texture("skills menu", "panel")
	panel_bg = TextureRect.new()
	panel_bg.name = "PanelBG"
	panel_bg.texture = bg_tex
	panel_bg.size = Vector2(735, 442)
	panel_bg.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(panel_bg)

	# 2. Кнопка закрытия (SkillsMenu.as:461-468: x=301, y=-191, pivot=(30, 19) -> (702, -5))
	var close_tex: Texture2D = atlas_loader.get_starling_texture("item menu", "x_btn_00")
	var close_hover: Texture2D = atlas_loader.get_starling_texture("item menu", "x_btn_01")
	close_btn = TextureButton.new()
	close_btn.name = "CloseButton"
	close_btn.texture_normal = close_tex
	close_btn.texture_hover = close_hover
	close_btn.position = Vector2(702, -5)
	close_btn.focus_mode = Control.FOCUS_NONE
	close_btn.pressed.connect(close_menu)
	add_child(close_btn)

	# 3. Кнопка прокрутки (SkillsMenu.as:28, 469-475: x=277, y=-128, pivot=(15, 19) -> (693, 58))
	var scroll_tex: Texture2D = atlas_loader.get_starling_texture("item menu", "scroll")
	if scroll_tex != null:
		scroll_btn = TextureButton.new()
		scroll_btn.name = "ScrollButton"
		scroll_btn.texture_normal = scroll_tex
		scroll_btn.position = Vector2(693, 58)
		scroll_btn.focus_mode = Control.FOCUS_NONE
		scroll_btn.pressed.connect(_on_scroll_btn_pressed)
		add_child(scroll_btn)

	# 4. Кнопка MP usage info (SkillsMenu.as:476-481: x=-336, y=-110, pivot=(9, 9) -> (86, 86))
	var info_tex: Texture2D = atlas_loader.get_starling_texture("character menu", "info_btn")
	if info_tex != null:
		mp_usage_btn = TextureButton.new()
		mp_usage_btn.name = "MPUsageBtn"
		mp_usage_btn.texture_normal = info_tex
		mp_usage_btn.position = Vector2(86, 86)
		mp_usage_btn.focus_mode = Control.FOCUS_NONE
		mp_usage_btn.pressed.connect(_on_mp_usage_pressed)
		add_child(mp_usage_btn)

	# 5. Счетчик SP (SkillsMenu.as:30, 482-484: x=-418, y=0 -> (13, 205), 92x48, stats_font 42)
	sp_label = Label.new()
	sp_label.name = "SPLabel"
	sp_label.text = "0"
	sp_label.position = Vector2(13, 205)
	sp_label.size = Vector2(92, 48)
	sp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sp_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	sp_label.add_theme_font_override("font", stats_font)
	sp_label.add_theme_font_size_override("font_size", 42)
	sp_label.add_theme_color_override("font_color", Color.WHITE)
	sp_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(sp_label)

	# 6. 5 классовых вкладок (SkillsMenu.as:423-454)
	var tabs_cfg: Array[Dictionary] = [
		{"cat": "basic", "tex": "basicSkills_btn", "pos": Vector2(127, 40)},
		{"cat": "warrior", "tex": "warriorSkills_btn", "pos": Vector2(224, 39)},
		{"cat": "archer", "tex": "archerSkills_btn", "pos": Vector2(341, 40)},
		{"cat": "wizard", "tex": "wizardSkills_btn", "pos": Vector2(457, 32)},
		{"cat": "cowboy", "tex": "cowboySkills_btn", "pos": Vector2(572, 39)},
	]
	for cfg: Dictionary in tabs_cfg:
		var cat: String = cfg["cat"]
		var t_btn: TextureButton = TextureButton.new()
		t_btn.name = "Tab_%s" % cat.capitalize()
		t_btn.texture_normal = atlas_loader.get_starling_texture("skills menu", cfg["tex"])
		t_btn.position = cfg["pos"]
		t_btn.focus_mode = Control.FOCUS_NONE
		t_btn.pressed.connect(func() -> void: display_skills(cat))
		add_child(t_btn)
		tab_buttons[cat] = t_btn

	# Скрытый TabContainer для совместимости с Stage 8 тестами
	tab_container = TabContainer.new()
	tab_container.name = "TabContainer"
	tab_container.visible = false
	tab_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(tab_container)
	for cat_name: String in ["Basic", "Warrior", "Archer", "Wizard", "Cowboy"]:
		var dummy: Control = Control.new()
		dummy.name = cat_name
		tab_container.add_child(dummy)

	# 7. Клиппированная область прокрутки (SkillsMenu.as:455-460: mask (-212,-22,603,357) + scrollArea (-96,-105) + (431,205) -> (123, 78, 603, 357))
	scroll_container = ScrollContainer.new()
	scroll_container.name = "ScrollArea"
	scroll_container.position = Vector2(123, 78)
	scroll_container.size = Vector2(603, 357)
	scroll_container.clip_contents = true
	scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll_container)

	scroll_content = Control.new()
	scroll_content.name = "ScrollContent"
	scroll_container.add_child(scroll_content)

	display_skills("basic")


func display_skills(category: String) -> void:
	current_display = category.to_lower()
	var categories: Array[String] = ["basic", "warrior", "archer", "wizard", "cowboy"]
	var tab_idx: int = categories.find(current_display)
	if tab_idx >= 0 and tab_container != null:
		tab_container.current_tab = tab_idx

	for child: Node in scroll_content.get_children():
		child.queue_free()
	skill_cards.clear()

	var atlas_loader: Node = _get_atlas_loader()
	var stats_font: Font = atlas_loader.get_bitmap_font("stats_font.fnt")
	var backdrop_tex: Texture2D = atlas_loader.get_starling_texture("skills menu", "skills backdrop")
	var more_tex: Texture2D = atlas_loader.get_starling_texture("character menu", "more_btn_00")
	var more_hover: Texture2D = atlas_loader.get_starling_texture("character menu", "more_btn_01")

	var sdb: Node = _get_stats_db()
	var raw_skills: Array = []
	if sdb != null and sdb.skills_meta.has("skills") and sdb.skills_meta["skills"] is Array:
		raw_skills = sdb.skills_meta["skills"]

	var cat_skills: Array[Dictionary] = []
	for sk: Variant in raw_skills:
		if sk is Dictionary and str(sk.get("category", "")).to_lower() == current_display:
			cat_skills.append(sk)

	var card_spacing: float = 212.0
	var total_height: float = maxf(357.0, float(cat_skills.size()) * card_spacing + 24.0)
	scroll_content.custom_minimum_size = Vector2(603.0, total_height)
	scroll_content.size = Vector2(603.0, total_height)

	# Фон "skills backdrop" (616x426) с тинтом по классу (SkillsMenu.as:1996-2026)
	if backdrop_tex != null:
		var num_backdrops: int = maxi(1, int(ceil(total_height / 423.0)))
		var tint: Color = CLASS_TINTS.get(current_display, Color.WHITE)
		for i: int in range(num_backdrops):
			var bd: TextureRect = TextureRect.new()
			bd.name = "Backdrop_%d" % i
			bd.texture = backdrop_tex
			bd.position = Vector2(-10.0, -1.0 + float(i) * 423.0)
			bd.size = Vector2(616.0, 426.0)
			bd.modulate = tint
			bd.mouse_filter = Control.MOUSE_FILTER_IGNORE
			scroll_content.add_child(bd)

	# Карточки навыков (SkillsMenu.as:1662-1994)
	for idx: int in range(cat_skills.size()):
		var sk: Dictionary = cat_skills[idx]
		var skill_id: String = str(sk.get("id", ""))
		var title_str: String = str(sk.get("title", skill_id)).capitalize()
		var desc_str: String = str(sk.get("description", ""))
		var max_lvl: int = int(sk.get("maxLvl", 10))
		var required_sp: int = int(sk.get("requiredSkillPointsPerUpgrade", 1))
		var mp_cost: int = int(sk.get("mpCost", 0))
		var use_key: String = str(sk.get("useKey", "Passive"))

		var base_y: float = 33.0 + float(idx) * card_spacing

		# Подложка 0x333333 (257x134)
		var box_bg: ColorRect = ColorRect.new()
		box_bg.name = "BoxBG_%s" % skill_id
		box_bg.color = Color(0.2, 0.2, 0.2, 1.0)
		box_bg.position = Vector2(7.0, base_y - 3.0)
		box_bg.size = Vector2(257.0, 134.0)
		box_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		scroll_content.add_child(box_bg)

		# Изображение навыка (251x126)
		var img_name: String = SKILL_IMAGE_MAP.get(skill_id, "")
		var img_tex: Texture2D = atlas_loader.get_starling_texture("skill images", img_name) if not img_name.is_empty() else null
		if img_tex != null:
			var img_rect: TextureRect = TextureRect.new()
			img_rect.name = "SkillImg_%s" % skill_id
			img_rect.texture = img_tex
			img_rect.position = Vector2(10.0, base_y)
			img_rect.size = Vector2(251.0, 126.0)
			img_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
			scroll_content.add_child(img_rect)

		# Заголовок навыка над карточкой
		var title_lbl: Label = Label.new()
		title_lbl.name = "Title_%s" % skill_id
		title_lbl.text = title_str
		title_lbl.position = Vector2(11.0, base_y - 25.0)
		title_lbl.size = Vector2(250.0, 22.0)
		title_lbl.add_theme_font_override("font", stats_font)
		title_lbl.add_theme_font_size_override("font_size", 18)
		title_lbl.add_theme_color_override("font_color", Color.WHITE)
		title_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		scroll_content.add_child(title_lbl)

		# Описание справа от картинки (SkillsMenu.as:1585-1605: x=53+212=265, width=302)
		var desc_lbl: Label = Label.new()
		desc_lbl.name = "Desc_%s" % skill_id
		desc_lbl.text = desc_str
		desc_lbl.position = Vector2(265.0, base_y)
		desc_lbl.size = Vector2(302.0, 126.0)
		desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc_lbl.clip_text = true
		var chosen_desc_sz: int = 14
		if stats_font != null:
			for try_sz: int in [14, 13, 12, 11, 10]:
				chosen_desc_sz = try_sz
				var measured: Vector2 = stats_font.get_multiline_string_size(desc_str, HORIZONTAL_ALIGNMENT_LEFT, 302.0, try_sz)
				if measured.y <= 126.0:
					break
			desc_lbl.add_theme_font_override("font", stats_font)
		desc_lbl.add_theme_font_size_override("font_size", chosen_desc_sz)
		desc_lbl.add_theme_color_override("font_color", Color.WHITE)
		desc_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		scroll_content.add_child(desc_lbl)

		# Желтые поля под картинкой (AllTextFormats.skill_textFormat: stats_font 14, 0xFFFF00)
		var yellow: Color = Color(1.0, 1.0, 0.0, 1.0)
		var lvl_lbl: Label = _make_skill_label("Lvl_%s" % skill_id, Vector2(11.0, base_y + 130.0), Vector2(60.0, 20.0), stats_font, yellow)
		scroll_content.add_child(lvl_lbl)

		var req_lbl: Label = _make_skill_label("Req_%s" % skill_id, Vector2(236.0, base_y + 130.0), Vector2(170.0, 20.0), stats_font, yellow)
		req_lbl.text = "Points required: %d" % required_sp
		scroll_content.add_child(req_lbl)

		var max_lbl: Label = _make_skill_label("Max_%s" % skill_id, Vector2(414.0, base_y + 130.0), Vector2(160.0, 20.0), stats_font, yellow)
		max_lbl.text = "Max lvl: %s" % (str(max_lvl) if max_lvl < 999999 else "infinite")
		scroll_content.add_child(max_lbl)

		var effect_lbl: Label = _make_skill_label("Effect_%s" % skill_id, Vector2(11.0, base_y + 151.0), Vector2(220.0, 20.0), stats_font, yellow)
		scroll_content.add_child(effect_lbl)

		var mp_lbl: Label = null
		var effective_base_mp: int = 0 if skill_id == "self rage" else mp_cost
		if skill_id == "self rage" or effective_base_mp > 0:
			mp_lbl = _make_skill_label("MP_%s" % skill_id, Vector2(236.0, base_y + 151.0), Vector2(160.0, 20.0), stats_font, yellow)
			mp_lbl.text = "MP: %d" % _calc_display_mp(skill_id, effective_base_mp)
			scroll_content.add_child(mp_lbl)

		if use_key != "Passive" and use_key != "None" and not use_key.is_empty():
			var key_lbl: Label = _make_skill_label("Key_%s" % skill_id, Vector2(414.0, base_y + 151.0), Vector2(180.0, 20.0), stats_font, yellow)
			key_lbl.text = "use: %s" % use_key
			scroll_content.add_child(key_lbl)

		# Кнопка "+" (more_btn_00) рядом с lvl
		var plus_btn: TextureButton = TextureButton.new()
		plus_btn.name = "Upgrade_%s" % skill_id
		plus_btn.texture_normal = more_tex
		plus_btn.texture_hover = more_hover
		plus_btn.position = Vector2(64.0, base_y + 130.0)
		plus_btn.focus_mode = Control.FOCUS_NONE
		plus_btn.pressed.connect(func() -> void: _on_upgrade_skill(sk))
		scroll_content.add_child(plus_btn)

		var activate_btn: Button = null
		if ACTIVATABLE_SKILLS.has(skill_id):
			activate_btn = Button.new()
			activate_btn.name = "Activate_%s" % skill_id
			activate_btn.text = "Activate"
			activate_btn.position = Vector2(414.0, base_y + 170.0)
			activate_btn.size = Vector2(88.0, 22.0)
			activate_btn.focus_mode = Control.FOCUS_NONE
			activate_btn.add_theme_font_override("font", stats_font)
			activate_btn.add_theme_font_size_override("font_size", 13)
			activate_btn.pressed.connect(func() -> void: _on_activate_skill(sk))
			scroll_content.add_child(activate_btn)

		skill_cards[skill_id] = {
			"dict": sk,
			"lvl_label": lvl_lbl,
			"effect_label": effect_lbl,
			"mp_label": mp_lbl,
			"base_mp": effective_base_mp,
			"plus_btn": plus_btn,
			"activate_btn": activate_btn,
		}

	scroll_container.scroll_vertical = 0
	update_display()


func _make_skill_label(lbl_name: String, pos: Vector2, sz: Vector2, font: Font, color: Color) -> Label:
	var lbl: Label = Label.new()
	lbl.name = lbl_name
	lbl.position = pos
	lbl.size = sz
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl.add_theme_font_override("font", font)
	lbl.add_theme_font_size_override("font_size", 14)
	lbl.add_theme_color_override("font_color", color)
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return lbl


func _get_skill_level(skill_dict: Dictionary) -> int:
	var skill_id: String = str(skill_dict.get("id", ""))
	if person != null:
		var p_levels: Variant = person.get("skill_levels")
		if p_levels is Dictionary and (p_levels as Dictionary).has(skill_id):
			return int((p_levels as Dictionary)[skill_id])
		var prop_name: String = str(skill_dict.get("personProperty", ""))
		if not prop_name.is_empty():
			var prop_val: Variant = person.get(prop_name)
			if prop_val != null:
				return int(prop_val)
	return int(learned_skills.get(skill_id, 0))


func _on_upgrade_skill(skill_dict: Dictionary) -> void:
	var skill_id: String = str(skill_dict.get("id", ""))
	var max_lvl: int = int(skill_dict.get("maxLvl", 10))
	var required_sp: int = maxi(1, int(skill_dict.get("requiredSkillPointsPerUpgrade", 1)))
	var cur_lvl: int = _get_skill_level(skill_dict)

	if cur_lvl >= max_lvl:
		return

	if person != null:
		var sp_val: Variant = person.get("skill_points")
		var sp: int = int(sp_val if sp_val != null else 0)
		if sp < required_sp:
			return
		if person.has_method("upgrade_skill"):
			var ok: bool = bool(person.call("upgrade_skill", skill_id, required_sp, max_lvl))
			if ok:
				learned_skills[skill_id] = _get_skill_level(skill_dict)
				update_display()
			return
		# Прямое списание SP и синхронизация со словарем/свойством, если upgrade_skill еще не реализован
		person.set("skill_points", sp - required_sp)
		cur_lvl += 1
		learned_skills[skill_id] = cur_lvl
		var p_levels: Variant = person.get("skill_levels")
		if p_levels is Dictionary:
			(p_levels as Dictionary)[skill_id] = cur_lvl
		var prop_name: String = str(skill_dict.get("personProperty", ""))
		if not prop_name.is_empty() and person.get(prop_name) != null:
			person.set(prop_name, cur_lvl)
		if person.has_signal("stats_updated"):
			person.stats_updated.emit()
		update_display()
	else:
		cur_lvl += 1
		learned_skills[skill_id] = cur_lvl
		update_display()


func _on_activate_skill(skill_dict: Dictionary) -> void:
	var skill_id: String = str(skill_dict.get("id", ""))
	if _get_skill_level(skill_dict) <= 0:
		return
	if person != null and person.has_method("use_skill"):
		person.call("use_skill", skill_id)
		update_display()


func _on_scroll_btn_pressed() -> void:
	if scroll_container != null:
		scroll_container.scroll_vertical += 100


func _on_mp_usage_pressed() -> void:
	if mp_info_popup != null:
		mp_info_popup.visible = not mp_info_popup.visible
		return
	mp_info_popup = Panel.new()
	mp_info_popup.name = "MPInfoPopup"
	mp_info_popup.position = Vector2(185, 110)
	mp_info_popup.size = Vector2(365, 175)
	mp_info_popup.z_index = 20
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.11, 0.12, 0.16, 0.96)
	style.border_color = Color(0.85, 0.72, 0.3, 1.0)
	style.set_border_width_all(2)
	style.set_corner_radius_all(6)
	mp_info_popup.add_theme_stylebox_override("panel", style)
	add_child(mp_info_popup)

	var lbl := Label.new()
	lbl.position = Vector2(14, 14)
	lbl.size = Vector2(337, 115)
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lbl.add_theme_font_size_override("font_size", 13)
	lbl.add_theme_color_override("font_color", Color.WHITE)
	lbl.text = "The amount of MP you use increases as you get stronger. Every 100 levels your character gains, you use 1x the amount of MP as stated. For example, if you are level 320 and a skill says it uses 6 MP, it will cost you 24mp."
	mp_info_popup.add_child(lbl)

	var ok_btn := Button.new()
	ok_btn.text = "OK"
	ok_btn.position = Vector2(142, 134)
	ok_btn.size = Vector2(80, 28)
	ok_btn.focus_mode = Control.FOCUS_NONE
	ok_btn.pressed.connect(func() -> void:
		if mp_info_popup != null:
			mp_info_popup.visible = false
	)
	mp_info_popup.add_child(ok_btn)


func _calc_display_mp(skill_id: String, base_mp: int) -> int:
	if skill_id == "self rage" or base_mp <= 0:
		return 0
	if person != null and person.has_method("level_mp"):
		return int(person.call("level_mp", base_mp))
	return base_mp


func bind_person(target_person: Node) -> void:
	if person != null and person.stats_updated.is_connected(update_display):
		person.stats_updated.disconnect(update_display)
	if person != null and person.has_signal("exp_changed") and person.exp_changed.is_connected(_on_person_exp_changed):
		person.exp_changed.disconnect(_on_person_exp_changed)

	person = target_person
	if person != null:
		person.stats_updated.connect(update_display)
		if person.has_signal("exp_changed"):
			person.exp_changed.connect(_on_person_exp_changed)
		update_display()


func _on_person_exp_changed(_exp: int, _max_exp: int, _lvl: int) -> void:
	update_display()


func update_display() -> void:
	var sp: int = 0
	if person != null:
		var sp_val: Variant = person.get("skill_points")
		sp = int(sp_val if sp_val != null else 0)
	if sp_label != null:
		sp_label.text = str(sp)

	for skill_id: String in skill_cards.keys():
		var card: Dictionary = skill_cards[skill_id]
		var sk: Dictionary = card["dict"]
		var cur_lvl: int = _get_skill_level(sk)
		var max_lvl: int = int(sk.get("maxLvl", 10))
		var required_sp: int = maxi(1, int(sk.get("requiredSkillPointsPerUpgrade", 1)))

		var lvl_lbl: Label = card["lvl_label"]
		lvl_lbl.text = "lvl: %d" % cur_lvl

		var effect_lbl: Label = card["effect_label"]
		if cur_lvl > 0:
			if skill_id == "mp restore":
				effect_lbl.text = "MP restored: %d" % (cur_lvl * 3 if cur_lvl > 1 else 0)
			elif skill_id == "self rage":
				effect_lbl.text = "Energy: %d" % (cur_lvl * 57)
			else:
				effect_lbl.text = str(sk.get("effectText", ""))
		else:
			effect_lbl.text = ""

		var mp_lbl: Label = card.get("mp_label", null) as Label
		if mp_lbl != null:
			mp_lbl.text = "MP: %d" % _calc_display_mp(skill_id, int(card.get("base_mp", 0)))

		var plus_btn: TextureButton = card["plus_btn"]
		if person != null:
			plus_btn.visible = (cur_lvl < max_lvl) and (sp >= required_sp)
		else:
			plus_btn.visible = (cur_lvl < max_lvl)

		var activate_btn: Button = card.get("activate_btn", null) as Button
		if activate_btn != null:
			activate_btn.visible = (cur_lvl > 0)
			activate_btn.disabled = (cur_lvl <= 0)


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
