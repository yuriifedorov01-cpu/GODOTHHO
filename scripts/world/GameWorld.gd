extends Node2D
class_name GameWorld
## GameWorld — Главный контроллер игрового мира Helmet Heroes (порт GameMain.as и MainStarlingStage.as).
## Загружает карты по ID (1..145), параллакс-фоны backgrounds1..30, слои тайлов TileMapRenderer,
## спавнит объекты (Portal, Tree, ATM, BouncePad, EnemyEntity) и локального игрока.
## Следит камерой Camera2D за игроком с центром (475, 449) и границами (clamp).

const NPCEntityScript = preload("res://scripts/entities/NPCEntity.gd")
const TreeEntityScript = preload("res://scripts/entities/TreeEntity.gd")
const FishEntityScript = preload("res://scripts/entities/FishEntity.gd")

signal npc_talk_requested(npc_data: Dictionary, npc_node: Node2D)
signal bank_requested()

@export var current_stage_id: int = 1

# Контейнеры мира
var parallax_background: ParallaxBackground = null
var parallax_layer_sky: ParallaxLayer = null
var parallax_layer_far: ParallaxLayer = null
var parallax_layer_mid: ParallaxLayer = null
var parallax_layer_near: ParallaxLayer = null

var tile_renderer: Node = null
var entities_container: Node2D = null
var props_container: Node2D = null
const BASE_VIEWPORT_SIZE: Vector2 = Vector2(950.0, 700.0)
const CAMERA_ZOOM_DEFAULT: float = 1.0
const CAMERA_ZOOM_MIN: float = 0.5
const CAMERA_ZOOM_MAX: float = 2.0
const CAMERA_ZOOM_STEP: float = 0.1

var camera: Camera2D = null
var user_camera_zoom: float = CAMERA_ZOOM_DEFAULT
var _map_pixel_size: Vector2 = Vector2.ZERO
var hud: CanvasLayer = null

# Сущности
var local_player: Node = null
var enemies: Array = []
var npcs: Array = []
var portals: Array = []
var trees: Array = []
var fishes: Array = []

# Метаданные уровня
var current_map_dict: Dictionary = {}
var current_area_meta: Dictionary = {}
var previous_stage_id: int = 0
var last_portal_id: int = 0
var level_change_ticks: int = 121
var _level_change_accum: float = 0.0

var _transition_layer: CanvasLayer = null
var _white_rect: ColorRect = null
var _fade_tween: Tween = null

signal level_loaded(stage_id: int)
signal level_changed(target_stage: int)

static func _get_stats_db() -> Node:
	if Engine.has_singleton("StatsDB"):
		return Engine.get_singleton("StatsDB")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("StatsDB"):
		return tree.root.get_node("StatsDB")
	return load("res://scripts/autoload/StatsDB.gd").new()

static func _get_atlas_loader() -> Node:
	if Engine.has_singleton("StarlingAtlasLoader"):
		return Engine.get_singleton("StarlingAtlasLoader")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("StarlingAtlasLoader"):
		return tree.root.get_node("StarlingAtlasLoader")
	return load("res://scripts/autoload/StarlingAtlasLoader.gd").new()

static func _get_audio_manager() -> Node:
	if Engine.has_singleton("AudioManager"):
		return Engine.get_singleton("AudioManager")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("AudioManager"):
		return tree.root.get_node("AudioManager")
	return load("res://scripts/autoload/AudioManager.gd").new()

func _ready() -> void:
	_setup_world_hierarchy()
	load_level(current_stage_id)


func _setup_world_hierarchy() -> void:
	# 1. Параллакс фон
	parallax_background = ParallaxBackground.new()
	add_child(parallax_background)

	parallax_layer_sky = ParallaxLayer.new()
	parallax_layer_sky.motion_scale = Vector2(0.0, 0.0)
	parallax_background.add_child(parallax_layer_sky)

	parallax_layer_far = ParallaxLayer.new()
	parallax_layer_far.motion_scale = Vector2(0.08, 0.02) # 1 / 12.0 (X), 1 / 48 (Y)
	parallax_background.add_child(parallax_layer_far)

	parallax_layer_mid = ParallaxLayer.new()
	parallax_layer_mid.motion_scale = Vector2(0.16, 0.04) # 1 / 6.0 (X), 1 / 24 (Y)
	parallax_background.add_child(parallax_layer_mid)

	parallax_layer_near = ParallaxLayer.new()
	parallax_layer_near.motion_scale = Vector2(0.32, 0.06) # 1 / 3.0 (X), 1 / 12 (Y)
	parallax_background.add_child(parallax_layer_near)

	# 2. Рендерер тайлов
	tile_renderer = TileMapRenderer.new()
	tile_renderer.name = "TileMapRenderer"
	add_child(tile_renderer)

	# 3. Декорации и пропсы (деревья, банкоматы, порталы, батуты) — SortDepths.REGION_2 (над LayerArt = -2)
	props_container = Node2D.new()
	props_container.name = "PropsContainer"
	props_container.z_index = -1
	add_child(props_container)

	# 4. Сущности (игроки, враги, лут)
	entities_container = Node2D.new()
	entities_container.name = "EntitiesContainer"
	entities_container.z_index = 0
	add_child(entities_container)

	# 5. Следящая камера
	camera = Camera2D.new()
	camera.name = "WorldCamera"
	# В оригинале центр экрана: (475, 449) при окне 950x700 -> смещение (0, 99)
	camera.offset = Vector2(0, 99)
	camera.position_smoothing_enabled = false
	camera.position_smoothing_speed = 10.0
	add_child(camera)
	if get_viewport() != null and not get_viewport().size_changed.is_connected(_update_camera_zoom):
		get_viewport().size_changed.connect(_update_camera_zoom)
	_update_camera_zoom()

	# 6. Игровой HUD (CanvasLayer поверх камеры)
	var hud_script: GDScript = load("res://scripts/ui/GameHUD.gd")
	if hud_script != null:
		hud = hud_script.new() as CanvasLayer
		hud.name = "GameHUD"
		add_child(hud)

	# 7. Белый экран перехода (GameMain.createWhite) поверх всего
	_transition_layer = CanvasLayer.new()
	_transition_layer.name = "TransitionOverlay"
	_transition_layer.layer = 100
	add_child(_transition_layer)

	_white_rect = ColorRect.new()
	_white_rect.name = "WhiteFadeRect"
	_white_rect.color = Color.WHITE
	_white_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_white_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_white_rect.visible = false
	_transition_layer.add_child(_white_rect)


