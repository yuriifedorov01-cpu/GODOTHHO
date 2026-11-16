extends Control
class_name TalkBox
## TalkBox — Всплывающее окно разговора с NPC (порт com.menus.TalkBox.as и TalkText.as).
## Использует оригинальный атлас "talk box", шрифт readable_font.fnt,
## живой анимированный портрет NPC (BodyAnimatorNode) и 3 оригинальные кнопки:
## next_btn, shop_btn, sell_btn.

signal closed()
signal shop_requested(npc_data: Dictionary)
signal sell_requested(npc_data: Dictionary)
signal talk_action_triggered(talk_id: int, action_dict: Dictionary, npc_data: Dictionary)

const BodyAnimatorScript = preload("res://scripts/entities/BodyAnimatorNode.gd")
const NPCEntityScript = preload("res://scripts/entities/NPCEntity.gd")
const FLASH_OFFSET: Vector2 = Vector2(412.0, 104.0)

var npc_data: Dictionary = {}
var dialogue_lines: Array[String] = []
var current_line_index: int = 0
var current_talk_id: int = 0
var current_action: Dictionary = {}
var has_next_action: bool = false

var panel_bg: TextureRect = null
var portrait_animator: Node2D = null
var dialogue_label: Label = null

var btn_next: TextureButton = null
var btn_shop: TextureButton = null
var btn_sell: TextureButton = null

var _full_line_text: String = ""
var _shown_chars: float = 0.0
var _is_typing: bool = false


func _init(target_npc: Dictionary = {}) -> void:
	npc_data = target_npc


func _ready() -> void:
	custom_minimum_size = Vector2(828, 242)
	size = Vector2(828, 242)
	_build_ui()
	if not npc_data.is_empty():
		start_dialogue(npc_data)


func _physics_process(_delta: float) -> void:
	if visible and portrait_animator != null and portrait_animator.is_playing:
		portrait_animator.advance_frame()


func _process(delta: float) -> void:
	if not visible or not _is_typing or dialogue_label == null:
		return
	_shown_chars += delta * 60.0
	var count: int = int(_shown_chars)
	if count >= _full_line_text.length():
		dialogue_label.text = _full_line_text
		_is_typing = false
	else:
		dialogue_label.text = _full_line_text.substr(0, count)


