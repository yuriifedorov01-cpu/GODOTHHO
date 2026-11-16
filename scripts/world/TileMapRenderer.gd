extends Node2D
class_name TileMapRenderer
## TileMapRenderer — Рендерер 6 слоев тайловой карты Helmet Heroes (165x165 px на ячейку).
## Слои: mapArt (фон), mapMain (твердая земля), mapWater (вода),
## mapG2, mapG3 (односторонние платформы), mapFG (передний план).

const TILE_SIZE: int = 165

## Flash TileHandler.as aliasing & horizontal flipping mapping
const TILE_MIRROR_MAP: Dictionary = {
	10: 9,
	4: 2,
	16: 14,
	20: 18,
	21: 55,
	22: 54,
	33: 67,
	42: 62,
	50: 48,
	64: 52,
	77: 75,
	78: 73
}

## Server TileDefRegistry payload for theme 1 (areas 1..8, Map.generated.cs TileDefsFor)
const THEME_1_TILE_DEFS_MAIN: Dictionary = {
	1: 18,
	3: 55,
	5: 54,
	6: 9,
	7: 14,
	8: 48,
	12: 67,
	13: 62,
	17: 73,
	23: 75,
	26: 52
}
const THEME_1_TILE_DEFS_FG: Dictionary = {
	23: 30,
	32: 28
}

static func resolve_tile_visual(tile_id: int, theme_id: int, is_foreground: bool) -> Dictionary:
	var render_tile_id: int = tile_id
	var is_mirrored: bool = false
	if theme_id == 1:
		if is_foreground and THEME_1_TILE_DEFS_FG.has(tile_id):
			render_tile_id = int(THEME_1_TILE_DEFS_FG[tile_id])
			is_mirrored = true
			return {"tile_id": render_tile_id, "mirrored": is_mirrored}
		if not is_foreground and THEME_1_TILE_DEFS_MAIN.has(tile_id):
			render_tile_id = int(THEME_1_TILE_DEFS_MAIN[tile_id])
			is_mirrored = true
			return {"tile_id": render_tile_id, "mirrored": is_mirrored}
	var tile_20_keeps_original: bool = tile_id == 20 and theme_id == 16
	if not is_foreground and TILE_MIRROR_MAP.has(tile_id) and not tile_20_keeps_original:
		render_tile_id = int(TILE_MIRROR_MAP[tile_id])
		is_mirrored = true
	return {"tile_id": render_tile_id, "mirrored": is_mirrored}