## Полная загрузка уровня по ID (1..145)
func load_level(stage_id: int) -> void:
	current_stage_id = stage_id
	var sdb: Node = _get_stats_db()
	current_map_dict = sdb.get_map_data(stage_id)
	current_area_meta = sdb.get_area_meta(stage_id)

	# Музыка уровня
	var music_track: String = str(current_area_meta.get("musicTrack", ""))
	if not music_track.is_empty():
		var amgr: Node = _get_audio_manager()
		amgr.play_music(music_track)

	# 1. Загрузка фона
	_setup_background(current_area_meta)

	# 2. Отрисовка тайлов
	tile_renderer.render_map(stage_id, current_map_dict, current_area_meta)
	if has_node("/root/PlayerIOClient"):
		var pio: Node = get_node("/root/PlayerIOClient")
		if "my_player_misc" in pio and pio.my_player_misc is Dictionary:
			var maps_arr: Variant = pio.my_player_misc.get("maps", [])
			if maps_arr is Array and not maps_arr.has(stage_id):
				maps_arr.append(stage_id)
				pio.my_player_misc["maps"] = maps_arr

	# 3. Очистка старых объектов и спавн новых
	_clear_level_entities()
	_spawn_map_props(current_map_dict, current_area_meta)
	_spawn_coin_boxes(current_map_dict)
	_spawn_enemies(current_map_dict)
	_spawn_npcs(stage_id)

	# 4. Спавн или перемещение игрока
	_setup_player(current_map_dict)

	# 5. Настройка границ камеры
	var map_w_px: float = float(tile_renderer.map_width * 165)
	var map_h_px: float = float(tile_renderer.map_height * 165)
	_map_pixel_size = Vector2(map_w_px, map_h_px)
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = int(map_w_px)
	camera.limit_bottom = int(map_h_px)
	_update_camera_zoom()

	level_loaded.emit(stage_id)


func _spawn_npcs(stage_id: int) -> void:
	npcs.clear()
	if entities_container == null:
		return
	var sdb: Node = _get_stats_db()
	if sdb == null or not sdb.has_method("get_npcs_for_area"):
		return
	var list: Variant = sdb.call("get_npcs_for_area", stage_id)
	if not (list is Array):
		return
	for npc_v: Variant in list:
		if not (npc_v is Dictionary):
			continue
		var npc_node := NPCEntityScript.new()
		entities_container.add_child(npc_node)
		npc_node.setup(npc_v as Dictionary)
		npc_node.talk_requested.connect(func(nd: Dictionary, nnode: Node2D) -> void:
			npc_talk_requested.emit(nd, nnode)
		)
		npcs.append(npc_node)


var _sky_sprite: Sprite2D = null
var _sky_tex_size: Vector2 = Vector2.ZERO


func _setup_background(meta: Dictionary) -> void:
	_sky_sprite = null
	_sky_tex_size = Vector2.ZERO
	for layer: ParallaxLayer in [parallax_layer_sky, parallax_layer_far, parallax_layer_mid, parallax_layer_near]:
		for child: Node in layer.get_children():
			layer.remove_child(child)
			child.queue_free()

	var bg_atlas: String = str(meta.get("backgroundAtlas", "backgrounds1"))
	if bg_atlas.is_empty():
		return
	var atlas: Node = _get_atlas_loader()
	atlas.register_starling_atlas(bg_atlas)

	# Небо (sky) — масштабируется под текущий viewport и camera.zoom; 1x1 заглушки игнорируются
	var sky_tex: Texture2D = atlas.get_starling_texture(bg_atlas, "sky")
	if sky_tex != null and (sky_tex.get_width() > 2 or sky_tex.get_height() > 2):
		var sky_sprite: Sprite2D = Sprite2D.new()
		sky_sprite.texture = sky_tex
		sky_sprite.centered = false
		parallax_layer_sky.add_child(sky_sprite)
		_sky_sprite = sky_sprite
		_sky_tex_size = Vector2(float(sky_tex.get_width()), float(sky_tex.get_height()))
		_update_sky_scale()

	_populate_parallax_layer(parallax_layer_far, atlas, bg_atlas, ["background 3", "background3"], -200.0, 620.0)
	_populate_parallax_layer(parallax_layer_mid, atlas, bg_atlas, ["background 2", "background2"], -300.0, 660.0)
	_populate_parallax_layer(parallax_layer_near, atlas, bg_atlas, ["background 1", "background1"], -250.0, 700.0)


