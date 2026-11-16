extends Control
class_name CreateCharacterMenu
## CreateCharacterMenu — Меню настройки и создания персонажа (порт CreateMenu.as:84-710):
## Пол, цвет кожи (1..4), прическа (включая 3 = bald), глаза, борода, класс (warrior, archer, mage, cowboy),
## живой предпросмотр central personClone ("white shirt", "green shorts", "white shoe" + стартовое оружие),
## боковые превью leftPersonClone / rightPersonClone в высокоуровневой экипировке, иконка класса,
## 6 пальм из trees_fish, текстуры атласа "char create menu", а также режим Offline Sandbox с Quick Start.

signal character_created(join_data: Dictionary)
signal back_to_main_menu()

# Опции пола
const GENDERS: Array[String] = ["boy", "girl"]

# Опции классов и их описания (CreateMenu.as:687-704)
const CLASSES: Array[String] = ["warrior", "archer", "mage", "cowboy"]
const CLASS_TITLES: Dictionary = {
	"warrior": "The Warrior",
	"archer": "The Archer",
	"mage": "The Mage",
	"cowboy": "The Cowboy"
}
const CLASS_ICONS: Dictionary = {
	"warrior": "beholder sword",
	"archer": "natures bow",
	"mage": "blue sphere staff",
	"cowboy": "M16"
}
const CLASS_STARTER_WEAPONS: Dictionary = {
	"warrior": "stick",
	"archer": "slingshot",
	"mage": "basic wand",
	"cowboy": "airsoft gun"
}
const CLASS_DESCRIPTIONS: Dictionary = {
	"warrior": "Warriors are focused towards power and defense.  They wear highly defensive armor allowing them to get up close and personal with enemies and deal large amounts of damage in a single blow.  The armor and helmets that warriors wear are often aggresive and fully protected for a high resistance to damage.   Warriors can dual weild, use shields, and make good use of large melee weapons.",
	"archer": "Archers are ideal for long distance attacks. Their bows allow them to hit enemies from across screen.  While their overall damage isn't quite as high as a warrior or mage, their attacking distance is unmatched.  Archers equipment is often crafted from natural materials such as leaves or green materials.  Their skills allow them to do things such as shoot multiple arrows at once or straight up into the air.",
	"mage": "Mages can deal extremely high damage over a short period of time at the cost of using MP. While they deal less damage than a warrior in a single blow, their projectiles can hit multiple times. A mages projectiles allow them to make attacks without having to be directly next to an enemy. Although they have some range capabilities, they are not as well equipped as an archer for long distance attacks.",
	"cowboy": "Cowboys are masters of guns.  They deal very low damage per shot but are able to dish out several shots per second depending on their weapon.  Their attacking distance is better than a mage but just less than an archer's.  Special abilities include the ability to throw grenades and attack upwards.  Cowboys often wear pirate clothes or cowboy hats styled in brown or black outfits."
}

# Названия для списков (BodyAnimator.as:1772-2083)
const SKIN_NAMES: Dictionary = {
	1: "pale",
	2: "peach",
	3: "tan",
	4: "dark"
}

const BEARD_NAMES: Dictionary = {
	1: "none",
	2: "brown goatee",
	3: "pointed goatee",
	4: "chin beard",
	5: "curly stache",
	6: "mustache",
	7: "handlebars",
	8: "full red beard"
}

const HAIR_NAMES: Dictionary = {
	1: "brown",
	2: "fro",
	3: "bald",
	4: "red curly",
	5: "mohawk",
	6: "thin black",
	7: "slick black",
	8: "spiked blond",
	9: "blond bowl",
	10: "medium brown",
	11: "blonde tails",
	12: "brown sag",
	13: "granny hair",
	14: "long black",
	15: "black ponytail",
	16: "red spiked",
	17: "short brown",
	18: "comb over",
	19: "curly black",
	20: "drooping blonde",
	21: "brown ponytails",
	22: "ratty blonde",
	23: "blonde ponytail",
	24: "brown emo",
	25: "blonde stylin",
	26: "light blonde emo"
}

