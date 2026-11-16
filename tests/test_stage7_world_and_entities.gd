extends SceneTree
## test_stage7_world_and_entities.gd — Комплексный автономный тест Этапа 7:
## 1. SwfSpriteLoader: нарезка тайлов 165x165 px и создание SpriteFrames врагов.
## 2. GravityBody: физика 30 FPS, гравитация, трение, скорость, отскок от батута.
## 3. TileMapRenderer и GameWorld: загрузка карты (Stage 1), слои тайлов, параллакс-фон, пропсы, спавны.
## 4. BodyAnimatorNode и PersonEntity: 15 слоев персонажа, матрицы анимации, управление, атаки, урон.
## 5. EnemyEntity: статы, SpriteFrames, получение урона, отбрасывание, смерть и дроп.
## 6. PortalEntity: генерация перехода между локациями.
## 7. GameFlow: интеграция с GameWorld.tscn.

const SwfSpriteLoaderScript = preload("res://scripts/autoload/SwfSpriteLoader.gd")
const StarlingAtlasLoaderScript = preload("res://scripts/autoload/StarlingAtlasLoader.gd")
const StatsDBScript = preload("res://scripts/autoload/StatsDB.gd")
const AudioManagerScript = preload("res://scripts/autoload/AudioManager.gd")
const GravityBodyScript = preload("res://scripts/world/GravityBody.gd")
const PersonEntityScript = preload("res://scripts/entities/PersonEntity.gd")
const EnemyEntityScript = preload("res://scripts/entities/EnemyEntity.gd")
const PortalEntityScript = preload("res://scripts/entities/PortalEntity.gd")
const LootItemEntityScript = preload("res://scripts/entities/LootItemEntity.gd")
const TileMapRendererScript = preload("res://scripts/world/TileMapRenderer.gd")
const GameWorldScript = preload("res://scripts/world/GameWorld.gd")
const BodyAnimatorScript = preload("res://scripts/entities/BodyAnimatorNode.gd")
const GameFlowScript = preload("res://scripts/GameFlow.gd")

class WaterTestWorld extends Node:
	var water_enabled: bool = false

	func is_point_in_water(_px: float, _py: float) -> bool:
		return water_enabled

var passed_count: int = 0
var failed_count: int = 0

var swf_loader: Node = null
var atlas_loader: Node = null
var stats_db: Node = null
var audio_mgr: Node = null

func _init() -> void:
	call_deferred("_bootstrap_and_run")


func _bootstrap_and_run() -> void:
	print("\n=======================================================")
	print("--- STARTING STAGE 7 TEST: WORLD, PHYSICS & ENTITIES ---")
	print("=======================================================\n")

	# Инициализируем синглтоны в дереве сцены для автономного режима SceneTree
	atlas_loader = StarlingAtlasLoaderScript.new()
	atlas_loader.name = "StarlingAtlasLoader"
	root.add_child(atlas_loader)

	stats_db = StatsDBScript.new()
	stats_db.name = "StatsDB"
	root.add_child(stats_db)

	audio_mgr = AudioManagerScript.new()
	audio_mgr.name = "AudioManager"
	root.add_child(audio_mgr)

	swf_loader = SwfSpriteLoaderScript.new()
	swf_loader.name = "SwfSpriteLoader"
	root.add_child(swf_loader)

	_run_all_tests()

	print("\n=======================================================")
	print("STAGE 7 TEST SUMMARY: %d passed, %d failed" % [passed_count, failed_count])
	print("=======================================================\n")
	quit(0 if failed_count == 0 else 1)


func assert_true(cond: bool, msg: String) -> void:
	if cond:
		passed_count += 1
		print("[PASS] %s" % msg)
	else:
		failed_count += 1
		printerr("[FAIL] %s" % msg)


func _run_all_tests() -> void:
	_test_swf_sprite_loader()
	_test_gravity_body_physics()
	_test_body_animator_and_person()
	_test_tilemap_renderer_and_gameworld()
	_test_enemy_combat_and_loot()
	_test_portal_and_gameflow()


func _test_swf_sprite_loader() -> void:
	print("\n--- 1. Testing SwfSpriteLoader ---")
	var tile_tex: Texture2D = swf_loader.call("get_tile_texture", "GreenAreaTiles", 2) as Texture2D
	assert_true(tile_tex != null, "SwfSpriteLoader: Sliced GreenAreaTiles tile 2 successfully")
	if tile_tex != null:
		assert_true(tile_tex.get_width() == 165 and tile_tex.get_height() == 165, "SwfSpriteLoader: Tile size is exactly 165x165 px")

	var frames: SpriteFrames = swf_loader.call("get_enemy_sprite_frames", "green bouncer") as SpriteFrames
	assert_true(frames != null, "SwfSpriteLoader: Generated SpriteFrames for 'green bouncer'")
	if frames != null:
		var frame_count: int = frames.get_frame_count("default")
		assert_true(frame_count >= 10, "SwfSpriteLoader: Green bouncer has %d animation frames" % frame_count)