func _populate_parallax_layer(
	layer: ParallaxLayer,
	atlas: Node,
	bg_atlas: String,
	tex_names: Array,
	x_offset: float,
	bottom_y: float
) -> void:
	var tex: Texture2D = null
	for tname: Variant in tex_names:
		tex = atlas.get_starling_texture(bg_atlas, str(tname))
		if tex != null:
			break
	if tex == null or (tex.get_width() <= 2 and tex.get_height() <= 2):
		layer.motion_mirroring = Vector2.ZERO
		return
	var w: float = float(tex.get_width())
	var h: float = float(tex.get_height())
	var y_pos: float = bottom_y - h
	var pair_w: float = w * 2.0
	var pair_count: int = maxi(1, ceili(2800.0 / maxf(1.0, pair_w)))
	layer.motion_mirroring = Vector2(pair_w * float(pair_count), 0.0)
	for p: int in range(pair_count):
		var base_x: float = x_offset + float(p) * pair_w
		var s1: Sprite2D = Sprite2D.new()
		s1.texture = tex
		s1.centered = false
		s1.position = Vector2(base_x, y_pos)
		layer.add_child(s1)
		var s2: Sprite2D = Sprite2D.new()
		s2.texture = tex
		s2.centered = false
		s2.flip_h = true
		s2.position = Vector2(base_x + w, y_pos)
		layer.add_child(s2)


func _update_sky_scale() -> void:
	if _sky_sprite == null or not is_instance_valid(_sky_sprite):
		return
	if _sky_tex_size.x <= 0.0 or _sky_tex_size.y <= 0.0:
		return
	var vp: Viewport = get_viewport()
	var vp_size: Vector2 = vp.get_visible_rect().size if vp != null else BASE_VIEWPORT_SIZE
	if vp_size.x <= 10.0 or vp_size.y <= 10.0:
		vp_size = BASE_VIEWPORT_SIZE
	var zoom_vec: Vector2 = camera.zoom if camera != null else Vector2.ONE
	var cover_w: float = vp_size.x / maxf(0.1, zoom_vec.x)
	var cover_h: float = vp_size.y / maxf(0.1, zoom_vec.y)
	_sky_sprite.scale = Vector2(cover_w / _sky_tex_size.x, cover_h / _sky_tex_size.y)


func _spawn_coin_boxes(map_dict: Dictionary) -> void:
	if props_container == null:
		return
	var cb_script := preload("res://scripts/entities/CoinBoxEntity.gd")
	var map_w: int = int(map_dict.get("width", 0))
	if map_w <= 0 and tile_renderer != null:
		map_w = int(tile_renderer.map_width)

	var layers_dict: Variant = map_dict.get("layers", null)
	var spawned_positions: Dictionary = {}

	for layer_key: String in ["mapMain", "mapG2", "mapG3"]:
		var raw_layer: Variant = null
		if layers_dict is Dictionary and (layers_dict as Dictionary).has(layer_key):
			raw_layer = (layers_dict as Dictionary)[layer_key]
		elif map_dict.has(layer_key):
			raw_layer = map_dict[layer_key]

		if raw_layer == null:
			continue

		if raw_layer is Array:
			var arr: Array = raw_layer as Array
			if arr.is_empty():
				continue
			if arr[0] is Array:
				for r: int in range(arr.size()):
					var row_arr: Variant = arr[r]
					if not (row_arr is Array):
						continue
					for c: int in range((row_arr as Array).size()):
						if int((row_arr as Array)[c]) == 31:
							var pos_key := Vector2i(c, r)
							if spawned_positions.has(pos_key):
								continue
							spawned_positions[pos_key] = true
							var cb := cb_script.new()
							cb.stage_id = current_stage_id
							cb.game_world = self
							cb.position = Vector2(float(c) * 165.0, float(r) * 165.0)
							props_container.add_child(cb)
			else:
				if map_w > 0:
					for idx: int in range(arr.size()):
						if int(arr[idx]) == 31:
							var c: int = idx % map_w
							var r: int = idx / map_w
							var pos_key := Vector2i(c, r)
							if spawned_positions.has(pos_key):
								continue
							spawned_positions[pos_key] = true
							var cb := cb_script.new()
							cb.stage_id = current_stage_id
							cb.game_world = self
							cb.position = Vector2(float(c) * 165.0, float(r) * 165.0)
							props_container.add_child(cb)
		elif raw_layer is PackedInt32Array or raw_layer is PackedByteArray:
			if map_w > 0:
				for idx: int in range(raw_layer.size()):
					if int(raw_layer[idx]) == 31:
						var c: int = idx % map_w
						var r: int = idx / map_w
						var pos_key := Vector2i(c, r)
						if spawned_positions.has(pos_key):
							continue
						spawned_positions[pos_key] = true
						var cb := cb_script.new()
						cb.position = Vector2(float(c) * 165.0, float(r) * 165.0)
						props_container.add_child(cb)