const EYES_NAMES: Dictionary = {
	1: "round",
	2: "foreign",
	3: "mad",
	4: "old",
	5: "weird",
	6: "tall",
	7: "round girl",
	8: "foreign girl",
	9: "mad girl",
	10: "old girl",
	11: "weird girl",
	12: "tall girl"
}

const EYES_MALE: Array[int] = [1, 2, 3, 4, 5, 6]
const EYES_FEMALE: Array[int] = [7, 8, 9, 10, 11, 12]

# Допустимые прически (CreateMenu.as:440-504: male включает 3 = bald)
const HAIR_MALE: Array[int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 17, 18, 19, 20, 24, 25, 26]
const HAIR_FEMALE: Array[int] = [11, 12, 13, 14, 15, 21, 22, 23]

# Примеры экипировки для боковых клонов (CreateMenu.as:615-680)
const EXAMPLE_OUTFITS: Dictionary = {
	"warrior1": {
		"helmet": "helmet of hatred", "shirt": "armor of hatred", "pants": "legs of hatred",
		"weapon": "single hatred blade", "weapon2": "single hatred blade", "shoes": "imperial boot"
	},
	"warrior2": {
		"helmet": "knight helmet", "shirt": "knight armor", "pants": "knight armor legs",
		"weapon": "teardrop blade", "weapon2": "none", "shoes": "steel boot"
	},
	"archer1": {
		"helmet": "archer hat", "shirt": "archer shirt", "pants": "archer pants",
		"weapon": "triple leaf bow", "weapon2": "none", "shoes": "elf bell shoe"
	},
	"archer2": {
		"helmet": "strong basket helmet", "shirt": "strong armor", "pants": "strong legs",
		"weapon": "night glow bow", "weapon2": "none", "shoes": "double bell shoe"
	},
	"mage1": {
		"helmet": "blue wizard belt hat", "shirt": "blue wizard robe", "pants": "blue wizard pants",
		"weapon": "nightingale wand", "weapon2": "star wand", "shoes": "blue magic shoe"
	},
	"mage2": {
		"helmet": "neon magic helmet", "shirt": "neon magic suit", "pants": "neon magic legs",
		"weapon": "spherical staff", "weapon2": "none", "shoes": "element boot"
	},
	"cowboy1": {
		"helmet": "cowboy hat", "shirt": "cowboy shirt", "pants": "cowboy pants",
		"weapon": "shotgun", "weapon2": "none", "shoes": "brown shoe"
	},
	"cowboy2": {
		"helmet": "pirate hat", "shirt": "pirate vest", "pants": "pirate pants",
		"weapon": "skullcrusher gun", "weapon2": "none", "shoes": "skull crusher boot"
	}
}

# Состояние выбора
var is_sandbox_mode: bool = false
var selected_gender: String = "boy"
var selected_skin: int = 1
var selected_eyes: int = 1
var selected_hair: int = 1
var selected_beard: int = 1
var selected_class: String = "warrior"
var character_name: String = ""

# Узлы UI (MenuRoot центрирован в (0.5, 0.5), координаты строго по CreateMenu.as)
@onready var menu_root: Control = $MenuRoot
@onready var non_change_frame: TextureRect = $MenuRoot/NonChangeFrame
@onready var sandbox_banner: Label = $MenuRoot/SandboxBanner
@onready var name_input: LineEdit = $MenuRoot/NameInputBg/LineEdit
@onready var password_label: Label = $MenuRoot/PasswordColonLabel
@onready var password_input: LineEdit = $MenuRoot/PassInputBg/LineEdit
@onready var email_label: Label = $MenuRoot/EmailColonLabel
@onready var email_input: LineEdit = $MenuRoot/EmailInputBg/LineEdit
@onready var email_notice_label: Label = $MenuRoot/EmailNoticeLabel
@onready var name_input_bg: TextureRect = $MenuRoot/NameInputBg
@onready var pass_input_bg: TextureRect = $MenuRoot/PassInputBg
@onready var email_input_bg: TextureRect = $MenuRoot/EmailInputBg