func _build_ui() -> void:
	var atlas_loader: Node = _get_atlas_loader()
	atlas_loader.register_starling_atlas("talk box")
	atlas_loader.register_starling_atlas("items_pets_bodies")
	var readable_font: Font = atlas_loader.get_bitmap_font("readable_font.fnt")

	var bg_tex: Texture2D = atlas_loader.get_starling_texture("talk box", "panel")
	panel_bg = TextureRect.new()
	panel_bg.name = "PanelBG"
	panel_bg.texture = bg_tex
	panel_bg.position = Vector2.ZERO
	panel_bg.size = Vector2(828, 242)
	add_child(panel_bg)

	# Живой анимированный портрет NPC (TalkBox.as:73-88: personClone в (-339, -10))
	portrait_animator = BodyAnimatorScript.new()
	portrait_animator.name = "PortraitAnimator"
	portrait_animator.position = Vector2(-339.0, -10.0) + FLASH_OFFSET
	add_child(portrait_animator)

	# Текст реплики (TalkBox.as:20: (-267, -87), 672x162, readable_font 16px, белый)
	dialogue_label = Label.new()
	dialogue_label.name = "DialogueText"
	dialogue_label.position = Vector2(-267.0, -87.0) + FLASH_OFFSET
	dialogue_label.size = Vector2(672, 162)
	dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if readable_font != null:
		dialogue_label.add_theme_font_override("font", readable_font)
	dialogue_label.add_theme_font_size_override("font_size", 16)
	dialogue_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	dialogue_label.text = ""
	add_child(dialogue_label)

	# Только 3 оригинальные кнопки из атласа "talk box" (TalkBox.as:40-72), все единого размера 112x44 и выровнены по одной линии
	btn_next = TextureButton.new()
	btn_next.name = "ExitBtn"
	var template_tex: Texture2D = atlas_loader.get_starling_texture("talk box", "shop_btn_00")
	if template_tex == null:
		template_tex = atlas_loader.get_starling_texture("talk box", "next_btn_00")
	if template_tex != null:
		var img: Image = template_tex.get_image()
		if img != null and not img.is_empty():
			var w: int = img.get_width()
			var h: int = img.get_height()
			var sample_x: int = mini(12, w - 1)
			for py: int in range(6, maxi(6, h - 6)):
				var row_col: Color = img.get_pixel(sample_x, py)
				for px: int in range(14, maxi(14, w - 14)):
					img.set_pixel(px, py, row_col)
			btn_next.texture_normal = ImageTexture.create_from_image(img)
		else:
			btn_next.texture_normal = template_tex
	btn_next.position = Vector2(323.0 - 56.0, 104.0 - 22.0) + FLASH_OFFSET
	btn_next.focus_mode = Control.FOCUS_NONE
	btn_next.pressed.connect(_on_next_pressed)
	add_child(btn_next)

	var exit_lbl := Label.new()
	exit_lbl.name = "ExitLabel"
	exit_lbl.text = "exit"
	exit_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	exit_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	exit_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	exit_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if readable_font != null:
		exit_lbl.add_theme_font_override("font", readable_font)
	exit_lbl.add_theme_font_size_override("font_size", 16)
	exit_lbl.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	exit_lbl.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.75))
	exit_lbl.add_theme_constant_override("shadow_offset_x", 1)
	exit_lbl.add_theme_constant_override("shadow_offset_y", 1)
	btn_next.add_child(exit_lbl)

	btn_shop = TextureButton.new()
	btn_shop.name = "ShopBtn"
	btn_shop.texture_normal = atlas_loader.get_starling_texture("talk box", "shop_btn_00")
	btn_shop.position = Vector2(202.0 - 56.0, 104.0 - 22.0) + FLASH_OFFSET
	btn_shop.focus_mode = Control.FOCUS_NONE
	btn_shop.pressed.connect(_on_shop_pressed)
	add_child(btn_shop)

	btn_sell = TextureButton.new()
	btn_sell.name = "SellBtn"
	btn_sell.texture_normal = atlas_loader.get_starling_texture("talk box", "sell_btn_00")
	btn_sell.position = Vector2(81.0 - 56.0, 104.0 - 22.0) + FLASH_OFFSET
	btn_sell.focus_mode = Control.FOCUS_NONE
	btn_sell.pressed.connect(_on_sell_pressed)
	add_child(btn_sell)


func _apply_portrait_appearance(npc: Dictionary) -> void:
	if portrait_animator == null:
		return
	var app: Dictionary = npc.get("appearance", {}) if npc.get("appearance") is Dictionary else {}
	portrait_animator.gender = str(app.get("gender", "male"))
	portrait_animator.skin_id = int(app.get("skin", 2))
	portrait_animator.eyes_id = int(app.get("eyeFrame", 1))
	var raw_hair: Variant = app.get("hair", "bald")
	if raw_hair is int or (raw_hair is String and str(raw_hair).is_valid_int()):
		portrait_animator.hair_id = int(raw_hair)
	else:
		var h_str: String = str(raw_hair).to_lower().strip_edges()
		portrait_animator.hair_id = int(NPCEntityScript.HAIR_NAME_TO_ID.get(h_str, 1))
	portrait_animator.beard_id = int(app.get("beard", 0))
	portrait_animator.helmet_name = str(app.get("helmet", "none"))
	portrait_animator.shirt_name = str(app.get("shirt", "none"))
	portrait_animator.pants_name = str(app.get("legs", "none"))
	var raw_shoe: String = str(app.get("shoes", "brown shoe")).strip_edges()
	portrait_animator.shoe_name = "brown shoe" if raw_shoe.is_empty() else raw_shoe
	portrait_animator.weapon_main_name = str(app.get("weapon1", "none"))
	portrait_animator.weapon_off_name = str(app.get("weapon2", "none"))
	portrait_animator.accessory_name = str(app.get("accessory", ""))
	if portrait_animator.has_method("refresh_equipment_textures"):
		portrait_animator.call("refresh_equipment_textures")
	if portrait_animator.has_method("play"):
		portrait_animator.call("play", "standing")