func _clear_level_entities() -> void:
	if props_container != null and is_instance_valid(props_container):
		for child: Node in props_container.get_children():
			if is_instance_valid(child):
				child.queue_free()
	if entities_container != null and is_instance_valid(entities_container):
		for child: Node in entities_container.get_children():
			if child != local_player and is_instance_valid(child):
				child.queue_free()
	for enemy: Variant in enemies:
		if enemy != null and is_instance_valid(enemy):
			(enemy as Node).queue_free()
	enemies.clear()
	portals.clear()


func _spawn_map_props(map_dict: Dictionary, meta: Dictionary) -> void:
	var atlas: Node = _get_atlas_loader()
	atlas.register_starling_atlas("trees_fish")

	# Порталы (map_*.json: [col, row, targetArea, ...]; Stats.as: portal1Lead..portal7Lead)
	var portals_data: Variant = map_dict.get("portals", [])
	var meta_portals: Dictionary = meta.get("portals", {})
	var used_slots: Dictionary = {}
	if portals_data is Array:
		for idx: int in range(portals_data.size()):
			var p_item: Variant = portals_data[idx]
			if p_item is Array and p_item.size() >= 3:
				var p_col: int = int(p_item[0])
				var p_row: int = int(p_item[1])
				var raw_target: int = int(p_item[2])
				var resolved_portal_id: int = idx + 1
				var resolved_target_stage: int = raw_target
				for slot: int in range(1, 8):
					if used_slots.has(slot):
						continue
					var lead_val: int = int(meta_portals.get("portal%dLead" % slot, 0))
					if lead_val == raw_target and lead_val > 0:
						resolved_portal_id = slot
						resolved_target_stage = lead_val
						used_slots[slot] = true
						break
				var portal_entity: PortalEntity = PortalEntity.new()
				portal_entity.portal_id = resolved_portal_id
				portal_entity.target_stage = resolved_target_stage
				portal_entity.current_stage_id = current_stage_id
				if current_stage_id == 1 and resolved_portal_id == 2:
					portal_entity.visible = false
				# GameMain.as:8792-8793: createPortal(param4, param2 + 83, param3 + 185), _loc4_.y = param3 - 5
				portal_entity.position = Vector2(p_col * 165 + 83, p_row * 165 + 180)
				portal_entity.player_entered_portal.connect(change_level)
				props_container.add_child(portal_entity)
				portals.append(portal_entity)

	# Деревья (trees -> TreeEntity)
	trees.clear()
	var trees_data: Variant = map_dict.get("trees", [])
	if trees_data is Array:
		for t_item: Variant in trees_data:
			if t_item is Array and t_item.size() >= 3:
				var t_col: int = int(t_item[0])
				var t_row: int = int(t_item[1])
				var tree_type: String = str(t_item[2])
				var tree_ent := TreeEntityScript.new()
				tree_ent.tree_type = tree_type
				tree_ent.position = Vector2(t_col * 165 + 82, t_row * 165 + 171)
				tree_ent.tree_chopped.connect(_on_tree_chopped)
				props_container.add_child(tree_ent)
				trees.append(tree_ent)

	# Рыбы (fish -> FishEntity внутри mapWater == 25, до 15 рыб)
	_spawn_map_fish(map_dict)

	# Банкомат (ATM из areas_meta.atmPosition — порт ATM.as:19-32)
	var atm_pos_v: Variant = meta.get("atmPosition", null)
	if atm_pos_v is Dictionary and (int(atm_pos_v.get("x", 0)) > 0 or int(atm_pos_v.get("y", 0)) > 0):
		var atm_root := Node2D.new()
		atm_root.name = "ATMProp"
		atm_root.position = Vector2(float(atm_pos_v.get("x", 0)), float(atm_pos_v.get("y", 0)))

		var atm_tex: Texture2D = atlas.get_starling_texture("trees_fish", "atm")
		var click_tex: Texture2D = atlas.get_starling_texture("trees_fish", "click to interact")
		if atm_tex != null:
			var atm_sprite := Sprite2D.new()
			atm_sprite.texture = atm_tex
			atm_sprite.centered = false
			atm_sprite.position = Vector2(-47.0, -78.0)
			atm_root.add_child(atm_sprite)
		if click_tex != null:
			var click_sprite := Sprite2D.new()
			click_sprite.texture = click_tex
			click_sprite.position = Vector2(-4.0, -92.0)
			atm_root.add_child(click_sprite)

		var atm_btn := Button.new()
		atm_btn.name = "ATMButton"
		atm_btn.flat = true
		atm_btn.modulate = Color(1, 1, 1, 0.0) if atm_tex != null else Color.WHITE
		if atm_tex == null:
			atm_btn.text = "ATM"
		atm_btn.position = Vector2(-47.0, -98.0)
		atm_btn.size = Vector2(96.0, 120.0)
		atm_btn.focus_mode = Control.FOCUS_NONE
		atm_btn.pressed.connect(func() -> void:
			bank_requested.emit()
			if hud != null and hud.has_method("toggle_bank_menu"):
				hud.call("toggle_bank_menu")
		)
		atm_root.add_child(atm_btn)
		props_container.add_child(atm_root)