## Legacy TileHandler.as collision geometry. TileDefRegistry server payload overrides
## these definitions in the original client; no captured payload is available locally.
static func get_source_collision_shapes(tile_id: int, layer_name: String, theme_id: int) -> Array[Dictionary]:
	var shapes: Array[Dictionary] = []
	if tile_id < 0 or layer_name == "mapFG" or not ["mapMain", "mapWater", "mapG2", "mapG3"].has(layer_name):
		return shapes

	if tile_id in [36, 44, 19, 78, 73, 17]:
		shapes.append(_rect_collision_shape(Vector2(0, 25), Vector2(165, 140)))
	elif tile_id in [14, 18]:
		shapes.append(_rect_collision_shape(Vector2(25, 25), Vector2(140, 140)))
	elif tile_id in [16, 20, 1, 7]:
		shapes.append(_rect_collision_shape(Vector2(0, 25), Vector2(140, 140)))
	elif tile_id == 30:
		shapes.append(_rect_collision_shape(Vector2(25, 25), Vector2(115, 140)))

	if layer_name != "mapMain" and layer_name != "mapWater":
		return shapes

	if tile_id in [38, 40, 72, 75, 77, 0, 25, 11, 23]:
		shapes.append(_rect_collision_shape(Vector2.ZERO, Vector2(165, 165)))
	elif tile_id in [48, 64]:
		shapes.append(_rect_collision_shape(Vector2.ZERO, Vector2(140, 165)))
	elif tile_id in [50, 52, 8]:
		shapes.append(_rect_collision_shape(Vector2(25, 0), Vector2(140, 165)))
	elif tile_id == 62:
		shapes.append(_polygon_collision_shape(PackedVector2Array([
			Vector2(0, 0), Vector2(140, 0), Vector2(140, 25), Vector2(165, 25), Vector2(165, 165), Vector2(0, 165)
		])))
	elif tile_id in [42, 13]:
		shapes.append(_polygon_collision_shape(PackedVector2Array([
			Vector2(25, 0), Vector2(165, 0), Vector2(165, 165), Vector2(0, 165), Vector2(0, 25), Vector2(25, 25)
		])))
	elif tile_id in [54, 10, 6]:
		shapes.append(_polygon_collision_shape(PackedVector2Array([
			Vector2(0, 25), Vector2(165, 107), Vector2(165, 165), Vector2(0, 165)
		])))
	elif tile_id == 55:
		shapes.append(_polygon_collision_shape(PackedVector2Array([
			Vector2(0, 107), Vector2(116, 165), Vector2(0, 165)
		])))
	elif tile_id == 67:
		shapes.append(_polygon_collision_shape(PackedVector2Array([
			Vector2(0, 0), Vector2(116, 0), Vector2(165, 25), Vector2(165, 165), Vector2(0, 165)
		])))
	elif tile_id in [22, 9, 5]:
		shapes.append(_polygon_collision_shape(PackedVector2Array([
			Vector2(0, 107), Vector2(165, 25), Vector2(165, 165), Vector2(0, 165)
		])))
	elif tile_id in [21, 3]:
		shapes.append(_polygon_collision_shape(PackedVector2Array([
			Vector2(49, 165), Vector2(165, 107), Vector2(165, 165)
		])))
	elif tile_id in [33, 12]:
		shapes.append(_polygon_collision_shape(PackedVector2Array([
			Vector2(0, 25), Vector2(49, 0), Vector2(165, 0), Vector2(165, 165), Vector2(0, 165)
		])))
	elif tile_id == 31:
		shapes.append(_rect_collision_shape(Vector2(56, 61), Vector2(50, 45)))
	elif theme_id == 13 and tile_id == 95:
		# TileHandler.as:720-725, 1177-1179: block17_data at (40, 80) -> (15,0,61,37) & (0,36,89,55)
		shapes.append(_rect_collision_shape(Vector2(55, 80), Vector2(61, 37)))
		shapes.append(_rect_collision_shape(Vector2(40, 116), Vector2(89, 55)))
	elif theme_id == 13 and tile_id == 119:
		# TileHandler.as:732-736, 1180-1182: block18_data at (40, 0) -> (15,0,61,37) & (0,36,89,55)
		shapes.append(_rect_collision_shape(Vector2(55, 0), Vector2(61, 37)))
		shapes.append(_rect_collision_shape(Vector2(40, 36), Vector2(89, 55)))
	elif theme_id == 13 and tile_id == 107:
		shapes.append(_rect_collision_shape(Vector2(55, 0), Vector2(60, 165)))

	return shapes


const NON_COLLIDING_DECOR_TILES: Array[int] = [0, 2, 4, 24, 25, 32]
const EMPTY_TILE_VISUAL_FALLBACK: Dictionary = {
	17: 73,
	23: 38,
}
static var _empty_texture_cache: Dictionary = {}


static func _is_texture_empty(sheet_name: String, tile_id: int, tex: Texture2D) -> bool:
	if tex == null:
		return true
	var cache_key: String = "%s:%d" % [sheet_name, tile_id]
	if _empty_texture_cache.has(cache_key):
		return bool(_empty_texture_cache[cache_key])
	var img: Image = tex.get_image()
	var is_empty: bool = img == null or img.is_empty() or img.get_used_rect().size == Vector2i.ZERO
	_empty_texture_cache[cache_key] = is_empty
	return is_empty


static func _rect_collision_shape(offset: Vector2, size: Vector2) -> Dictionary:
	return {"type": "rect", "offset": offset, "size": size}


static func _polygon_collision_shape(points: PackedVector2Array) -> Dictionary:
	return {"type": "polygon", "offset": Vector2.ZERO, "points": points}

var map_width: int = 40
var map_height: int = 12
var current_theme: int = 1
var main_tiles_class: String = "GreenAreaTiles"
var fg_tiles_class: String = "GreenAreaForegroundTiles"

# Ссылки на контейнеры слоев
var art_layer_node: Node2D = null
var main_layer_node: Node2D = null
var water_layer_node: Node2D = null
var g2_layer_node: Node2D = null
var g3_layer_node: Node2D = null
var fg_layer_node: Node2D = null

# Распарсенные данные слоев (1D PackedInt32Array длины width*height)
var layer_data_dict: Dictionary = {}

static func _get_stats_db() -> Node:
	if Engine.has_singleton("StatsDB"):
		return Engine.get_singleton("StatsDB")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("StatsDB"):
		return tree.root.get_node("StatsDB")
	return load("res://scripts/autoload/StatsDB.gd").new()