func _test_gravity_body_physics() -> void:
	print("\n--- 2. Testing GravityBody Physics ---")
	var body: Node = GravityBodyScript.new()
	root.add_child(body)

	body.set("global_position", Vector2(100, 100))
	var water_world := WaterTestWorld.new()
	root.add_child(water_world)
	body.set("game_world", water_world)
	body.set("vel_x", 10.0)
	body.set("vel_y", 0.0)

	# 1 тик физики (30 FPS)
	body.call("physics_tick")
	var cur_vel_y: float = float(body.get("vel_y"))
	var cur_vel_x: float = float(body.get("vel_x"))
	assert_true(cur_vel_y > 0.0, "GravityBody: Gravity applied downwards (vel_y = %.2f)" % cur_vel_y)
	assert_true(cur_vel_x < 10.0, "GravityBody: Air friction damped vel_x (vel_x = %.2f)" % cur_vel_x)
	assert_true(is_equal_approx(cur_vel_y, 1.1), "GravityBody: Zero acceleration multiplier applies base gravity once (vel_y = %.2f)" % cur_vel_y)

	# Original GravityObject formula: g + accelDownMultiplier * g.
	body.set("vel_y", 0.0)
	body.set("accel_down_multiplier", 2.0)
	body.call("physics_tick")
	var multiplied_vel_y: float = float(body.get("vel_y"))
	assert_true(is_equal_approx(multiplied_vel_y, 3.3), "GravityBody: Nonzero multiplier adds multiplier-scaled gravity (vel_y = %.2f)" % multiplied_vel_y)

	# Water uses 0.7 gravity and caps downward speed at maxFallSpeed / 4.
	water_world.water_enabled = true
	body.set("vel_y", 0.0)
	body.set("accel_down_multiplier", 0.0)
	body.call("physics_tick")
	var water_gravity_vel_y: float = float(body.get("vel_y"))
	assert_true(is_equal_approx(water_gravity_vel_y, 0.77), "GravityBody: Water gravity is 0.7 of base gravity (vel_y = %.2f)" % water_gravity_vel_y)
	body.set("vel_y", 100.0)
	body.call("physics_tick")
	var water_capped_vel_y: float = float(body.get("vel_y"))
	assert_true(is_equal_approx(water_capped_vel_y, 6.25), "GravityBody: Water fall speed capped at maxFallSpeed / 4 (vel_y = %.2f)" % water_capped_vel_y)
	water_world.water_enabled = false

	# Батут (BouncePad)
	body.call("apply_bounce", 25.0)
	var bounce_vel_y: float = float(body.get("vel_y"))
	assert_true(bounce_vel_y < 0.0 and abs(bounce_vel_y) >= 20.0, "GravityBody: BouncePad launched body upwards (vel_y = %.2f)" % bounce_vel_y)

	body.queue_free()
	water_world.queue_free()


