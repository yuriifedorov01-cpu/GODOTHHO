extends Control
class_name PetShopMenu
## PetShopMenu — Окно магазина питомцев (порт com.menus.PetShopMenu.as + GameMain.as:7715-7745).

const PET_DATA_PATH: String = "res://assets/client_data/data/petData.json"

const VENDOR_PETS: Dictionary = {
	42: ["Tebra", "Marshy", "Baby Bounce", "Petri", "Gibler", "Fisky"],
	43: ["Roblost", "Pumpman", "Chippy", "Thumper", "Nooter", "Gobloid"],
	44: ["Ritardo", "Ozich", "Topper", "Bunyan", "Quackster"],
	45: ["Dwimplepike", "Squatch", "Stalkling", "Civic"],
}

const FALLBACK_PET_STATS: Dictionary = {
	"Civic": {"key": "Civic", "type": "Civic", "health": 22, "totalHealth": 22, "power": 8, "dex": 4, "def": 3, "love": 10, "lvl": 1, "xp": 0, "coins": 340000}
}

var person: PersonEntity = null
var _pet_db: Dictionary = {}
var _current_pets: Array[Dictionary] = []
var _selected_idx: int = -1

var _slot_buttons: Array[TextureButton] = []
var _slot_icons: Array[TextureRect] = []
var _preview_body: TextureRect = null
var _preview_head: TextureRect = null
var _name_lbl: Label = null
var _stats_lbl: Label = null
var _price_lbl: Label = null
var _status_lbl: Label = null
var _buy_btn: TextureButton = null
var _close_btn: TextureButton = null

var _dragging: bool = false
var _drag_offset: Vector2 = Vector2.ZERO
var _anim_t: float = 0.0

signal pet_purchased(pet_data: Dictionary)


func _ready() -> void:
	custom_minimum_size = Vector2(796, 283)
	size = Vector2(796, 283)
	mouse_filter = Control.MOUSE_FILTER_STOP
	_load_pet_data()
	_build_ui()


func _process(delta: float) -> void:
	if not visible:
		return
	_anim_t += delta * 4.0
	if _preview_head != null and _preview_head.visible:
		_preview_head.position.y = 44.0 + sin(_anim_t) * 2.5
	if _preview_body != null and _preview_body.visible:
		_preview_body.position.y = 66.0 + sin(_anim_t - 0.5) * 1.5


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb: InputEventMouseButton = event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT:
			if mb.pressed:
				_dragging = true
				_drag_offset = get_global_mouse_position() - global_position
			else:
				_dragging = false
	elif event is InputEventMouseMotion and _dragging:
		global_position = get_global_mouse_position() - _drag_offset


static func _get_atlas_loader() -> Node:
	if Engine.has_singleton("StarlingAtlasLoader"):
		return Engine.get_singleton("StarlingAtlasLoader")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("StarlingAtlasLoader"):
		return tree.root.get_node("StarlingAtlasLoader")
	return load("res://scripts/autoload/StarlingAtlasLoader.gd").new()


func _load_pet_data() -> void:
	_pet_db.clear()
	var abs_path: String = ProjectSettings.globalize_path(PET_DATA_PATH)
	if not FileAccess.file_exists(abs_path):
		return
	var txt: String = FileAccess.get_file_as_string(abs_path)
	var parsed: Variant = JSON.parse_string(txt)
	if parsed is Array:
		for item: Variant in parsed:
			if item is Dictionary:
				var k: String = str((item as Dictionary).get("key", ""))
				if not k.is_empty():
					_pet_db[k] = item
	for fk: String in FALLBACK_PET_STATS.keys():
		if not _pet_db.has(fk):
			_pet_db[fk] = FALLBACK_PET_STATS[fk]


