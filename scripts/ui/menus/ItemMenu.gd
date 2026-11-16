extends Control
class_name ItemMenu
## ItemMenu — Окно инвентаря (порт com.menus.ItemMenu.as и com.menus.ItemGameMenu.as).
## Содержит:
## - Вертикальный скроллируемый список из 40 строк (item panel_00/01, 245x28, шаг 34 px)
## - Мини-иконки предметов из items_pets_bodies (scale = 0.75, поворот -55° для оружия) и иконку equip
## - Справа: превью выбранного предмета в (142, -97) относительно центра, item_txt, stats_txt, desc_txt
## - Кнопки из item menu.xml: equip_btn, unEquip_btn, use_btn_00/01, drop_btn, scroll, x_btn_00/01

signal closed()
signal item_selected(item_name: String, index: int)

@export var is_draggable: bool = true

var person: Node = null
var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var _dragging_scroll: bool = false

var panel_bg: TextureRect = null
var close_btn: TextureButton = null
var title_label: Label = null
var scroll_btn: TextureButton = null

# Список инвентаря (40 строк по ItemMenu.as:305)
var inventory_scroll: ScrollContainer = null
var list_content: Control = null
var row_nodes: Array[Control] = []
var row_bg_rects: Array[TextureRect] = []
var row_icon_sprites: Array[Sprite2D] = []
var row_name_labels: Array[Label] = []
var row_equip_icons: Array[TextureRect] = []

# Текущий отображаемый список: Array[Dictionary] {"name": String, "equipped": bool, "slot": String, "inv_index": int}
var _display_entries: Array[Dictionary] = []
var selected_row_index: int = -1

# Панель информации и превью справа
var item_preview_sprite: Sprite2D = null
var item_title_label: Label = null
var item_stats_label: Label = null
var item_desc_label: Label = null

# Кнопки действий (TextureButton из item menu.xml)
var btn_equip: TextureButton = null
var btn_unequip: TextureButton = null
var btn_use: TextureButton = null
var btn_drop: TextureButton = null
var btn_store: TextureButton = null
var is_bank_store_mode: bool = false

signal store_item_requested(inventory_index: int)

# Диалог выбора руки при экипировке 1H оружия / dual-gun (ItemMenu.as:452-485)
var dual_wield_panel: TextureRect = null
var btn_dual_primary: TextureButton = null
var btn_dual_secondary: TextureButton = null
var _pending_dual_item: String = ""

# Окно предупреждения об ошибке экипировки/снятия (alert panel из item menu.xml)
var alert_panel: Control = null
var alert_label: Label = null
var alert_ok_btn: Button = null

# Панели сравнения с текущей экипировкой (ItemGameMenu.as:241-342)
var your_item_panel: Control = null
var your_item2_panel: Control = null
var your_item_type_label: Label = null
var your_item2_type_label: Label = null
var your_item_title_label: Label = null
var your_item2_title_label: Label = null
var your_item_stats_label: Label = null
var your_item2_stats_label: Label = null
var your_item_sprite: Sprite2D = null
var your_item2_sprite: Sprite2D = null

# Текстуры строк
var _tex_panel_normal: Texture2D = null
var _tex_panel_selected: Texture2D = null
var _tex_equip_badge: Texture2D = null

const INVENTORY_CAPACITY: int = 40
const ROW_WIDTH: float = 245.0
const ROW_HEIGHT: float = 28.0
const ROW_STEP: float = 34.0
# Смещение центра Flash ItemMenu относительно левого верхнего угла panel (-257, -208)
const FLASH_OFFSET: Vector2 = Vector2(257.0, 208.0)
const SCROLL_MIN_Y: float = 55.0   # -134 + 208 - 19
const SCROLL_MAX_Y: float = 383.0  #  194 + 208 - 19


func _init(target_person: Node = null) -> void:
	person = target_person


func _ready() -> void:
	custom_minimum_size = Vector2(500, 487)
	size = Vector2(500, 487)
	_build_ui()
	if person != null:
		bind_person(person)