func _test_body_animator_and_person() -> void:
	print("\n--- 3. Testing BodyAnimatorNode and PersonEntity ---")
	var person: Node = PersonEntityScript.new()
	root.add_child(person)

	var animator: Node = person.get("animator") as Node
	assert_true(animator != null, "PersonEntity: Initialized BodyAnimatorNode child")
	assert_true(animator.get("head_sprite") != null, "BodyAnimator: Head layer initialized")
	assert_true(animator.get("body_sprite") != null, "BodyAnimator: Body layer initialized")
	assert_true(animator.get("weapon_left_sprite") != null, "BodyAnimator: Main weapon layer initialized")

	# Source helmetStats: archer hat frame 41; BodyAnimator.as uses helmetsX/Y[frame - 1].
	animator.set("helmet_name", "archer hat")
	animator.call("apply_appearance")
	var helmet_image: Sprite2D = animator.get("helmet_image") as Sprite2D
	assert_true(helmet_image != null and helmet_image.texture != null, "BodyAnimator: Archer hat texture loaded")
	if helmet_image != null and helmet_image.texture != null:
		var helmet_pivot: Vector2 = helmet_image.texture.get_meta("pivot", Vector2.ZERO)
		assert_true(helmet_image.position == Vector2(-6.0, -17.0), "BodyAnimator: Archer hat uses frame-41 source offsets")
		assert_true(helmet_image.texture.get_size() == Vector2(48.0, 31.0), "BodyAnimator: Archer hat uses its untrimmed atlas dimensions")
		assert_true(helmet_pivot.is_equal_approx(Vector2(23.55, 12.9)), "BodyAnimator: Archer hat keeps its source Starling pivot")
		assert_true(not helmet_image.centered and helmet_image.offset.is_equal_approx(Vector2(-23.55, -12.9)), "BodyAnimator: Sprite2D drawing origin matches source pivot")
	animator.set("helmet_name", "")
	animator.call("apply_appearance")
	assert_true(helmet_image.position == Vector2.ZERO and helmet_image.offset == Vector2.ZERO, "BodyAnimator: Removing helmet clears helmet-only transforms")

	# Проверка переключения анимаций
	animator.call("play", "walking")
	var cur_anim: String = str(animator.get("current_anim_name"))
	assert_true(cur_anim == "walking" or cur_anim == "standing", "BodyAnimator: Played locomotion animation")

	animator.call("advance_frame")
	var cframe: int = int(animator.get("current_frame"))
	assert_true(cframe >= 0, "BodyAnimator: Advanced frame to %d" % cframe)

	# Проверка урона по персонажу
	var initial_hp: int = int(person.get("health"))
	person.call("take_damage", 20)
	var hp_after: int = int(person.get("health"))
	assert_true(hp_after < initial_hp, "PersonEntity: Took damage (HP: %d -> %d)" % [initial_hp, hp_after])

	# Атака
	person.call("execute_attack", "attack")
	var is_atk: bool = bool(person.get("is_attacking"))
	assert_true(is_atk, "PersonEntity: Executed basic attack")

	person.queue_free()