@onready var gender_label: Label = $MenuRoot/GenderRow/ValueLabel
@onready var skin_label: Label = $MenuRoot/SkinRow/ValueLabel
@onready var hair_label: Label = $MenuRoot/HairRow/ValueLabel
@onready var eyes_label: Label = $MenuRoot/EyesRow/ValueLabel
@onready var beard_box: Control = $MenuRoot/BeardBox
@onready var beard_label: Label = $MenuRoot/BeardBox/ValueLabel
@onready var class_label: Label = $MenuRoot/ClassRow/ValueLabel
@onready var class_title_label: Label = $MenuRoot/ClassTitleLabel
@onready var class_item_icon: TextureRect = $MenuRoot/ClassItemIcon
@onready var class_desc_label: Label = $MenuRoot/ClassDescLabel
@onready var status_label: Label = $StatusLabel

# Кнопки (TextureButton из атласа "char create menu")
@onready var gender_left: TextureButton = $MenuRoot/GenderRow/LeftBtn
@onready var gender_right: TextureButton = $MenuRoot/GenderRow/RightBtn
@onready var skin_left: TextureButton = $MenuRoot/SkinRow/LeftBtn
@onready var skin_right: TextureButton = $MenuRoot/SkinRow/RightBtn
@onready var hair_left: TextureButton = $MenuRoot/HairRow/LeftBtn
@onready var hair_right: TextureButton = $MenuRoot/HairRow/RightBtn
@onready var eyes_left: TextureButton = $MenuRoot/EyesRow/LeftBtn
@onready var eyes_right: TextureButton = $MenuRoot/EyesRow/RightBtn
@onready var beard_left: TextureButton = $MenuRoot/BeardBox/LeftBtn
@onready var beard_right: TextureButton = $MenuRoot/BeardBox/RightBtn
@onready var class_left: TextureButton = $MenuRoot/ClassRow/LeftBtn
@onready var class_right: TextureButton = $MenuRoot/ClassRow/RightBtn

@onready var quick_start_btn: Button = $MenuRoot/QuickStartBtn
@onready var finish_btn: TextureButton = $MenuRoot/FinishBtn
@onready var back_btn: TextureButton = $MenuRoot/BackBtn
@onready var terms_btn: TextureButton = $MenuRoot/TermsBtn

# Узлы превью персонажа
@onready var preview_platform: TextureRect = $MenuRoot/Platform
@onready var preview_head: TextureRect = $MenuRoot/LegacyPreviewHead
@onready var center_person_holder: Node2D = $MenuRoot/CenterPersonPreview
@onready var left_person_holder: Node2D = $MenuRoot/LeftPersonPreview
@onready var right_person_holder: Node2D = $MenuRoot/RightPersonPreview

var center_person_clone: BodyAnimatorNode = null
var left_person_clone: BodyAnimatorNode = null
var right_person_clone: BodyAnimatorNode = null
var _anim_accum: float = 0.0


func _get_atlas_loader() -> Node:
	if has_node("/root/StarlingAtlasLoader"):
		return get_node("/root/StarlingAtlasLoader")
	return null


func _get_pio_client() -> Node:
	if has_node("/root/PlayerIOClient"):
		return get_node("/root/PlayerIOClient")
	return null


func set_sandbox_mode(enabled: bool) -> void:
	is_sandbox_mode = enabled
	_apply_sandbox_mode_ui()


func _ready() -> void:
	# GameMain.as:12154 — name_txt по умолчанию пустой
	if name_input:
		name_input.text = ""
	_init_preview_assets()
	_init_side_clones()
	_connect_controls()
	_apply_sandbox_mode_ui()
	_update_ui()
	_update_preview()