func _build_ui() -> void:
	var atlas_loader: Node = _get_atlas_loader()
	atlas_loader.register_starling_atlas("item menu")
	atlas_loader.register_starling_atlas("items_pets_bodies")
	var stats_font: Font = atlas_loader.get_bitmap_font("stats_font.fnt")
	var readable_font: Font = atlas_loader.get_bitmap_font("readable_font.fnt")

	_tex_panel_normal = atlas_loader.get_starling_texture("item menu", "item panel_00")
	_tex_panel_selected = atlas_loader.get_starling_texture("item menu", "item panel_01")
	_tex_equip_badge = atlas_loader.get_starling_texture("item menu", "equip")

	# Фоновая текстура оригинального меню (500x487) из item menu.xml ("panel")
	panel_bg = TextureRect.new()
	panel_bg.name = "PanelBG"
	panel_bg.texture = atlas_loader.get_starling_texture("item menu", "panel")
	panel_bg.position = Vector2.ZERO
	panel_bg.size = Vector2(500, 487)
	panel_bg.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(panel_bg)

	# Кнопка закрытия ("x_btn_00" / "x_btn_01"): Flash (237, -192), pivot (30, 19) -> (464, -3)
	close_btn = TextureButton.new()
	close_btn.name = "CloseButton"
	close_btn.texture_normal = atlas_loader.get_starling_texture("item menu", "x_btn_00")
	close_btn.texture_hover = atlas_loader.get_starling_texture("item menu", "x_btn_01")
	close_btn.position = Vector2(237.0 - 30.0, -192.0 - 19.0) + FLASH_OFFSET
	close_btn.focus_mode = Control.FOCUS_NONE
	close_btn.pressed.connect(close_menu)
	add_child(close_btn)

	# Заголовок меню (ItemMenu.as:206-209, 343): Flash (-174, -207), size 348x34
	title_label = Label.new()
	title_label.name = "TitleLabel"
	title_label.text = "YOUR ITEMS"
	title_label.position = Vector2(-174.0, -207.0) + FLASH_OFFSET
	title_label.size = Vector2(348, 34)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_label.add_theme_font_override("font", stats_font)
	title_label.add_theme_font_size_override("font_size", 28)
	title_label.add_theme_color_override("font_color", Color.WHITE)
	add_child(title_label)

	# --- 1. ВЕРТИКАЛЬНЫЙ СПИСОК ПРЕДМЕТОВ (ItemMenu.as:288-339) ---
	# В Flash: list_sprite.x = -102, itemPanel.x = -140 => -242 + 257 = 15
	# list_sprite.y = 325, itemPanel[0].y = -484 => -159 + 208 = 49
	inventory_scroll = ScrollContainer.new()
	inventory_scroll.name = "InvScroll"
	inventory_scroll.position = Vector2(15, 49)
	inventory_scroll.size = Vector2(248, 418)
	inventory_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	inventory_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	inventory_scroll.focus_mode = Control.FOCUS_NONE
	add_child(inventory_scroll)

	list_content = Control.new()
	list_content.name = "ItemListContent"
	list_content.custom_minimum_size = Vector2(ROW_WIDTH, INVENTORY_CAPACITY * ROW_STEP)
	list_content.size = Vector2(ROW_WIDTH, INVENTORY_CAPACITY * ROW_STEP)
	inventory_scroll.add_child(list_content)

	for i: int in range(INVENTORY_CAPACITY):
		var row: Control = Control.new()
		row.name = "ItemRow_%d" % i
		row.position = Vector2(0.0, float(i) * ROW_STEP)
		row.size = Vector2(ROW_WIDTH, ROW_HEIGHT)
		row.mouse_filter = Control.MOUSE_FILTER_STOP
		var idx: int = i
		row.gui_input.connect(func(ev: InputEvent) -> void: _on_row_gui_input(ev, idx))
		list_content.add_child(row)
		row_nodes.append(row)

		var row_bg: TextureRect = TextureRect.new()
		row_bg.name = "PanelBG"
		row_bg.texture = _tex_panel_normal
		row_bg.position = Vector2.ZERO
		row_bg.size = Vector2(ROW_WIDTH, ROW_HEIGHT)
		row_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(row_bg)
		row_bg_rects.append(row_bg)

		# Мини-иконка предмета (ItemGameMenu.as:540-542): x = -121 - (-140) = 19, y = -469 - (-484) = 15, scale = 0.75
		var icon_sprite: Sprite2D = Sprite2D.new()
		icon_sprite.name = "ItemIcon"
		icon_sprite.position = Vector2(19.0, 15.0)
		icon_sprite.scale = Vector2(0.75, 0.75)
		icon_sprite.visible = false
		row.add_child(icon_sprite)
		row_icon_sprites.append(icon_sprite)

		# Название предмета (ItemMenu.as:329-331): 165x23, x = -98 - (-140) = 42, y = -482 - (-484) = 2
		var name_lbl: Label = Label.new()
		name_lbl.name = "ItemName"
		name_lbl.text = "(empty)"
		name_lbl.position = Vector2(42.0, 2.0)
		name_lbl.size = Vector2(165.0, 23.0)
		name_lbl.clip_text = true
		name_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		name_lbl.add_theme_font_override("font", stats_font)
		name_lbl.add_theme_font_size_override("font_size", 18)
		name_lbl.add_theme_color_override("font_color", Color.WHITE)
		name_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(name_lbl)
		row_name_labels.append(name_lbl)

		# Иконка "equip" (ItemMenu.as:314-318): x = 92 - 24 - (-140) = 208, y = -470 - 13 - (-484) = 1
		var eq_icon: TextureRect = TextureRect.new()
		eq_icon.name = "EquipIcon"
		eq_icon.texture = _tex_equip_badge
		eq_icon.position = Vector2(208.0, 1.0)
		eq_icon.size = Vector2(26.0, 27.0)
		eq_icon.visible = false
		eq_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(eq_icon)
		row_equip_icons.append(eq_icon)

	# Ползунок скролла ("scroll"): ItemMenu.as:142-146 Flash (22, -132), pivot (15, 19) -> (264, 57)
	scroll_btn = TextureButton.new()
	scroll_btn.name = "ScrollButton"
	scroll_btn.texture_normal = atlas_loader.get_starling_texture("item menu", "scroll")
	scroll_btn.position = Vector2(22.0 - 15.0, -132.0 - 19.0) + FLASH_OFFSET
	scroll_btn.focus_mode = Control.FOCUS_NONE
	scroll_btn.gui_input.connect(_on_scroll_btn_gui_input)
	add_child(scroll_btn)
	inventory_scroll.get_v_scroll_bar().value_changed.connect(_on_vscroll_value_changed)

	# --- 2. ПРЕВЬЮ И ИНФОРМАЦИЯ О ПРЕДМЕТЕ СПРАВА (ItemMenu.as:99, 210-218; ItemGameMenu.as:20-24, 140-141) ---
	# item_txt: Flash (52, -173) -> (309, 35), size 184x24
	item_title_label = Label.new()
	item_title_label.name = "ItemTitle"
	item_title_label.text = ""
	item_title_label.position = Vector2(52.0, -173.0) + FLASH_OFFSET
	item_title_label.size = Vector2(184.0, 24.0)
	item_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	item_title_label.add_theme_font_override("font", stats_font)
	item_title_label.add_theme_font_size_override("font_size", 14)
	item_title_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.4))
	add_child(item_title_label)

	# Большая иконка превью в (142, -97) относительно центра Flash -> (399, 111)
	item_preview_sprite = Sprite2D.new()
	item_preview_sprite.name = "ItemPreview"
	item_preview_sprite.position = Vector2(142.0, -97.0) + FLASH_OFFSET
	item_preview_sprite.visible = false
	add_child(item_preview_sprite)

	# stats_txt: Flash (58, -18) -> (315, 190), size 165x138
	item_stats_label = Label.new()
	item_stats_label.name = "ItemStats"
	item_stats_label.text = ""
	item_stats_label.position = Vector2(58.0, -18.0) + FLASH_OFFSET
	item_stats_label.size = Vector2(165.0, 138.0)
	item_stats_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	item_stats_label.add_theme_font_override("font", stats_font)
	item_stats_label.add_theme_font_size_override("font_size", 12)
	add_child(item_stats_label)

	# desc_txt: Flash (58, 139) -> (315, 347), size 165x82
	item_desc_label = Label.new()
	item_desc_label.name = "ItemDesc"
	item_desc_label.text = ""
	item_desc_label.position = Vector2(58.0, 139.0) + FLASH_OFFSET
	item_desc_label.size = Vector2(165.0, 82.0)
	item_desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	item_desc_label.add_theme_font_override("font", readable_font)
	item_desc_label.add_theme_font_size_override("font_size", 11)
	add_child(item_desc_label)

	# --- 3. КНОПКИ ДЕЙСТВИЙ (ItemMenu.as:162-196) ---
	# equip_btn: Flash (91, 248), pivot (33, 15) -> (315, 441)
	btn_equip = TextureButton.new()
	btn_equip.name = "BtnEquip"
	btn_equip.texture_normal = atlas_loader.get_starling_texture("item menu", "equip_btn")
	btn_equip.position = Vector2(91.0 - 33.0, 248.0 - 15.0) + FLASH_OFFSET
	btn_equip.visible = false
	btn_equip.focus_mode = Control.FOCUS_NONE
	btn_equip.pressed.connect(_on_equip_clicked)
	add_child(btn_equip)

	# unEquip_btn: Flash (91, 248), pivot (45, 15) -> (303, 441)
	btn_unequip = TextureButton.new()
	btn_unequip.name = "BtnUnequip"
	btn_unequip.texture_normal = atlas_loader.get_starling_texture("item menu", "unEquip_btn")
	btn_unequip.position = Vector2(91.0 - 45.0, 248.0 - 15.0) + FLASH_OFFSET
	btn_unequip.visible = false
	btn_unequip.focus_mode = Control.FOCUS_NONE
	btn_unequip.pressed.connect(_on_unequip_clicked)
	add_child(btn_unequip)

	# use_btn: Flash (95, 248), pivot (33, 15) -> (319, 441)
	btn_use = TextureButton.new()
	btn_use.name = "BtnUse"
	btn_use.texture_normal = atlas_loader.get_starling_texture("item menu", "use_btn_00")
	btn_use.texture_hover = atlas_loader.get_starling_texture("item menu", "use_btn_01")
	btn_use.position = Vector2(95.0 - 33.0, 248.0 - 15.0) + FLASH_OFFSET
	btn_use.visible = false
	btn_use.focus_mode = Control.FOCUS_NONE
	btn_use.pressed.connect(_on_use_clicked)
	add_child(btn_use)

	# drop_btn: Flash (191, 247), pivot (33, 15) -> (415, 440)
	btn_drop = TextureButton.new()
	btn_drop.name = "BtnDrop"
	btn_drop.texture_normal = atlas_loader.get_starling_texture("item menu", "drop_btn")
	btn_drop.position = Vector2(191.0 - 33.0, 247.0 - 15.0) + FLASH_OFFSET
	btn_drop.visible = false
	btn_drop.focus_mode = Control.FOCUS_NONE
	btn_drop.pressed.connect(_on_drop_clicked)
	add_child(btn_drop)

	btn_store = TextureButton.new()
	btn_store.name = "BtnStore"
	btn_store.texture_normal = atlas_loader.get_starling_texture("item menu", "vend_btn_00")
	btn_store.position = Vector2(95.0 - 33.0, 248.0 - 15.0) + FLASH_OFFSET
	btn_store.visible = false
	btn_store.focus_mode = Control.FOCUS_NONE
	btn_store.pressed.connect(_on_store_clicked)
	add_child(btn_store)

	# Диалог выбора основной/второй руки ("small menu", "primary_00", "secondary_00")
	dual_wield_panel = TextureRect.new()
	dual_wield_panel.name = "DualWieldPanel"
	dual_wield_panel.texture = atlas_loader.get_starling_texture("item menu", "small menu")
	dual_wield_panel.position = Vector2(42.0, 228.0) + FLASH_OFFSET
	dual_wield_panel.size = Vector2(200, 46)
	dual_wield_panel.visible = false
	dual_wield_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dual_wield_panel)

	btn_dual_primary = TextureButton.new()
	btn_dual_primary.name = "PrimaryBtn"
	btn_dual_primary.texture_normal = atlas_loader.get_starling_texture("item menu", "primary_00")
	btn_dual_primary.position = Vector2(5, 16)
	btn_dual_primary.focus_mode = Control.FOCUS_NONE
	btn_dual_primary.pressed.connect(_on_dual_primary_clicked)
	dual_wield_panel.add_child(btn_dual_primary)

	btn_dual_secondary = TextureButton.new()
	btn_dual_secondary.name = "SecondaryBtn"
	btn_dual_secondary.texture_normal = atlas_loader.get_starling_texture("item menu", "secondary_00")
	btn_dual_secondary.position = Vector2(82, 16)
	btn_dual_secondary.focus_mode = Control.FOCUS_NONE
	btn_dual_secondary.pressed.connect(_on_dual_secondary_clicked)
	dual_wield_panel.add_child(btn_dual_secondary)

	# Панели сравнения текущей экипировки справа (weapon / weapon2)
	var your_panel_tex: Texture2D = atlas_loader.get_starling_texture("item menu", "your item panel")
	your_item_panel = _build_compare_card("YourItemPanel", Vector2(506, 20), your_panel_tex, stats_font)
	your_item_type_label = your_item_panel.get_node("TypeLabel") as Label
	your_item_title_label = your_item_panel.get_node("TitleLabel") as Label
	your_item_stats_label = your_item_panel.get_node("StatsLabel") as Label
	your_item_sprite = your_item_panel.get_node("ItemIcon") as Sprite2D
	add_child(your_item_panel)

	your_item2_panel = _build_compare_card("YourItem2Panel", Vector2(506, 218), your_panel_tex, stats_font)
	your_item2_type_label = your_item2_panel.get_node("TypeLabel") as Label
	your_item2_title_label = your_item2_panel.get_node("TitleLabel") as Label
	your_item2_stats_label = your_item2_panel.get_node("StatsLabel") as Label
	your_item2_sprite = your_item2_panel.get_node("ItemIcon") as Sprite2D
	add_child(your_item2_panel)

	# Alert popup (если equip/unequip запрещён по правилам Flash)
	alert_panel = Panel.new()
	alert_panel.name = "AlertPanel"
	alert_panel.position = Vector2(130, 175)
	alert_panel.size = Vector2(240, 118)
	alert_panel.visible = false
	alert_panel.z_index = 20
	var alert_style: StyleBoxFlat = StyleBoxFlat.new()
	alert_style.bg_color = Color(0.11, 0.13, 0.17, 0.96)
	alert_style.border_color = Color(0.76, 0.65, 0.34, 1.0)
	alert_style.set_border_width_all(2)
	alert_panel.add_theme_stylebox_override("panel", alert_style)
	add_child(alert_panel)

	var alert_tex: Texture2D = atlas_loader.get_starling_texture("item menu", "alert panel")
	if alert_tex != null:
		var alert_bg: TextureRect = TextureRect.new()
		alert_bg.texture = alert_tex
		alert_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		alert_bg.size = alert_panel.size
		alert_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		alert_panel.add_child(alert_bg)

	alert_label = Label.new()
	alert_label.name = "AlertLabel"
	alert_label.position = Vector2(12, 12)
	alert_label.size = Vector2(216, 66)
	alert_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	alert_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	alert_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	alert_label.add_theme_font_override("font", readable_font)
	alert_label.add_theme_font_size_override("font_size", 12)
	alert_label.add_theme_color_override("font_color", Color.WHITE)
	alert_panel.add_child(alert_label)

	alert_ok_btn = Button.new()
	alert_ok_btn.name = "AlertOkBtn"
	alert_ok_btn.text = "OK"
	alert_ok_btn.position = Vector2(85, 82)
	alert_ok_btn.size = Vector2(70, 26)
	alert_ok_btn.focus_mode = Control.FOCUS_NONE
	alert_ok_btn.pressed.connect(func() -> void: alert_panel.visible = false)
	alert_panel.add_child(alert_ok_btn)


