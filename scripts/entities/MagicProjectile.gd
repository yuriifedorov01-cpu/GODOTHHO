extends Area2D
class_name MagicProjectile
## MagicProjectile — Магический снаряд посоха/жезла (порт com.game_objects.Projectile.as + MagicEffect.as).
## Загружает текстуру "<weapon_name> proj" (fallback "magic oval" / "basic wand proj") из StarlingAtlasLoader,
## движется с floaty gravity (accel_down = -0.8 - randf() / 3.0) и наносит урон EnemyEntity.

var creator: Node2D = null
var game_world: Node = null
var weapon_name: String = "basic wand"
var damage: int = 1
var is_crit: bool = false
var dir: int = 1
var magic_distance_lvl: int = 0

var vel_x: float = 0.0
var vel_y: float = 0.0
var accel_down_multiplier: float = -0.8
var base_gravity: float = 1.1
var life_span: int = 4
var max_hits: int = 1
var piercing: bool = false
var is_magic_secondary: bool = false

var _tick_counter: int = 0
var _tick_accum: float = 0.0
var _hit_enemies: Array[Node] = []

var sprite: Sprite2D = null
var collision_shape: CollisionShape2D = null


class MagicBurstEffect extends Node2D:
	var _ovals: Array[Dictionary] = []
	var _tick_accum: float = 0.0

	func setup_ovals(atlas: Node, count: int = 3) -> void:
		if atlas == null or not atlas.has_method("get_starling_texture"):
			queue_free()
			return
		var oval_tex: Texture2D = atlas.call("get_starling_texture", "items_pets_bodies", "magic oval") as Texture2D
		if oval_tex == null:
			queue_free()
			return
		for _i in range(count):
			var oval := Sprite2D.new()
			oval.texture = oval_tex
			oval.position = Vector2(randf_range(-16.0, 16.0), randf_range(-16.0, 16.0))
			oval.rotation = randf() * TAU
			oval.modulate.a = 1.0
			add_child(oval)
			_ovals.append({
				"node": oval,
				"fade_speed": 0.018 + randf() / 15.0
			})

	func _physics_process(delta: float) -> void:
		_tick_accum += delta * 30.0
		var ticks_to_run: int = int(floor(_tick_accum))
		if ticks_to_run <= 0:
			return
		_tick_accum -= float(ticks_to_run)
		for _t in range(ticks_to_run):
			for i in range(_ovals.size() - 1, -1, -1):
				var p: Dictionary = _ovals[i]
				var node: Sprite2D = p["node"] as Sprite2D
				if is_instance_valid(node):
					node.rotation += 0.22
					node.modulate.a -= float(p["fade_speed"])
					if node.modulate.a <= 0.0:
						node.queue_free()
						_ovals.remove_at(i)
				else:
					_ovals.remove_at(i)
			if _ovals.is_empty():
				queue_free()
				return


static func _get_atlas_loader() -> Node:
	if Engine.has_singleton("StarlingAtlasLoader"):
		return Engine.get_singleton("StarlingAtlasLoader")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("StarlingAtlasLoader"):
		return tree.root.get_node("StarlingAtlasLoader")
	return null


func setup(p_creator: Node2D, p_world: Node, p_weapon_name: String, p_dir: int, p_damage: int, p_magic_distance_lvl: int = 0, p_is_crit: bool = false) -> void:
	creator = p_creator
	game_world = p_world
	weapon_name = p_weapon_name
	dir = 1 if p_dir >= 0 else -1
	damage = maxi(1, p_damage)
	magic_distance_lvl = maxi(0, p_magic_distance_lvl)
	is_crit = p_is_crit

	# GameMain.as:11697-11702
	vel_x = (9.0 + randf() * 3.0) * float(dir)
	vel_y = 0.0
	accel_down_multiplier = -0.8 - randf() / 3.0
	life_span = 4 + magic_distance_lvl