func _build_ui() -> void:
	var atlas: Node = _get_atlas_loader()
	atlas.register_starling_atlas("pet menu")
	atlas.register_starling_atlas("item menu")
	atlas.register_starling_atlas("items_pets_bodies")

	var bg_tex: Texture2D = atlas.get_starling_texture("pet menu", "pet shop panel")
	if bg_tex != null:
		var bg := TextureRect.new()
		bg.texture = bg_tex
		bg.position = Vector2.ZERO
		bg.size = Vector2(796, 283)
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(bg)
	else:
		var panel := Panel.new()
		panel.size = Vector2(796, 283)
		panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(panel)

	var slot_n: Texture2D = atlas.get_starling_texture("pet menu", "panel_00")
	var slot_s: Texture2D = atlas.get_starling_texture("pet menu", "panel_01")
	for i: int in range(6):
		var col: int = i % 3
		var row: int = i / 3
		var btn := TextureButton.new()
		btn.name = "PetSlot%d" % i
		btn.position = Vector2(28.0 + float(col) * 96.0, 44.0 + float(row) * 102.0)
		btn.custom_minimum_size = Vector2(88, 96)
		btn.size = Vector2(88, 96)
		btn.focus_mode = Control.FOCUS_NONE
		if slot_n != null:
			btn.texture_normal = slot_n
		if slot_s != null:
			btn.texture_hover = slot_s
			btn.texture_pressed = slot_s
		var idx: int = i
		btn.pressed.connect(func() -> void: _select_slot(idx))
		add_child(btn)
		_slot_buttons.append(btn)

		var icon := TextureRect.new()
		icon.position = Vector2(14, 18)
		icon.size = Vector2(60, 60)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		btn.add_child(icon)
		_slot_icons.append(icon)

	# Правая панель предпросмотра и статов
	_preview_body = TextureRect.new()
	_preview_body.position = Vector2(368, 66)
	_preview_body.size = Vector2(64, 48)
	_preview_body.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_preview_body.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_preview_body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_preview_body)

	_preview_head = TextureRect.new()
	_preview_head.position = Vector2(368, 44)
	_preview_head.size = Vector2(64, 54)
	_preview_head.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_preview_head.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_preview_head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_preview_head)

	var stats_font: Font = atlas.get_bitmap_font("stats_font.fnt") if atlas.has_method("get_bitmap_font") else ThemeDB.fallback_font
	_name_lbl = Label.new()
	_name_lbl.name = "PetNameLabel"
	_name_lbl.position = Vector2(465, 36)
	_name_lbl.size = Vector2(260, 28)
	_name_lbl.add_theme_font_override("font", stats_font)
	_name_lbl.add_theme_font_size_override("font_size", 18)
	_name_lbl.add_theme_color_override("font_color", Color.WHITE)
	add_child(_name_lbl)

	_stats_lbl = Label.new()
	_stats_lbl.name = "PetStatsLabel"
	_stats_lbl.position = Vector2(465, 68)
	_stats_lbl.size = Vector2(280, 120)
	_stats_lbl.add_theme_font_override("font", stats_font)
	_stats_lbl.add_theme_font_size_override("font_size", 14)
	_stats_lbl.add_theme_color_override("font_color", Color(0.92, 0.92, 0.92))
	add_child(_stats_lbl)

	_price_lbl = Label.new()
	_price_lbl.name = "PetPriceLabel"
	_price_lbl.position = Vector2(465, 192)
	_price_lbl.size = Vector2(200, 26)
	_price_lbl.add_theme_font_override("font", stats_font)
	_price_lbl.add_theme_font_size_override("font_size", 16)
	_price_lbl.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2))
	add_child(_price_lbl)

	_status_lbl = Label.new()
	_status_lbl.name = "PetStatusLabel"
	_status_lbl.position = Vector2(340, 232)
	_status_lbl.size = Vector2(260, 24)
	_status_lbl.add_theme_font_override("font", stats_font)
	_status_lbl.add_theme_font_size_override("font_size", 13)
	_status_lbl.add_theme_color_override("font_color", Color(0.5, 1.0, 0.5))
	add_child(_status_lbl)

	_buy_btn = TextureButton.new()
	_buy_btn.name = "PetBuyButton"
	_buy_btn.position = Vector2(630, 214)
	_buy_btn.focus_mode = Control.FOCUS_NONE
	var buy_tex: Texture2D = atlas.get_starling_texture("item menu", "buy_btn")
	if buy_tex != null:
		_buy_btn.texture_normal = buy_tex
		_buy_btn.custom_minimum_size = buy_tex.get_size()
		_buy_btn.size = buy_tex.get_size()
	else:
		_buy_btn.custom_minimum_size = Vector2(100, 36)
		_buy_btn.size = Vector2(100, 36)
	_buy_btn.pressed.connect(_on_buy_pressed)
	add_child(_buy_btn)

	_close_btn = TextureButton.new()
	_close_btn.name = "PetCloseButton"
	_close_btn.position = Vector2(746, 2)
	_close_btn.focus_mode = Control.FOCUS_NONE
	var x0: Texture2D = atlas.get_starling_texture("pet menu", "x_btn_00")
	var x1: Texture2D = atlas.get_starling_texture("pet menu", "x_btn_01")
	if x0 != null:
		_close_btn.texture_normal = x0
		_close_btn.custom_minimum_size = x0.get_size()
		_close_btn.size = x0.get_size()
	if x1 != null:
		_close_btn.texture_hover = x1
		_close_btn.texture_pressed = x1
	_close_btn.pressed.connect(func() -> void: visible = false)
	add_child(_close_btn)