func _spawn_map_fish(map_dict: Dictionary) -> void:
	fishes.clear()
	if props_container == null or tile_renderer == null:
		return
	var fish_types: Variant = map_dict.get("fish", [])
	if not (fish_types is Array) or (fish_types as Array).is_empty():
		return
	var water_layer: PackedInt32Array = tile_renderer.layer_data_dict.get("mapWater", PackedInt32Array())
	if water_layer.is_empty():
		return
	var w: int = int(tile_renderer.map_width)
	var h: int = int(tile_renderer.map_height)
	var inner_cells: Array[Vector2i] = []
	var any_cells: Array[Vector2i] = []
	for y: int in range(h):
		for x: int in range(w):
			if water_layer[y * w + x] != 25:
				continue
			any_cells.append(Vector2i(x, y))
			if x > 0 and y > 0 and x < w - 1 and y < h - 1:
				if water_layer[y * w + (x - 1)] == 25 and water_layer[y * w + (x + 1)] == 25 and water_layer[(y - 1) * w + x] == 25 and water_layer[(y + 1) * w + x] == 25:
					inner_cells.append(Vector2i(x, y))
	var pool: Array[Vector2i] = inner_cells if not inner_cells.is_empty() else any_cells
	if pool.is_empty():
		return
	pool.shuffle()
	var count: int = mini(15, pool.size())
	var f_arr: Array = fish_types as Array
	for i: int in range(count):
		var cell: Vector2i = pool[i]
		var fish_ent := FishEntityScript.new()
		fish_ent.fish_type = str(f_arr[randi() % f_arr.size()])
		fish_ent.is_shiny = (randi() % 550) == 0
		fish_ent.game_world = self
		fish_ent.position = Vector2(float(cell.x * 165 + 82), float(cell.y * 165 + 82))
		props_container.add_child(fish_ent)
		fishes.append(fish_ent)


func spawn_coin_box_coins(world_pos: Vector2, coin_value: int, count: int) -> void:
	for _i: int in range(count):
		var loot: LootItemEntity = spawn_dropped_item("coin", world_pos, "", true, coin_value)
		loot.vel_x = randf_range(-20.0, 20.0)
		loot.vel_y = -20.0


func _on_tree_chopped(tree_kind: String, world_pos: Vector2, log_count: int) -> void:
	var log_item: String = (tree_kind.strip_edges() + " log") if not tree_kind.strip_edges().is_empty() else "log"
	for _i: int in range(log_count):
		var drop_pos := world_pos + Vector2(randf_range(-56.0, 56.0), randf_range(-20.0, 20.0))
		spawn_dropped_item(log_item, drop_pos, "", false, 0)


func chop_nearby_trees(player: Node2D, raw_dmg: int) -> bool:
	if player == null or trees.is_empty():
		return false
	var hit_any: bool = false
	for t_v: Variant in trees:
		if not is_instance_valid(t_v):
			continue
		var t: TreeEntity = t_v as TreeEntity
		if t == null or t.is_chopped:
			continue
		if absf(t.global_position.x - player.global_position.x) <= 130.0 and absf(t.global_position.y - player.global_position.y) <= 160.0:
			t.take_chop_damage(raw_dmg, player)
			hit_any = true
			break
	return hit_any


func try_catch_nearest_fish(player: Node2D) -> String:
	if player == null or fishes.is_empty():
		return ""
	var best_fish: FishEntity = null
	var best_dist: float = 180.0
	for f_v: Variant in fishes:
		if not is_instance_valid(f_v):
			continue
		var f: FishEntity = f_v as FishEntity
		if f == null or f.is_caught:
			continue
		var d: float = f.global_position.distance_to(player.global_position)
		if d <= best_dist:
			best_dist = d
			best_fish = f
	if best_fish == null:
		return ""
	return best_fish.catch_fish()


func _spawn_enemies(map_dict: Dictionary) -> void:
	var spawns: Variant = map_dict.get("spawns", [])
	if spawns is Array:
		for s: Variant in spawns:
			if s is Array and s.size() >= 5:
				var e_col: int = int(s[0])
				var e_row: int = int(s[1])
				var e_type: String = str(s[4])
				var enemy: EnemyEntity = EnemyEntity.new()
				enemy.enemy_type = e_type
				enemy.game_world = self
				enemy.position = Vector2(e_col * 165 + 83, e_row * 165 + 155)
				enemy.enemy_died.connect(_on_enemy_died)
				entities_container.add_child(enemy)
				enemies.append(enemy)


