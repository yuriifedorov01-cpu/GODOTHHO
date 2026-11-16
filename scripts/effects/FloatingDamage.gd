extends Node2D
class_name FloatingDamage
## FloatingDamage — Всплывающие числа урона и XP (порт GameMain.as:11544-11583, 11630-11647).

const COLOR_AVOIDED: Color = Color("#FFFFFF")
const COLOR_PLAYER_OR_PET: Color = Color("#CD0000")
const COLOR_ENEMY: Color = Color("#FFB200")
const DAMAGE_FNT_PATH: String = "res://assets/extracted/bitmap_fonts/damage_font.fnt"
const STATS_FNT_PATH: String = "res://assets/extracted/bitmap_fonts/stats_font.fnt"

static var _fallback_atlas_loader: Node = null
static var _bmfont_cache: Dictionary = {}


static func _get_bmfont_data(fnt_path: String) -> Dictionary:
	if _bmfont_cache.has(fnt_path):
		return _bmfont_cache[fnt_path]
	var abs_path: String = ProjectSettings.globalize_path(fnt_path)
	if not FileAccess.file_exists(abs_path):
		return {}
	var parser: XMLParser = XMLParser.new()
	if parser.open(abs_path) != OK:
		return {}
	var data: Dictionary = {
		"size": 48,
		"line_height": 51.0,
		"base": 41.0,
		"pages": {},
		"glyphs": {},
		"kernings": {},
	}
	var base_dir: String = abs_path.get_base_dir()
	while parser.read() == OK:
		if parser.get_node_type() != XMLParser.NODE_ELEMENT:
			continue
		var tag: String = parser.get_node_name()
		match tag:
			"info":
				var sz_str: String = parser.get_named_attribute_value_safe("size")
				if not sz_str.is_empty():
					data["size"] = maxi(1, abs(sz_str.to_int()))
			"common":
				var lh_str: String = parser.get_named_attribute_value_safe("lineHeight")
				var b_str: String = parser.get_named_attribute_value_safe("base")
				if not lh_str.is_empty():
					data["line_height"] = lh_str.to_float()
				if not b_str.is_empty():
					data["base"] = b_str.to_float()
			"page":
				var pid: int = parser.get_named_attribute_value_safe("id").to_int()
				var fname: String = parser.get_named_attribute_value_safe("file")
				var img_path: String = base_dir.path_join(fname)
				if FileAccess.file_exists(img_path):
					var img: Image = Image.load_from_file(img_path)
					if img != null:
						data["pages"][pid] = ImageTexture.create_from_image(img)
			"char":
				var cid: int = parser.get_named_attribute_value_safe("id").to_int()
				data["glyphs"][cid] = {
					"x": parser.get_named_attribute_value_safe("x").to_float(),
					"y": parser.get_named_attribute_value_safe("y").to_float(),
					"w": parser.get_named_attribute_value_safe("width").to_float(),
					"h": parser.get_named_attribute_value_safe("height").to_float(),
					"xoffset": parser.get_named_attribute_value_safe("xoffset").to_float(),
					"yoffset": parser.get_named_attribute_value_safe("yoffset").to_float(),
					"xadvance": parser.get_named_attribute_value_safe("xadvance").to_float(),
					"page": parser.get_named_attribute_value_safe("page").to_int(),
				}
			"kerning":
				var f_id: int = parser.get_named_attribute_value_safe("first").to_int()
				var s_id: int = parser.get_named_attribute_value_safe("second").to_int()
				var amt: float = parser.get_named_attribute_value_safe("amount").to_float()
				data["kernings"]["%d_%d" % [f_id, s_id]] = amt
	_bmfont_cache[fnt_path] = data
	return data


static func _get_atlas_loader() -> Node:
	if Engine.has_singleton("StarlingAtlasLoader"):
		return Engine.get_singleton("StarlingAtlasLoader")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("StarlingAtlasLoader"):
		return tree.root.get_node("StarlingAtlasLoader")
	if _fallback_atlas_loader == null or not is_instance_valid(_fallback_atlas_loader):
		var script: Script = load("res://scripts/autoload/StarlingAtlasLoader.gd") as Script
		if script != null:
			_fallback_atlas_loader = script.new()
	return _fallback_atlas_loader


static func _format_comma_number(amount: int) -> String:
	var sign_prefix: String = "-" if amount < 0 else ""
	var digits: String = str(absi(amount))
	var length: int = digits.length()
	if length <= 3:
		return sign_prefix + digits
	var parts: PackedStringArray = PackedStringArray()
	var idx: int = length
	while idx > 0:
		var start_idx: int = maxi(0, idx - 3)
		parts.append(digits.substr(start_idx, idx - start_idx))
		idx = start_idx
	parts.reverse()
	return sign_prefix + ",".join(parts)


