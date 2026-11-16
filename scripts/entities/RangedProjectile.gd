extends Area2D
class_name RangedProjectile
## RangedProjectile — Снаряд лучника (стрела/камень рогатки) или ковбоя (пуля).
## Порт Projectile.as + Person.as:603-667 + PersonFrameHandler.as:433-512.

var creator: Node2D = null
var game_world: Node = null
var weapon_name: String = ""
var dir: int = 1
var damage: int = 1
var is_crit: bool = false
var knockback_mult: float = 1.0

var vel_x: float = 0.0
var vel_y: float = 0.0
var accel_down_multiplier: float = 0.0
var apply_gravity_flag: bool = true
var life_span: int = 30
var piercing: bool = false
var max_hits: int = 1
var custom_modulate: Color = Color.WHITE
var custom_scale: Vector2 = Vector2.ONE
var _hit_enemies: Array[Node] = []

var _tick_counter: int = 0
var _tick_accum: float = 0.0
var sprite: Sprite2D = null


static func _get_atlas_loader() -> Node:
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("StarlingAtlasLoader"):
		return tree.root.get_node("StarlingAtlasLoader")
	return null


func setup(
	p_creator: Node2D,
	p_world: Node,
	p_weapon_name: String,
	p_dir: int,
	p_damage: int,
	p_vel_x: float,
	p_accel_down_mult: float,
	p_life_span: int,
	p_is_crit: bool = false,
	p_knockback_mult: float = 1.0,
	p_apply_gravity: bool = true
) -> void:
	creator = p_creator
	game_world = p_world
	weapon_name = p_weapon_name
	dir = 1 if p_dir >= 0 else -1
	damage = maxi(1, p_damage)
	vel_x = p_vel_x
	accel_down_multiplier = p_accel_down_mult
	life_span = maxi(1, p_life_span)
	is_crit = p_is_crit
	knockback_mult = p_knockback_mult
	apply_gravity_flag = p_apply_gravity


func _ready() -> void:
	collision_layer = 0
	collision_mask = 4 | 1

	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(maxf(24.0, absf(vel_x)), 14.0)
	shape.shape = rect
	add_child(shape)

	sprite = Sprite2D.new()
	var loader: Node = _get_atlas_loader()
	var tex: Texture2D = null
	if weapon_name == "air slash wave":
		var img := Image.create(24, 34, false, Image.FORMAT_RGBA8)
		for y: int in range(34):
			var ny: float = (float(y) - 16.5) / 16.5
			var arc_x: float = 16.0 - ny * ny * 10.0
			for x: int in range(24):
				var dist: float = absf(float(x) - arc_x)
				if dist < 4.5 * (1.0 - ny * ny * 0.45):
					var alpha: float = clampf(1.0 - dist / 4.5, 0.2, 1.0)
					img.set_pixel(x, y, Color(0.75, 0.92, 1.0, alpha))
		tex = ImageTexture.create_from_image(img)
	elif loader != null and loader.has_method("get_texture") and not weapon_name.is_empty():
		tex = loader.get_texture(weapon_name + " proj", "items_pets_bodies")
		if tex == null:
			tex = loader.get_texture("arrow", "items_pets_bodies")
	if tex != null:
		sprite.texture = tex
	else:
		var img := Image.create(12, 4, false, Image.FORMAT_RGBA8)
		img.fill(Color(1.0, 0.85, 0.2, 1.0))
		sprite.texture = ImageTexture.create_from_image(img)
	sprite.flip_h = (dir < 0)
	sprite.modulate = custom_modulate
	sprite.scale = custom_scale
	add_child(sprite)

	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	_tick_accum += delta
	while _tick_accum >= 1.0 / 30.0:
		_tick_accum -= 1.0 / 30.0
		_step_30hz()


func _step_30hz() -> void:
	_tick_counter += 1
	if _tick_counter > life_span:
		queue_free()
		return

	if apply_gravity_flag:
		vel_y += 1.1 + accel_down_multiplier * 1.1
		vel_x *= 0.96

	position += Vector2(vel_x, vel_y)

	if sprite != null and (absf(vel_x) > 0.01 or absf(vel_y) > 0.01):
		sprite.rotation = atan2(vel_y, vel_x)
		sprite.flip_h = false


func _on_body_entered(body: Node2D) -> void:
	if body == creator or _hit_enemies.has(body):
		return
	if body.has_method("take_damage") and body.get("health") != null and int(body.get("health")) > 0:
		_hit_enemies.append(body)
		body.call("take_damage", damage, creator, is_crit, false, knockback_mult)
		if not piercing or _hit_enemies.size() >= maxi(1, max_hits):
			queue_free()
	elif body is TileMapLayer or body is StaticBody2D:
		queue_free()