func _setup_player(map_dict: Dictionary) -> void:
	var spawn_coord: Variant = map_dict.get("playerSpawn", [4, 4])
	var spawn_pos: Vector2 = Vector2(4 * 165 + 82.5, 4 * 165)
	if spawn_coord is Array and spawn_coord.size() >= 2:
		var col: int = int(spawn_coord[0])
		var row: int = int(spawn_coord[1])
		spawn_pos = Vector2(col * 165 + 82.5, row * 165)

	# GameMain.as:2777-2793: случайный спавн в зонах 112..114; иначе спавн у ответного портала
	if current_stage_id in [112, 113, 114]:
		spawn_pos = Vector2(825.0 + randf() * 2000.0, randf() * 800.0)
	elif (last_portal_id > 0 or previous_stage_id > 0) and not portals.is_empty():
		var matched_portal: PortalEntity = null
		if previous_stage_id > 0:
			for p: Variant in portals:
				if p is PortalEntity and p.target_stage == previous_stage_id:
					if matched_portal == null or p.portal_id == last_portal_id:
						matched_portal = p
		if matched_portal == null and last_portal_id > 0:
			for p: Variant in portals:
				if p is PortalEntity and p.portal_id == last_portal_id:
					matched_portal = p
					break
		if matched_portal == null:
			matched_portal = portals[0] as PortalEntity
		if matched_portal != null:
			spawn_pos = Vector2(matched_portal.position.x, matched_portal.position.y + 5.0)

	if local_player == null:
		local_player = PersonEntity.new()
		local_player.name = "LocalPlayer"
		local_player.is_local_player = true
		local_player.game_world = self
		entities_container.add_child(local_player)
	
	local_player.position = spawn_pos
	local_player.vel_x = 0.0
	local_player.vel_y = 0.0
	local_player.on_ground = true
	local_player.drop_through_counter = 500
	local_player.is_ducking = false

	# Привязка игрока к HUD
	if hud != null and hud.has_method("bind_player"):
		hud.call("bind_player", local_player)


func _physics_process(delta: float) -> void:
	_level_change_accum += delta
	while _level_change_accum >= (1.0 / 30.0):
		_level_change_accum -= (1.0 / 30.0)
		level_change_ticks += 1
	# Камера центрируется на игроке с pixel snap
	if local_player != null and camera != null:
		camera.position = local_player.position.round()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var kev: InputEventKey = event
		if kev.pressed and not kev.echo:
			var vp: Viewport = get_viewport()
			var focus_owner: Control = vp.gui_get_focus_owner() if vp != null else null
			if focus_owner is TextEdit or focus_owner is LineEdit or focus_owner is CodeEdit:
				return
			if kev.keycode == KEY_E:
				if local_player != null and not local_player.is_dead:
					if try_pickup_nearest_loot(local_player):
						if vp != null:
							vp.set_input_as_handled()
						return
			if kev.keycode == KEY_EQUAL or kev.keycode == KEY_PLUS or kev.keycode == KEY_KP_ADD:
				zoom_camera_in()
				if vp != null:
					vp.set_input_as_handled()
			elif kev.keycode == KEY_MINUS or kev.keycode == KEY_KP_SUBTRACT:
				zoom_camera_out()
				if vp != null:
					vp.set_input_as_handled()


func zoom_camera_in() -> void:
	user_camera_zoom = clampf(snappedf(user_camera_zoom + CAMERA_ZOOM_STEP, 0.05), CAMERA_ZOOM_MIN, CAMERA_ZOOM_MAX)
	_update_camera_zoom()


func zoom_camera_out() -> void:
	user_camera_zoom = clampf(snappedf(user_camera_zoom - CAMERA_ZOOM_STEP, 0.05), CAMERA_ZOOM_MIN, CAMERA_ZOOM_MAX)
	_update_camera_zoom()


func reset_camera_zoom() -> void:
	user_camera_zoom = CAMERA_ZOOM_DEFAULT
	_update_camera_zoom()


func _update_camera_zoom() -> void:
	if camera == null:
		return
	var vp: Viewport = get_viewport()
	var vp_size: Vector2 = vp.get_visible_rect().size if vp != null else BASE_VIEWPORT_SIZE
	if vp_size.x <= 10.0 or vp_size.y <= 10.0:
		vp_size = BASE_VIEWPORT_SIZE
	var effective_zoom: float = user_camera_zoom
	if _map_pixel_size.x > 0.0 and _map_pixel_size.y > 0.0:
		var min_fit_zoom: float = maxf(vp_size.x / _map_pixel_size.x, vp_size.y / _map_pixel_size.y)
		effective_zoom = maxf(effective_zoom, minf(min_fit_zoom, CAMERA_ZOOM_MAX))
	camera.zoom = Vector2(effective_zoom, effective_zoom)
	camera.offset = Vector2(0.0, 99.0 / maxf(0.1, effective_zoom))
	_update_sky_scale()


func can_use_portal() -> bool:
	return level_change_ticks > 120


## Смена локации / уровня через портал или карту
func change_level(target_stage: int, via_portal_id: int = 1) -> void:
	if target_stage <= 0:
		return
	print("[GameWorld] Changing level to stage: %d (via portal %d)" % [target_stage, via_portal_id])
	var amgr: Node = _get_audio_manager()
	if amgr != null and amgr.has_method("play_sfx"):
		amgr.play_sfx("SFX/teleport")
	_trigger_white_fade()
	previous_stage_id = current_stage_id
	_unlock_map(target_stage)
	last_portal_id = via_portal_id
	level_change_ticks = 0
	_level_change_accum = 0.0
	level_changed.emit(target_stage)
	load_level(target_stage)
	if hud != null and "map_menu" in hud and hud.map_menu != null:
		if hud.map_menu.has_method("set_current_area"):
			hud.map_menu.call("set_current_area", target_stage)
		if hud.map_menu.has_method("refresh_unlocked_maps"):
			hud.map_menu.call("refresh_unlocked_maps")