static func _create_floating_text(
	parent: Node,
	text: String,
	world_pos: Vector2,
	font: Font,
	font_size: int,
	color: Color,
	rise_distance: float,
	duration: float,
	fnt_path: String = DAMAGE_FNT_PATH
) -> Node2D:
	var node: Node2D = Node2D.new()
	node.z_index = 50
	node.position = world_pos

	var bmfont: Dictionary = _get_bmfont_data(fnt_path)
	var glyphs: Dictionary = bmfont.get("glyphs", {})
	var pages: Dictionary = bmfont.get("pages", {})
	if not glyphs.is_empty() and not pages.is_empty():
		var native_size: float = float(maxi(1, int(bmfont.get("size", 48))))
		var text_scale: float = float(font_size) / native_size
		var line_h: float = float(bmfont.get("line_height", native_size))
		var kernings: Dictionary = bmfont.get("kernings", {})

		var container: Node2D = Node2D.new()
		container.scale = Vector2(text_scale, text_scale)
		var cursor_x: float = 0.0
		var prev_cid: int = -1
		for i: int in range(text.length()):
			var cid: int = text.unicode_at(i)
			if prev_cid >= 0:
				cursor_x += float(kernings.get("%d_%d" % [prev_cid, cid], 0.0))
			if glyphs.has(cid):
				var g: Dictionary = glyphs[cid]
				var tex: Texture2D = pages.get(int(g.get("page", 0)), null) as Texture2D
				var gw: float = float(g.get("w", 0.0))
				var gh: float = float(g.get("h", 0.0))
				if tex != null and gw > 0.0 and gh > 0.0:
					var sp: Sprite2D = Sprite2D.new()
					sp.texture = tex
					sp.region_enabled = true
					sp.region_rect = Rect2(float(g.get("x", 0.0)), float(g.get("y", 0.0)), gw, gh)
					sp.centered = false
					sp.position = Vector2(cursor_x + float(g.get("xoffset", 0.0)), float(g.get("yoffset", 0.0)) - line_h)
					sp.modulate = color
					container.add_child(sp)
				cursor_x += float(g.get("xadvance", gw))
			else:
				cursor_x += native_size * 0.4
			prev_cid = cid
		container.position = Vector2(-cursor_x * 0.5 * text_scale, 0.0)
		node.add_child(container)
	else:
		var label: Label = Label.new()
		label.text = text
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if font != null:
			label.add_theme_font_override("font", font)
		label.add_theme_font_size_override("font_size", font_size)
		label.add_theme_color_override("font_color", color)

		var min_size: Vector2 = label.get_minimum_size()
		label.size = min_size
		label.position = Vector2(-min_size.x * 0.5, -min_size.y)
		node.add_child(label)

	if parent != null:
		parent.add_child(node)
		node.global_position = world_pos
	if node.is_inside_tree():
		var tween: Tween = node.create_tween()
		tween.set_parallel(true)
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(node, "position:y", node.position.y - rise_distance, duration)
		tween.tween_property(node, "modulate:a", 0.0, duration)
		tween.chain().tween_callback(node.queue_free)

	return node


## Спавнит всплывающее число урона (GameMain.as:11544-11583).
static func spawn_damage(
	parent: Node,
	amount: int,
	world_pos: Vector2,
	is_player_or_pet: bool = false,
	is_crit: bool = false,
	is_avoided: bool = false
) -> Node2D:
	var text: String = "avoided" if is_avoided else _format_comma_number(amount)
	var font_size: int = 28 if is_avoided else (48 if is_crit else 34)
	var color: Color = COLOR_AVOIDED if is_avoided else (COLOR_PLAYER_OR_PET if is_player_or_pet else COLOR_ENEMY)

	var atlas: Node = _get_atlas_loader()
	var font: Font = ThemeDB.fallback_font
	if atlas != null and atlas.has_method("get_damage_font"):
		var loaded_font: Variant = atlas.call("get_damage_font")
		if loaded_font is Font:
			font = loaded_font as Font

	return _create_floating_text(parent, text, world_pos, font, font_size, color, 100.0, 1.0)


## Спавнит всплывающий текст опыта "+Xxp" (GameMain.as:11630-11647).
static func spawn_xp(parent: Node, xp_amount: int, world_pos: Vector2) -> Node2D:
	var text: String = "+%dxp" % xp_amount
	var atlas: Node = _get_atlas_loader()
	var font: Font = ThemeDB.fallback_font
	if atlas != null and atlas.has_method("get_bitmap_font"):
		var loaded_font: Variant = atlas.call("get_bitmap_font", "stats_font.fnt")
		if loaded_font is Font:
			font = loaded_font as Font

	return _create_floating_text(parent, text, world_pos, font, 16, Color.WHITE, 60.0, 0.8, STATS_FNT_PATH)


## Совместимый строковый спавнер для PersonEntity._spawn_floating_damage.
static func spawn(
	parent: Node,
	text: String,
	world_pos: Vector2,
	is_crit: bool = false,
	is_player_or_pet: bool = true
) -> Node2D:
	var clean_text: String = text.strip_edges()
	if clean_text.to_lower() == "avoided":
		return spawn_damage(parent, 0, world_pos, is_player_or_pet, false, true)
	var numeric_str: String = clean_text.replace(",", "")
	if numeric_str.is_valid_int():
		return spawn_damage(parent, numeric_str.to_int(), world_pos, is_player_or_pet, is_crit, false)

	var font_size: int = 48 if is_crit else 34
	var color: Color = COLOR_PLAYER_OR_PET if is_player_or_pet else COLOR_ENEMY
	var atlas: Node = _get_atlas_loader()
	var font: Font = ThemeDB.fallback_font
	if atlas != null and atlas.has_method("get_damage_font"):
		var loaded_font: Variant = atlas.call("get_damage_font")
		if loaded_font is Font:
			font = loaded_font as Font
	return _create_floating_text(parent, clean_text, world_pos, font, font_size, color, 100.0, 1.0)