func _test_tilemap_renderer_and_gameworld() -> void:
	print("\n--- 4. Testing TileMapRenderer & GameWorld ---")
	var tile20_theme16: Dictionary = TileMapRendererScript.resolve_tile_visual(20, 16, false)
	var tile20_other_theme: Dictionary = TileMapRendererScript.resolve_tile_visual(20, 1, false)
	var tile20_foreground: Dictionary = TileMapRendererScript.resolve_tile_visual(20, 1, true)
	var tile10_control: Dictionary = TileMapRendererScript.resolve_tile_visual(10, 1, false)
	assert_true(int(tile20_theme16["tile_id"]) == 20 and not bool(tile20_theme16["mirrored"]), "TileMapRenderer: Theme 16 keeps tile 20 unchanged")
	assert_true(int(tile20_other_theme["tile_id"]) == 18 and bool(tile20_other_theme["mirrored"]), "TileMapRenderer: Other themes mirror tile 20 as tile 18")
	assert_true(int(tile20_foreground["tile_id"]) == 20 and not bool(tile20_foreground["mirrored"]), "TileMapRenderer: Foreground tile 20 is not aliased")
	assert_true(int(tile10_control["tile_id"]) == 9 and bool(tile10_control["mirrored"]), "TileMapRenderer: Existing tile 10 alias remains intact")
	var wooden_plains_main: PackedInt32Array = stats_db.call("get_map_layer_int16", 1, "mapMain")
	var shroom_passage_g2: PackedInt32Array = stats_db.call("get_map_layer_int16", 64, "mapG2")
	var elandra_peak_main: PackedInt32Array = stats_db.call("get_map_layer_int16", 100, "mapMain")
	assert_true(wooden_plains_main.has(67) and TileMapRendererScript.get_source_collision_shapes(67, "mapMain", 1).size() == 1, "TileMapRenderer: Wooden Plains tile 67 uses source-defined partial mask")
	assert_true(shroom_passage_g2.has(20) and int(TileMapRendererScript.resolve_tile_visual(20, 16, false)["tile_id"]) == 20, "TileMapRenderer: Shroom Passage theme 16 keeps platform tile 20")
	assert_true(elandra_peak_main.has(10) and TileMapRendererScript.get_source_collision_shapes(10, "mapMain", 11).size() == 1, "TileMapRenderer: Elandra Peak theme 11 uses shared slope rules")
	var noncolliding_tile: Array[Dictionary] = TileMapRendererScript.get_source_collision_shapes(2, "mapMain", 1)
	assert_true(noncolliding_tile.is_empty(), "TileMapRenderer: Unspecified legacy tile has no invented full-cell collision")
	var fg_collision: Array[Dictionary] = TileMapRendererScript.get_source_collision_shapes(18, "mapFG", 1)
	assert_true(fg_collision.is_empty(), "TileMapRenderer: Foreground layer never creates physical collision")
	var world: Node = GameWorldScript.new()
	world.set("current_stage_id", 1)
	root.add_child(world)

	var renderer: Node = world.get("tile_renderer") as Node
	assert_true(renderer != null, "GameWorld: TileMapRenderer initialized")
	var mw: int = int(renderer.get("map_width"))
	var mh: int = int(renderer.get("map_height"))
	assert_true(mw > 0 and mh > 0, "GameWorld: Map dimensions loaded (%dx%d)" % [mw, mh])
	assert_true(world.get("local_player") != null, "GameWorld: Local player spawned in world")
	var enemies_arr: Array = world.get("enemies") as Array
	assert_true(enemies_arr.size() > 0, "GameWorld: Spawned %d enemies on Stage 1" % enemies_arr.size())
	var cam: Camera2D = world.get("camera") as Camera2D
	assert_true(cam != null, "GameWorld: Camera2D initialized and tracking")

	# Проверка границ камеры
	assert_true(cam.limit_right > 0 and cam.limit_bottom > 0, "GameWorld: Camera limits set (%d, %d)" % [cam.limit_right, cam.limit_bottom])
	var map64: Dictionary = stats_db.call("get_map_data", 64)
	var area64: Dictionary = stats_db.call("get_area_meta", 64)
	renderer.call("render_map", 64, map64, area64)
	assert_true(int(renderer.get("current_theme")) == 3 and int(renderer.get("map_width")) == 37, "TileMapRenderer: Shroom Passage (theme 3 per AreaCreator.as) renders through shared pipeline")
	var map100: Dictionary = stats_db.call("get_map_data", 100)
	var area100: Dictionary = stats_db.call("get_area_meta", 100)
	renderer.call("render_map", 100, map100, area100)
	assert_true(int(renderer.get("current_theme")) == 12 and int(renderer.get("map_width")) == 38, "TileMapRenderer: Elandra Peak (theme 12 per AreaCreator.as) renders through shared pipeline")
	var map41: Dictionary = stats_db.call("get_map_data", 41)
	var area41: Dictionary = stats_db.call("get_area_meta", 41)
	renderer.call("render_map", 41, map41, area41)
	assert_true(int(renderer.get("current_theme")) == 16 and int(renderer.get("map_width")) == 37, "TileMapRenderer: Repguana Sanction (theme 16) renders through shared pipeline")
	var map33: Dictionary = stats_db.call("get_map_data", 33)
	var area33: Dictionary = stats_db.call("get_area_meta", 33)
	renderer.call("render_map", 33, map33, area33)
	assert_true(int(renderer.get("current_theme")) == 11 and int(renderer.get("map_width")) == 38, "TileMapRenderer: Wastelands Entrance (theme 11) renders through shared pipeline")

	world.queue_free()


func _test_enemy_combat_and_loot() -> void:
	print("\n--- 5. Testing EnemyEntity Combat & Loot ---")
	var enemy: Node = EnemyEntityScript.new()
	enemy.set("enemy_type", "green bouncer")
	root.add_child(enemy)

	var max_hp: int = int(enemy.get("max_health"))
	assert_true(max_hp > 0, "EnemyEntity: Initialized stats from DB (Max HP: %d)" % max_hp)
	assert_true(enemy.get("sprite") != null, "EnemyEntity: Attached AnimatedSprite2D")

	var prev_hp: int = int(enemy.get("health"))
	enemy.call("take_damage", 10, null)
	var cur_hp: int = int(enemy.get("health"))
	assert_true(cur_hp < prev_hp, "EnemyEntity: Successfully damaged (HP: %d -> %d)" % [prev_hp, cur_hp])

	var loot: Node = LootItemEntityScript.new()
	loot.set("item_name", "apple")
	root.add_child(loot)
	assert_true(loot.get("sprite") != null, "LootItemEntity: Visualized drop item 'apple'")

	loot.queue_free()
	enemy.queue_free()


