extends Control
class_name PetMenu
## PetMenu — Окно питомцев игрока (порт com.menus.PetMenu.as).
## Содержит:
## - Статус и параметры выбранного питомца (Имя, Тип, HP, XP, Love, Power, Dex, Defense)
## - Полоски прогресса (Love - pink, HP - red, XP - yellow)
## - Инвентарь питомцев (8 слотов: 2 ряда по 4 слота) с мини-барами HP и меткой Active
## - Кнопки управления: Activate/Withdraw, Companion, Equip, Mode, Release, Info

signal closed()
signal pet_activated(pet_data: Dictionary)
signal pet_withdrawn(pet_data: Dictionary)

@export var is_draggable: bool = true

var person: Node = null
var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

var panel_bg: TextureRect = null
var close_btn: TextureButton = null

# Верхняя панель: статус и статы выбранного питомца
var name_label: Label = null
var type_label: Label = null
var stats_label: Label = null

var love_bar: TextureProgressBar = null
var hp_bar: TextureProgressBar = null
var xp_bar: TextureProgressBar = null

# Кнопки действий
var btn_activate: TextureButton = null
var btn_withdraw: TextureButton = null
var btn_vend: TextureButton = null
var btn_companion: TextureButton = null
var btn_equip: TextureButton = null
var btn_mode: TextureButton = null
var btn_release: TextureButton = null
var btn_info: TextureButton = null

# 8 слотов питомцев
var pet_slots_container: Control = null
var slot_panels: Array[TextureButton] = []
var slot_labels: Array[Label] = []
var slot_level_labels: Array[Label] = []
var slot_hp_bars: Array[TextureProgressBar] = []
var slot_active_icons: Array[TextureRect] = []

var selected_pet_index: int = 0

# Коллекция питомцев игрока (загружается из PlayerIOClient.my_player_object, без фиктивных заглушек)
var pets_list: Array[Dictionary] = []

func _init(target_person: Node = null) -> void:
	person = target_person


func _ready() -> void:
	_load_pets_from_profile()
	custom_minimum_size = Vector2(779, 458)
	size = Vector2(779, 458)
	_build_ui()
	_update_selected_pet_display()


func reload_from_profile() -> void:
	_load_pets_from_profile()
	if pets_list.is_empty():
		selected_pet_index = -1
	elif selected_pet_index < 0 or selected_pet_index >= pets_list.size():
		selected_pet_index = 0
	if is_inside_tree():
		_update_selected_pet_display()


func _save_pets_to_profile() -> void:
	var pio: Node = get_node_or_null("/root/PlayerIOClient")
	if pio != null and "my_player_object" in pio and pio.my_player_object is Dictionary:
		pio.my_player_object["petData"] = pets_list.duplicate(true)
		if pio.has_method("save_sandbox_profile"):
			pio.call("save_sandbox_profile")


func _load_pets_from_profile() -> void:
	pets_list.clear()
	var pio: Node = get_node_or_null("/root/PlayerIOClient")
	if pio == null or not ("my_player_object" in pio) or not (pio.my_player_object is Dictionary):
		return
	var raw_pets: Variant = pio.my_player_object.get("petData", [])
	if raw_pets is Array:
		for p_item: Variant in raw_pets:
			if p_item is Dictionary:
				var pd: Dictionary = (p_item as Dictionary).duplicate(true)
				if not pd.has("name") and pd.has("type"):
					pd["name"] = str(pd["type"])
				if not pd.has("level") and pd.has("lvl"):
					pd["level"] = int(pd["lvl"])
				if not pd.has("max_health"):
					pd["max_health"] = int(pd.get("totalHealth", pd.get("health", 15)))
				if not pd.has("defense") and pd.has("def"):
					pd["defense"] = int(pd["def"])
				if not pd.has("max_xp"):
					var lv: int = int(pd.get("level", 1))
					pd["max_xp"] = int(lv * (lv * 1.1 + 50.0))
				pets_list.append(pd)