func _build_compare_card(card_name: String, card_pos: Vector2, card_tex: Texture2D, font_res: Font) -> Control:
	var card: Control = Control.new()
	card.name = card_name
	card.position = card_pos
	card.size = Vector2(234, 189)
	card.visible = false
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE

	if card_tex != null:
		var bg: TextureRect = TextureRect.new()
		bg.texture = card_tex
		bg.size = Vector2(234, 189)
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(bg)

	var t_lbl: Label = Label.new()
	t_lbl.name = "TypeLabel"
	t_lbl.position = Vector2(10, 4)
	t_lbl.size = Vector2(214, 18)
	t_lbl.add_theme_font_override("font", font_res)
	t_lbl.add_theme_font_size_override("font_size", 12)
	t_lbl.add_theme_color_override("font_color", Color(0.85, 0.92, 1.0))
	t_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(t_lbl)

	var name_lbl: Label = Label.new()
	name_lbl.name = "TitleLabel"
	name_lbl.position = Vector2(54, 22)
	name_lbl.size = Vector2(170, 22)
	name_lbl.add_theme_font_override("font", font_res)
	name_lbl.add_theme_font_size_override("font_size", 13)
	name_lbl.add_theme_color_override("font_color", Color(1.0, 0.9, 0.4))
	name_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(name_lbl)

	var icon: Sprite2D = Sprite2D.new()
	icon.name = "ItemIcon"
	icon.position = Vector2(28, 34)
	icon.scale = Vector2(0.75, 0.75)
	card.add_child(icon)

	var s_lbl: Label = Label.new()
	s_lbl.name = "StatsLabel"
	s_lbl.position = Vector2(14, 52)
	s_lbl.size = Vector2(206, 128)
	s_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	s_lbl.add_theme_font_override("font", font_res)
	s_lbl.add_theme_font_size_override("font_size", 11)
	s_lbl.add_theme_color_override("font_color", Color.WHITE)
	s_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(s_lbl)
	return card