func _process(delta: float) -> void:
	# CreateMenu.as:741-752 — personClone.bodyAnimator.onEnter() на 30 FPS
	if center_person_clone == null:
		return
	_anim_accum += delta
	while _anim_accum >= 1.0 / 30.0:
		_anim_accum -= 1.0 / 30.0
		center_person_clone.advance_frame()


func _apply_sandbox_mode_ui() -> void:
	if sandbox_banner:
		sandbox_banner.visible = is_sandbox_mode
	if quick_start_btn:
		quick_start_btn.visible = is_sandbox_mode
	if password_label:
		password_label.text = "pass (opt):" if is_sandbox_mode else "password:"
	if password_input:
		password_input.placeholder_text = "Optional in Sandbox" if is_sandbox_mode else ""
	if email_label:
		email_label.text = "mail (opt):" if is_sandbox_mode else "*email:"
	if email_input:
		email_input.placeholder_text = "Optional in Sandbox" if is_sandbox_mode else ""


func _attach_hover_scale(btn: Control) -> void:
	if btn == null:
		return
	btn.mouse_entered.connect(func() -> void: btn.scale = Vector2(0.95, 0.95))
	btn.mouse_exited.connect(func() -> void: btn.scale = Vector2(1.0, 1.0))


func _init_preview_assets() -> void:
	var loader: Node = _get_atlas_loader()
	if not loader:
		return

	loader.register_starling_atlas("items_pets_bodies")
	loader.register_starling_atlas("char create menu")

	if non_change_frame:
		var frame_tex: Texture2D = loader.get_texture("nonChange", "char create menu")
		if frame_tex:
			non_change_frame.texture = frame_tex

	if preview_platform:
		var plat_tex: Texture2D = loader.get_texture("wooden platform", "char create menu")
		if plat_tex:
			preview_platform.texture = plat_tex

	var input_tex: Texture2D = loader.get_texture("input box", "char create menu")
	if input_tex:
		for bg in [name_input_bg, pass_input_bg, email_input_bg]:
			if bg:
				bg.texture = input_tex

	var left_up: Texture2D = loader.get_texture("left_00", "char create menu")
	var left_over: Texture2D = loader.get_texture("left_01", "char create menu")
	for btn in [class_left, gender_left, hair_left, eyes_left, skin_left, beard_left]:
		if btn:
			if left_up: btn.texture_normal = left_up
			if left_over: btn.texture_hover = left_over
			_attach_hover_scale(btn)

	var right_up: Texture2D = loader.get_texture("right_00", "char create menu")
	var right_over: Texture2D = loader.get_texture("right_01", "char create menu")
	for btn in [class_right, gender_right, hair_right, eyes_right, skin_right, beard_right]:
		if btn:
			if right_up: btn.texture_normal = right_up
			if right_over: btn.texture_hover = right_over
			_attach_hover_scale(btn)

	if finish_btn:
		var fin_tex: Texture2D = loader.get_texture("finished_00", "char create menu")
		if fin_tex:
			finish_btn.texture_normal = fin_tex
		_attach_hover_scale(finish_btn)
	if back_btn:
		var back_tex: Texture2D = loader.get_texture("back_00", "char create menu")
		if back_tex:
			back_btn.texture_normal = back_tex
		_attach_hover_scale(back_btn)
	if terms_btn:
		var terms_tex: Texture2D = loader.get_texture("terms_00", "char create menu")
		if terms_tex:
			terms_btn.texture_normal = terms_tex
		_attach_hover_scale(terms_btn)

	# 6 пальм из trees_fish (CreateMenu.as:161-166, 303-326)
	var palm_tex: Texture2D = loader.get_texture("palm tree", "trees_fish")
	if palm_tex:
		var palm_size: Vector2 = palm_tex.get_size()
		for i in range(1, 7):
			var tree_node: TextureRect = get_node_or_null("MenuRoot/PalmTreesLayer/Tree%d" % i) as TextureRect
			if tree_node:
				tree_node.texture = palm_tex
				tree_node.size = palm_size

	# Шрифты строго по AllTextFormats.as:192, 197-200
	var stats_font: Font = loader.get_bitmap_font("stats_font.fnt")
	var readable_font: Font = loader.get_bitmap_font("readable_font.fnt")
	if stats_font:
		for ctrl in [class_title_label, password_label, email_label, gender_label, skin_label, hair_label, eyes_label, beard_label, class_label]:
			if ctrl:
				ctrl.add_theme_font_override("font", stats_font)
	if readable_font:
		for ctrl in [class_desc_label, email_notice_label, status_label, sandbox_banner]:
			if ctrl:
				ctrl.add_theme_font_override("font", readable_font)


