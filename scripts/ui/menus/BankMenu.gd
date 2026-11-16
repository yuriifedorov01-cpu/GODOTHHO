extends Control
class_name BankMenu
## BankMenu — Личный банковский счёт и хранилище предметов (порт BankMenu.as + item menu.xml).

signal closed()

@export var is_draggable: bool = true

var person: Node = null
var bank_money: int = 0
var bank_items: Array[String] = []
const MAX_BANK_ITEMS: int = 40
const VISIBLE_SLOTS: int = 13

var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

var _money_lbl: Label = null
var _carried_lbl: Label = null
var _withdraw_input: LineEdit = null
var _deposit_input: LineEdit = null
var _status_lbl: Label = null
var _slot_buttons: Array[TextureButton] = []
var _slot_labels: Array[Label] = []
var _selected_bank_idx: int = -1


func _ready() -> void:
	custom_minimum_size = Vector2(651, 492)
	size = Vector2(651, 492)
	mouse_filter = Control.MOUSE_FILTER_STOP
	_load_from_profile()
	_build_ui()
	refresh()


func bind_person(target_person: Node) -> void:
	person = target_person
	refresh()


func _load_from_profile() -> void:
	var pio: Node = get_node_or_null("/root/PlayerIOClient")
	if pio != null and "my_player_object" in pio and pio.my_player_object is Dictionary:
		var obj: Dictionary = pio.my_player_object
		bank_money = int(obj.get("bank_money", 0))
		bank_items.clear()
		var raw: Variant = obj.get("bank_items", [])
		if raw is Array:
			for it: Variant in raw:
				var s: String = str(it).strip_edges()
				if not s.is_empty():
					bank_items.append(s)


func _save_to_profile() -> void:
	var pio: Node = get_node_or_null("/root/PlayerIOClient")
	if pio != null and "my_player_object" in pio and pio.my_player_object is Dictionary:
		pio.my_player_object["bank_money"] = bank_money
		pio.my_player_object["bank_items"] = bank_items.duplicate()
		if person != null and "coins" in person:
			pio.my_player_object["money"] = int(person.coins)
		if pio.has_method("save_sandbox_profile"):
			pio.call("save_sandbox_profile")


func _build_ui() -> void:
	var atlas: Node = _get_atlas_loader()
	atlas.register_starling_atlas("item menu")
	var stats_font: Font = atlas.get_bitmap_font("stats_font.fnt")
	var readable_font: Font = atlas.get_bitmap_font("readable_font.fnt")

	# Оригинальная панель банка ("bank panel" 651x492 из item menu.xml, смещение (-314, -187))
	var panel_tex: Texture2D = atlas.get_starling_texture("item menu", "bank panel")
	if panel_tex != null:
		var bg := TextureRect.new()
		bg.texture = panel_tex
		bg.position = Vector2.ZERO
		bg.size = Vector2(651, 492)
		bg.mouse_filter = Control.MOUSE_FILTER_PASS
		add_child(bg)

	# Кнопка закрытия (BankMenu.as:67-70: (330,-106) -> (614, 62))
	var close_btn := TextureButton.new()
	close_btn.texture_normal = atlas.get_starling_texture("item menu", "x_btn_00")
	close_btn.texture_hover = atlas.get_starling_texture("item menu", "x_btn_01")
	close_btn.position = Vector2(614, 62)
	close_btn.focus_mode = Control.FOCUS_NONE
	close_btn.pressed.connect(close_menu)
	add_child(close_btn)

	# 13 слотов хранения предметов слева (BankMenu.as:97-117)
	var slot_tex: Texture2D = atlas.get_starling_texture("item menu", "item panel_00")
	for i: int in range(VISIBLE_SLOTS):
		var sbtn := TextureButton.new()
		sbtn.texture_normal = slot_tex
		sbtn.position = Vector2(17, 15 + i * 33)
		sbtn.focus_mode = Control.FOCUS_NONE
		sbtn.pressed.connect(_on_slot_clicked.bind(i))
		add_child(sbtn)
		_slot_buttons.append(sbtn)

		var slbl := Label.new()
		slbl.text = "(empty)"
		slbl.position = Vector2(58, 17 + i * 33)
		slbl.size = Vector2(196, 23)
		slbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		slbl.add_theme_font_override("font", readable_font)
		slbl.add_theme_font_size_override("font_size", 14)
		slbl.add_theme_color_override("font_color", Color.WHITE)
		slbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(slbl)
		_slot_labels.append(slbl)

	# Кнопка снятия выбранного предмета (BankMenu.as:88-94)
	var item_wd_btn := TextureButton.new()
	item_wd_btn.texture_normal = atlas.get_starling_texture("item menu", "withdrawl_00")
	item_wd_btn.position = Vector2(69, 446)
	item_wd_btn.focus_mode = Control.FOCUS_NONE
	item_wd_btn.pressed.connect(func() -> void:
		if _selected_bank_idx >= 0:
			withdraw_item(_selected_bank_idx)
	)
	add_child(item_wd_btn)

	# Баланс в банке и на руках (BankMenu.as:118-120: (-33, -74) -> (281, 113))
	_money_lbl = Label.new()
	_money_lbl.position = Vector2(281, 113)
	_money_lbl.size = Vector2(337, 56)
	_money_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_money_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_money_lbl.add_theme_font_override("font", readable_font)
	_money_lbl.add_theme_font_size_override("font_size", 16)
	_money_lbl.add_theme_color_override("font_color", Color.WHITE)
	add_child(_money_lbl)

	# Поля ввода (BankMenu.as:146-165: withdraw (-32,92)->(282,279), deposit (159,91)->(473,278))
	_withdraw_input = LineEdit.new()
	_withdraw_input.placeholder_text = "0"
	_withdraw_input.position = Vector2(282, 279)
	_withdraw_input.size = Vector2(135, 28)
	_withdraw_input.max_length = 9
	add_child(_withdraw_input)

	_deposit_input = LineEdit.new()
	_deposit_input.placeholder_text = "0"
	_deposit_input.position = Vector2(473, 278)
	_deposit_input.size = Vector2(135, 28)
	_deposit_input.max_length = 9
	add_child(_deposit_input)

	# Оригинальные кнопки WITHDRAW / DEPOSIT (BankMenu.as:73-84)
	var wd_btn := TextureButton.new()
	wd_btn.texture_normal = atlas.get_starling_texture("item menu", "withdrawl_00")
	wd_btn.position = Vector2(277, 313)
	wd_btn.focus_mode = Control.FOCUS_NONE
	wd_btn.pressed.connect(_on_withdraw_pressed)
	add_child(wd_btn)

	var dep_btn := TextureButton.new()
	dep_btn.texture_normal = atlas.get_starling_texture("item menu", "deposit_00")
	dep_btn.position = Vector2(484, 313)
	dep_btn.focus_mode = Control.FOCUS_NONE
	dep_btn.pressed.connect(_on_deposit_pressed)
	add_child(dep_btn)

	_status_lbl = Label.new()
	_status_lbl.position = Vector2(281, 368)
	_status_lbl.size = Vector2(337, 26)
	_status_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status_lbl.add_theme_font_override("font", readable_font)
	_status_lbl.add_theme_font_size_override("font_size", 13)
	_status_lbl.add_theme_color_override("font_color", Color(1.0, 0.9, 0.45))
	add_child(_status_lbl)