func bind_person(target_person: Node) -> void:
	if person != null and person.inventory_updated.is_connected(update_display):
		person.inventory_updated.disconnect(update_display)

	person = target_person
	if person != null:
		person.inventory_updated.connect(update_display)
		update_display()


func open_menu() -> void:
	visible = true
	_hide_dual_wield_menu()
	if alert_panel != null:
		alert_panel.visible = false
	refresh_inventory()


func refresh_inventory() -> void:
	update_display()


func select_item(index: int) -> void:
	if index < 0 or index >= _display_entries.size():
		selected_row_index = -1
		_refresh_row_highlights()
		_update_selection_details()
		return
	selected_row_index = index
	_refresh_row_highlights()
	_update_selection_details()
	var entry: Dictionary = _display_entries[index]
	item_selected.emit(str(entry.get("name", "")), index)


func update_display() -> void:
	if person == null or row_name_labels.is_empty():
		return

	_display_entries.clear()
	var inv: Array = person.get("inventory") if person.get("inventory") is Array else []
	var eq_dict: Dictionary = person.get("equipment") if person.get("equipment") is Dictionary else {}

	# 1. Предметы в инвентаре (не экипированы — экипированные хранятся в equipment)
	for inv_idx: int in range(inv.size()):
		if _display_entries.size() >= INVENTORY_CAPACITY:
			break
		var item_name: String = str(inv[inv_idx]).strip_edges()
		if item_name.is_empty():
			continue
		_display_entries.append({
			"name": item_name,
			"equipped": false,
			"slot": "",
			"inv_index": inv_idx
		})

	# 2. Экипированные предметы из equipment
	var remaining_eq: Dictionary = {}
	for slot_id: String in eq_dict.keys():
		var eq_name: String = str(eq_dict.get(slot_id, "")).strip_edges()
		if not eq_name.is_empty() and eq_name != "none" and eq_name != "nothing":
			remaining_eq[slot_id] = eq_name

	var slot_order: Array[String] = ["weapon", "weapon2", "helmet", "shirt", "legs", "shoes", "accessory"]
	for slot_id: String in slot_order:
		if _display_entries.size() >= INVENTORY_CAPACITY:
			break
		if remaining_eq.has(slot_id):
			_display_entries.append({
				"name": str(remaining_eq[slot_id]),
				"equipped": true,
				"slot": slot_id,
				"inv_index": -1
			})
			remaining_eq.erase(slot_id)

	for slot_id: String in remaining_eq.keys():
		if _display_entries.size() >= INVENTORY_CAPACITY:
			break
		_display_entries.append({
			"name": str(remaining_eq[slot_id]),
			"equipped": true,
			"slot": slot_id,
			"inv_index": -1
		})

	if selected_row_index >= _display_entries.size():
		selected_row_index = -1

	var atlas_loader: Node = _get_atlas_loader()
	var sdb: Node = _get_stats_db()

	for i: int in range(INVENTORY_CAPACITY):
		var lbl: Label = row_name_labels[i]
		var icon: Sprite2D = row_icon_sprites[i]
		var eq_badge: TextureRect = row_equip_icons[i]

		if i < _display_entries.size():
			var entry: Dictionary = _display_entries[i]
			var item_name: String = str(entry["name"])
			lbl.text = item_name
			eq_badge.visible = bool(entry["equipped"])
			_apply_item_sprite(icon, item_name, atlas_loader, sdb)
			icon.visible = (icon.texture != null)
		else:
			lbl.text = "(empty)"
			eq_badge.visible = false
			icon.texture = null
			icon.visible = false

	_refresh_row_highlights()
	_update_selection_details()