func _init_side_clones() -> void:
	if center_person_holder:
		center_person_holder.scale = Vector2(1.0, 1.0)
		center_person_clone = BodyAnimatorNode.new()
		center_person_clone.name = "CenterPersonClone"
		center_person_holder.add_child(center_person_clone)
		center_person_clone.play("standing")
	if left_person_holder:
		left_person_clone = BodyAnimatorNode.new()
		left_person_clone.name = "LeftPersonClone"
		left_person_holder.scale = Vector2(2.0, 2.0)
		left_person_holder.add_child(left_person_clone)
		left_person_clone.hold_frame("standing", 0)
	if right_person_holder:
		right_person_clone = BodyAnimatorNode.new()
		right_person_clone.name = "RightPersonClone"
		right_person_holder.scale = Vector2(-2.0, 2.0)
		right_person_holder.add_child(right_person_clone)
		right_person_clone.hold_frame("standing", 0)


func _apply_example_outfit(clone: BodyAnimatorNode, example_key: String) -> void:
	if clone == null:
		return
	var outfit: Dictionary = EXAMPLE_OUTFITS.get(example_key, {})
	if outfit.is_empty():
		return
	clone.helmet_name = str(outfit.get("helmet", "none"))
	clone.shirt_name = str(outfit.get("shirt", "white shirt"))
	clone.pants_name = str(outfit.get("pants", "green shorts"))
	clone.shoe_name = str(outfit.get("shoes", "white shoe"))
	clone.weapon_main_name = str(outfit.get("weapon", "stick"))
	clone.weapon_off_name = str(outfit.get("weapon2", "none"))
	clone.apply_appearance()
	clone.refresh_equipment_textures()
	clone.hold_frame("standing", 0)


func _connect_controls() -> void:
	if gender_left: gender_left.pressed.connect(func() -> void: _cycle_gender(-1))
	if gender_right: gender_right.pressed.connect(func() -> void: _cycle_gender(1))

	if skin_left: skin_left.pressed.connect(func() -> void: _cycle_skin(-1))
	if skin_right: skin_right.pressed.connect(func() -> void: _cycle_skin(1))

	if hair_left: hair_left.pressed.connect(func() -> void: _cycle_hair(-1))
	if hair_right: hair_right.pressed.connect(func() -> void: _cycle_hair(1))

	if eyes_left: eyes_left.pressed.connect(func() -> void: _cycle_eyes(-1))
	if eyes_right: eyes_right.pressed.connect(func() -> void: _cycle_eyes(1))

	if beard_left: beard_left.pressed.connect(func() -> void: _cycle_beard(-1))
	if beard_right: beard_right.pressed.connect(func() -> void: _cycle_beard(1))

	if class_left: class_left.pressed.connect(func() -> void: _cycle_class(-1))
	if class_right: class_right.pressed.connect(func() -> void: _cycle_class(1))

	if quick_start_btn: quick_start_btn.pressed.connect(_on_quick_start_pressed)
	if finish_btn: finish_btn.pressed.connect(_on_finish_pressed)
	if back_btn: back_btn.pressed.connect(_on_back_pressed)

	if name_input:
		name_input.text_changed.connect(func(new_text: String) -> void: character_name = new_text)