func _test_portal_and_gameflow() -> void:
	print("\n--- 6. Testing PortalEntity & GameFlow Integration ---")
	var portal: Node = PortalEntityScript.new()
	portal.set("target_stage", 2)
	root.add_child(portal)
	assert_true(int(portal.get("target_stage")) == 2, "PortalEntity: Configured target stage to 2")
	var portal_triggered: Array[bool] = [false]
	portal.connect("player_entered_portal", func(_t: int, _p: int) -> void: portal_triggered[0] = true)
	var dummy_player: Node = PersonEntityScript.new()
	dummy_player.set("is_local_player", true)
	portal.call("_on_body_entered", dummy_player)
	assert_true(not portal_triggered[0], "PortalEntity: Touching portal without DOWN does not trigger transition")
	dummy_player.queue_free()
	portal.queue_free()

	var gw_script: GDScript = load("res://scripts/world/GameWorld.gd")
	var gw55: Node = gw_script.new()
	gw55.set("current_stage_id", 55)
	root.add_child(gw55)
	var tr55: Node = gw55.get("tile_renderer")
	var vis8_t2: Dictionary = tr55.call("resolve_tile_visual", 8, 2, false)
	var vis8_t1: Dictionary = tr55.call("resolve_tile_visual", 8, 1, false)
	var vis23_fg: Dictionary = tr55.call("resolve_tile_visual", 23, 1, true)
	var vis32_fg: Dictionary = tr55.call("resolve_tile_visual", 32, 1, true)
	var vis16: Dictionary = tr55.call("resolve_tile_visual", 16, 1, false)
	assert_true(int(vis8_t2.get("tile_id", -1)) == 8 and not bool(vis8_t2.get("mirrored", true)), "TileMapRenderer: Tile 8 keeps ID 8 without mirror outside theme 1")
	assert_true(int(vis8_t1.get("tile_id", -1)) == 48 and bool(vis8_t1.get("mirrored", false)), "TileMapRenderer: Theme 1 Tile 8 aliases to 48 mirrored (TileDefsFor)")
	assert_true(int(vis23_fg.get("tile_id", -1)) == 30 and bool(vis23_fg.get("mirrored", false)), "TileMapRenderer: Theme 1 FG Tile 23 aliases to 30 mirrored")
	assert_true(int(vis32_fg.get("tile_id", -1)) == 28 and bool(vis32_fg.get("mirrored", false)), "TileMapRenderer: Theme 1 FG Tile 32 aliases to 28 mirrored")
	assert_true(int(vis16.get("tile_id", -1)) == 14 and bool(vis16.get("mirrored", false)), "TileMapRenderer: Tile 16 mirrors from ID 14")
	var pts_55: PackedVector2Array = TileMapRendererScript.get_source_collision_shapes(55, "mapMain", 1)[0]["points"]
	var pts_67: PackedVector2Array = TileMapRendererScript.get_source_collision_shapes(67, "mapMain", 1)[0]["points"]
	var pts_21: PackedVector2Array = TileMapRendererScript.get_source_collision_shapes(21, "mapMain", 1)[0]["points"]
	var pts_33: PackedVector2Array = TileMapRendererScript.get_source_collision_shapes(33, "mapMain", 1)[0]["points"]
	assert_true(pts_55[1].x == pts_67[1].x and pts_55[1].x == 116.0, "TileMapRenderer: Slope 55->67 vertex seam aligned at x=116")
	assert_true(pts_21[0].x == pts_33[1].x and pts_21[0].x == 49.0, "TileMapRenderer: Slope 33->21 vertex seam aligned at x=49")
	var props_node: Node2D = gw55.get("props_container") as Node2D
	var art_node: Node2D = tr55.get("art_layer_node") as Node2D
	var water_node: Node2D = tr55.get("water_layer_node") as Node2D
	assert_true(props_node.z_index > art_node.z_index, "GameWorld: PropsContainer renders above LayerArt (SortDepths.REGION_2)")
	assert_true(is_equal_approx(water_node.modulate.a, 1.0), "TileMapRenderer: LayerWater has no invented 0.75 alpha modulation")
	var targets55: Array = []
	for p: Variant in gw55.get("portals"):
		targets55.append(int(p.get("target_stage")))
	assert_true(targets55.size() == 7 and not targets55.has(128) and targets55.has(127) and targets55.has(54), "GameWorld: Stage 55 portals match Stats.as without +1 fallback (128)")
	gw55.queue_free()

	var flow: Node = GameFlowScript.new()
	root.add_child(flow)
	flow.call("setup_flow", root)
	var st: int = int(flow.get("current_state"))
	assert_true(st == 0, "GameFlow: Initialized in MAIN_MENU")

	flow.call("start_game", {"stage": 1}, {"gender": "male", "skin": 1})
	var st_after: int = int(flow.get("current_state"))
	assert_true(st_after == 2, "GameFlow: Transitioned to IN_GAME state")
	assert_true(flow.get("active_world_node") != null, "GameFlow: Instantiated GameWorld.tscn into active scene tree")

	flow.queue_free()