func _refresh_row_highlights() -> void:
	for i: int in range(INVENTORY_CAPACITY):
		row_bg_rects[i].texture = _tex_panel_selected if (i == selected_row_index) else _tex_panel_normal


func _on_row_gui_input(event: InputEvent, index: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if index < _display_entries.size():
			select_item(index)
			if event.double_click:
				var entry: Dictionary = _display_entries[index]
				if bool(entry.get("equipped", false)):
					_on_unequip_clicked()
				else:
					var sdb: Node = _get_stats_db()
					var itm_info: Dictionary = _lookup_item_stats(sdb, str(entry.get("name", "")))
					var itm_cat: String = str(itm_info.get("_category", "item")).to_lower()
					if itm_cat in ["helmet", "shirt", "legs", "shoes", "weapon", "acc"]:
						_on_equip_clicked()
					elif itm_cat == "item" or int(itm_info.get("heal", itm_info.get("h", 0))) > 0:
						_on_use_clicked()


func _on_scroll_btn_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_dragging_scroll = event.pressed
	elif event is InputEventMouseMotion and _dragging_scroll:
		var local_y: float = clampf(get_local_mouse_position().y - 19.0, SCROLL_MIN_Y, SCROLL_MAX_Y)
		scroll_btn.position.y = local_y
		var ratio: float = (local_y - SCROLL_MIN_Y) / maxf(1.0, SCROLL_MAX_Y - SCROLL_MIN_Y)
		var max_scroll: float = maxf(0.0, list_content.size.y - inventory_scroll.size.y)
		inventory_scroll.scroll_vertical = int(round(ratio * max_scroll))


func _on_vscroll_value_changed(val: float) -> void:
	if _dragging_scroll:
		return
	var max_scroll: float = maxf(1.0, list_content.size.y - inventory_scroll.size.y)
	var ratio: float = clampf(val / max_scroll, 0.0, 1.0)
	scroll_btn.position.y = lerpf(SCROLL_MIN_Y, SCROLL_MAX_Y, ratio)


func _apply_item_sprite(sprite: Sprite2D, item_name: String, atlas_loader: Node, sdb: Node) -> void:
	var lookup_name: String = item_name
	if lookup_name.begins_with("shiny "):
		var no_shiny: String = lookup_name.substr(6)
		if atlas_loader.get_starling_texture("items_pets_bodies", lookup_name) == null:
			lookup_name = no_shiny

	var tex: Texture2D = atlas_loader.get_starling_texture("items_pets_bodies", lookup_name)
	if tex == null:
		tex = atlas_loader.get_starling_texture("trees_fish", lookup_name)
	sprite.texture = tex
	if tex == null:
		sprite.rotation = 0.0
		return

	var pivot: Vector2 = atlas_loader.get_pivot(lookup_name, "items_pets_bodies")
	if pivot != Vector2.ZERO:
		sprite.centered = false
		sprite.offset = -pivot
	else:
		sprite.centered = true
		sprite.offset = Vector2.ZERO

	var itm_info: Dictionary = _lookup_item_stats(sdb, item_name)
	var itm_cat: String = str(itm_info.get("_category", "")).to_lower()
	if itm_cat.is_empty():
		itm_cat = _guess_type_for_rotation(item_name)
	# Item.as:122-125: оружие поворачивается на -55 градусов
	sprite.rotation = deg_to_rad(-55.0) if itm_cat == "weapon" else 0.0


func _guess_type_for_rotation(item_name: String) -> String:
	var l: String = item_name.to_lower()
	if l.contains("sword") or l.contains("bow") or l.contains("staff") or l.contains("gun") or l.contains("stick") or l.contains("axe") or l.contains("blade") or l.contains("shield") or l.contains("wand") or l.contains("slingshot"):
		return "weapon"
	return ""


func _hide_dual_wield_menu() -> void:
	_pending_dual_item = ""
	if dual_wield_panel != null:
		dual_wield_panel.visible = false


func _show_alert(msg: String) -> void:
	if msg.is_empty():
		return
	if alert_panel != null and alert_label != null:
		alert_label.text = msg
		alert_panel.visible = true


func _format_item_stats_lines(itm_data: Dictionary, preview_tex: Texture2D) -> PackedStringArray:
	var itm_cat: String = str(itm_data.get("_category", "item")).to_lower()
	var stats_lines: PackedStringArray = PackedStringArray()
	var def_val: int = _safe_int(itm_data.get("def", 0))
	var min_p: int = _safe_int(itm_data.get("min", 0))
	var max_p: int = _safe_int(itm_data.get("max", 0))
	var heal_val: int = _safe_int(itm_data.get("heal", itm_data.get("h", 0)))

	# ItemGameMenu.as:150-240, 347-376, 466-485
	match itm_cat:
		"weapon":
			if def_val == 0:
				stats_lines.append("Power: %d-%d" % [min_p, max_p])
				var is_range: bool = bool(itm_data.get("rng", false))
				var sr_val: int = _safe_int(itm_data.get("sr", 0))
				if not is_range:
					var h_px: float = float(preview_tex.get_height()) if preview_tex != null else 0.0
					var reach_ft: int = int(round((h_px / 20.0) * 10.0)) / 10 if h_px > 0.0 else 0
					if reach_ft > 0:
						stats_lines.append("Reach: %d feet" % reach_ft)
				elif sr_val == 0:
					stats_lines.append("Reach: 100 feet")
				else:
					stats_lines.append("Reach: 70 feet")
				if bool(itm_data.get("mgc", false)):
					stats_lines.append("Is Magic: yes")
				var fire_dmg: int = _safe_int(itm_data.get("fire", 0))
				if fire_dmg > 0:
					stats_lines.append("Fire Damage: %d" % fire_dmg)
				var shock_dmg: int = _safe_int(itm_data.get("shock", 0))
				if shock_dmg > 0:
					stats_lines.append("Shock Damage: %d" % shock_dmg)
				var ice_dmg: int = _safe_int(itm_data.get("ice", 0))
				if ice_dmg > 0:
					stats_lines.append("Ice Damage: %d" % ice_dmg)
				if sr_val > 0:
					stats_lines.append("Shots per min: %d" % int(30.0 / float(sr_val) * 60.0))
			else:
				stats_lines.append("Defense: %d" % def_val)
			stats_lines.append("Two Handed: %s" % ("yes" if bool(itm_data.get("two", false)) else "no"))
		"helmet", "shirt", "legs", "shoes", "acc":
			if itm_data.has("def") or def_val > 0:
				stats_lines.append("Defense: %d" % def_val)
			var rng_bonus: int = _safe_int(itm_data.get("rng", 0))
			if rng_bonus > 0:
				stats_lines.append("Range: %d" % rng_bonus)
			var mgc_bonus: int = _safe_int(itm_data.get("mgc", 0))
			if mgc_bonus > 0:
				stats_lines.append("Magic: %d" % mgc_bonus)
			var pow_bonus: int = _safe_int(itm_data.get("pow", 0))
			if pow_bonus > 0:
				stats_lines.append("Power: %d" % pow_bonus)
			var art_bonus: int = _safe_int(itm_data.get("art", 0))
			if art_bonus > 0:
				stats_lines.append("Artillery: %d" % art_bonus)
		"pet_helmet":
			stats_lines.append("Defense: %d" % def_val)
			var luck_val: int = _safe_int(itm_data.get("l", itm_data.get("luck", 0)))
			if luck_val > 0:
				stats_lines.append("Luck: %d" % luck_val)
			if heal_val > 0:
				stats_lines.append("Heal: %d" % heal_val)
			var spd_val: float = float(_safe_int(itm_data.get("spe", itm_data.get("speed", 0))))
			if spd_val > 0.0:
				var mph: float = roundf((spd_val / 85.0) * 100.0) / 100.0
				stats_lines.append("Speed: +%s mph" % str(mph))
		_:
			if max_p > 0:
				stats_lines.append("Power: %d-%d" % [min_p, max_p])
			if def_val > 0:
				stats_lines.append("Defense: %d" % def_val)
			if heal_val > 0:
				stats_lines.append("Heals: %d hp" % heal_val)

	if itm_data.has("lvl"):
		if itm_cat == "pet_helmet":
			stats_lines.append("Required Pet Lev: %d" % _safe_int(itm_data.get("lvl", 1)))
		elif itm_cat in ["helmet", "shirt", "legs", "shoes", "weapon", "acc"]:
			stats_lines.append("Required Lev: %d" % _safe_int(itm_data.get("lvl", 1)))
	return stats_lines


func _populate_compare_card(
	card: Control,
	type_lbl: Label,
	title_lbl: Label,
	stats_lbl: Label,
	icon: Sprite2D,
	type_text: String,
	eq_item_name: String,
	slot_hint: String,
	atlas_loader: Node,
	sdb: Node
) -> void:
	if card == null:
		return
	if eq_item_name.is_empty() or eq_item_name == "none" or eq_item_name == "nothing":
		card.visible = false
		return
	card.visible = true
	type_lbl.text = type_text
	title_lbl.text = eq_item_name
	_apply_item_sprite(icon, eq_item_name, atlas_loader, sdb)
	var info: Dictionary = _lookup_item_stats(sdb, eq_item_name, slot_hint)
	stats_lbl.text = "\n".join(_format_item_stats_lines(info, icon.texture))


func _update_compare_cards(selected_name: String, itm_cat: String, atlas_loader: Node, sdb: Node) -> void:
	if your_item_panel == null or your_item2_panel == null:
		return
	if person == null or itm_cat in ["item", "fish", "pet_helmet", "pet", ""]:
		your_item_panel.visible = false
		your_item2_panel.visible = false
		return
	var eq: Variant = person.get("equipment")
	if not (eq is Dictionary):
		your_item_panel.visible = false
		your_item2_panel.visible = false
		return
	var eq_dict: Dictionary = eq
	var slot_key: String = _resolve_slot_by_type(itm_cat, selected_name)
	var eq1_name: String = str(eq_dict.get(slot_key, ""))
	var eq2_name: String = str(eq_dict.get("weapon2", "")) if itm_cat == "weapon" else ""
	var has_dual: bool = (itm_cat == "weapon" and not eq2_name.is_empty() and eq2_name != "none" and eq2_name != "nothing")
	var type1_label: String = ("primary weapon" if has_dual else "current %s" % itm_cat)
	_populate_compare_card(
		your_item_panel, your_item_type_label, your_item_title_label, your_item_stats_label, your_item_sprite,
		type1_label, eq1_name, slot_key, atlas_loader, sdb
	)
	if has_dual:
		_populate_compare_card(
			your_item2_panel, your_item2_type_label, your_item2_title_label, your_item2_stats_label, your_item2_sprite,
			"secondary weapon", eq2_name, "weapon2", atlas_loader, sdb
		)
	else:
		your_item2_panel.visible = false


func _update_selection_details() -> void:
	_hide_dual_wield_menu()
	if selected_row_index < 0 or selected_row_index >= _display_entries.size():
		item_title_label.text = ""
		item_stats_label.text = ""
		item_desc_label.text = ""
		item_preview_sprite.texture = null
		item_preview_sprite.visible = false
		btn_equip.visible = false
		btn_unequip.visible = false
		btn_use.visible = false
		btn_drop.visible = false
		if btn_store != null:
			btn_store.visible = false
		if your_item_panel != null:
			your_item_panel.visible = false
		if your_item2_panel != null:
			your_item2_panel.visible = false
		return

	var entry: Dictionary = _display_entries[selected_row_index]
	var target_item_name: String = str(entry["name"])
	var is_equipped: bool = bool(entry["equipped"])
	var slot_hint: String = str(entry.get("slot", ""))

	var atlas_loader: Node = _get_atlas_loader()
	var sdb: Node = _get_stats_db()
	_apply_item_sprite(item_preview_sprite, target_item_name, atlas_loader, sdb)
	item_preview_sprite.visible = (item_preview_sprite.texture != null)

	item_title_label.text = target_item_name
	var itm_data: Dictionary = _lookup_item_stats(sdb, target_item_name, slot_hint)
	var itm_cat: String = str(itm_data.get("_category", "item")).to_lower()
	var heal_val: int = _safe_int(itm_data.get("heal", itm_data.get("h", 0)))

	item_stats_label.text = "\n".join(_format_item_stats_lines(itm_data, item_preview_sprite.texture))
	var desc_text: String = str(itm_data.get("d", itm_data.get("desc", itm_data.get("description", ""))))
	if desc_text.is_empty() and sdb != null:
		var descs_dict: Variant = sdb.get("item_descs")
		if descs_dict is Dictionary:
			var d_entry: Variant = descs_dict.get(target_item_name, descs_dict.get(target_item_name.to_lower(), {}))
			if d_entry is Dictionary:
				desc_text = str(d_entry.get("d", d_entry.get("desc", "")))
	item_desc_label.text = desc_text
	_update_compare_cards(target_item_name, itm_cat, atlas_loader, sdb)

	# Видимость кнопок по ItemMenu.as:559, 579-606 (в режиме банка STORE вместо EQUIP/USE)
	btn_drop.visible = (itm_cat != "fish")
	if is_bank_store_mode:
		btn_equip.visible = false
		btn_unequip.visible = false
		btn_use.visible = false
		if btn_store != null:
			btn_store.visible = not is_equipped
		return
	if btn_store != null:
		btn_store.visible = false
	var is_equipment: bool = itm_cat in ["helmet", "shirt", "legs", "shoes", "weapon", "acc"]
	var is_consumable: bool = (not is_equipment) and (itm_cat == "item" or heal_val > 0)
	if is_equipment:
		btn_equip.visible = not is_equipped
		btn_unequip.visible = is_equipped
		btn_use.visible = false
	elif is_consumable:
		btn_equip.visible = false
		btn_unequip.visible = false
		btn_use.visible = true
	else:
		btn_equip.visible = false
		btn_unequip.visible = false
		btn_use.visible = false


func set_bank_store_mode(enabled: bool) -> void:
	is_bank_store_mode = enabled
	update_display()


func _on_store_clicked() -> void:
	if person == null or selected_row_index < 0 or selected_row_index >= _display_entries.size():
		return
	var entry: Dictionary = _display_entries[selected_row_index]
	if bool(entry.get("equipped", false)):
		return
	var inv_idx: int = int(entry.get("inv_index", -1))
	if inv_idx >= 0:
		store_item_requested.emit(inv_idx)


func _on_equip_clicked() -> void:
	if person == null or selected_row_index < 0 or selected_row_index >= _display_entries.size():
		return
	var entry: Dictionary = _display_entries[selected_row_index]
	if bool(entry["equipped"]):
		return
	var item_name: String = str(entry["name"])
	var sdb: Node = _get_stats_db()
	var itm_info: Dictionary = _lookup_item_stats(sdb, item_name)
	var itm_cat: String = str(itm_info.get("_category", "")).to_lower()
	var is_shield: bool = (itm_cat == "weapon" and _safe_int(itm_info.get("def", 0)) > 0)
	var is_two: bool = bool(itm_info.get("two", false))
	var is_dual_gun: bool = bool(person.call("is_dual_gun_weapon", item_name)) if person.has_method("is_dual_gun_weapon") else false

	# MainStarlingStage.as:673-682: 1H оружие и dual-gun показывают диалог Primary/Secondary
	if itm_cat == "weapon" and not is_shield and (not is_two or is_dual_gun) and dual_wield_panel != null:
		_pending_dual_item = item_name
		dual_wield_panel.visible = true
		return

	var target_slot: String = _resolve_slot_by_type(itm_cat, item_name)
	if not target_slot.is_empty():
		_equip_selected_to_slot(item_name, target_slot)


func _on_dual_primary_clicked() -> void:
	var item_name: String = _pending_dual_item
	_hide_dual_wield_menu()
	if not item_name.is_empty():
		_equip_selected_to_slot(item_name, "weapon")


func _on_dual_secondary_clicked() -> void:
	var item_name: String = _pending_dual_item
	_hide_dual_wield_menu()
	if not item_name.is_empty():
		_equip_selected_to_slot(item_name, "weapon2")


func _equip_selected_to_slot(item_name: String, target_slot: String) -> void:
	if person == null:
		return
	var ok: Variant = person.call("equip_item", item_name, target_slot)
	if ok is bool and not bool(ok):
		var err_msg: String = str(person.get("last_equip_error"))
		_show_alert(err_msg if not err_msg.is_empty() else "Cannot equip %s" % item_name)
		return
	selected_row_index = -1
	update_display()


func _on_unequip_clicked() -> void:
	if person == null or selected_row_index < 0 or selected_row_index >= _display_entries.size():
		return
	var entry: Dictionary = _display_entries[selected_row_index]
	var slot_id: String = str(entry.get("slot", ""))
	if slot_id.is_empty():
		return
	var ok: Variant = person.call("unequip_item", slot_id)
	if ok is bool and not bool(ok):
		var err_msg: String = str(person.get("last_equip_error"))
		_show_alert(err_msg if not err_msg.is_empty() else "Cannot unequip %s" % str(entry.get("name", "")))
		return
	selected_row_index = -1
	update_display()


func _on_use_clicked() -> void:
	if person == null or selected_row_index < 0 or selected_row_index >= _display_entries.size():
		return
	var entry: Dictionary = _display_entries[selected_row_index]
	var item_name: String = str(entry["name"])
	person.call("use_item", item_name)
	selected_row_index = -1
	update_display()


func _on_drop_clicked() -> void:
	if person == null or selected_row_index < 0 or selected_row_index >= _display_entries.size():
		return
	var entry: Dictionary = _display_entries[selected_row_index]
	var item_name: String = str(entry["name"])
	if bool(entry["equipped"]) and not str(entry.get("slot", "")).is_empty():
		person.call("unequip_item", str(entry["slot"]))
	var world_node: Node = person.get("game_world") as Node
	if world_node == null and is_inside_tree():
		world_node = get_tree().current_scene
	if world_node != null and world_node.has_method("spawn_dropped_item"):
		var drop_pos: Vector2 = person.global_position + Vector2(0.0, -16.0) if person is Node2D else Vector2.ZERO
		world_node.call("spawn_dropped_item", item_name, drop_pos, str(person.get("character_name")))
	person.call("remove_inventory_item", item_name)
	var amgr: Node = get_tree().root.get_node_or_null("AudioManager") if is_inside_tree() else null
	if amgr != null and amgr.has_method("play_sfx"):
		amgr.call("play_sfx", "SFX/pickup")
	selected_row_index = -1
	update_display()


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
	for cat: String in ["helmet", "shirt", "legs", "shoes", "weapon", "acc", "item", "pet_helmet", "pet"]:
		var d: Dictionary = sdb.get_item_stats_data(cat, item_name)
		if not d.is_empty():
			return d
	return {}


func _resolve_slot_by_type(itm_type: String, item_name: String) -> String:
	match itm_type.to_lower():
		"helmet", "hat":
			return "helmet"
		"shirt", "body", "armor":
			return "shirt"
		"pants", "legs":
			return "legs"
		"shoes", "boots":
			return "shoes"
		"weapon", "shield":
			return "weapon"
		"weapon2":
			return "weapon2"
		"acc", "accessory", "ring":
			return "accessory"
	var l_name: String = item_name.to_lower()
	if l_name.contains("helm") or l_name.contains("hat") or l_name.contains("cap"):
		return "helmet"
	if l_name.contains("shirt") or l_name.contains("armor") or l_name.contains("robe"):
		return "shirt"
	if l_name.contains("pants") or l_name.contains("jeans") or l_name.contains("legs") or l_name.contains("shorts"):
		return "legs"
	if l_name.contains("shoe") or l_name.contains("boot"):
		return "shoes"
	if l_name.contains("sword") or l_name.contains("bow") or l_name.contains("staff") or l_name.contains("gun") or l_name.contains("stick") or l_name.contains("wand") or l_name.contains("slingshot"):
		return "weapon"
	if l_name.contains("shield"):
		return "weapon"
	return "accessory"


func close_menu() -> void:
	_hide_dual_wield_menu()
	if alert_panel != null:
		alert_panel.visible = false
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