func _ready() -> void:
	collision_layer = 0
	collision_mask = 4 # EnemyEntity layer

	sprite = Sprite2D.new()
	sprite.name = "ProjectileSprite"
	var atlas: Node = _get_atlas_loader()
	var tex: Texture2D = null
	if atlas != null and atlas.has_method("get_starling_texture"):
		if not weapon_name.is_empty():
			tex = atlas.call("get_starling_texture", "items_pets_bodies", weapon_name + " proj") as Texture2D
		if tex == null:
			tex = atlas.call("get_starling_texture", "items_pets_bodies", "magic oval") as Texture2D
		if tex == null:
			tex = atlas.call("get_starling_texture", "items_pets_bodies", "basic wand proj") as Texture2D
	sprite.texture = tex
	add_child(sprite)

	# Projectile.as:48: Rectangle(-30, -15, 55, 25) -> largerHit_rect.height += 20
	collision_shape = CollisionShape2D.new()
	var rect: RectangleShape2D = RectangleShape2D.new()
	rect.size = Vector2(55.0, 45.0)
	collision_shape.shape = rect
	add_child(collision_shape)


func _physics_process(delta: float) -> void:
	# Эмулируем тики 30 FPS (GameMain / GravityObject)
	_tick_accum += delta * 30.0
	var ticks_to_run: int = int(floor(_tick_accum))
	if ticks_to_run <= 0:
		ticks_to_run = 1
		_tick_accum = 0.0
	else:
		_tick_accum -= float(ticks_to_run)

	for _t in range(ticks_to_run):
		_step_tick()
		if is_queued_for_deletion():
			return


func _step_tick() -> void:
	_tick_counter += 1

	# GravityObject: effective_gravity = g + accel_down_multiplier * g
	var effective_gravity: float = base_gravity + accel_down_multiplier * base_gravity
	vel_y += effective_gravity
	position += Vector2(vel_x, vel_y)

	# Projectile.as:82: ориентация по вектору скорости
	if sprite != null:
		sprite.rotation = atan2(vel_y + base_gravity, vel_x)

	# Проверка попадания по врагам (Projectile.as:85-112)
	if _check_enemy_hits():
		return

	# AS3 Projectile.as:115: время жизни ровно life_span (4 + magicDistanceLvl тиков)
	if _tick_counter > life_span:
		queue_free()


func _check_enemy_hits() -> bool:
	var hit_rect: Rect2 = Rect2(global_position + Vector2(-27.5, -22.5), Vector2(55.0, 45.0))

	# 1. Проверка через список врагов в GameWorld (быстро и работает без ожидания physics broadphase)
	if game_world != null and "enemies" in game_world:
		var enemies_list: Variant = game_world.get("enemies")
		if enemies_list is Array:
			for enemy_var: Variant in enemies_list:
				var enemy: Node2D = enemy_var as Node2D
				if enemy == null or not is_instance_valid(enemy):
					continue
				if enemy in _hit_enemies:
					continue
				var hp_val: Variant = enemy.get("health")
				if hp_val != null and int(hp_val) <= 0:
					continue
				var enemy_rect: Rect2 = Rect2(enemy.global_position + Vector2(-22.0, -32.0), Vector2(44.0, 64.0))
				if enemy.has_method("get_world_hitbox"):
					enemy_rect = enemy.call("get_world_hitbox") as Rect2
				if hit_rect.intersects(enemy_rect):
					if _apply_hit(enemy):
						return true

	# 2. Проверка пересечений Area2D (для врагов вне списка game_world.enemies)
	for body: Node2D in get_overlapping_bodies():
		if body in _hit_enemies or body == creator:
			continue
		if body.has_method("take_damage") and body.get("health") != null and int(body.get("health")) > 0:
			if _apply_hit(body):
				return true

	return false


func _spawn_hit_burst(target_pos: Vector2) -> void:
	var burst_parent: Node = get_parent()
	if burst_parent == null:
		return
	var atlas: Node = _get_atlas_loader()
	if atlas == null:
		return
	var burst := MagicBurstEffect.new()
	burst.name = "MagicBurstEffect"
	burst.global_position = target_pos
	burst_parent.add_child(burst)
	burst.setup_ovals(atlas, 3)


func _apply_hit(enemy: Node2D) -> bool:
	_hit_enemies.append(enemy)
	_spawn_hit_burst(enemy.global_position)
	if enemy.has_method("take_damage"):
		enemy.call("take_damage", damage, creator, is_crit)
	if not piercing or _hit_enemies.size() >= max_hits:
		queue_free()
		return true
	return false