func open_pet_shop(npc_data: Dictionary, player: PersonEntity) -> void:
	person = player
	var talk_id: int = int(npc_data.get("talkID", npc_data.get("talk_id", 42)))
	var names: Array = VENDOR_PETS.get(talk_id, VENDOR_PETS[42])
	_current_pets.clear()
	for pname: Variant in names:
		var pkey: String = str(pname)
		var pdict: Dictionary = _pet_db.get(pkey, {"key": pkey, "type": pkey, "health": 15, "totalHealth": 15, "power": 3, "dex": 3, "def": 2, "lvl": 1, "xp": 0, "coins": 200000}).duplicate(true)
		_current_pets.append(pdict)

	var atlas: Node = _get_atlas_loader()
	for i: int in range(6):
		var btn: TextureButton = _slot_buttons[i]
		var icon: TextureRect = _slot_icons[i]
		if i < _current_pets.size():
			btn.visible = true
			var ptype: String = str(_current_pets[i].get("type", ""))
			var tex: Texture2D = _find_pet_part_texture(atlas, ptype, "head")
			if tex == null:
				tex = _find_pet_part_texture(atlas, ptype, "body")
			icon.texture = tex
		else:
			btn.visible = false
			icon.texture = null

	_status_lbl.text = ""
	visible = true
	if _current_pets.size() > 0:
		_select_slot(0)


func _find_pet_part_texture(atlas: Node, pet_type: String, part: String) -> Texture2D:
	var lower: String = pet_type.to_lower()
	for candidate: String in ["%s %s" % [lower, part], "%s_%s" % [lower, part], lower, pet_type]:
		var tex: Texture2D = atlas.get_starling_texture("items_pets_bodies", candidate)
		if tex != null:
			return tex
	return null


func _select_slot(idx: int) -> void:
	if idx < 0 or idx >= _current_pets.size():
		return
	_selected_idx = idx
	var pet: Dictionary = _current_pets[idx]
	var ptype: String = str(pet.get("type", "Pet"))
	var atlas: Node = _get_atlas_loader()
	_preview_head.texture = _find_pet_part_texture(atlas, ptype, "head")
	_preview_body.texture = _find_pet_part_texture(atlas, ptype, "body")
	_name_lbl.text = ptype
	_stats_lbl.text = "Level: %d\nHealth: %d\nPower: %d\nDexterity: %d\nDefense: %d" % [
		int(pet.get("lvl", 1)),
		int(pet.get("health", 15)),
		int(pet.get("power", 3)),
		int(pet.get("dex", 3)),
		int(pet.get("def", 2)),
	]
	_price_lbl.text = "Cost: $%s" % _format_int(int(pet.get("coins", 0)))


func _on_buy_pressed() -> void:
	if person == null or _selected_idx < 0 or _selected_idx >= _current_pets.size():
		return
	var pet: Dictionary = _current_pets[_selected_idx].duplicate(true)
	var cost: int = int(pet.get("coins", 0))
	if person.coins < cost:
		_status_lbl.add_theme_color_override("font_color", Color(1.0, 0.35, 0.35))
		_status_lbl.text = "Not enough coins!"
		return
	person.coins -= cost
	person.coins_changed.emit(person.coins)
	pet["owner"] = person.character_name
	var tree: SceneTree = get_tree()
	var pio: Node = tree.root.get_node_or_null("PlayerIOClient") if tree != null else null
	if pio != null and "my_player_object" in pio and pio.my_player_object is Dictionary:
		var p_data: Variant = pio.my_player_object.get("petData", [])
		if not (p_data is Array):
			p_data = []
			pio.my_player_object["petData"] = p_data
		(p_data as Array).append(pet)
	_status_lbl.add_theme_color_override("font_color", Color(0.5, 1.0, 0.5))
	_status_lbl.text = "Purchased %s!" % str(pet.get("type", "Pet"))
	var amgr: Node = tree.root.get_node_or_null("AudioManager") if tree != null else null
	if amgr != null and amgr.has_method("play_sfx"):
		amgr.call("play_sfx", "SFX/coin get")
	pet_purchased.emit(pet)


static func _format_int(v: int) -> String:
	var s: String = str(absi(v))
	var out: String = ""
	var count: int = 0
	for i: int in range(s.length() - 1, -1, -1):
		if count > 0 and count % 3 == 0:
			out = "," + out
		out = s[i] + out
		count += 1
	return ("-" + out) if v < 0 else out