func _build_ui() -> void:
	var atlas_loader: Node = _get_atlas_loader()
	atlas_loader.register_starling_atlas("pet menu")
	var stats_font: Font = atlas_loader.get_bitmap_font("stats_font.fnt")
	var readable_font: Font = atlas_loader.get_bitmap_font("readable_font.fnt")

	# Фоновая панель из pet menu.xml ("big panel": 779x458)
	var bg_tex: Texture2D = atlas_loader.get_starling_texture("pet menu", "big panel")
	panel_bg = TextureRect.new()
	panel_bg.name = "PanelBG"
	panel_bg.texture = bg_tex
	panel_bg.size = Vector2(779, 458)
	panel_bg.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(panel_bg)

	# Кнопка закрытия (PetMenu.as:119-122: x=391, y=-213, pivotX=30, pivotY=19 -> (745, -6))
	var close_tex: Texture2D = atlas_loader.get_starling_texture("pet menu", "x_btn_00")
	var close_hover: Texture2D = atlas_loader.get_starling_texture("pet menu", "x_btn_01")
	close_btn = TextureButton.new()
	close_btn.name = "CloseButton"
	close_btn.texture_normal = close_tex
	close_btn.texture_hover = close_hover
	close_btn.position = Vector2(745, -6)
	close_btn.focus_mode = Control.FOCUS_NONE
	close_btn.pressed.connect(close_menu)
	add_child(close_btn)

	# --- 1. ВЕРХНЯЯ ЛЕВАЯ ЧАСТЬ: ИМЯ, ТИП, СТАТЫ ВЫБРАННОГО ПИТОМЦА (PetMenu.as:208-215) ---
	name_label = Label.new()
	name_label.name = "PetNameLabel"
	name_label.position = Vector2(36, 33)
	name_label.size = Vector2(213, 29)
	name_label.text = "No Pet"
	name_label.add_theme_font_override("font", stats_font)
	name_label.add_theme_font_size_override("font_size", 18)
	add_child(name_label)

	type_label = Label.new()
	type_label.name = "PetTypeLabel"
	type_label.position = Vector2(48, 170)
	type_label.size = Vector2(188, 23)
	type_label.text = "Type: None"
	type_label.add_theme_font_override("font", stats_font)
	type_label.add_theme_font_size_override("font_size", 13)
	add_child(type_label)

	stats_label = Label.new()
	stats_label.name = "PetStatsLabel"
	stats_label.position = Vector2(273, 38)
	stats_label.size = Vector2(223, 153)
	stats_label.text = "Level: 0\nLove: 0\nHealth: 0\nPower: 0\nDexterity: 0\nDefense: 0"
	stats_label.add_theme_font_override("font", readable_font)
	stats_label.add_theme_font_size_override("font_size", 13)
	add_child(stats_label)

	# Полоски прогресса (PetMenu.as:176-195: BG (438, 58/78/100) 102x21, bar 96x15)
	var bar_w: int = 96
	var bar_h: int = 15

	love_bar = _create_color_bar(Vector2(438, 58), Vector2(bar_w, bar_h), Color(1.0, 0.4, 0.7)) # Розовый для Love
	hp_bar = _create_color_bar(Vector2(438, 78), Vector2(bar_w, bar_h), Color(0.9, 0.2, 0.2)) # Красный для HP
	xp_bar = _create_color_bar(Vector2(438, 100), Vector2(bar_w, bar_h), Color(1.0, 0.85, 0.1)) # Желтый для XP

	# --- 2. ПРАВАЯ ВЕРХНЯЯ ЧАСТЬ: КНОПКИ ДЕЙСТВИЙ (PetMenu.as:125-175) ---
	var equip_tex: Texture2D = atlas_loader.get_starling_texture("pet menu", "equip_00")
	var equip_hover: Texture2D = atlas_loader.get_starling_texture("pet menu", "equip_01")
	btn_equip = TextureButton.new()
	btn_equip.name = "EquipBtn"
	btn_equip.texture_normal = equip_tex
	btn_equip.texture_hover = equip_hover
	btn_equip.position = Vector2(681, 39)
	btn_equip.focus_mode = Control.FOCUS_NONE
	add_child(btn_equip)

	var withdraw_tex: Texture2D = atlas_loader.get_starling_texture("pet menu", "withdraw_00")
	btn_withdraw = TextureButton.new()
	btn_withdraw.name = "WithdrawBtn"
	btn_withdraw.texture_normal = withdraw_tex
	btn_withdraw.position = Vector2(625, 76)
	btn_withdraw.focus_mode = Control.FOCUS_NONE
	btn_withdraw.pressed.connect(_on_withdraw_clicked)
	add_child(btn_withdraw)

	var vend_tex: Texture2D = atlas_loader.get_starling_texture("pet menu", "vend_00")
	btn_vend = TextureButton.new()
	btn_vend.name = "VendBtn"
	btn_vend.texture_normal = vend_tex
	btn_vend.position = Vector2(681, 75)
	btn_vend.focus_mode = Control.FOCUS_NONE
	add_child(btn_vend)

	var mode_tex: Texture2D = atlas_loader.get_starling_texture("pet menu", "mode_00")
	btn_mode = TextureButton.new()
	btn_mode.name = "ModeBtn"
	btn_mode.texture_normal = mode_tex
	btn_mode.position = Vector2(657, 113)
	btn_mode.focus_mode = Control.FOCUS_NONE
	add_child(btn_mode)

	var activate_tex: Texture2D = atlas_loader.get_starling_texture("pet menu", "activate_00")
	btn_activate = TextureButton.new()
	btn_activate.name = "ActivateBtn"
	btn_activate.texture_normal = activate_tex
	btn_activate.position = Vector2(607, 150)
	btn_activate.focus_mode = Control.FOCUS_NONE
	btn_activate.pressed.connect(_on_activate_clicked)
	add_child(btn_activate)

	var comp_tex: Texture2D = atlas_loader.get_starling_texture("pet menu", "companion")
	btn_companion = TextureButton.new()
	btn_companion.name = "CompanionBtn"
	btn_companion.texture_normal = comp_tex
	btn_companion.position = Vector2(481, 115)
	btn_companion.focus_mode = Control.FOCUS_NONE
	add_child(btn_companion)

	var info_tex: Texture2D = atlas_loader.get_starling_texture("pet menu", "info")
	btn_info = TextureButton.new()
	btn_info.name = "InfoBtn"
	btn_info.texture_normal = info_tex
	btn_info.position = Vector2(491, 138)
	btn_info.focus_mode = Control.FOCUS_NONE
	add_child(btn_info)

	var release_tex: Texture2D = atlas_loader.get_starling_texture("pet menu", "release")
	btn_release = TextureButton.new()
	btn_release.name = "ReleaseBtn"
	btn_release.texture_normal = release_tex
	btn_release.position = Vector2(506, 160)
	btn_release.focus_mode = Control.FOCUS_NONE
	btn_release.pressed.connect(_on_release_clicked)
	add_child(btn_release)

	# --- 3. НИЖНЯЯ ПАНЕЛЬ: 8 СЛОТОВ ПИТОМЦЕВ (PetMenu.as:200-202: x=41+col*141, y=221 / 344) ---
	var panel_slot_tex: Texture2D = atlas_loader.get_starling_texture("pet menu", "panel_00")
	var active_icon_tex: Texture2D = atlas_loader.get_starling_texture("pet menu", "active icon")
	var health_bg_tex: Texture2D = atlas_loader.get_starling_texture("pet menu", "small health BG")
	var health_fill_tex: Texture2D = atlas_loader.get_starling_texture("pet menu", "small health bar")

	pet_slots_container = Control.new()
	pet_slots_container.name = "PetSlotsContainer"
	pet_slots_container.position = Vector2.ZERO
	pet_slots_container.size = Vector2(779, 458)
	pet_slots_container.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(pet_slots_container)

	for i: int in range(8):
		var col: int = i % 4
		var row: int = i / 4
		var slot_x: float = 41.0 + float(col) * 141.0
		var slot_y: float = 221.0 if row == 0 else 344.0

		var slot_btn: TextureButton = TextureButton.new()
		slot_btn.name = "SlotBtn_%d" % i
		slot_btn.texture_normal = panel_slot_tex
		slot_btn.position = Vector2(slot_x, slot_y)
		slot_btn.focus_mode = Control.FOCUS_NONE
		var s_idx: int = i
		slot_btn.pressed.connect(func() -> void: _on_slot_clicked(s_idx))
		pet_slots_container.add_child(slot_btn)
		slot_panels.append(slot_btn)

		# Метка имени питомца (PetMenu.as:231-232: x=23+col*141, y=214 / 336)
		var s_name_lbl: Label = Label.new()
		s_name_lbl.position = Vector2(23.0 + float(col) * 141.0, 214.0 if row == 0 else 336.0)
		s_name_lbl.size = Vector2(121, 21)
		s_name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		s_name_lbl.add_theme_font_override("font", stats_font)
		s_name_lbl.add_theme_font_size_override("font_size", 11)
		pet_slots_container.add_child(s_name_lbl)
		slot_labels.append(s_name_lbl)

		# Метка уровня внизу слота (PetMenu.as:236-237: x=53+col*141, y=305 / 428)
		var s_lvl_lbl: Label = Label.new()
		s_lvl_lbl.position = Vector2(53.0 + float(col) * 141.0, 305.0 if row == 0 else 428.0)
		s_lvl_lbl.size = Vector2(65, 21)
		s_lvl_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		s_lvl_lbl.add_theme_font_override("font", stats_font)
		s_lvl_lbl.add_theme_font_size_override("font_size", 11)
		pet_slots_container.add_child(s_lvl_lbl)
		slot_level_labels.append(s_lvl_lbl)

		# Мини HP бар (PetMenu.as:272-273: x=67+col*141, y=236 / 359)
		var mini_hp: TextureProgressBar = TextureProgressBar.new()
		mini_hp.texture_under = health_bg_tex
		mini_hp.texture_progress = health_fill_tex
		mini_hp.position = Vector2(67.0 + float(col) * 141.0, 236.0 if row == 0 else 359.0)
		mini_hp.min_value = 0
		mini_hp.max_value = 100
		mini_hp.value = 100
		pet_slots_container.add_child(mini_hp)
		slot_hp_bars.append(mini_hp)

		# Иконка Active
		var active_ico: TextureRect = TextureRect.new()
		active_ico.texture = active_icon_tex
		active_ico.position = Vector2(slot_x - 8, slot_y - 15)
		active_ico.scale = Vector2(0.65, 0.65)
		active_ico.mouse_filter = Control.MOUSE_FILTER_IGNORE
		active_ico.visible = false
		pet_slots_container.add_child(active_ico)
		slot_active_icons.append(active_ico)