func _trigger_white_fade() -> void:
	if _white_rect == null or not is_instance_valid(_white_rect):
		return
	if _fade_tween != null and _fade_tween.is_valid():
		_fade_tween.kill()
	_white_rect.modulate.a = 1.0
	_white_rect.visible = true
	_fade_tween = create_tween()
	_fade_tween.tween_interval(0.2)
	_fade_tween.tween_property(_white_rect, "modulate:a", 0.0, 1.0)
	_fade_tween.tween_callback(func() -> void:
		if is_instance_valid(_white_rect):
			_white_rect.visible = false
	)


func _unlock_map(stage_id: int) -> void:
	if stage_id <= 0 or stage_id == GameConfig.REDIRECTED_STAGE_FROM:
		return
	var pio: Node = get_node_or_null("/root/PlayerIOClient")
	if pio == null or not ("my_player_object" in pio) or not (pio.my_player_object is Dictionary):
		return
	var p_obj: Dictionary = pio.my_player_object
	var unlocked: Array = []
	var raw_unlocked: Variant = p_obj.get("unlockedMaps", [])
	if raw_unlocked is Array:
		for item: Variant in raw_unlocked:
			var sid: int = int(item)
			if sid > 0 and not unlocked.has(sid):
				unlocked.append(sid)
	if unlocked.is_empty():
		unlocked.append(1)
	if not unlocked.has(stage_id):
		unlocked.append(stage_id)
		p_obj["unlockedMaps"] = unlocked
		if bool(pio.get("is_offline_mode")) and pio.has_method("bigdb_save_changes"):
			var save_key: String = str(p_obj.get("_key", pio.get("connect_user_id")))
			if not save_key.is_empty():
				pio.bigdb_save_changes("PlayerObjects", save_key, {"unlockedMaps": unlocked})
	elif not raw_unlocked is Array or (raw_unlocked as Array).is_empty():
		p_obj["unlockedMaps"] = unlocked


## Разрешение физики для GravityBody (тайлы и ступени maxGap)
func resolve_gravity_body(body: GravityBody) -> void:
	if tile_renderer == null:
		body.on_ground = body.is_on_floor()
		return

	# Проверяем контакт с полом
	body.on_ground = body.is_on_floor()


## Проверка, находится ли точка в воде
func is_point_in_water(px: float, py: float) -> bool:
	if tile_renderer == null:
		return false
	return tile_renderer.is_point_in_water(px, py)


## Нанесение урона всем врагам в радиусе атаки
func damage_enemies_in_range(attack_center: Vector2, radius: float, damage: int, attacker: Node2D, is_crit: bool = false) -> void:
	for enemy: EnemyEntity in enemies:
		if is_instance_valid(enemy) and enemy.health > 0:
			var enemy_rect: Rect2 = enemy.get_world_hitbox() if enemy.has_method("get_world_hitbox") else Rect2(enemy.global_position + enemy.hit_offset, Vector2(enemy.body_width, enemy.body_height))
			var closest: Vector2 = attack_center.clamp(enemy_rect.position, enemy_rect.end)
			if closest.distance_to(attack_center) <= radius:
				enemy.take_damage(damage, attacker, is_crit)


const ENEMY_DROP_TABLES: Dictionary = {
	"green bouncer": {"items": ["apple", "potion"], "chance": 0.08},
	"blue bouncer": {"items": ["apple", "potion", "blue potion"], "chance": 0.09},
	"red bouncer": {"items": ["apple", "orange", "potion"], "chance": 0.10},
	"purple bouncer": {"items": ["orange", "potion", "blue potion"], "chance": 0.10},
	"bat": {"items": ["apple", "bread"], "chance": 0.08},
	"zombie": {"items": ["bread", "potion"], "chance": 0.09},
	"skeleton": {"items": ["bread", "orange", "potion"], "chance": 0.10},
}
const DEFAULT_DROP_ITEMS: Array[String] = ["apple", "potion"]
const DEFAULT_DROP_CHANCE: float = 0.06