func refresh() -> void:
	_load_from_profile()
	var carried: int = int(person.coins) if (person != null and "coins" in person) else 0
	if _money_lbl != null:
		_money_lbl.text = "Money in bank: $%d\nCarrying money: $%d" % [bank_money, carried]
	for i: int in range(VISIBLE_SLOTS):
		if i < _slot_labels.size():
			_slot_labels[i].text = bank_items[i] if i < bank_items.size() else "(empty)"
			_slot_buttons[i].modulate = Color(1.2, 1.2, 0.7) if i == _selected_bank_idx else Color.WHITE


func _on_slot_clicked(idx: int) -> void:
	if idx < bank_items.size():
		_selected_bank_idx = idx
	else:
		_selected_bank_idx = -1
	refresh()


func deposit_money(amount: int) -> bool:
	if person == null or not ("coins" in person) or amount <= 0 or int(person.coins) < amount:
		if _status_lbl != null:
			_status_lbl.text = "Invalid deposit amount."
		return false
	person.coins -= amount
	if person.has_signal("coins_changed"):
		person.coins_changed.emit(person.coins)
	bank_money += amount
	_save_to_profile()
	refresh()
	if _status_lbl != null:
		_status_lbl.text = "Deposited $%d." % amount
	return true


func withdraw_money(amount: int) -> bool:
	if person == null or not ("coins" in person) or amount <= 0 or bank_money < amount:
		if _status_lbl != null:
			_status_lbl.text = "Invalid withdraw amount."
		return false
	bank_money -= amount
	person.coins += amount
	if person.has_signal("coins_changed"):
		person.coins_changed.emit(person.coins)
	_save_to_profile()
	refresh()
	if _status_lbl != null:
		_status_lbl.text = "Withdrew $%d." % amount
	return true


func deposit_item(idx: int) -> bool:
	if person == null or not ("inventory" in person) or idx < 0 or idx >= person.inventory.size():
		return false
	if bank_items.size() >= MAX_BANK_ITEMS:
		if _status_lbl != null:
			_status_lbl.text = "Bank storage is full (%d/%d)." % [bank_items.size(), MAX_BANK_ITEMS]
		return false
	var item_name: String = str(person.inventory[idx])
	person.inventory.remove_at(idx)
	bank_items.append(item_name)
	_save_to_profile()
	refresh()
	if _status_lbl != null:
		_status_lbl.text = "Stored '%s' in bank." % item_name
	return true


func withdraw_item(idx: int) -> bool:
	if person == null or idx < 0 or idx >= bank_items.size():
		return false
	var item_name: String = bank_items[idx]
	if person.has_method("add_inventory_item") and not bool(person.call("add_inventory_item", item_name)):
		if _status_lbl != null:
			_status_lbl.text = "Inventory is full!"
		return false
	bank_items.remove_at(idx)
	_selected_bank_idx = -1
	_save_to_profile()
	refresh()
	if _status_lbl != null:
		_status_lbl.text = "Withdrew '%s' from bank." % item_name
	return true


func _on_deposit_pressed() -> void:
	var amt: int = int(_deposit_input.text) if _deposit_input != null else 0
	deposit_money(amt)


func _on_withdraw_pressed() -> void:
	var amt: int = int(_withdraw_input.text) if _withdraw_input != null else 0
	withdraw_money(amt)


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
			move_to_front()
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