func _create_color_bar(pos: Vector2, bar_size: Vector2, color: Color) -> TextureProgressBar:
	var bar: TextureProgressBar = TextureProgressBar.new()
	bar.position = pos
	bar.min_value = 0
	bar.max_value = 100
	bar.value = 100

	# Создаем однопиксельные текстуры подложки и прогресса
	var img_under: Image = Image.create(int(bar_size.x), int(bar_size.y), false, Image.FORMAT_RGBA8)
	img_under.fill(Color(0.1, 0.1, 0.1, 0.8))
	bar.texture_under = ImageTexture.create_from_image(img_under)

	var img_prog: Image = Image.create(int(bar_size.x), int(bar_size.y), false, Image.FORMAT_RGBA8)
	img_prog.fill(color)
	bar.texture_progress = ImageTexture.create_from_image(img_prog)

	add_child(bar)
	return bar


func bind_person(target_person: Node) -> void:
	person = target_person
	update_display()


func update_display() -> void:
	_update_selected_pet_display()


func _update_selected_pet_display() -> void:
	# Обновляем слоты
	for i: int in range(8):
		if i < pets_list.size():
			var p: Dictionary = pets_list[i]
			slot_labels[i].text = str(p.get("name", ""))
			slot_level_labels[i].text = "Lvl %d" % int(p.get("level", 1))
			slot_hp_bars[i].visible = true
			var hp: int = int(p.get("health", 1))
			var max_hp: int = int(p.get("max_health", 1))
			slot_hp_bars[i].max_value = max_hp
			slot_hp_bars[i].value = hp
			slot_active_icons[i].visible = bool(p.get("is_active", false))
			slot_panels[i].modulate = Color(1.2, 1.2, 0.6) if (i == selected_pet_index) else Color.WHITE
		else:
			slot_labels[i].text = ""
			slot_level_labels[i].text = ""
			slot_hp_bars[i].visible = false
			slot_active_icons[i].visible = false
			slot_panels[i].modulate = Color(0.6, 0.6, 0.6, 0.4)

	# Обновляем выбранного питомца
	if selected_pet_index >= 0 and selected_pet_index < pets_list.size():
		var sel: Dictionary = pets_list[selected_pet_index]
		name_label.text = str(sel.get("name", "Unknown Pet"))
		type_label.text = "Type: %s" % str(sel.get("type", "normal")).capitalize()

		var lvl: int = int(sel.get("level", 1))
		var love: int = int(sel.get("love", 0))
		var hp: int = int(sel.get("health", 1))
		var max_hp: int = int(sel.get("max_health", 1))
		var xp: int = int(sel.get("xp", 0))
		var max_xp: int = int(sel.get("max_xp", 100))
		var pow: int = int(sel.get("power", 0))
		var dex: int = int(sel.get("dex", 0))
		var def: int = int(sel.get("defense", 0))

		stats_label.text = "Level: %d\nLove: %d / 100\nHealth: %d / %d\nXP: %d / %d\nPower: %d\nDexterity: %d\nDefense: %d" % [
			lvl, love, hp, max_hp, xp, max_xp, pow, dex, def
		]

		love_bar.visible = true
		love_bar.value = love

		hp_bar.visible = true
		hp_bar.max_value = max_hp
		hp_bar.value = hp

		xp_bar.visible = true
		xp_bar.max_value = max_xp
		xp_bar.value = xp

		var is_active: bool = bool(sel.get("is_active", false))
		btn_withdraw.visible = is_active
		btn_activate.visible = not is_active
		btn_release.visible = not is_active
	else:
		name_label.text = "No Pet Selected"
		type_label.text = ""
		stats_label.text = ""
		love_bar.visible = false
		hp_bar.visible = false
		xp_bar.visible = false
		btn_withdraw.visible = false
		btn_activate.visible = false
		btn_release.visible = false


func _on_slot_clicked(idx: int) -> void:
	if idx < pets_list.size():
		selected_pet_index = idx
		_update_selected_pet_display()


func _on_activate_clicked() -> void:
	if selected_pet_index >= 0 and selected_pet_index < pets_list.size():
		for i: int in range(pets_list.size()):
			pets_list[i]["is_active"] = (i == selected_pet_index)
		_save_pets_to_profile()
		pet_activated.emit(pets_list[selected_pet_index])
		_update_selected_pet_display()


func _on_withdraw_clicked() -> void:
	if selected_pet_index >= 0 and selected_pet_index < pets_list.size():
		pets_list[selected_pet_index]["is_active"] = false
		_save_pets_to_profile()
		pet_withdrawn.emit(pets_list[selected_pet_index])
		_update_selected_pet_display()


func _on_release_clicked() -> void:
	if selected_pet_index >= 0 and selected_pet_index < pets_list.size():
		pets_list.remove_at(selected_pet_index)
		selected_pet_index = 0 if pets_list.size() > 0 else -1
		_save_pets_to_profile()
		_update_selected_pet_display()


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