## Обработка естественной смерти врага: XP, монеты, вероятностный дроп по таблице и запись в Heropedia (GameMain.as:3615-3637)
func _on_enemy_died(enemy: EnemyEntity) -> void:
	if enemy == null:
		return
	enemies.erase(enemy)

	var sdb: Node = _get_stats_db()
	var e_data: Dictionary = sdb.get_enemy_data(enemy.enemy_type) if sdb != null else {}
	var worth: int = int(e_data.get("w", e_data.get("worth", maxi(1, int(enemy.xp_reward / 3)))))

	if local_player != null:
		if local_player.has_method("add_exp") and enemy.xp_reward > 0:
			local_player.add_exp(enemy.xp_reward)
		if local_player.has_method("add_coins") and worth > 0:
			local_player.add_coins(worth)

	# Таблица дропа по типу врага + бонус навыка loot steal
	var drop_entry: Dictionary = ENEMY_DROP_TABLES.get(enemy.enemy_type.to_lower(), {})
	var drop_items: Array = drop_entry.get("items", DEFAULT_DROP_ITEMS)
	var drop_chance: float = float(drop_entry.get("chance", DEFAULT_DROP_CHANCE))
	if local_player != null and "skill_levels" in local_player and local_player.skill_levels is Dictionary:
		var loot_steal_lvl: int = int(local_player.skill_levels.get("loot steal", local_player.skill_levels.get("lootSteal", 0)))
		if loot_steal_lvl > 0:
			drop_chance += float(loot_steal_lvl) * 0.005

	if not drop_items.is_empty() and randf() < drop_chance:
		var drop_item: String = str(drop_items[randi() % drop_items.size()])
		spawn_enemy_loot(enemy.global_position, drop_item)

	_record_enemy_discovery(enemy.enemy_type)


func _record_enemy_discovery(enemy_type: String) -> void:
	if enemy_type.is_empty():
		return

	var newly_discovered: bool = false
	var pio: Node = get_node_or_null("/root/PlayerIOClient")
	if pio != null and ("my_player_object" in pio) and pio.my_player_object is Dictionary:
		var p_obj: Dictionary = pio.my_player_object
		var raw_list: Variant = p_obj.get("enemyList", "")
		var list_arr: Array[String] = []
		if raw_list is String and not raw_list.is_empty():
			for part: String in raw_list.split(",", false):
				var clean: String = part.strip_edges()
				if not clean.is_empty() and not list_arr.has(clean):
					list_arr.append(clean)
		elif raw_list is Array:
			for item: Variant in raw_list:
				var clean: String = str(item).strip_edges()
				if not clean.is_empty() and not list_arr.has(clean):
					list_arr.append(clean)

		if not list_arr.has(enemy_type):
			list_arr.append(enemy_type)
			var joined: String = ",".join(list_arr)
			p_obj["enemyList"] = joined
			newly_discovered = true
			if bool(pio.get("is_offline_mode")) and pio.has_method("bigdb_save_changes"):
				var save_key: String = str(p_obj.get("_key", pio.get("connect_user_id")))
				if not save_key.is_empty():
					pio.bigdb_save_changes("PlayerObjects", save_key, {"enemyList": joined})

	if local_player != null and "enemy_list" in local_player and local_player.enemy_list is Array:
		if not local_player.enemy_list.has(enemy_type):
			local_player.enemy_list.append(enemy_type)
			newly_discovered = true

	if newly_discovered and hud != null and hud.has_method("on_heropedia_unlocked"):
		hud.call("on_heropedia_unlocked", enemy_type)


## Спавн дропа предмета в мире (при явном вызове с item_name)
func spawn_enemy_loot(drop_pos: Vector2, item_name: String = "apple") -> void:
	var resolved_item: String = item_name
	if resolved_item.is_empty():
		resolved_item = "apple"
	else:
		# Совместимость со старыми вызовами/тестами, передающими enemy_type вместо item_name
		var sdb: Node = _get_stats_db()
		if sdb != null and sdb.has_method("get_enemy_data") and not sdb.get_enemy_data(resolved_item).is_empty():
			if not sdb.has_method("get_item_data") or sdb.get_item_data(resolved_item).is_empty():
				resolved_item = "apple"

	spawn_dropped_item(resolved_item, drop_pos)


func spawn_dropped_item(
	item_name: String,
	drop_pos: Vector2,
	drop_owner: String = "",
	is_coin: bool = false,
	coin_amount: int = 10
) -> LootItemEntity:
	var loot: LootItemEntity = LootItemEntity.new()
	loot.item_name = item_name
	loot.is_coin = is_coin
	loot.coin_amount = coin_amount
	loot.owner_name = drop_owner
	loot.position = drop_pos
	loot.game_world = self
	loot.item_picked_up.connect(_on_loot_picked_up)
	entities_container.add_child(loot)
	return loot


func _on_loot_picked_up(loot: LootItemEntity, collector: Node2D) -> void:
	if loot == null or collector == null:
		return
	if loot.is_coin:
		if collector.has_method("add_coins"):
			collector.call("add_coins", loot.coin_amount)
		elif "coins" in collector:
			collector.set("coins", int(collector.get("coins")) + loot.coin_amount)
	else:
		if collector.has_method("add_inventory_item"):
			collector.call("add_inventory_item", loot.item_name)


func try_pickup_nearest_loot(collector: Node2D, max_dist: float = 56.0) -> bool:
	if collector == null or entities_container == null:
		return false
	var best: LootItemEntity = null
	var best_dist: float = max_dist
	for child: Node in entities_container.get_children():
		if child is LootItemEntity:
			var loot: LootItemEntity = child as LootItemEntity
			if loot.is_coin or not loot.can_be_picked_up_by(collector):
				continue
			var d: float = loot.global_position.distance_to(collector.global_position)
			if d <= best_dist:
				best_dist = d
				best = loot
	if best != null:
		return best.try_pickup(collector)
	return false