func _cycle_gender(delta: int) -> void:
	var idx: int = GENDERS.find(selected_gender)
	idx = (idx + delta) % GENDERS.size()
	if idx < 0:
		idx += GENDERS.size()
	selected_gender = GENDERS[idx]

	if selected_gender == "girl":
		selected_eyes = 7
		selected_hair = 11
		selected_beard = 1
	else:
		selected_eyes = 1
		selected_hair = 1
		selected_beard = 1

	_update_ui()
	_update_preview()


func _cycle_skin(delta: int) -> void:
	selected_skin += delta
	if selected_skin < 1:
		selected_skin = 4
	elif selected_skin > 4:
		selected_skin = 1
	_update_ui()
	_update_preview()


func _cycle_hair(delta: int) -> void:
	var list: Array[int] = HAIR_MALE if selected_gender == "boy" else HAIR_FEMALE
	var cur_idx: int = list.find(selected_hair)
	if cur_idx == -1:
		cur_idx = 0
	cur_idx = (cur_idx + delta) % list.size()
	if cur_idx < 0:
		cur_idx += list.size()
	selected_hair = list[cur_idx]
	_update_ui()
	_update_preview()


func _cycle_eyes(delta: int) -> void:
	var list: Array[int] = EYES_MALE if selected_gender == "boy" else EYES_FEMALE
	var cur_idx: int = list.find(selected_eyes)
	if cur_idx == -1:
		cur_idx = 0
	cur_idx = (cur_idx + delta) % list.size()
	if cur_idx < 0:
		cur_idx += list.size()
	selected_eyes = list[cur_idx]
	_update_ui()
	_update_preview()


func _cycle_beard(delta: int) -> void:
	if selected_gender == "girl":
		selected_beard = 1
		return
	selected_beard += delta
	if selected_beard < 1:
		selected_beard = 8
	elif selected_beard > 8:
		selected_beard = 1
	_update_ui()
	_update_preview()


func _cycle_class(delta: int) -> void:
	var idx: int = CLASSES.find(selected_class)
	idx = (idx + delta) % CLASSES.size()
	if idx < 0:
		idx += CLASSES.size()
	selected_class = CLASSES[idx]
	_update_ui()
	_update_preview()


func _update_ui() -> void:
	if gender_label:
		gender_label.text = selected_gender
	if skin_label:
		skin_label.text = SKIN_NAMES.get(selected_skin, "pale")
	if hair_label:
		hair_label.text = HAIR_NAMES.get(selected_hair, "brown")
	if eyes_label:
		eyes_label.text = EYES_NAMES.get(selected_eyes, "round")
	if beard_box:
		beard_box.visible = (selected_gender == "boy")
	if beard_label:
		beard_label.text = BEARD_NAMES.get(selected_beard, "none")
	if class_label:
		class_label.text = selected_class
	if class_title_label:
		class_title_label.text = CLASS_TITLES.get(selected_class, "The Warrior")
	if class_desc_label:
		class_desc_label.text = CLASS_DESCRIPTIONS.get(selected_class, "")