static func _get_swf_loader() -> Node:
	if Engine.has_singleton("SwfSpriteLoader"):
		return Engine.get_singleton("SwfSpriteLoader")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("SwfSpriteLoader"):
		return tree.root.get_node("SwfSpriteLoader")
	return load("res://scripts/autoload/SwfSpriteLoader.gd").new()

func _init() -> void:
	_setup_layer_nodes()


func _setup_layer_nodes() -> void:
	# В оригинале (GameMain.as:2740-2755, TileHandler.as:435-441) non-FG слои добавляются через addChildAt(..., 0),
	# поэтому более ранние слои (Art) лежат ПОВЕРХ более поздних (Main > Water > G2 > G3).
	art_layer_node = Node2D.new()
	art_layer_node.name = "LayerArt"
	art_layer_node.z_index = -2
	add_child(art_layer_node)

	main_layer_node = Node2D.new()
	main_layer_node.name = "LayerMain"
	main_layer_node.z_index = -5
	add_child(main_layer_node)

	water_layer_node = Node2D.new()
	water_layer_node.name = "LayerWater"
	water_layer_node.z_index = -10
	add_child(water_layer_node)

	g2_layer_node = Node2D.new()
	g2_layer_node.name = "LayerG2"
	g2_layer_node.z_index = -15
	add_child(g2_layer_node)

	g3_layer_node = Node2D.new()
	g3_layer_node.name = "LayerG3"
	g3_layer_node.z_index = -20
	add_child(g3_layer_node)

	fg_layer_node = Node2D.new()
	fg_layer_node.name = "LayerFG"
	fg_layer_node.z_index = 20
	add_child(fg_layer_node)


## Полная загрузка и отрисовка карты по данным из StatsDB
func render_map(map_id: int, map_dict: Dictionary, area_meta: Dictionary) -> void:
	clear_map()

	map_width = int(map_dict.get("width", 40))
	map_height = int(map_dict.get("height", 12))
	current_theme = int(area_meta.get("theme", 1))
	main_tiles_class = str(area_meta.get("mainTilesClass", "GreenAreaTiles"))
	fg_tiles_class = str(area_meta.get("foregroundTilesClass", "GreenAreaForegroundTiles"))

	var sdb: Node = _get_stats_db()

	# Декодируем все 6 слоев карты
	layer_data_dict["mapMain"] = sdb.get_map_layer_int16(map_id, "mapMain")
	layer_data_dict["mapArt"] = sdb.get_map_layer_int16(map_id, "mapArt")
	layer_data_dict["mapWater"] = sdb.get_map_layer_int16(map_id, "mapWater")
	layer_data_dict["mapG2"] = sdb.get_map_layer_int16(map_id, "mapG2")
	layer_data_dict["mapG3"] = sdb.get_map_layer_int16(map_id, "mapG3")
	layer_data_dict["mapFG"] = sdb.get_map_layer_int16(map_id, "mapFG")

	# Рендерим слои
	_render_layer(layer_data_dict["mapArt"], art_layer_node, main_tiles_class, false, false, false, "mapArt")
	_render_layer(layer_data_dict["mapMain"], main_layer_node, main_tiles_class, true, false, false, "mapMain")
	_render_layer(layer_data_dict["mapWater"], water_layer_node, main_tiles_class, false, false, false, "mapWater")
	_render_layer(layer_data_dict["mapG2"], g2_layer_node, main_tiles_class, false, true, false, "mapG2")
	_render_layer(layer_data_dict["mapG3"], g3_layer_node, main_tiles_class, false, true, false, "mapG3")
	_render_layer(layer_data_dict["mapFG"], fg_layer_node, fg_tiles_class, false, false, true, "mapFG")


func clear_map() -> void:
	for layer_node: Node in [art_layer_node, main_layer_node, water_layer_node, g2_layer_node, g3_layer_node, fg_layer_node]:
		if layer_node != null:
			for child: Node in layer_node.get_children():
				child.queue_free()
	layer_data_dict.clear()


