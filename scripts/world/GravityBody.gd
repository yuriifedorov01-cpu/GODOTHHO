extends CharacterBody2D
class_name GravityBody
## GravityBody — Базовая физическая модель на 30 FPS, точный порт com.gravityPackage.GravityObject.as.
## Физические параметры:
##   gravity = 1.1 px/frame^2
##   groundFriction = 0.83
##   airFriction = 0.96
##   maxFallSpeed = 25 px/frame
##   maxGap = 20 px (ступенчатый подъем / спуск)

const MIN_VELX: float = 0.3
const ONE_WAY_PLATFORM_BIT: int = 8

@export var do_apply_gravity: bool = true
@export var base_gravity: float = 1.1
@export var ground_friction: float = 0.83
var original_friction: float = 0.83
@export var air_friction: float = 0.96
@export var max_fall_speed: float = 25.0
@export var max_gap: float = 20.0
@export var accel_down_multiplier: float = 0.0

var on_ground: bool = false
var on_wall: bool = false
var on_wall_counter: int = 0
var in_water: bool = false
var drop_through_counter: int = 500
var tick_counter: int = 0
var jumps: int = 0
var max_jumps: int = 1
var vel_x: float = 0.0
var vel_y: float = 0.0

# Размеры и смещение хитбокса сущности (соответствуют hit_rect в GravityObject.as)
var hit_offset: Vector2 = Vector2(-20.0, -35.0)
var body_width: float = 40.0
var body_height: float = 70.0

# Ссылка на карту / менеджер уровней
var game_world: Node = null

signal landed()
signal entered_water()
signal exited_water()
signal hit_bounce_pad(power: float)

func _init() -> void:
	collision_layer = 1
	collision_mask = 1 | ONE_WAY_PLATFORM_BIT
	floor_max_angle = deg_to_rad(55.0)
	floor_snap_length = 8.0


func _physics_process(delta: float) -> void:
	# Шаг физики в тиках (движок настроен на 30 physics ticks per second)
	physics_tick()


func _check_in_water() -> bool:
	if game_world == null or not game_world.has_method("is_point_in_water"):
		return false
	# GravityObject.as:195: проверка всех 4 углов hit_rect
	var left: float = global_position.x + hit_offset.x
	var top: float = global_position.y + hit_offset.y
	var right: float = left + body_width
	var bottom: float = top + body_height
	return (
		game_world.is_point_in_water(left, top)
		or game_world.is_point_in_water(right, top)
		or game_world.is_point_in_water(left, bottom)
		or game_world.is_point_in_water(right, bottom)
	)


func physics_tick() -> void:
	tick_counter += 1
	var prev_in_water: bool = in_water
	var prev_on_ground: bool = on_ground

	# Проверка воды по 4 углам хитбокса (GravityObject.as:195)
	in_water = _check_in_water()

	if in_water and not prev_in_water:
		entered_water.emit()
	elif not in_water and prev_in_water:
		exited_water.emit()

	# 1. Применение гравитации
	if do_apply_gravity:
		var effective_gravity: float = base_gravity + accel_down_multiplier * base_gravity
		if in_water:
			effective_gravity *= 0.7 # Коэффициент из GravityObject.as
			vel_y += effective_gravity
			if vel_y > max_fall_speed / 4.0:
				vel_y = max_fall_speed / 4.0
		else:
			vel_y += effective_gravity
			if vel_y > max_fall_speed:
				vel_y = max_fall_speed

	# 2. Трение
	var friction: float = ground_friction if on_ground else air_friction
	if in_water:
		friction *= 0.95
	vel_x *= friction

	# Односторонние платформы: отключаем бит слоя 8 на первые 10 тиков спрыгивания (GravityObject.as:232)
	if drop_through_counter <= 10:
		collision_mask &= ~ONE_WAY_PLATFORM_BIT
	else:
		collision_mask |= ONE_WAY_PLATFORM_BIT

	# 3. Применение скорости через CharacterBody2D velocity (px/sec = vel * 30.0)
	velocity = Vector2(vel_x * 30.0, vel_y * 30.0)
	move_and_slide()

	# Обновляем скорости после столкновений Godot и применяем deadzone MIN_VELX (GravityObject.as:205)
	vel_x = velocity.x / 30.0
	if absf(vel_x) < MIN_VELX:
		vel_x = 0.0
	vel_y = velocity.y / 30.0

	# 4. Проверка коллизий с картой через GameWorld (тайлы mainGround, ground2, ground3)
	if game_world != null and game_world.has_method("resolve_gravity_body"):
		game_world.resolve_gravity_body(self)
	else:
		on_ground = is_on_floor()

	on_wall = is_on_wall()
	if on_wall:
		on_wall_counter += 1
	else:
		on_wall_counter = 0

	if on_ground:
		jumps = 0
		accel_down_multiplier = 0.0

	if on_ground and not prev_on_ground:
		landed.emit()

	# Таймер спрыгивания через платформы (drop-through)
	if drop_through_counter < 500:
		drop_through_counter += 1


## Прыжок вверх
func jump(power: float) -> void:
	vel_y = -abs(power)
	on_ground = false


## Отскок от батута (BouncePad)
func apply_bounce(bounce_power: float = 30.0) -> void:
	vel_y = -abs(bounce_power)
	on_ground = false
	hit_bounce_pad.emit(bounce_power)


## Спрыгнуть через одностороннюю платформу вниз (клавиша S / Down)
func drop_down() -> void:
	drop_through_counter = 0
	vel_y = 5.0
	on_ground = false


## GravityObject.as:369-380 — скольжение по склону при ducking / dash attack
func slide(slide_friction: float = 0.98) -> void:
	if ground_friction != slide_friction:
		original_friction = ground_friction
	ground_friction = slide_friction
	if on_ground:
		vel_x += get_ground_slope() * 0.03


## GravityObject.as:382-385 — восстановление трения
func end_slide() -> void:
	ground_friction = original_friction


## TileHandler.as:1030-1046 — угол склона под ногами (±27.0 или 0.0)
func get_ground_slope() -> float:
	if not on_ground:
		return 0.0
	var n: Vector2 = get_floor_normal()
	if absf(n.x) > 0.15:
		return 27.0 if n.x > 0.0 else -27.0
	return 0.0