func start_dialogue(npc: Dictionary, target_player: Node = null) -> void:
	npc_data = npc
	_apply_portrait_appearance(npc_data)

	dialogue_lines.clear()
	current_talk_id = 0
	current_action = {}
	has_next_action = false

	var origin: Dictionary = npc_data.get("origin", {}) if npc_data.get("origin") is Dictionary else {}
	var trigger_id: int = int(origin.get("trigger", -1))
	var sdb: Node = get_node_or_null("/root/StatsDB")
	var dlg: Dictionary = {}
	if sdb != null and sdb.has_method("get_npc_dialog_for_trigger"):
		dlg = sdb.call("get_npc_dialog_for_trigger", trigger_id, npc_data, target_player)

	var dlg_text: Variant = dlg.get("text", "")
	var npc_text: Variant = npc_data.get("text", "")
	var has_dlg_text: bool = (dlg_text is String and not (dlg_text as String).is_empty()) or (dlg_text is Array and not (dlg_text as Array).is_empty())
	var has_npc_text: bool = (npc_text is String and not (npc_text as String).is_empty()) or (npc_text is Array and not (npc_text as Array).is_empty())
	var raw_text: Variant = ""
	if trigger_id > -1 and has_dlg_text:
		raw_text = dlg_text
	elif has_npc_text:
		raw_text = npc_text
	elif has_dlg_text:
		raw_text = dlg_text
	if raw_text is Array:
		for l in raw_text:
			dialogue_lines.append(str(l))
	elif raw_text is String and not raw_text.is_empty():
		dialogue_lines.append(raw_text)
	else:
		dialogue_lines.append("Hello adventurer!")

	current_talk_id = int(dlg.get("talkID", 0))
	has_next_action = bool(dlg.get("hasNext", false)) and current_talk_id > 0
	if current_talk_id > 0 and sdb != null and sdb.has_method("get_talk_action"):
		current_action = sdb.call("get_talk_action", current_talk_id)

	var shop_dict: Variant = npc_data.get("shop", null)
	var has_shop_items: bool = (shop_dict is Dictionary and not (shop_dict as Dictionary).get("items", []).is_empty()) or (npc_data.has("items") and not npc_data["items"].is_empty())
	var has_shop: bool = bool(dlg.get("hasShop", false)) or bool(origin.get("buy", false)) or bool(npc_data.get("buy", false)) or has_shop_items
	btn_shop.visible = has_shop

	var has_sell: bool = bool(dlg.get("hasSell", false)) or bool(origin.get("sell", false)) or bool(npc_data.get("sell", false))
	btn_sell.visible = has_sell

	# В оригинале для обычных торговцев без квестового перехода next_btn может закрывать диалог,
	# но при желании закрыть окно остаётся доступной.
	btn_next.visible = true

	current_line_index = 0
	_display_current_line()


func _display_current_line() -> void:
	if current_line_index < dialogue_lines.size():
		_full_line_text = dialogue_lines[current_line_index]
		_shown_chars = 0.0
		_is_typing = true
		if dialogue_label != null:
			dialogue_label.text = ""
	else:
		close_dialogue()


func _on_next_pressed() -> void:
	if _is_typing and dialogue_label != null:
		dialogue_label.text = _full_line_text
		_is_typing = false
		return
	current_line_index += 1
	if current_line_index < dialogue_lines.size():
		_display_current_line()
	elif has_next_action and current_talk_id > 0:
		var tid: int = current_talk_id
		var act: Dictionary = current_action.duplicate(true)
		var nd: Dictionary = npc_data.duplicate(true)
		close_dialogue()
		talk_action_triggered.emit(tid, act, nd)
	else:
		close_dialogue()


func _on_shop_pressed() -> void:
	var nd: Dictionary = npc_data
	close_dialogue()
	shop_requested.emit(nd)


func _on_sell_pressed() -> void:
	var nd: Dictionary = npc_data
	close_dialogue()
	sell_requested.emit(nd)


func close_dialogue() -> void:
	_is_typing = false
	visible = false
	closed.emit()


static func _get_atlas_loader() -> Node:
	if Engine.has_singleton("StarlingAtlasLoader"):
		return Engine.get_singleton("StarlingAtlasLoader")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("StarlingAtlasLoader"):
		return tree.root.get_node("StarlingAtlasLoader")
	return load("res://scripts/autoload/StarlingAtlasLoader.gd").new()