## Отрисовывает один слой тайлов и добавляет коллизии при необходимости
func _render_layer(tiles: PackedInt32Array, parent_node: Node2D, sheet_name: String, is_solid: bool = false, is_one_way: bool = false, is_foreground: bool = false, layer_name: String = "") -> void:
	if tiles.is_empty() or parent_node == null:
		return

	var swf: Node = _get_swf_loader()
	var layer_static_body: StaticBody2D = null
	if is_solid or is_one_way:
		layer_static_body = StaticBody2D.new()
		layer_static_body.name = "%s_Collision" % (layer_name if not layer_name.is_empty() else "Layer")
		layer_static_body.collision_layer = 8 if is_one_way else 1
		layer_static_body.collision_mask = 0
		parent_node.add_child(layer_static_body)

	var count: int = tiles.size()
	for i: int in range(count):
		var tile_id: int = tiles[i]
		if tile_id < 0 or tile_id == 255:
			continue

		var col: int = i % map_width
		var row: int = i / map_width
		var pos_x: float = float(col * TILE_SIZE)
		var pos_y: float = float(row * TILE_SIZE)

		# Обработка замены и отзеркаливания тайлов (порт TileHandler.as)
		var visual: Dictionary = resolve_tile_visual(tile_id, current_theme, is_foreground)
		var render_tile_id: int = int(visual["tile_id"])
		var is_mirrored: bool = bool(visual["mirrored"])

		var tex: Texture2D = swf.get_tile_texture(sheet_name, render_tile_id)
		if EMPTY_TILE_VISUAL_FALLBACK.has(render_tile_id) and _is_texture_empty(sheet_name, render_tile_id, tex):
			tex = swf.get_tile_texture(sheet_name, int(EMPTY_TILE_VISUAL_FALLBACK[render_tile_id]))
		if tex == null:
			# TileHandler falls back to atlas tile_0 when the requested visual frame is absent.
			tex = swf.get_tile_texture(sheet_name, 0)
		if tex != null:
			var sprite: Sprite2D = Sprite2D.new()
			sprite.texture = tex
			sprite.centered = false
			sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			# В Flash Starling: тайлы масштабировались до 166x166 с 1px оверлапом против щелей
			var tex_size: Vector2 = tex.get_size()
			var sx: float = 166.0 / tex_size.x if tex_size.x > 0.0 else 1.0
			var sy: float = 166.0 / tex_size.y if tex_size.y > 0.0 else 1.0
			sprite.scale = Vector2(sx, sy)
			sprite.flip_h = is_mirrored
			sprite.position = Vector2(pos_x, pos_y)
			parent_node.add_child(sprite)

		# Коллизии создаются строго по геометрии из AS3 TileHandler.as (без alpha-трассировки на mapG2/mapG3 и травинках mapMain).
		var collision_shapes: Array[Dictionary] = []
		if layer_static_body != null:
			collision_shapes = get_source_collision_shapes(tile_id, layer_name, current_theme)
		if not collision_shapes.is_empty():
			var cell_origin: Vector2 = Vector2(pos_x, pos_y)
			for collision_spec: Dictionary in collision_shapes:
				if collision_spec["type"] == "rect":
					var shape: CollisionShape2D = CollisionShape2D.new()
					var rect: RectangleShape2D = RectangleShape2D.new()
					rect.size = collision_spec["size"]
					shape.shape = rect
					shape.position = cell_origin + collision_spec["offset"] + rect.size * 0.5
					shape.one_way_collision = is_one_way
					layer_static_body.add_child(shape)
				else:
					var polygon: CollisionPolygon2D = CollisionPolygon2D.new()
					polygon.polygon = collision_spec["points"]
					polygon.position = cell_origin
					polygon.one_way_collision = is_one_way
					layer_static_body.add_child(polygon)


## Проверяет, является ли ячейка твердым тайлом (mainGround)
func is_solid_at_grid(col: int, row: int) -> bool:
	if col < 0 or col >= map_width or row < 0 or row >= map_height:
		return false
	var tiles: PackedInt32Array = layer_data_dict.get("mapMain", PackedInt32Array())
	if tiles.is_empty():
		return false
	var idx: int = row * map_width + col
	if idx < 0 or idx >= tiles.size():
		return false
	var v: int = tiles[idx]
	if v < 0 or v == 255:
		return false
	return not get_source_collision_shapes(v, "mapMain", current_theme).is_empty()


## Проверяет, находится ли точка в воде
func is_point_in_water(px: float, py: float) -> bool:
	var col: int = int(px / TILE_SIZE)
	var row: int = int(py / TILE_SIZE)
	if col < 0 or col >= map_width or row < 0 or row >= map_height:
		return false
	var tiles: PackedInt32Array = layer_data_dict.get("mapWater", PackedInt32Array())
	if tiles.is_empty():
		return false
	var idx: int = row * map_width + col
	if idx < 0 or idx >= tiles.size():
		return false
	var v: int = tiles[idx]
	return v >= 0 and v != 255