func _update_preview() -> void:
	var loader: Node = _get_atlas_loader()
	if not loader:
		return

	if center_person_clone:
		var final_skin: int = selected_skin if selected_gender == "boy" else (selected_skin + 4)
		center_person_clone.skin_id = final_skin
		center_person_clone.hair_id = selected_hair
		center_person_clone.eyes_id = selected_eyes
		center_person_clone.beard_id = selected_beard if selected_gender == "boy" else 1
		center_person_clone.helmet_name = "none"
		center_person_clone.shirt_name = "white shirt"
		center_person_clone.pants_name = "green shorts"
		center_person_clone.shoe_name = "white shoe"
		center_person_clone.weapon_main_name = CLASS_STARTER_WEAPONS.get(selected_class, "stick")
		center_person_clone.weapon_off_name = "none"
		center_person_clone.apply_appearance()
		center_person_clone.refresh_equipment_textures()
		center_person_clone.play("standing")
	if preview_head:
		var head_name: String = "%s head %d" % ["male" if selected_gender == "boy" else "female", selected_skin]
		preview_head.texture = loader.get_texture(head_name, "items_pets_bodies")

	# 7. Иконка класса (classItem) под углом 45 градусов
	if class_item_icon:
		var icon_name: String = CLASS_ICONS.get(selected_class, "beholder sword")
		class_item_icon.texture = loader.get_texture(icon_name, "items_pets_bodies")

	# 8. Боковые превью высокоуровневых классов (leftPersonClone / rightPersonClone)
	_apply_example_outfit(left_person_clone, selected_class + "1")
	_apply_example_outfit(right_person_clone, selected_class + "2")


## Формирует точный словарь joinData в соответствии с разд. 1.4 ARCHITECTURE_MAP.md
func build_join_data() -> Dictionary:
	var final_skin: int = selected_skin if selected_gender == "boy" else (selected_skin + 4)
	var raw_name: String = name_input.text.strip_edges() if name_input and not name_input.text.strip_edges().is_empty() else character_name.strip_edges()
	if raw_name.is_empty():
		raw_name = "Hero"

	var jd: Dictionary = {
		"skin": final_skin,
		"eyes": selected_eyes,
		"hair": selected_hair,
		"beard": selected_beard,
		"classType": selected_class,
		"username": raw_name,
		"gender": "male" if selected_gender == "boy" else "female",
		"url": "godot.client",
		"onPlayerIO": true
	}
	if password_input and not password_input.text.strip_edges().is_empty():
		jd["password"] = password_input.text.strip_edges()
	if email_input and not email_input.text.strip_edges().is_empty():
		jd["email"] = email_input.text.strip_edges()
	return jd


func build_default_hero_data() -> Dictionary:
	return {
		"skin": 1,
		"eyes": 1,
		"hair": 1,
		"beard": 1,
		"classType": "warrior",
		"username": "Hero",
		"gender": "male",
		"url": "godot.client",
		"onPlayerIO": true
	}


func _on_quick_start_pressed() -> void:
	var default_data: Dictionary = build_default_hero_data()
	_save_to_player_object(default_data)
	character_created.emit(default_data)


func _on_finish_pressed() -> void:
	var cname: String = name_input.text.strip_edges() if name_input and not name_input.text.strip_edges().is_empty() else character_name.strip_edges()
	if is_sandbox_mode and cname.is_empty():
		cname = "Hero"
	elif not is_sandbox_mode and cname.length() < 3:
		if status_label:
			status_label.text = "Character name must be at least 3 characters!"
			status_label.modulate = Color.RED
		return

	character_name = cname
	var join_data: Dictionary = build_join_data()
	_save_to_player_object(join_data)
	character_created.emit(join_data)


func _save_to_player_object(join_data: Dictionary) -> void:
	var pio: Node = _get_pio_client()
	if pio and pio.my_player_object:
		pio.my_player_object["name"] = join_data["username"]
		pio.my_player_object["username"] = join_data["username"]
		pio.my_player_object["skin"] = join_data["skin"]
		pio.my_player_object["eye"] = join_data["eyes"]
		pio.my_player_object["eyes"] = join_data["eyes"]
		pio.my_player_object["hair"] = join_data["hair"]
		pio.my_player_object["beard"] = join_data["beard"]
		pio.my_player_object["classType"] = join_data["classType"]
		pio.my_player_object["stage"] = 1 # Стартовая локация 1
		pio.my_player_object["currentMap"] = 1
		pio.my_player_object["unlockedMaps"] = [1]
		pio.bigdb_save_changes("PlayerObjects", pio.connect_user_id, pio.my_player_object)


func _on_back_pressed() -> void:
	back_to_main_menu.emit()
