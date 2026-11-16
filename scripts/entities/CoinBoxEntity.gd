extends Area2D
class_name CoinBoxEntity
## CoinBoxEntity — Интерактивный блок с монетами (порт CoinBox.as:14-96 и GameCode.Items.cs:588-645).
## Максимум 3 удара, по 3 разлетающиеся монеты за удар (стоимость зависит от stage_id), респавн 900с.

const HIT_RECT := Rect2(60.0, 57.0, 65.0, 51.0)
const COOLDOWN_TICKS := 21
const MAX_HITS := 3
const RESPAWN_SECONDS := 900.0

@export var stage_id: int = 1
var game_world: Node = null
var original_pos: Vector2 = Vector2.ZERO
var _hits: int = 0
var _cooldown_ticks: int = 0
var _tick_accum: float = 0.0
var _respawn_timer: float = 0.0
var _bounce_tween: Tween = null
var _solid_body: StaticBody2D = null
var _solid_shape: CollisionShape2D = null
var _area_shape: CollisionShape2D = null

signal coin_box_emptied(box: CoinBoxEntity)


static func coin_value_for_stage(a: int) -> int:
	match a:
		1:
			return 2
		2, 3:
			return 3
		4, 5:
			return 4
		6, 7:
			return 5
		8:
			return 6
		_:
			return 2


func _ready() -> void:
	original_pos = position
	collision_layer = 0
	collision_mask = 2

	# Зона обнаружения удара головой снизу (JUMP_TYPE) — выступает на 10px вниз, чтобы сработать до/при касании потолка
	_area_shape = CollisionShape2D.new()
	var area_rect := RectangleShape2D.new()
	area_rect.size = Vector2(HIT_RECT.size.x, HIT_RECT.size.y + 12.0)
	_area_shape.shape = area_rect
	_area_shape.position = HIT_RECT.position + HIT_RECT.size * 0.5 + Vector2(0.0, 6.0)
	add_child(_area_shape)

	# Твёрдая коллизия самого блока (65x51)
	_solid_body = StaticBody2D.new()
	_solid_body.collision_layer = 1
	_solid_body.collision_mask = 0
	_solid_shape = CollisionShape2D.new()
	var solid_rect := RectangleShape2D.new()
	solid_rect.size = HIT_RECT.size
	_solid_shape.shape = solid_rect
	_solid_shape.position = HIT_RECT.position + HIT_RECT.size * 0.5
	_solid_body.add_child(_solid_shape)
	add_child(_solid_body)


func _physics_process(delta: float) -> void:
	if _respawn_timer > 0.0:
		_respawn_timer -= delta
		if _respawn_timer <= 0.0:
			_respawn()
		return

	_tick_accum += delta
	while _tick_accum >= 1.0 / 30.0:
		_tick_accum -= 1.0 / 30.0
		if _cooldown_ticks > 0:
			_cooldown_ticks -= 1

	if _cooldown_ticks > 0 or _hits >= MAX_HITS:
		return

	for body in get_overlapping_bodies():
		if body is PersonEntity:
			var p: PersonEntity = body as PersonEntity
			var box_mid_y: float = global_position.y + HIT_RECT.position.y + HIT_RECT.size.y * 0.5
			if not p.on_ground and p.vel_y <= 0.0 and p.global_position.y > box_mid_y:
				_on_jump_hit(p)
				break


func _on_jump_hit(player: PersonEntity) -> void:
	if _hits >= MAX_HITS:
		return
	_hits += 1
	_cooldown_ticks = COOLDOWN_TICKS
	var coin_val: int = coin_value_for_stage(stage_id)

	if game_world != null and game_world.has_method("spawn_coin_box_coins"):
		game_world.call("spawn_coin_box_coins", original_pos + Vector2(82.0, 10.0), coin_val, 3)
	elif player != null and player.has_method("add_coins"):
		player.add_coins(coin_val * 3)

	if has_node("/root/AudioManager"):
		var am: Node = get_node("/root/AudioManager")
		if am.has_method("play_sfx"):
			am.call("play_sfx", "SFX/coin box hit")

	if _bounce_tween != null and _bounce_tween.is_valid():
		_bounce_tween.kill()
	position = original_pos
	_bounce_tween = create_tween()
	_bounce_tween.tween_property(self, "position:y", original_pos.y - 30.0, 0.08)
	_bounce_tween.tween_property(self, "position:y", original_pos.y, 0.08)

	if _hits >= MAX_HITS:
		_empty_box()


func _empty_box() -> void:
	visible = false
	monitoring = false
	if _area_shape != null:
		_area_shape.set_deferred("disabled", true)
	if _solid_shape != null:
		_solid_shape.set_deferred("disabled", true)
	_respawn_timer = RESPAWN_SECONDS
	coin_box_emptied.emit(self)


func _respawn() -> void:
	_hits = 0
	_cooldown_ticks = 0
	_respawn_timer = 0.0
	position = original_pos
	visible = true
	monitoring = true
	if _area_shape != null:
		_area_shape.set_deferred("disabled", false)
	if _solid_shape != null:
		_solid_shape.set_deferred("disabled", false)
