extends GravityBody
class_name PersonEntity
## PersonEntity — Сущность персонажа игрока или сетевого клона/NPC (порт com.game_objects.Person.as).
## Включает управление с клавиатуры, скелетную анимацию BodyAnimatorNode,
## здоровье, ману, экипировку, комбо-атаки и взаимодействие с миром.

const MagicProjectileScript = preload("res://scripts/entities/MagicProjectile.gd")
const RangedProjectileScript = preload("res://scripts/entities/RangedProjectile.gd")

const DUAL_GUNS_ARRAY: Array[String] = [
	"airsoft gun", "paintball gun", "handgun", "revolver",
	"mac10", "mp5", "tommy gun", "es c90", "beholder gun", "corruptor"
]
const MAIN_MAGIC_SWING_FRAMES: Array[int] = [79, 102, 156, 170, 205, 404, 414, 426, 443]
const OFF_MAGIC_SWING_FRAMES: Array[int] = [117, 106, 160, 169, 183, 194, 430, 447, 458, 469]

@export var is_local_player: bool = true
@export var character_name: String = "Player"

# Характеристики персонажа (AS3 Person.as:123-146)
var health: int = 100
var max_health: int = 100
var mana: int = 0
var max_mana: int = 0
var energy: int = 0
var max_energy: int = 100
var power_stat: int = 0
var dex_stat: int = 0
var def_stat: int = 0
var range_stat: int = 0
var magic_stat: int = 0
var artillery_stat: int = 0
var character_class: String = ""

var level: int = 1
var exp_points: int = 0
var max_exp_points: int = 51
var chopping_level: int = 1
var chopping_xp: int = 0
var fishing_level: int = 1
var fishing_xp: int = 0
var coins: int = 0
var ability_points: int = 3
var skill_points: int = 0

# Инвентарь и экипировка (GameMain.as:3775-3779: инвентарь приходит с сервера и пуст при "";
# визуал дефолтной одежды задаётся в BodyAnimatorNode по BodyAnimator.as:219-231)
var inventory: Array[String] = []
var equipment: Dictionary = {
	"helmet": "",
	"shirt": "",
	"legs": "",
	"shoes": "",
	"weapon": "",
	"weapon2": "",
	"accessory": ""
}

# Скорость движения по формуле: moveSpeed = 7 + dex / 176
var move_speed_stat: float = 7.0
var jump_power_stat: float = 20.0
var dash_lvl: int = 1
var accel_down_lvl: int = 1
var shield_mastery_lvl: int = 0
var skill_levels: Dictionary = {}

# Внутренние таймеры и состояния навыков
var _mp_regen_timer: float = 0.0
var _rage_timer: float = 0.0
var _rage_bonus_mult: float = 0.0
var _dash_tap_dir: int = 0
var _dash_tap_timer: float = 0.0
var _air_slash_charging: bool = false
var _air_slash_charge_ticks: int = 0
var _recent_up_timer: float = 0.0
var _recent_down_timer: float = 0.0
var _recent_left_timer: float = 0.0
var _recent_right_timer: float = 0.0
var _prev_keys: Dictionary = {}

# Направление взгляда: 1 = вправо, -1 = влево
var facing_dir: int = 1

# Ссылки на дочерние узлы
var animator: BodyAnimatorNode = null
var collision_shape: CollisionShape2D = null
var shadow_sprite: Sprite2D = null
static var _cached_shadow_tex: Texture2D = null

static func _get_shadow_texture() -> Texture2D:
	if _cached_shadow_tex != null:
		return _cached_shadow_tex
	var img: Image = Image.create(44, 14, false, Image.FORMAT_RGBA8)
	var cx: float = 22.0
	var cy: float = 7.0
	var rx: float = 21.0
	var ry: float = 6.0
	for y in range(14):
		for x in range(44):
			var dx: float = (float(x) + 0.5 - cx) / rx
			var dy: float = (float(y) + 0.5 - cy) / ry
			var d: float = dx * dx + dy * dy
			if d < 1.0:
				var alpha: float = clampf((1.0 - sqrt(d)) * 2.0, 0.0, 1.0) * 0.45
				img.set_pixel(x, y, Color(0.0, 0.0, 0.0, alpha))
	_cached_shadow_tex = ImageTexture.create_from_image(img)
	return _cached_shadow_tex

# Состояние боя и действий
var is_dead: bool = false
var spawn_position: Vector2 = Vector2.ZERO
var is_attacking: bool = false
var is_blocking: bool = false
var is_ducking: bool = false
var is_dashing: bool = false
var jumped_while_dashing: bool = false
var flaps: int = 0
var current_attack_move: String = ""
var attack_cooldown_counter: int = 0

signal health_changed(new_hp: int, max_hp: int)
signal mp_changed(new_mp: int, max_mp: int)
signal exp_changed(new_exp: int, max_exp: int, current_lvl: int)
signal energy_changed(new_energy: int, max_energy: int)
signal coins_changed(new_coins: int)
signal stats_updated()
signal inventory_updated()
signal died()
signal attack_triggered(move_name: String, dir: int)

static func _get_stats_db() -> Node:
	if Engine.has_singleton("StatsDB"):
		return Engine.get_singleton("StatsDB")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("StatsDB"):
		return tree.root.get_node("StatsDB")
	return load("res://scripts/autoload/StatsDB.gd").new()

func _ready() -> void:
	_setup_collision()
	_setup_drop_shadow()
	_setup_animator()
	_calc_stats()


func _setup_drop_shadow() -> void:
	shadow_sprite = Sprite2D.new()
	shadow_sprite.name = "DropShadow"
	shadow_sprite.texture = _get_shadow_texture()
	shadow_sprite.z_index = -1
	shadow_sprite.position = Vector2(0, 48)
	add_child(shadow_sprite)


func _setup_collision() -> void:
	# Person.as:302: hit_rect = Rectangle(-23, -36, 54, 84) -> центр (4, 6), ноги на y=+48
	hit_offset = Vector2(-23.0, -36.0)
	body_width = 54.0
	body_height = 84.0
	collision_layer = 2
	collision_mask = 1 | ONE_WAY_PLATFORM_BIT

	collision_shape = CollisionShape2D.new()
	var rect: RectangleShape2D = RectangleShape2D.new()
	rect.size = Vector2(54.0, 84.0)
	collision_shape.shape = rect
	collision_shape.position = Vector2(4.0, 6.0)
	add_child(collision_shape)


func _setup_animator() -> void:
	animator = BodyAnimatorNode.new()
	animator.name = "BodyAnimator"
	# Person.as:302 / BodyAnimator.as:632: ноги на +41.30, коллизия до +48.0 -> сдвиг +7.0 ставит подошвы ровно на пол
	animator.position = Vector2(0, 7.0)
	add_child(animator)

	animator.animation_finished.connect(func(_anim_name: String) -> void:
		if is_attacking:
			is_attacking = false
			current_attack_move = ""
			_cowboy_fired_on_frame = false
			_bow_fired_on_frame = false
			_bow_charging = false
			_magic_main_fired = false
			_magic_off_fired = false
			_update_locomotion_animation()
	)


func _calc_stats() -> void:
	move_speed_stat = 7.0 + float(dex_stat) / 176.0
	var jump_lvl: int = get_skill_level("jump height")
	jump_power_stat = 20.0 + float(jump_lvl) * 0.3


func apply_class_starter_stats(char_class: String) -> void:
	character_class = char_class.to_lower().strip_edges()
	match character_class:
		"warrior":
			max_mana = 0
			mana = 0
			power_stat = 4
			def_stat = 3
			range_stat = 0
			magic_stat = 0
			dex_stat = 0
			artillery_stat = 0
			mp_changed.emit(mana, max_mana)
		"archer":
			max_mana = 0
			mana = 0
			power_stat = 0
			range_stat = 5
			def_stat = 1
			dex_stat = 1
			magic_stat = 0
			artillery_stat = 0
			mp_changed.emit(mana, max_mana)
		"mage", "wizard":
			max_mana = 20
			mana = 20
			power_stat = 0
			range_stat = 0
			magic_stat = 3
			def_stat = 1
			dex_stat = 0
			artillery_stat = 0
			mp_changed.emit(mana, max_mana)
		"cowboy":
			max_mana = 0
			mana = 0
			power_stat = 0
			range_stat = 0
			magic_stat = 0
			def_stat = 1
			dex_stat = 0
			artillery_stat = 6
			mp_changed.emit(mana, max_mana)
	_calc_stats()
	stats_updated.emit()


func get_skill_level(skill_id: String) -> int:
	if skill_levels.has(skill_id):
		return maxi(0, int(skill_levels[skill_id]))
	match skill_id:
		"speed dash", "dash":
			return maxi(0, dash_lvl)
		"accel down", "accelDown", "fastFall":
			return maxi(0, accel_down_lvl)
		"shield mastery", "shieldMastery":
			return maxi(0, shield_mastery_lvl)
	return 0


func _physics_process(delta: float) -> void:
	if spawn_position == Vector2.ZERO and global_position != Vector2.ZERO:
		spawn_position = global_position

	if is_dead:
		vel_x = 0.0
		vel_y = 0.0
		if shadow_sprite != null:
			shadow_sprite.visible = false
		return

	# Таймеры баффов, дэша и регена маны (mp restore)
	if _rage_timer > 0.0:
		_rage_timer = maxf(0.0, _rage_timer - delta)
		if _rage_timer <= 0.0:
			_rage_bonus_mult = 0.0
	if _dash_tap_timer > 0.0:
		_dash_tap_timer = maxf(0.0, _dash_tap_timer - delta)
		if _dash_tap_timer <= 0.0:
			_dash_tap_dir = 0
	if _recent_up_timer > 0.0:
		_recent_up_timer = maxf(0.0, _recent_up_timer - delta)
	if _recent_down_timer > 0.0:
		_recent_down_timer = maxf(0.0, _recent_down_timer - delta)
	if _recent_left_timer > 0.0:
		_recent_left_timer = maxf(0.0, _recent_left_timer - delta)
	if _recent_right_timer > 0.0:
		_recent_right_timer = maxf(0.0, _recent_right_timer - delta)
	var mp_restore_lvl: int = get_skill_level("mp restore")
	if mp_restore_lvl > 1 and mana < max_mana:
		_mp_regen_timer += delta
		if _mp_regen_timer >= 30.0:
			_mp_regen_timer -= 30.0
			restore_mp(mp_restore_lvl * 3)
	else:
		_mp_regen_timer = 0.0

	if _cowboy_cooldown_ticks > 0:
		_cowboy_cooldown_ticks -= 1

	# Скелетный аниматор тикает синхронно с физикой 30 FPS
	if animator != null and animator.is_playing:
		animator.advance_frame()

	_process_ranged_attack_frames()

	if is_local_player:
		_handle_player_input()

	super._physics_process(delta)

	if on_ground:
		flaps = 0
		jumped_while_dashing = false

	if shadow_sprite != null:
		shadow_sprite.visible = on_ground

	if is_local_player and not is_attacking:
		_update_locomotion_animation()

	_update_dash_dust()
	_update_fall_vfx()
	_previous_dust_pos = global_position


var _dash_dust_tick: int = 0
var _fall_vfx_tick: int = 0
var _fall_pixel_texture: ImageTexture = null
var _previous_dust_pos: Vector2 = Vector2.ZERO


func _update_fall_vfx() -> void:
	# AS3 PersonFrameHandler.as:84-114 (handleDownAccel): белые вертикальные полосы при ускоренном падении
	if accel_down_multiplier <= 0.0 or on_ground:
		_fall_vfx_tick = 0
		return
	_fall_vfx_tick += 1
	if _fall_vfx_tick % 7 != 0:
		return
	var parent_node: Node = _get_projectile_parent()
	if parent_node == null:
		return
	if _fall_pixel_texture == null:
		var img := Image.create(1, 1, false, Image.FORMAT_RGBA8)
		img.set_pixel(0, 0, Color(1.0, 1.0, 1.0, 1.0))
		_fall_pixel_texture = ImageTexture.create_from_image(img)
	var count: int = 3 if accel_down_multiplier > 1.1 else 2
	for _i: int in range(count):
		var streak := Sprite2D.new()
		streak.texture = _fall_pixel_texture
		streak.centered = false
		streak.z_index = -1
		streak.scale = Vector2(1.0, 30.0 + randf() * 70.0)
		streak.modulate = Color(1.0, 1.0, 1.0, 0.9)
		streak.global_position = global_position + Vector2(-25.0 + randf() * 50.0, -randf() * 40.0)
		parent_node.add_child(streak)
		var tw: Tween = streak.create_tween()
		tw.tween_interval(0.3)
		tw.tween_property(streak, "modulate:a", 0.0, 0.7)
		tw.tween_callback(streak.queue_free)


func _play_sfx(sfx_name: String, vol: float = 1.0) -> void:
	if sfx_name.is_empty():
		return
	var am: Node = get_node_or_null("/root/AudioManager")
	if am != null and am.has_method("play_sfx"):
		am.play_sfx(sfx_name, vol)


func _get_weapon_sound_name(w_name: String) -> String:
	if w_name.is_empty() or w_name == "none":
		return ""
	var sdb: Node = _get_stats_db()
	if sdb != null and sdb.has_method("get_item_data"):
		var data: Dictionary = sdb.get_item_data(w_name)
		var snd: String = str(data.get("sound", "")).strip_edges()
		if not snd.is_empty():
			return snd
	return w_name


func _play_skill_sfx(skill_id: String) -> void:
	match skill_id:
		"power attack":
			_play_sfx("slash")
		"multi attack":
			_play_sfx("sciFiExplosion")
		"air slash", "down crush":
			_play_sfx("slash 3")
		"spin attack":
			_play_sfx("slash 2")
		"arrow barrage", "triple shot", "arrow rain", "piercing arrow":
			_play_sfx("bow fire")
		"circular attack":
			_play_sfx("lightBeam")
		"thunder attack":
			_play_sfx("thunder")
		"shotgun attack", "upward shoot":
			_play_sfx(_get_weapon_sound_name(str(equipment.get("weapon", ""))))
		"grenade attack", "jump grenade":
			_play_sfx("sciFiExplosion", 0.65)


func _update_dash_dust() -> void:
	_dash_dust_tick += 1
	if animator == null:
		return
	var anim_name: String = animator.current_anim_name
	# Пыль бега/дэша спавнится только на земле (не в воздухе и не на стене), как в Person.as:724-742
	if anim_name in ["dashing", "pet dashing"] and on_ground and not on_wall:
		if _dash_dust_tick % 10 == 0 and absf(global_position.x - _previous_dust_pos.x) > 4.0:
			var slope_deg: float = rad_to_deg(get_floor_normal().angle() + PI * 0.5)
			var spawn_base: Vector2 = _previous_dust_pos if _previous_dust_pos != Vector2.ZERO else global_position
			spawn_dash_cloud(Vector2(spawn_base.x, spawn_base.y + 45.0), -float(facing_dir), slope_deg, 0, "dash_run_dust")
	elif anim_name in ["wall slide", "pet wall slide"] and on_wall:
		if _dash_dust_tick % 10 == 0:
			# Person.as:505-512: при wall slide всегда используется 'dash cloud 1'
			if facing_dir == -1:
				spawn_dash_cloud(Vector2(global_position.x - 25.0, global_position.y), -1.0, 90.0, 1, "wall_slide_dust")
			else:
				spawn_dash_cloud(Vector2(global_position.x + 32.0, global_position.y), 1.0, -90.0, 1, "wall_slide_dust")


func _clear_run_dash_dust() -> void:
	var target_parent: Node = get_parent()
	if target_parent == null:
		return
	for child: Node in target_parent.get_children():
		if is_instance_valid(child) and child.is_in_group("dash_run_dust"):
			child.queue_free()


func spawn_dash_cloud(world_pos: Vector2, p_scale_x: float = 1.0, rot_deg: float = 0.0, force_cloud_idx: int = 0, dust_group: String = "dash_run_dust") -> Sprite2D:
	var atlas: Node = get_node_or_null("/root/StarlingAtlasLoader")
	if atlas == null or not atlas.has_method("get_starling_texture"):
		return null
	var dash_idx: int = 1
	if force_cloud_idx > 0:
		dash_idx = clampi(force_cloud_idx, 1, 4)
	elif dash_lvl >= 12:
		dash_idx = 4
	elif dash_lvl >= 8:
		dash_idx = 3
	elif dash_lvl >= 4:
		dash_idx = 2
	var tex: Texture2D = atlas.call("get_starling_texture", "items_pets_bodies", "dash cloud %d" % dash_idx) as Texture2D
	if tex == null:
		tex = atlas.call("get_starling_texture", "items_pets_bodies", "dash cloud 1") as Texture2D
	if tex == null:
		return null
	var cloud := Sprite2D.new()
	cloud.name = "DashCloud_%d" % _dash_dust_tick
	if not dust_group.is_empty():
		cloud.add_to_group(dust_group)
	cloud.texture = tex
	var sz: Vector2 = tex.get_size()
	cloud.centered = false
	cloud.offset = Vector2(-sz.x * 0.5, -sz.y)
	cloud.position = world_pos
	cloud.scale = Vector2(p_scale_x, 1.0)
	cloud.rotation = deg_to_rad(rot_deg)
	cloud.z_index = 1
	var target_parent: Node = get_parent()
	if target_parent == null:
		target_parent = self
	target_parent.add_child(cloud)
	var tw: Tween = cloud.create_tween()
	tw.tween_property(cloud, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_LINEAR)
	tw.tween_callback(cloud.queue_free)
	return cloud


func _is_text_input_focused() -> bool:
	if not is_inside_tree():
		return false
	var vp: Viewport = get_viewport()
	if vp == null:
		return false
	var focus_owner: Control = vp.gui_get_focus_owner()
	return focus_owner is LineEdit or focus_owner is TextEdit or focus_owner is CodeEdit


func _handle_player_input() -> void:
	if _is_text_input_focused():
		is_ducking = false
		is_blocking = false
		is_dashing = false
		return
	var left_pressed: bool = Input.is_action_pressed("move_left")
	var right_pressed: bool = Input.is_action_pressed("move_right")
	var up_pressed: bool = Input.is_action_just_pressed("move_up")
	var up_released: bool = Input.is_action_just_released("move_up")
	var down_pressed: bool = Input.is_action_pressed("move_down")
	var down_just_pressed: bool = Input.is_action_just_pressed("move_down")

	# Приседание (Person.as:404, 521-526), быстрое падение и спрыгивание с платформы
	if down_pressed and not is_attacking and not is_blocking:
		if on_ground:
			is_ducking = true
			if down_just_pressed:
				drop_down()
		else:
			is_ducking = false
			var is_chicken_set: bool = (
				animator != null
				and animator.helmet_name == "chicken hat"
				and animator.shirt_name == "chicken outfit"
				and animator.pants_name == "chicken pants"
			)
			if is_chicken_set and down_just_pressed and flaps < 5 and animator.current_anim_name in ["jumping", "flap", "falling"]:
				vel_y = -13.0
				animator.play("flap")
				flaps += 1
				_play_sfx("wing flap")
			elif not is_chicken_set:
				# PersonKeyHandler.as:347-354: fast-fall accelDownMultiplier (строго при accel_down_lvl > 0)
				if accel_down_lvl > 0:
					if vel_y < 0.0:
						accel_down_multiplier = 0.4 + float(accel_down_lvl) / 10.0
					else:
						accel_down_multiplier = 1.0 + float(accel_down_lvl) / 10.0
				else:
					accel_down_multiplier = 0.0
	else:
		is_ducking = false
		accel_down_multiplier = 0.0

	# Таймеры недавних нажатий направлений для комбо (AS3 twoKeysChecker: Fwd+Space, Down+Space, Up+Space)
	if up_pressed:
		_recent_up_timer = 0.20
	if down_just_pressed:
		_recent_down_timer = 0.20

	# Double-tap dash (строго при dash_lvl > 0, стоит level_mp(3))
	if Input.is_action_just_pressed("move_right"):
		_recent_right_timer = 0.20
		if _dash_tap_dir == 1 and _dash_tap_timer > 0.0 and dash_lvl > 0 and not is_ducking and not is_blocking:
			if spend_mp(level_mp(3)):
				is_dashing = true
			_dash_tap_dir = 0
			_dash_tap_timer = 0.0
		else:
			_dash_tap_dir = 1
			_dash_tap_timer = 0.28
	elif Input.is_action_just_pressed("move_left"):
		_recent_left_timer = 0.20
		if _dash_tap_dir == -1 and _dash_tap_timer > 0.0 and dash_lvl > 0 and not is_ducking and not is_blocking:
			if spend_mp(level_mp(3)):
				is_dashing = true
			_dash_tap_dir = 0
			_dash_tap_timer = 0.0
		else:
			_dash_tap_dir = -1
			_dash_tap_timer = 0.28

	if (not left_pressed and not right_pressed) or is_ducking or is_blocking or is_attacking or dash_lvl <= 0:
		is_dashing = false

	# Горизонтальное ускорение (Person.as:404-439)
	var can_move_hor: bool = (
		not is_ducking
		and not is_blocking
		and (animator == null or animator.current_anim_name != "take hit")
		and (not is_attacking or not on_ground)
	)
	if can_move_hor:
		var bonus_speed: float = 0.0
		if dash_lvl > 0 and (is_dashing or jumped_while_dashing or (animator != null and animator.current_anim_name == "dashing")):
			bonus_speed += move_speed_stat * (0.4 + float(dash_lvl) / 10.0)
		if right_pressed and not left_pressed:
			facing_dir = 1
			if animator != null:
				animator.scale.x = 1.0
			if on_ground:
				vel_x += (move_speed_stat + bonus_speed) / 6.5
			elif vel_x < 15.0:
				vel_x += (move_speed_stat + bonus_speed) / 13.0
		elif left_pressed and not right_pressed:
			facing_dir = -1
			if animator != null:
				animator.scale.x = -1.0
			if on_ground:
				vel_x -= (move_speed_stat + bonus_speed) / 6.5
			elif vel_x > -15.0:
				vel_x -= (move_speed_stat + bonus_speed) / 13.0

	# Прыжок и отскок от стены (PersonKeyHandler.as:317-331)
	if up_pressed and jumps < max_jumps and not is_attacking:
		jumped_while_dashing = (animator != null and animator.current_anim_name == "dashing") or jumped_while_dashing
		if animator == null or animator.current_anim_name != "wall slide" or on_ground:
			vel_y = -jump_power_stat if jumps == 0 else -jump_power_stat * 0.8
		else:
			# Wall jump (PersonKeyHandler.as:326-327)
			vel_y = -jump_power_stat * 0.9
			vel_x = -jump_power_stat * 0.8 * float(facing_dir)
		on_ground = false
		jumps += 1

	# Переменная высота прыжка при отпускании кнопки вверх (PersonKeyHandler.as:647-649)
	if up_released and vel_y < -jump_power_stat / 1.5:
		vel_y = -jump_power_stat / 1.5

	# Блок (строго при block_lvl > 0, стоит level_mp(2), Person.as:552-560, BodyAnimator.BLOCK_FRAME = 857)
	var block_lvl: int = get_skill_level("block")
	if block_lvl > 0 and Input.is_action_pressed("block"):
		if not is_blocking:
			if spend_mp(level_mp(2)):
				is_blocking = true
		if is_blocking and not is_attacking and animator != null:
			if animator.current_anim_name != "block":
				animator.play("block")
			elif animator.current_frame >= 857:
				animator.is_playing = false
	else:
		if is_blocking:
			is_blocking = false
			if animator != null:
				animator.is_playing = true

	# Горячие клавиши активных навыков (H, G, T, R, C, V, E Hold & Release)
	if _is_key_just_pressed(KEY_H):
		use_skill("self heal")
	elif _is_key_just_pressed(KEY_G):
		use_skill("guild heal")
	elif _is_key_just_pressed(KEY_T):
		use_skill("guild rage")
	elif _is_key_just_pressed(KEY_R):
		use_skill("self rage")
	elif _is_key_just_pressed(KEY_C) and not is_attacking and not is_blocking:
		var caught_fish: String = ""
		if game_world != null and game_world.has_method("try_catch_nearest_fish"):
			caught_fish = str(game_world.call("try_catch_nearest_fish", self))
		if not caught_fish.is_empty():
			add_inventory_item(caught_fish)
			gain_fishing_xp(4)
		elif game_world != null and game_world.has_method("chop_nearby_trees") and bool(game_world.call("chop_nearby_trees", self, _roll_attack_damage(get_attack_damage_range("main")))):
			if animator != null:
				animator.play("swing 1")
		else:
			_trigger_class_hotkey("c")
	elif _is_key_just_pressed(KEY_V) and not is_attacking and not is_blocking:
		_trigger_class_hotkey("v")
	elif _is_key_just_pressed(KEY_E) and not is_attacking and not is_blocking:
		if get_skill_level("air slash") > 0 and _get_equipped_weapon_class() == "warrior":
			_air_slash_charging = true
			_air_slash_charge_ticks = 0

	if _air_slash_charging:
		if Input.is_key_pressed(KEY_E) and not is_blocking and not is_attacking:
			_air_slash_charge_ticks = mini(45, _air_slash_charge_ticks + 1)
			if animator != null and animator.has_method("set_bow_charge_glow"):
				animator.set_bow_charge_glow(true, 0.3 + float(_air_slash_charge_ticks) * 0.05, facing_dir)
		else:
			_air_slash_charging = false
			if animator != null and animator.has_method("set_bow_charge_glow"):
				animator.set_bow_charge_glow(false)
			if not is_blocking and not is_attacking:
				use_skill("air slash")

	# Скатывание по склонам (Person.as:711-718)
	if (is_ducking and on_ground) or current_attack_move in ["dash attack", "pet dash attack"]:
		slide(0.96)
	else:
		end_slide()

	# Атаки (Space атака, B вперед, N вниз, M вверх, а также Fwd/Down/Up + Space) + зарядка лучника / автострельба ковбоя
	var w_cls_now: String = _get_equipped_weapon_class()
	if Input.is_action_just_released("attack"):
		_con_bullets_shot = 0
	if not is_attacking and not is_blocking and not _air_slash_charging:
		if Input.is_action_just_pressed("attack"):
			if Input.is_action_pressed("move_down") or _recent_down_timer > 0.0:
				_trigger_directional_attack("down")
			elif (Input.is_action_pressed("move_up") or _recent_up_timer > 0.0) and w_cls_now != "cowboy":
				_trigger_directional_attack("up")
			elif (_recent_left_timer > 0.0 or _recent_right_timer > 0.0) and (left_pressed or right_pressed) and not is_dashing:
				_trigger_directional_attack("forward")
			elif w_cls_now == "archer":
				is_attacking = true
				current_attack_move = "shoot bow"
				_bow_charging = true
				_bow_fired_on_frame = false
				_bow_charge_scale = 0.3
				if animator != null:
					animator.play("shoot bow")
					animator.set_bow_charge_glow(true, _bow_charge_scale, facing_dir)
				attack_triggered.emit("shoot bow", facing_dir)
			else:
				execute_attack("attack")
		elif w_cls_now == "cowboy" and Input.is_action_pressed("attack") and _con_bullets_shot < 25:
			execute_attack("attack")
		elif Input.is_action_just_pressed("attack_forward"):
			_trigger_directional_attack("forward")
		elif Input.is_action_just_pressed("attack_down"):
			_trigger_directional_attack("down")
		elif Input.is_action_just_pressed("attack_up"):
			_trigger_directional_attack("up")


func _update_locomotion_animation() -> void:
	if is_attacking or is_blocking or _bow_charging or animator == null:
		return

	var text_focused: bool = _is_text_input_focused()
	var left_pressed: bool = false if text_focused else Input.is_action_pressed("move_left")
	var right_pressed: bool = false if text_focused else Input.is_action_pressed("move_right")

	if not on_ground:
		# Wall slide (Person.as:493-519)
		if (animator.current_anim_name == "jumping" or animator.current_anim_name == "wall slide") and on_wall and vel_y > 0.0 and on_wall_counter > 4 and (left_pressed or right_pressed):
			if animator.current_anim_name != "wall slide":
				jumps = max_jumps - 1
				is_dashing = false
				_clear_run_dash_dust()
				animator.play("wall slide")
				animator.is_playing = false
			accel_down_multiplier = 0.0
		elif animator.current_anim_name == "wall slide":
			if not on_wall or (not left_pressed and not right_pressed):
				animator.play("jumping")
		elif animator.current_anim_name != "jumping" and animator.current_anim_name != "flap" and animator.current_anim_name != "gliding":
			animator.play("jumping")

		if animator.current_anim_name == "wall slide":
			vel_y /= 1.2
		return

	if is_ducking:
		if animator.current_anim_name != "ducking":
			animator.play("ducking")
		animator.is_playing = false
		return

	if on_wall and (left_pressed or right_pressed):
		if animator.current_anim_name != "wall push":
			animator.play("wall push")
		return

	if left_pressed or right_pressed or absf(vel_x) > 0.5:
		var run_anim: String = "dashing" if is_dashing else "running"
		if animator.current_anim_name != run_anim and animator.current_anim_name != "walking":
			animator.play(run_anim)
	else:
		if animator.current_anim_name != "standing" and animator.current_anim_name != "take hit":
			animator.play("standing")


## Проверка, является ли оружие магическим (Stats.wStats[w].isMagic / mgc)
func _is_magic_weapon(weapon_name: String) -> bool:
	if weapon_name.is_empty() or weapon_name == "none":
		return false
	var sdb: Node = _get_stats_db()
	if sdb != null and sdb.has_method("get_weapon_data"):
		var w_data: Dictionary = sdb.call("get_weapon_data", weapon_name)
		if not w_data.is_empty() and bool(w_data.get("mgc", false)):
			return true
	var w_lower: String = weapon_name.to_lower()
	return w_lower.contains("wand") or w_lower.contains("staff")


## Стоимость MP с учетом уровня (Person.as:1164-1167)
func level_mp(base_cost: int) -> int:
	return base_cost * ceili(float(maxi(1, level)) / 100.0)


func spend_mp(amount: int) -> bool:
	return use_mp(amount)


## Суммарная защита с учетом экипированной брони и щита (CharacterMenu.as:508, 559-561)
func get_total_defense() -> int:
	var total: int = def_stat
	var sdb: Node = _get_stats_db()
	if sdb == null:
		return total
	var armor_slots: Array[Array] = [
		["helmet", "get_helmet_data"],
		["shirt", "get_shirt_data"],
		["legs", "get_leg_data"],
		["shoes", "get_shoe_data"],
		["accessory", "get_acc_data"]
	]
	for pair in armor_slots:
		var item_name: String = str(equipment.get(pair[0], ""))
		if not item_name.is_empty() and item_name != "none" and sdb.has_method(pair[1]):
			var data: Dictionary = sdb.call(pair[1], item_name)
			total += int(data.get("def", 0))
	for w_slot in ["weapon", "weapon2"]:
		var w_name: String = str(equipment.get(w_slot, ""))
		if not w_name.is_empty() and w_name != "none" and sdb.has_method("get_weapon_data"):
			var w_data: Dictionary = sdb.call("get_weapon_data", w_name)
			var w_def: int = int(w_data.get("def", 0))
			if w_def > 0:
				if shield_mastery_lvl > 0:
					total += roundi(float(w_def) * (1.0 + float(shield_mastery_lvl) * 0.06))
				else:
					total += w_def
	return total


var is_dual_gun: bool = false # compat alias if read externally
var orb_focus: bool = false
var orb_bonuses: Dictionary = {"pow": 0, "rng": 0, "mgc": 0, "art": 0}
var riding_pet: Node = null
var riding_pet_power: int = 0
var last_equip_error: String = ""

## Проверка двуствольного пистолета по AS3 DUAL_GUNS_array (Person.as:78, 355)
func is_dual_gun_weapon(weapon_name: String) -> bool:
	return DUAL_GUNS_ARRAY.has(weapon_name)


func _is_shield_weapon(weapon_name: String) -> bool:
	if weapon_name.is_empty() or weapon_name == "none":
		return false
	var sdb: Node = _get_stats_db()
	if sdb != null and sdb.has_method("get_weapon_data"):
		var w_data: Dictionary = sdb.call("get_weapon_data", weapon_name)
		return int(w_data.get("def", 0)) > 0
	return false


func _is_two_handed_weapon(weapon_name: String) -> bool:
	if weapon_name.is_empty() or weapon_name == "none":
		return false
	if is_dual_gun_weapon(weapon_name):
		return false
	var sdb: Node = _get_stats_db()
	if sdb != null and sdb.has_method("get_weapon_data"):
		var w_data: Dictionary = sdb.call("get_weapon_data", weapon_name)
		return bool(w_data.get("two", false))
	return false


func _has_any_magic_weapon() -> bool:
	return _is_magic_weapon(str(equipment.get("weapon", ""))) or _is_magic_weapon(str(equipment.get("weapon2", "")))


func get_riding_pet_power_bonus() -> int:
	var rp_pwr: int = riding_pet_power
	if riding_pet != null:
		if "power_stat" in riding_pet:
			rp_pwr = int(riding_pet.get("power_stat"))
		elif "power" in riding_pet:
			rp_pwr = int(riding_pet.get("power"))
	return int(float(rp_pwr) * 0.4)


func get_orb_bonuses() -> Dictionary:
	return {
		"pow": int(orb_bonuses.get("pow", 0)),
		"rng": int(orb_bonuses.get("rng", 0)),
		"mgc": int(orb_bonuses.get("mgc", 0)),
		"art": int(orb_bonuses.get("art", 0)),
	}


## Диапазон урона текущей атаки по формуле CharacterMenu.as:504-558
func get_attack_damage_range(hand: String = "main") -> Vector2i:
	var sdb: Node = _get_stats_db()
	var bonus_pow: int = 0
	var bonus_rng: int = 0
	var bonus_mgc: int = 0
	var bonus_art: int = 0
	var w1_data: Dictionary = {}
	var w2_data: Dictionary = {}

	if sdb != null:
		var armor_slots: Array[Array] = [
			["helmet", "get_helmet_data"],
			["shirt", "get_shirt_data"],
			["legs", "get_leg_data"],
			["shoes", "get_shoe_data"]
		]
		for pair in armor_slots:
			var item_name: String = str(equipment.get(pair[0], ""))
			if not item_name.is_empty() and item_name != "none" and sdb.has_method(pair[1]):
				var data: Dictionary = sdb.call(pair[1], item_name)
				bonus_pow += int(data.get("pow", 0))
				bonus_rng += int(data.get("rng", 0))
				bonus_mgc += int(data.get("mgc", 0))
				bonus_art += int(data.get("art", 0))
		var w1_name: String = str(equipment.get("weapon", ""))
		var w2_name: String = str(equipment.get("weapon2", ""))
		if not w1_name.is_empty() and w1_name != "none" and sdb.has_method("get_weapon_data"):
			w1_data = sdb.call("get_weapon_data", w1_name)
		if not w2_name.is_empty() and w2_name != "none" and sdb.has_method("get_weapon_data"):
			w2_data = sdb.call("get_weapon_data", w2_name)

	var w_atk: Dictionary
	if hand == "off":
		w_atk = w2_data
	else:
		w_atk = w2_data if int(w1_data.get("def", 0)) > 0 else w1_data

	var w_min: int = int(w_atk.get("min", 0))
	var w_max: int = int(w_atk.get("max", 0))
	if w_atk.is_empty() or str(w_atk.get("key", "none")) == "none" or (w_min == 0 and w_max == 0):
		return Vector2i(1, maxi(1, power_stat))

	var orbs: Dictionary = get_orb_bonuses()
	var mount_bonus: int = get_riding_pet_power_bonus()
	var eff_pow: int = power_stat + int(orbs["pow"]) + mount_bonus
	var eff_rng: int = range_stat + int(orbs["rng"]) + mount_bonus
	var eff_mgc: int = magic_stat + int(orbs["mgc"]) + mount_bonus
	var eff_art: int = artillery_stat + int(orbs["art"]) + mount_bonus

	var min_dmg: int = 0
	var max_dmg: int = 0
	var expert_lvl: int = 0
	if int(w_atk.get("sr", 0)) > 0:
		min_dmg = eff_art * (w_min + bonus_art)
		max_dmg = eff_art * (w_max + bonus_art)
		expert_lvl = get_skill_level("expert cowboy")
	elif bool(w_atk.get("mgc", false)):
		min_dmg = eff_mgc * (w_min + bonus_mgc)
		max_dmg = eff_mgc * (w_max + bonus_mgc)
		expert_lvl = get_skill_level("expert wizard")
	elif bool(w_atk.get("rng", false)):
		min_dmg = eff_rng * (w_min + bonus_rng)
		max_dmg = eff_rng * (w_max + bonus_rng)
		expert_lvl = get_skill_level("expert archer")
	else:
		min_dmg = eff_pow * (w_min + bonus_pow)
		max_dmg = eff_pow * (w_max + bonus_pow)
		expert_lvl = get_skill_level("expert warrior")

	min_dmg = maxi(1, int(min_dmg / 2))
	max_dmg = maxi(min_dmg, int(max_dmg / 2))
	if expert_lvl > 0:
		min_dmg += expert_lvl * 2
		max_dmg += expert_lvl * 2
		var tighten_ratio: float = minf(0.85, float(expert_lvl) * 0.07)
		min_dmg = clampi(min_dmg + int(float(max_dmg - min_dmg) * tighten_ratio), min_dmg, max_dmg)
	if _rage_timer > 0.0 and _rage_bonus_mult > 0.0:
		min_dmg = maxi(1, int(float(min_dmg) * (1.0 + _rage_bonus_mult)))
		max_dmg = maxi(min_dmg, int(float(max_dmg) * (1.0 + _rage_bonus_mult)))
	return Vector2i(min_dmg, max_dmg)


## Шанс критического удара (CharacterMenu.as:503: dex / 300)
func get_crit_chance() -> float:
	return clampf(float(dex_stat) / 300.0, 0.0, 1.0)


var is_last_attack_crit: bool = false


func _roll_attack_damage(dmg_range: Vector2i) -> int:
	var dmg: int = randi_range(dmg_range.x, dmg_range.y)
	is_last_attack_crit = randf() < get_crit_chance()
	if is_last_attack_crit:
		var crit_lvl: int = get_skill_level("critical hit")
		var mult: float = 2.0 + float(crit_lvl) / 8.0
		dmg = maxi(1, int(float(dmg) * mult))
	return dmg


var _combo_index: int = 0
var _con_bullets_shot: int = 0
var _cowboy_counter: int = 0
var _cowboy_cooldown_ticks: int = 0
var _cowboy_fired_on_frame: bool = false
var _hold_attack_override: bool = false
var _magic_main_fired: bool = false
var _magic_off_fired: bool = false
var _bow_charging: bool = false
var _bow_fired_on_frame: bool = false
var _bow_charge_scale: float = 0.0
var _last_arrow_charge: float = 0.0


func _get_projectile_parent() -> Node:
	if game_world != null and "entities_container" in game_world and game_world.get("entities_container") != null:
		return game_world.get("entities_container") as Node
	if get_parent() != null:
		return get_parent()
	return null


func _pick_attack_animation(w_cls: String) -> String:
	if animator == null:
		return "attack"
	var up_held: bool = Input.is_action_pressed("move_up")
	var w1: String = str(equipment.get("weapon", ""))
	var w2: String = str(equipment.get("weapon2", ""))
	var has_w1: bool = not w1.is_empty() and w1 != "none"
	var has_w2: bool = not w2.is_empty() and w2 != "none"
	var candidates: Array[String] = []
	match w_cls:
		"cowboy":
			var can_up: bool = up_held and get_skill_level("upward shoot") > 1 and mana >= level_mp(2)
			if can_up:
				candidates = ["gun shoot upward", "shoot gun"]
			else:
				candidates = ["shoot gun"]
		"archer":
			candidates = ["shoot bow"]
		_:
			if dash_lvl > 0 and (is_dashing or jumped_while_dashing or animator.current_anim_name == "dashing") and w_cls != "wizard":
				if animator.animations_meta.has("dash attack"):
					return "dash attack"
			# AS3 PersonKeyHandler.as:714-739: щит всегда в weapon, оружие в weapon2
			if has_w1 and _is_shield_weapon(w1):
				candidates = ["attack shield", "attack shield stab", "attack shield upward"]
			elif has_w1 and has_w2:
				candidates = ["attack single", "attack single stab", "attack single multi"]
			elif w_cls == "wizard":
				candidates = ["attack", "attack magic upward"]
			else:
				candidates = ["attack", "attack stab", "attack upward"]
			var pick: String = candidates[_combo_index % candidates.size()]
			_combo_index = (_combo_index + 1) % candidates.size()
			if animator.animations_meta.has(pick):
				return pick
	for c in candidates:
		if animator.animations_meta.has(c):
			return c
	return "attack"


func _get_cowboy_s_rate() -> int:
	var w_name: String = str(equipment.get("weapon", ""))
	if _is_shield_weapon(w_name):
		w_name = str(equipment.get("weapon2", ""))
	var s_rate: int = 8
	var sdb: Node = _get_stats_db()
	if sdb != null and sdb.has_method("get_item_data") and not w_name.is_empty():
		s_rate = maxi(1, int(sdb.get_item_data(w_name).get("sr", 8)))
	return s_rate


func _spawn_single_bullet(w_name: String, hand: String, is_upward: bool, y_offset: float = 0.0, is_secondary: bool = false) -> void:
	var parent_node: Node = _get_projectile_parent()
	if parent_node == null:
		return
	var dmg_range: Vector2i = get_attack_damage_range(hand)
	var dmg: int = _roll_attack_damage(dmg_range)
	var b_dist: int = get_skill_level("bullet distance")
	var kb: float = 1.0 + float(get_skill_level("bullet knockback")) * 0.15
	var life_ticks: int = 5 + (ceili(float(b_dist - 1) * 35.0 / 52.5) if b_dist > 1 else 0)
	var proj: Area2D = RangedProjectileScript.new()
	if is_upward:
		proj.setup(self, game_world, w_name, facing_dir, dmg, 0.0, 0.0, life_ticks, is_last_attack_crit, kb, false)
		proj.vel_y = -30.0
		proj.position = global_position + Vector2(6.0 * float(facing_dir) if is_secondary else 0.0, -24.0 + y_offset)
	else:
		proj.setup(self, game_world, w_name, facing_dir, dmg, 52.5 * float(facing_dir), 0.0, life_ticks, is_last_attack_crit, kb, false)
		proj.position = global_position + Vector2(facing_dir * 20.0, -2.0 + y_offset)
	parent_node.add_child(proj)


func _spawn_cowboy_bullet(is_upward: bool) -> void:
	if _con_bullets_shot >= 25:
		return
	var parent_node: Node = _get_projectile_parent()
	if parent_node == null:
		return
	var w1: String = str(equipment.get("weapon", ""))
	var w2: String = str(equipment.get("weapon2", ""))
	var main_gun: String = w2 if _is_shield_weapon(w1) else w1
	var main_hand: String = "off" if _is_shield_weapon(w1) else "main"
	_con_bullets_shot += 1
	_cowboy_cooldown_ticks = _get_cowboy_s_rate()
	if not is_upward:
		vel_x -= float(facing_dir) * 1.0
	_spawn_single_bullet(main_gun, main_hand, is_upward, 0.0, false)
	_play_sfx(_get_weapon_sound_name(main_gun))

	# AS3 Person.as:638: dual-gun offhand выстрел из weapon2
	if main_hand == "main" and not w2.is_empty() and w2 != "none" and _get_weapon_class_for_name(w2) == "cowboy" and is_dual_gun_weapon(w2):
		_spawn_single_bullet(w2, "off", is_upward, -4.0, true)
		_play_sfx(_get_weapon_sound_name(w2), 0.75)


func _spawn_magic_shots(weapon_name: String, hand: String, shot_dir: int, is_secondary: bool) -> bool:
	var mp_cost: int = level_mp(2)
	if mana < mp_cost or not spend_mp(mp_cost):
		return false
	var parent_node: Node = _get_projectile_parent()
	if parent_node == null:
		return true
	var dmg_range: Vector2i = get_attack_damage_range(hand)
	var magic_shots_lvl: int = get_skill_level("magic shots")
	var magic_distance_lvl: int = get_skill_level("magic distance")
	for i in range(magic_shots_lvl + 1):
		var proj: Area2D = MagicProjectileScript.new()
		var dmg: int = _roll_attack_damage(dmg_range)
		proj.setup(self, game_world, weapon_name, shot_dir, dmg, magic_distance_lvl, is_last_attack_crit)
		proj.is_magic_secondary = is_secondary
		proj.position = global_position + Vector2((float(i) * 15.0 + 10.0) * float(shot_dir), float(i) * 8.0)
		parent_node.add_child(proj)
	_play_sfx("magic swing")
	return true


func _spawn_archer_arrow() -> void:
	var parent_node: Node = _get_projectile_parent()
	if parent_node == null:
		return
	var w_main_raw: String = str(equipment.get("weapon", ""))
	var dmg_range: Vector2i = get_attack_damage_range()
	var dmg: int = _roll_attack_damage(dmg_range)
	var kb: float = 1.0 + float(get_skill_level("arrow knockback")) * 0.15
	var proj: Area2D = RangedProjectileScript.new()
	proj.setup(self, game_world, w_main_raw, facing_dir, dmg, 45.0 * float(facing_dir), -(0.78 + _last_arrow_charge), 30, is_last_attack_crit, kb, true)
	proj.position = global_position + Vector2(facing_dir * 16.0, -4.0)
	parent_node.add_child(proj)
	_play_sfx("bow fire")
	vel_x -= float(facing_dir)
	_last_arrow_charge = 0.0


func _process_ranged_attack_frames() -> void:
	if not is_attacking or animator == null:
		return
	var anim_name: String = animator.current_anim_name
	if anim_name == "shoot gun" or anim_name == "gun shoot upward":
		var is_up: bool = (anim_name == "gun shoot upward")
		var shoot_frame: int = 765 if is_up else 753
		var hold_frame_idx: int = 764 if is_up else 752
		var after_recoil_frame: int = 767 if is_up else 755
		var min_loop: int = 759 if is_up else 749
		var max_loop: int = 769 if is_up else 758
		var s_rate: int = _get_cowboy_s_rate()
		_cowboy_counter += 1
		if animator.current_frame == shoot_frame and not _cowboy_fired_on_frame:
			_cowboy_fired_on_frame = true
			_cowboy_counter = 0
			_spawn_cowboy_bullet(is_up)
		if animator.current_frame > min_loop and animator.current_frame < max_loop:
			var attack_held: bool = (Input.is_action_pressed("attack") and not _is_text_input_focused()) or _hold_attack_override
			if attack_held and _con_bullets_shot < 25:
				if _cowboy_fired_on_frame and _cowboy_counter >= s_rate:
					_cowboy_counter = 0
					_cowboy_fired_on_frame = false
					if animator.current_frame != hold_frame_idx:
						animator.current_frame = hold_frame_idx
						animator.update_frame()
					animator.is_playing = true
				elif animator.current_frame >= after_recoil_frame:
					# AS3 Person.as:613 / PersonFrameHandler.as:244: gotoAndStopInt(752 / 764) — вытянутая рука без опускания
					if animator.current_frame != hold_frame_idx or animator.is_playing:
						animator.current_frame = hold_frame_idx
						animator.is_playing = false
						animator.update_frame()
			else:
				animator.is_playing = true
	elif anim_name == "shoot bow" and current_attack_move == "shoot bow":
		var bow_attack_held: bool = Input.is_action_pressed("attack") and not _is_text_input_focused()
		if _bow_charging and not bow_attack_held:
			_bow_charging = false
			_last_arrow_charge = _bow_charge_scale / 12.0
			_bow_charge_scale = 0.0
			animator.set_bow_charge_glow(false)
			animator.is_playing = true
		if animator.current_frame == 91:
			if _bow_charging and bow_attack_held:
				animator.is_playing = false
				_bow_charge_scale = minf(2.7, _bow_charge_scale + 0.11)
				animator.set_bow_charge_glow(true, _bow_charge_scale, facing_dir)
			else:
				animator.is_playing = true
		if animator.current_frame >= 95 and not _bow_fired_on_frame:
			_bow_fired_on_frame = true
			_spawn_archer_arrow()

	# AS3 Person.as:681-705: Магические выстрелы ровно на кадрах замаха weapon1 / weapon2
	var w1: String = str(equipment.get("weapon", ""))
	var w2: String = str(equipment.get("weapon2", ""))
	if _is_magic_weapon(w1) and not _magic_main_fired and MAIN_MAGIC_SWING_FRAMES.has(animator.current_frame):
		_magic_main_fired = true
		var shot_dir: int = -facing_dir if animator.current_frame == 170 else facing_dir
		_spawn_magic_shots(w1, "main", shot_dir, false)
	if not w2.is_empty() and w2 != "none" and _is_magic_weapon(w2) and not _magic_off_fired and OFF_MAGIC_SWING_FRAMES.has(animator.current_frame):
		_magic_off_fired = true
		_spawn_magic_shots(w2, "off", facing_dir, true)


## Выполнить атаку
func execute_attack(move_name: String) -> void:
	if is_dead or is_attacking:
		return

	var w1: String = str(equipment.get("weapon", ""))
	var w2: String = str(equipment.get("weapon2", ""))
	var w_cls: String = _get_equipped_weapon_class()
	if w_cls == "cowboy" and move_name == "attack" and _cowboy_cooldown_ticks > 0:
		return

	var resolved_move: String = _pick_attack_animation(w_cls) if move_name == "attack" else move_name
	if resolved_move == "gun shoot upward":
		if not spend_mp(level_mp(2)):
			resolved_move = "shoot gun"

	is_attacking = true
	is_ducking = false
	current_attack_move = resolved_move
	_magic_main_fired = false
	_magic_off_fired = false
	if resolved_move == "dash attack":
		vel_y -= 9.0
		vel_x = float(facing_dir) * (10.0 + float(dash_lvl))
		is_dashing = false
	if w_cls == "cowboy":
		_cowboy_counter = 0
		_cowboy_fired_on_frame = false
	elif w_cls == "archer":
		_bow_fired_on_frame = false
	if animator != null:
		animator.play(resolved_move)
	attack_triggered.emit(resolved_move, facing_dir)

	# Магические снаряды стреляют на точном кадре замаха в _process_ranged_attack_frames();
	# если аниматор без метаданных (чистые unit-моки), спавним сразу как fallback.
	if w_cls == "cowboy" or w_cls == "archer":
		return
	if resolved_move in ["attack stab", "attack single stab", "attack shield"]:
		_play_sfx("slash 2")
	elif resolved_move in ["attack upward", "attack single multi", "attack shield stab"]:
		_play_sfx("slash 3")
	else:
		_play_sfx("slash")
	if animator == null or animator.animations_meta.is_empty():
		if _is_magic_weapon(w1) and not _magic_main_fired:
			_magic_main_fired = true
			_spawn_magic_shots(w1, "main", facing_dir, false)
		if not w2.is_empty() and w2 != "none" and _is_magic_weapon(w2) and not _magic_off_fired:
			_magic_off_fired = true
			_spawn_magic_shots(w2, "off", facing_dir, true)
		if w_cls == "wizard":
			return
	elif w_cls == "wizard":
		return

	var dmg_range: Vector2i = get_attack_damage_range("main")
	# Нанесение урона врагам в секторе атаки (ближний бой воина)
	if animator != null and animator.has_method("create_slash"):
		var slash_tex: String = "yellow slash 1" if resolved_move.contains("upward") else ("slash 2" if resolved_move.contains("stab") else "slash 1")
		animator.create_slash(slash_tex, facing_dir)
	if game_world != null and game_world.has_method("damage_enemies_in_range"):
		var reach: float = 55.0
		var attack_pos: Vector2 = global_position + Vector2(facing_dir * 45.0, 6.0)
		var dmg: int = _roll_attack_damage(dmg_range)
		game_world.damage_enemies_in_range(attack_pos, reach, dmg, self, is_last_attack_crit)
		if game_world.has_method("chop_nearby_trees"):
			game_world.call("chop_nearby_trees", self, dmg)
		# Dual-wield второго оружия ближнего боя (weapon и weapon2 оба атакуют)
		if not _is_shield_weapon(w1) and not w2.is_empty() and w2 != "none" and not _is_magic_weapon(w2) and _get_weapon_class_for_name(w2) == "warrior":
			var off_dmg: int = _roll_attack_damage(get_attack_damage_range("off"))
			game_world.damage_enemies_in_range(attack_pos, reach, off_dmg, self, is_last_attack_crit)
			_play_sfx("slash 2", 0.75)
		_apply_passive_knockback(attack_pos, reach, w_cls)


func gain_chopping_xp(amount: int) -> void:
	if amount <= 0:
		return
	chopping_xp += amount
	var req: int = int(chopping_level * (chopping_level * 1.1 + 50.0))
	while chopping_xp >= req and req > 0:
		chopping_xp -= req
		chopping_level += 1
		req = int(chopping_level * (chopping_level * 1.1 + 50.0))


func gain_fishing_xp(amount: int) -> void:
	if amount <= 0:
		return
	fishing_xp += amount
	var req: int = int(fishing_level * (fishing_level * 1.1 + 50.0))
	while fishing_xp >= req and req > 0:
		fishing_xp -= req
		fishing_level += 1
		req = int(fishing_level * (fishing_level * 1.1 + 50.0))


func _spawn_floating_damage(text: String, world_pos: Vector2, is_crit: bool = false, is_player_or_pet: bool = true) -> void:
	if not ResourceLoader.exists("res://scripts/effects/FloatingDamage.gd"):
		return
	var fd_script: Script = load("res://scripts/effects/FloatingDamage.gd") as Script
	if fd_script == null:
		return
	var parent_node: Node = null
	if game_world != null and "entities_container" in game_world and game_world.get("entities_container") != null:
		parent_node = game_world.get("entities_container") as Node
	elif get_parent() != null:
		parent_node = get_parent()
	elif is_inside_tree() and get_tree().current_scene != null:
		parent_node = get_tree().current_scene
	if parent_node == null:
		return
	if fd_script.has_method("spawn"):
		fd_script.call("spawn", parent_node, text, world_pos, is_crit, is_player_or_pet)
		return
	var fd: Node = fd_script.new()
	if fd == null:
		return
	parent_node.add_child(fd)
	if fd.has_method("setup"):
		fd.call("setup", text, world_pos, is_crit, is_player_or_pet)
	elif fd is Node2D:
		(fd as Node2D).global_position = world_pos


## Получение урона
func take_damage(raw_dmg: int) -> void:
	if is_dead or health <= 0:
		return

	var avoid_lvl: int = get_skill_level("avoidability")
	if avoid_lvl > 0 and randf() < minf(0.60, float(avoid_lvl) * 0.02):
		_spawn_floating_damage("avoided", global_position + Vector2(0, -70), false, true)
		return

	var effective_dmg: int = raw_dmg
	var block_lvl: int = get_skill_level("block")
	if is_blocking and block_lvl > 0:
		var reduction: float = minf(0.85, 0.50 + float(block_lvl) * 0.01)
		effective_dmg = int(float(effective_dmg) * (1.0 - reduction))

	var net_dmg: int = maxi(1, effective_dmg - get_total_defense())
	health = maxi(0, health - net_dmg)
	health_changed.emit(health, max_health)
	_spawn_floating_damage("-%d" % net_dmg, global_position + Vector2(0, -70), false, true)

	if health <= 0:
		die()
	else:
		if not is_attacking and not is_blocking and animator != null:
			animator.play("take hit")


func heal(amount: int) -> void:
	health = min(max_health, health + amount)
	health_changed.emit(health, max_health)


func use_mp(amount: int) -> bool:
	if mana >= amount:
		mana -= amount
		mp_changed.emit(mana, max_mana)
		return true
	return false


func restore_mp(amount: int) -> void:
	mana = min(max_mana, mana + amount)
	mp_changed.emit(mana, max_mana)


func add_coins(amount: int) -> void:
	coins += amount
	coins_changed.emit(coins)


func spend_coins(amount: int) -> bool:
	if coins >= amount:
		coins -= amount
		coins_changed.emit(coins)
		return true
	return false


func add_exp(amount: int) -> void:
	var final_amount: int = amount
	var training_lvl: int = get_skill_level("training")
	if training_lvl > 0 and amount > 0:
		final_amount = maxi(amount, int(round(float(amount) * (1.0 + float(training_lvl) * 0.025))))
	exp_points += final_amount
	while exp_points >= max_exp_points:
		exp_points -= max_exp_points
		level += 1
		ability_points += 3
		skill_points += 1
		# Порог опыта по оригиналу Controls.as: int(lev * (lev * 1.1 + 50))
		max_exp_points = int(float(level) * (float(level) * 1.1 + 50.0))
		stats_updated.emit()
	exp_changed.emit(exp_points, max_exp_points, level)


func add_inventory_item(item_name: String) -> bool:
	if inventory.size() < 40:
		inventory.append(item_name)
		inventory_updated.emit()
		return true
	return false


func remove_inventory_item(item_name: String) -> bool:
	var idx: int = inventory.find(item_name)
	if idx != -1:
		inventory.remove_at(idx)
		inventory_updated.emit()
		return true
	return false


func equip_item(item_name: String, slot: String = "") -> bool:
	last_equip_error = ""
	var sdb: Node = _get_stats_db()
	var cat: String = slot
	if cat.is_empty() and sdb != null:
		if sdb.has_method("get_item_category"):
			cat = str(sdb.call("get_item_category", item_name))
		elif sdb.has_method("get_helmet_data") and not (sdb.call("get_helmet_data", item_name) as Dictionary).is_empty():
			cat = "helmet"
		elif sdb.has_method("get_shirt_data") and not (sdb.call("get_shirt_data", item_name) as Dictionary).is_empty():
			cat = "shirt"
		elif sdb.has_method("get_leg_data") and not (sdb.call("get_leg_data", item_name) as Dictionary).is_empty():
			cat = "legs"
		elif sdb.has_method("get_shoe_data") and not (sdb.call("get_shoe_data", item_name) as Dictionary).is_empty():
			cat = "shoes"
		elif sdb.has_method("get_weapon_data") and not (sdb.call("get_weapon_data", item_name) as Dictionary).is_empty():
			cat = "weapon"
		elif sdb.has_method("get_acc_data") and not (sdb.call("get_acc_data", item_name) as Dictionary).is_empty():
			cat = "acc"
	# Нормализация имени слота
	match cat:
		"helm", "helmet":
			cat = "helmet"
		"shirt", "body":
			cat = "shirt"
		"legs", "pants":
			cat = "legs"
		"shoes", "boots":
			cat = "shoes"
		"weapon":
			cat = "weapon"
		"weapon2", "shield":
			cat = "weapon2"
		"acc", "accessory":
			cat = "accessory"
		_:
			cat = "item"

	if cat == "item":
		# Расходник
		use_item(item_name)
		return true

	var idata: Dictionary = {}
	if sdb != null and sdb.has_method("get_item_data"):
		idata = sdb.call("get_item_data", item_name)
		var req_lvl: int = int(idata.get("lvl", 0))
		if req_lvl > level:
			last_equip_error = "required level %d" % req_lvl
			return false

	if cat == "weapon" or cat == "weapon2":
		var w1: String = str(equipment.get("weapon", ""))
		var w2: String = str(equipment.get("weapon2", ""))
		var is_new_shield: bool = _is_shield_weapon(item_name) or int(idata.get("def", 0)) > 0
		var is_new_2h: bool = _is_two_handed_weapon(item_name)

		if is_new_shield:
			# AS3 MainStarlingStage.as:684-702: щит ВСЕГДА надевается в weapon, а 1H-оружие переходит в weapon2
			if not w1.is_empty() and w1 != "none" and not _is_shield_weapon(w1):
				if _is_two_handed_weapon(w1):
					last_equip_error = "cannot equip a shield with a two handed weapon"
					return false
				if not w2.is_empty() and w2 != "none":
					inventory.append(w2)
				equipment["weapon2"] = w1
			elif not w1.is_empty() and w1 != "none":
				inventory.append(w1)
			equipment["weapon"] = item_name
		elif is_new_2h:
			if not w1.is_empty() and w1 != "none":
				inventory.append(w1)
			if not w2.is_empty() and w2 != "none":
				inventory.append(w2)
			equipment["weapon"] = item_name
			equipment["weapon2"] = ""
		elif cat == "weapon2":
			if not w1.is_empty() and w1 != "none" and _is_two_handed_weapon(w1):
				inventory.append(w1)
				equipment["weapon"] = item_name
				equipment["weapon2"] = ""
			else:
				if not w2.is_empty() and w2 != "none":
					inventory.append(w2)
				equipment["weapon2"] = item_name
		else:
			if not w1.is_empty() and w1 != "none":
				inventory.append(w1)
			equipment["weapon"] = item_name
		remove_inventory_item(item_name)
	else:
		# Снимаем старый предмет из этого слота в инвентарь
		var old_item: String = equipment.get(cat, "")
		if not old_item.is_empty():
			inventory.append(old_item)
		equipment[cat] = item_name
		remove_inventory_item(item_name)

	# Обновляем визуальный аниматор если доступно
	if animator != null:
		animator.helmet_name = str(equipment.get("helmet", ""))
		animator.shirt_name = str(equipment.get("shirt", ""))
		animator.pants_name = str(equipment.get("legs", ""))
		animator.shoe_name = str(equipment.get("shoes", ""))
		animator.weapon_main_name = str(equipment.get("weapon", ""))
		animator.weapon_off_name = str(equipment.get("weapon2", ""))
		animator.accessory_name = str(equipment.get("accessory", ""))
		if animator.has_method("refresh_equipment_textures"):
			animator.refresh_equipment_textures()

	inventory_updated.emit()
	stats_updated.emit()
	return true


func unequip_item(slot: String) -> bool:
	last_equip_error = ""
	if not equipment.has(slot) or equipment[slot].is_empty():
		return false
	var item_name: String = equipment[slot]
	# AS3 MainStarlingStage.as:705-715: снимать можно только accessory, helmet, либо weapon/weapon2 при наличии обоих слотов (и не weapon2 под щитом)
	if slot == "shirt" or slot == "legs" or slot == "shoes":
		last_equip_error = "cannot unequip %s: must have a %s equipped at all times" % [item_name, slot]
		return false
	if slot == "weapon" or slot == "weapon2":
		var w1: String = str(equipment.get("weapon", ""))
		var w2: String = str(equipment.get("weapon2", ""))
		if w1.is_empty() or w1 == "none" or w2.is_empty() or w2 == "none":
			last_equip_error = "cannot unequip %s: must have a weapon equipped at all times" % item_name
			return false
		if slot == "weapon2" and _is_shield_weapon(w1):
			last_equip_error = "cannot unequip %s: must have a weapon equipped at all times" % item_name
			return false
		equipment[slot] = ""
		inventory.append(item_name)
		if slot == "weapon" and not w2.is_empty() and w2 != "none":
			equipment["weapon"] = w2
			equipment["weapon2"] = ""
	else:
		equipment[slot] = ""
		inventory.append(item_name)

	if animator != null:
		animator.helmet_name = str(equipment.get("helmet", ""))
		animator.shirt_name = str(equipment.get("shirt", ""))
		animator.pants_name = str(equipment.get("legs", ""))
		animator.shoe_name = str(equipment.get("shoes", ""))
		animator.weapon_main_name = str(equipment.get("weapon", ""))
		animator.weapon_off_name = str(equipment.get("weapon2", ""))
		animator.accessory_name = str(equipment.get("accessory", ""))
		if animator.has_method("refresh_equipment_textures"):
			animator.refresh_equipment_textures()

	inventory_updated.emit()
	stats_updated.emit()
	return true


func use_item(item_name: String) -> void:
	last_equip_error = ""
	var sdb: Node = _get_stats_db()
	if sdb != null and sdb.has_method("get_item_data"):
		var idata: Dictionary = sdb.call("get_item_data", item_name)
		var req_lvl: int = int(idata.get("lvl", 0))
		if req_lvl > level:
			return
	var lower: String = item_name.to_lower()
	match lower:
		"apple":
			heal(50)
			remove_inventory_item(item_name)
		"banana":
			heal(20)
			restore_mp(100)
			remove_inventory_item(item_name)
		"watermelon":
			heal(200)
			restore_mp(50)
			remove_inventory_item(item_name)
		"turkey":
			heal(400)
			restore_mp(100)
			remove_inventory_item(item_name)
		"book of power":
			power_stat += 1
			stats_updated.emit()
			remove_inventory_item(item_name)
		"book of magic":
			magic_stat += 1
			stats_updated.emit()
			remove_inventory_item(item_name)
		"book of range":
			range_stat += 1
			stats_updated.emit()
			remove_inventory_item(item_name)
		"book of artillery":
			artillery_stat += 1
			stats_updated.emit()
			remove_inventory_item(item_name)
		"book of dexterity":
			if dex_stat < 300:
				dex_stat += 1
				_calc_stats()
				stats_updated.emit()
				remove_inventory_item(item_name)
			else:
				last_equip_error = "You cannot use anymore dexterity books"
		"book of health":
			max_health += 10
			health += 10
			health_changed.emit(health, max_health)
			stats_updated.emit()
			remove_inventory_item(item_name)
		"book of mp":
			max_mana += 10
			mana += 10
			mp_changed.emit(mana, max_mana)
			stats_updated.emit()
			remove_inventory_item(item_name)
		"book of defense":
			def_stat += 1
			stats_updated.emit()
			remove_inventory_item(item_name)
		"book of skill":
			skill_points += 1
			stats_updated.emit()
			remove_inventory_item(item_name)
		_:
			if lower.contains("potion"):
				heal(50)
				remove_inventory_item(item_name)
			elif lower.contains("mana") or lower.contains("mp"):
				restore_mp(30)
				remove_inventory_item(item_name)
			else:
				heal(25)
				remove_inventory_item(item_name)


func upgrade_stat(stat_name: String) -> bool:
	if ability_points <= 0:
		return false
	ability_points -= 1
	match stat_name.to_lower():
		"power", "power_stat":
			power_stat += 1
		"dex", "dex_stat", "dexterity":
			if dex_stat >= 300:
				ability_points += 1
				return false
			dex_stat += 1
			_calc_stats()
		"def", "def_stat", "defense":
			def_stat += 1
		"range", "range_stat":
			range_stat += 1
		"magic", "magic_stat":
			magic_stat += 1
		"art", "art_stat", "artillery":
			artillery_stat += 1
		"hp", "health":
			max_health += 10
			health += 10
			health_changed.emit(health, max_health)
		"mp", "mana":
			max_mana += 5
			mana += 5
			mp_changed.emit(mana, max_mana)
		_:
			ability_points += 1
			return false

	stats_updated.emit()
	return true


func upgrade_skill(skill_id: String, required_sp: int = 1, max_lvl: int = 10) -> bool:
	var cost: int = maxi(1, required_sp)
	if skill_points < cost:
		return false
	var cur_lvl: int = int(skill_levels.get(skill_id, 0))
	if cur_lvl >= max_lvl:
		return false
	skill_points -= cost
	cur_lvl += 1
	skill_levels[skill_id] = cur_lvl
	if skill_id == "speed dash" or skill_id == "dash":
		dash_lvl = cur_lvl
	elif skill_id == "accel down" or skill_id == "accelDown" or skill_id == "fastFall":
		accel_down_lvl = cur_lvl
	elif skill_id == "shield mastery" or skill_id == "shieldMastery":
		shield_mastery_lvl = cur_lvl
	elif skill_id == "jump height":
		_calc_stats()
	elif skill_id == "expert warrior":
		power_stat += 1
	elif skill_id == "expert archer":
		range_stat += 1
	elif skill_id == "expert wizard":
		magic_stat += 1
	elif skill_id == "expert cowboy":
		artillery_stat += 1
	elif skill_id == "training":
		def_stat += 1
		power_stat += 1
		range_stat += 1
		magic_stat += 1
		artillery_stat += 1
		max_health += 10
		health += 10
		max_mana += 10
		mana += 10
		health_changed.emit(health, max_health)
		mp_changed.emit(mana, max_mana)
	stats_updated.emit()
	return true


func get_loot_steal_wait_seconds() -> float:
	var lvl: int = get_skill_level("loot steal")
	if lvl <= 0:
		return 11.0
	return maxf(0.5, 11.0 - float(lvl - 1) * 0.6)


func _is_key_just_pressed(key: Key) -> bool:
	if _is_text_input_focused():
		_prev_keys[key] = false
		return false
	var pressed: bool = Input.is_key_pressed(key)
	var was_pressed: bool = bool(_prev_keys.get(key, false))
	_prev_keys[key] = pressed
	return pressed and not was_pressed


func _get_weapon_class_for_name(w_name: String) -> String:
	if w_name.is_empty() or w_name == "none":
		return ""
	var sdb: Node = _get_stats_db()
	if sdb != null and sdb.has_method("get_weapon_data"):
		var w_data: Dictionary = sdb.call("get_weapon_data", w_name)
		if not w_data.is_empty():
			if int(w_data.get("sr", 0)) > 0:
				return "cowboy"
			if bool(w_data.get("mgc", false)):
				return "wizard"
			if bool(w_data.get("rng", false)):
				return "archer"
			return "warrior"
	var w_lower: String = w_name.to_lower()
	if w_lower.contains("gun") or w_lower.contains("pistol") or w_lower.contains("rifle") or w_lower.contains("shotgun"):
		return "cowboy"
	if w_lower.contains("wand") or w_lower.contains("staff"):
		return "wizard"
	if w_lower.contains("bow"):
		return "archer"
	return "warrior"


func _get_equipped_weapon_class() -> String:
	var w_main_raw: String = str(equipment.get("weapon", ""))
	var w_off_raw: String = str(equipment.get("weapon2", ""))
	if (w_main_raw.is_empty() or w_main_raw == "none" or _is_shield_weapon(w_main_raw)) and not w_off_raw.is_empty() and w_off_raw != "none":
		return _get_weapon_class_for_name(w_off_raw)
	if w_main_raw.is_empty() or w_main_raw == "none":
		return ""
	return _get_weapon_class_for_name(w_main_raw)


func _apply_passive_knockback(attack_pos: Vector2, radius: float, weapon_class: String) -> void:
	if game_world == null or not ("enemies" in game_world):
		return
	var kb_bonus: float = 0.0
	match weapon_class:
		"warrior":
			var lvl: int = get_skill_level("melee knockback")
			if lvl > 0:
				kb_bonus = float(lvl) * 1.5
		"archer":
			var lvl: int = get_skill_level("arrow knockback")
			if lvl > 0:
				kb_bonus = float(lvl) * 2.0
		"cowboy":
			var lvl: int = get_skill_level("bullet knockback")
			if lvl > 0:
				kb_bonus = float(lvl) * 1.5
	if kb_bonus <= 0.0:
		return
	var enemies_arr: Variant = game_world.get("enemies")
	if enemies_arr is Array:
		for e in enemies_arr:
			if is_instance_valid(e) and e is Node2D and (e as Node2D).global_position.distance_to(attack_pos) <= radius:
				if "vel_x" in e:
					e.set("vel_x", float(facing_dir) * kb_bonus * 2.0)


func _trigger_class_hotkey(key_char: String) -> void:
	var w_cls: String = _get_equipped_weapon_class()
	if key_char == "c":
		match w_cls:
			"warrior":
				use_skill("power attack")
			"archer":
				if on_ground:
					use_skill("arrow barrage")
				elif not use_skill("triple shot"):
					use_skill("down crush")
			"wizard":
				use_skill("circular attack")
			"cowboy":
				if on_ground:
					if not use_skill("shotgun attack"):
						use_skill("upward shoot")
				else:
					use_skill("upward shoot")
	elif key_char == "v":
		match w_cls:
			"warrior":
				use_skill("multi attack" if on_ground else "spin attack")
			"archer":
				use_skill("arrow rain" if on_ground else "piercing arrow")
			"wizard":
				use_skill("thunder attack")
			"cowboy":
				use_skill("grenade attack" if on_ground else "jump grenade")


func _damage_skill_aoe(center: Vector2, radius: float, dmg_mult: float, hits: int = 1, max_targets: int = -1, hit_log: Array = []) -> void:
	var base_range: Vector2i = get_attack_damage_range()
	if game_world != null and ("enemies" in game_world):
		var enemies_arr: Variant = game_world.get("enemies")
		if enemies_arr is Array:
			var hit_count: int = 0
			for e in enemies_arr:
				if max_targets >= 0 and hit_count >= max_targets:
					break
				if is_instance_valid(e) and e is Node2D and (e as Node2D).global_position.distance_to(center) <= radius:
					if e.has_method("take_damage"):
						for _h in range(hits):
							var dmg: int = maxi(1, int(float(_roll_attack_damage(base_range)) * dmg_mult))
							e.call("take_damage", dmg, self, is_last_attack_crit)
						hit_log.append(e)
						hit_count += 1
			if hit_count > 0 or max_targets >= 0:
				return
	if game_world != null and game_world.has_method("damage_enemies_in_range") and max_targets < 0:
		for _h in range(hits):
			var dmg: int = maxi(1, int(float(_roll_attack_damage(base_range)) * dmg_mult))
			game_world.damage_enemies_in_range(center, radius, dmg, self, is_last_attack_crit)


func _trigger_directional_attack(dir_kind: String) -> void:
	is_ducking = false
	var w_cls: String = _get_equipped_weapon_class()
	match dir_kind:
		"forward":
			match w_cls:
				"cowboy":
					use_skill("shotgun attack")
				"archer":
					use_skill("piercing arrow")
				_:
					if not use_skill("power attack"):
						execute_attack("lunge attack")
		"down":
			if not on_ground:
				if w_cls == "archer":
					use_skill("down crush")
				elif not _has_any_magic_weapon():
					if not use_skill("air slash"):
						execute_attack("down slash")
			else:
				match w_cls:
					"archer":
						use_skill("triple shot")
					"wizard":
						use_skill("thunder attack")
					"cowboy":
						is_ducking = true
					_:
						if not use_skill("multi attack"):
							execute_attack("down slash")
		"up":
			if _has_any_magic_weapon():
				use_skill("circular attack")
			elif w_cls == "cowboy":
				if not use_skill("upward shoot"):
					execute_attack("shoot gun")
			elif w_cls == "archer":
				use_skill("arrow rain")
			else:
				if not use_skill("spin attack"):
					execute_attack("attack upward")


func _get_skill_target_anim(skill_id: String) -> String:
	match skill_id:
		"power attack":
			return "lunge attack"
		"multi attack":
			return "ground stab"
		"air slash":
			return "down slash"
		"spin attack":
			return "spin attack"
		"arrow barrage", "piercing arrow":
			return "shoot bow"
		"triple shot":
			return "triple shot"
		"arrow rain":
			return "rain attack"
		"down crush":
			return "down stab"
		"circular attack":
			return "summon beam"
		"thunder attack":
			return "summon thunder"
		"shotgun attack", "grenade attack":
			return "shoot gun"
		"upward shoot":
			return "gun shoot upward"
		"jump grenade":
			return "jumping"
	return skill_id


func use_skill(skill_id: String) -> bool:
	if is_dead:
		return false
	var lvl: int = get_skill_level(skill_id)
	if lvl <= 0:
		return false

	# Поддержка и ауры работают даже во время анимации удара
	if is_attacking and not (skill_id in ["self heal", "guild heal", "self rage", "guild rage"]):
		if current_attack_move == skill_id or current_attack_move == _get_skill_target_anim(skill_id):
			return false

	var w_cls: String = _get_equipped_weapon_class()
	match skill_id:
		"self heal":
			if not _has_any_magic_weapon() or not spend_mp(level_mp(15)):
				return false
			var amount: int = 35 + lvl * 5
			heal(amount)
			_spawn_ring_vfx(global_position, Color(0.25, 1.0, 0.45, 0.85), 48.0)
			_spawn_floating_damage("+%d HP" % amount, global_position + Vector2(0, -75), false, true)
			return true
		"guild heal":
			if not _has_any_magic_weapon() or not spend_mp(19):
				return false
			var amount: int = 20 + lvl * 5
			heal(amount)
			_spawn_ring_vfx(global_position, Color(0.20, 0.95, 0.65, 0.85), 95.0)
			_spawn_floating_damage("+%d HP" % amount, global_position + Vector2(0, -75), false, true)
			if game_world != null and ("players" in game_world):
				var p_arr: Variant = game_world.get("players")
				if p_arr is Array:
					for p in p_arr:
						if is_instance_valid(p) and p != self and p.has_method("heal"):
							if (p as Node2D).global_position.distance_to(global_position) <= 300.0:
								p.call("heal", amount)
			return true
		"self rage":
			_rage_bonus_mult = 0.20 + float(lvl) * 0.02
			_rage_timer = 20.0
			energy = mini(max_energy, energy + lvl * 57)
			energy_changed.emit(energy, max_energy)
			_spawn_ring_vfx(global_position, Color(1.0, 0.35, 0.15, 0.85), 54.0)
			_spawn_floating_damage("RAGE!", global_position + Vector2(0, -80), true, true)
			return true
		"guild rage":
			if lvl <= 1 or not spend_mp(level_mp(45)):
				return false
			_rage_bonus_mult = 0.20 + float(lvl) * 0.02
			_rage_timer = 20.0
			_spawn_ring_vfx(global_position, Color(1.0, 0.20, 0.25, 0.85), 110.0)
			_spawn_floating_damage("GUILD RAGE!", global_position + Vector2(0, -80), true, true)
			return true
		"power attack":
			if w_cls != "warrior" or not spend_mp(level_mp(6)):
				return false
			is_ducking = false
			is_attacking = true
			current_attack_move = "lunge attack"
			if animator != null:
				animator.play("lunge attack")
				if animator.has_method("create_slash"):
					animator.create_slash("slash 1", facing_dir)
			vel_x = float(facing_dir) * 14.0
			var p_center: Vector2 = global_position + Vector2(facing_dir * 55.0, 6.0)
			_damage_skill_aoe(p_center, 65.0, 1.0 + float(lvl) * 0.14)
			_apply_passive_knockback(p_center, 70.0, "warrior")
			_play_skill_sfx("power attack")
			attack_triggered.emit("power attack", facing_dir)
			return true
		"multi attack":
			if w_cls != "warrior" or not spend_mp(level_mp(8)):
				return false
			is_ducking = false
			is_attacking = true
			current_attack_move = "ground stab"
			if animator != null:
				animator.play("ground stab")
				if animator.has_method("create_slash"):
					animator.create_slash("slash 2", facing_dir)
			var m_center: Vector2 = global_position + Vector2(facing_dir * 50.0, 6.0)
			_damage_skill_aoe(m_center, 75.0, 0.30 + float(lvl) * 0.15, 3, 1 + lvl)
			_apply_passive_knockback(m_center, 75.0, "warrior")
			_play_skill_sfx("multi attack")
			attack_triggered.emit("multi attack", facing_dir)
			return true
		"air slash":
			if w_cls != "warrior" or not spend_mp(level_mp(6)):
				return false
			is_ducking = false
			is_attacking = true
			current_attack_move = "down slash"
			if animator != null:
				animator.play("down slash")
				if animator.has_method("create_slash"):
					animator.create_slash("yellow slash 1", facing_dir)
			var charge_ratio: float = clampf(float(_air_slash_charge_ticks) / 30.0, 0.0, 1.5)
			_air_slash_charge_ticks = 0
			var already_hit: Array = []
			_damage_skill_aoe(global_position + Vector2(facing_dir * 65.0, 6.0), 70.0 + float(lvl) * 4.0, 0.75 + float(lvl) * 0.16 + charge_ratio * 0.35, 1, -1, already_hit)
			var parent_node: Node = _get_projectile_parent()
			if parent_node != null:
				var wave: Area2D = RangedProjectileScript.new()
				var dmg: int = maxi(1, int(float(_roll_attack_damage(get_attack_damage_range())) * (0.75 + float(lvl) * 0.16 + charge_ratio * 0.35)))
				var kb: float = 1.0 + float(get_skill_level("melee knockback")) * 0.15
				wave.piercing = true
				wave.max_hits = 5 + lvl
				wave.custom_scale = Vector2(1.0 + float(lvl) * 0.08, 1.0 + float(lvl) * 0.08)
				wave.setup(self, game_world, "air slash wave", facing_dir, dmg, float(facing_dir) * (16.0 + charge_ratio * 8.0), 0.0, 24 + int(charge_ratio * 10.0), is_last_attack_crit, kb, false)
				for e_hit: Variant in already_hit:
					if e_hit is Node:
						wave._hit_enemies.append(e_hit)
				wave.position = global_position + Vector2(float(facing_dir) * 26.0, -4.0)
				parent_node.add_child(wave)
			_play_skill_sfx("air slash")
			attack_triggered.emit("air slash", facing_dir)
			return true
		"spin attack":
			if w_cls != "warrior" or not spend_mp(level_mp(5)):
				return false
			is_ducking = false
			is_attacking = true
			current_attack_move = "spin attack"
			if not on_ground:
				vel_y = minf(vel_y, -5.0)
			if animator != null:
				animator.play("spin attack")
				if animator.has_method("create_slash"):
					animator.create_slash("yellow slash 1", facing_dir)
			_damage_skill_aoe(global_position, 85.0 + float(lvl) * 3.0, 1.0 + float(lvl) * 0.09)
			_apply_passive_knockback(global_position, 85.0 + float(lvl) * 3.0, "warrior")
			_play_skill_sfx("spin attack")
			attack_triggered.emit("spin attack", facing_dir)
			return true
		"arrow barrage":
			if w_cls != "archer" or not spend_mp(level_mp(7)):
				return false
			is_ducking = false
			is_attacking = true
			current_attack_move = "arrow barrage"
			_bow_charging = false
			if animator != null:
				animator.play("shoot bow")
			var parent_ab: Node = _get_projectile_parent()
			var count_ab: int = 2 + mini(4, int(lvl / 2))
			if parent_ab != null:
				var w_ab: String = str(equipment.get("weapon", ""))
				var kb_ab: float = 1.0 + float(get_skill_level("arrow knockback")) * 0.15
				for i: int in range(count_ab):
					var proj: Area2D = RangedProjectileScript.new()
					var dmg: int = maxi(1, int(float(_roll_attack_damage(get_attack_damage_range())) * (0.45 + float(lvl) * 0.08)))
					proj.setup(self, game_world, w_ab, facing_dir, dmg, float(facing_dir) * (40.0 + float(i) * 2.0), -0.65, 28, is_last_attack_crit, kb_ab, true)
					proj.vel_y = -2.0 + float(i) * 1.1
					proj.position = global_position + Vector2(float(facing_dir) * (16.0 + float(i) * 10.0), -6.0 + float(i) * 2.0)
					parent_ab.add_child(proj)
			else:
				_damage_skill_aoe(global_position + Vector2(facing_dir * 95.0, 0.0), 90.0, 0.32 + float(lvl) * 0.08, 3)
			_play_skill_sfx("arrow barrage")
			attack_triggered.emit("arrow barrage", facing_dir)
			return true
		"triple shot":
			if w_cls != "archer" or not spend_mp(level_mp(8)):
				return false
			is_ducking = false
			is_attacking = true
			current_attack_move = "triple shot"
			if animator != null:
				animator.play("triple shot")
			var parent_ts: Node = _get_projectile_parent()
			if parent_ts != null:
				var w_ts: String = str(equipment.get("weapon", ""))
				var kb_ts: float = 1.0 + float(get_skill_level("arrow knockback")) * 0.15
				for i: int in range(3):
					var proj: Area2D = RangedProjectileScript.new()
					var dmg: int = maxi(1, int(float(_roll_attack_damage(get_attack_damage_range())) * (0.50 + float(lvl) * 0.10)))
					proj.setup(self, game_world, w_ts, facing_dir, dmg, float(facing_dir) * (28.0 + float(i) * 5.0), -0.2, 28, is_last_attack_crit, kb_ts, true)
					proj.vel_y = 2.0 + float(i) * 4.5
					proj.position = global_position + Vector2(float(facing_dir) * 18.0, -4.0)
					parent_ts.add_child(proj)
			else:
				_damage_skill_aoe(global_position + Vector2(facing_dir * 80.0, 40.0), 95.0, 0.45 + float(lvl) * 0.10, 3)
			_play_skill_sfx("triple shot")
			attack_triggered.emit("triple shot", facing_dir)
			return true
		"arrow rain":
			if w_cls != "archer" or not spend_mp(level_mp(9)):
				return false
			is_ducking = false
			is_attacking = true
			current_attack_move = "arrow rain"
			if animator != null:
				animator.play("rain attack")
			var parent_ar: Node = _get_projectile_parent()
			var rain_count: int = 4 + lvl
			if parent_ar != null:
				var w_ar: String = str(equipment.get("weapon", ""))
				var kb_ar: float = 1.0 + float(get_skill_level("arrow knockback")) * 0.15
				for i: int in range(rain_count):
					var proj: Area2D = RangedProjectileScript.new()
					var dmg: int = maxi(1, int(float(_roll_attack_damage(get_attack_damage_range())) * (0.65 + float(lvl) * 0.12)))
					proj.setup(self, game_world, w_ar, facing_dir, dmg, float(facing_dir) * 3.0, 0.0, 32, is_last_attack_crit, kb_ar, true)
					proj.vel_y = 16.0 + float(i % 3) * 2.0
					proj.position = global_position + Vector2(float(facing_dir) * (65.0 + float(i) * 26.0), -220.0 - float(i % 2) * 35.0)
					parent_ar.add_child(proj)
			else:
				_damage_skill_aoe(global_position + Vector2(facing_dir * 120.0, 0.0), 115.0, 0.65 + float(lvl) * 0.12, 2)
			_play_skill_sfx("arrow rain")
			attack_triggered.emit("arrow rain", facing_dir)
			return true
		"piercing arrow":
			if w_cls != "archer" or not spend_mp(level_mp(6)):
				return false
			is_ducking = false
			is_attacking = true
			current_attack_move = "piercing arrow"
			_bow_charging = false
			if animator != null:
				animator.play("shoot bow")
			var parent_pa: Node = _get_projectile_parent()
			if parent_pa != null:
				var w_pa: String = str(equipment.get("weapon", ""))
				var kb_pa: float = 1.0 + float(get_skill_level("arrow knockback")) * 0.15
				var proj: Area2D = RangedProjectileScript.new()
				var dmg: int = maxi(1, int(float(_roll_attack_damage(get_attack_damage_range())) * (0.85 + float(lvl) * 0.13)))
				proj.piercing = true
				proj.max_hits = 3 + lvl
				proj.custom_modulate = Color(1.0, 0.30, 0.25, 1.0)
				proj.setup(self, game_world, w_pa, facing_dir, dmg, float(facing_dir) * 52.0, 0.0, 36, is_last_attack_crit, kb_pa, false)
				proj.position = global_position + Vector2(float(facing_dir) * 18.0, -4.0)
				parent_pa.add_child(proj)
			else:
				_damage_skill_aoe(global_position + Vector2(facing_dir * 120.0, 0.0), 130.0, 0.85 + float(lvl) * 0.13)
			_play_skill_sfx("piercing arrow")
			attack_triggered.emit("piercing arrow", facing_dir)
			return true
		"down crush":
			if w_cls != "archer" or not spend_mp(level_mp(3)):
				return false
			is_ducking = false
			is_attacking = true
			current_attack_move = "down stab"
			if animator != null:
				animator.play("down stab")
			vel_y = 14.0
			var dc_center: Vector2 = global_position + Vector2(0.0, 40.0)
			_damage_skill_aoe(dc_center, 85.0, 1.0 + float(lvl) * 0.18)
			_apply_passive_knockback(dc_center, 85.0, "archer")
			_play_skill_sfx("down crush")
			attack_triggered.emit("down crush", facing_dir)
			return true
		"circular attack":
			if not _has_any_magic_weapon() or not spend_mp(level_mp(10)):
				return false
			is_ducking = false
			is_attacking = true
			current_attack_move = "summon beam"
			if animator != null:
				animator.play("summon beam")
			var beam_pos: Vector2 = global_position + Vector2(float(facing_dir) * 80.0, 0.0)
			_spawn_beam_vfx(beam_pos)
			_damage_skill_aoe(beam_pos, 100.0 + float(lvl) * 4.0, 1.0 + float(lvl) * 0.18)
			_play_skill_sfx("circular attack")
			attack_triggered.emit("circular attack", facing_dir)
			return true
		"thunder attack":
			if not _has_any_magic_weapon() or not spend_mp(level_mp(23)):
				return false
			is_ducking = false
			is_attacking = true
			current_attack_move = "summon thunder"
			if animator != null:
				animator.play("summon thunder")
			var thunder_pos: Vector2 = global_position + Vector2(float(facing_dir) * 110.0, 0.0)
			_spawn_thunder_vfx(thunder_pos, mini(5, 2 + int(lvl / 3)))
			_damage_skill_aoe(thunder_pos, 120.0 + float(lvl) * 4.0, 0.90 + float(lvl) * 0.14)
			_play_skill_sfx("thunder attack")
			attack_triggered.emit("thunder attack", facing_dir)
			return true
		"grenade attack":
			if w_cls != "cowboy" or not spend_mp(level_mp(50)):
				return false
			is_ducking = false
			is_attacking = true
			current_attack_move = "grenade attack"
			if animator != null:
				animator.play("shoot gun")
			_spawn_grenade(false, lvl)
			_play_skill_sfx("grenade attack")
			attack_triggered.emit("grenade attack", facing_dir)
			return true
		"upward shoot":
			if w_cls != "cowboy" or lvl <= 1 or not spend_mp(level_mp(2)):
				return false
			is_ducking = false
			is_attacking = true
			current_attack_move = "upward shoot"
			if animator != null:
				animator.play("gun shoot upward")
			var parent_us: Node = _get_projectile_parent()
			if parent_us != null:
				var w_us: String = str(equipment.get("weapon", ""))
				var kb_us: float = 1.0 + float(get_skill_level("bullet knockback")) * 0.15
				var proj: Area2D = RangedProjectileScript.new()
				var dmg: int = maxi(1, int(float(_roll_attack_damage(get_attack_damage_range())) * (0.80 + float(lvl) * 0.12)))
				proj.setup(self, game_world, w_us, facing_dir, dmg, float(facing_dir) * 8.0, 0.0, 26, is_last_attack_crit, kb_us, false)
				proj.vel_y = -22.0
				proj.position = global_position + Vector2(float(facing_dir) * 14.0, -32.0)
				parent_us.add_child(proj)
			else:
				_damage_skill_aoe(global_position + Vector2(facing_dir * 75.0, -50.0), 85.0, 0.80 + float(lvl) * 0.12)
			_play_skill_sfx("upward shoot")
			attack_triggered.emit("upward shoot", facing_dir)
			return true
		"shotgun attack":
			if w_cls != "cowboy" or not spend_mp(50 * lvl):
				return false
			is_ducking = false
			is_attacking = true
			current_attack_move = "shotgun attack"
			if animator != null:
				animator.play("shoot gun")
			vel_x -= float(facing_dir) * 4.0
			var parent_sg: Node = _get_projectile_parent()
			var pellets: int = 3 + mini(4, int(lvl / 2))
			if parent_sg != null:
				var w_sg: String = str(equipment.get("weapon", ""))
				var kb_sg: float = 1.0 + float(get_skill_level("bullet knockback")) * 0.15
				for i: int in range(pellets):
					var proj: Area2D = RangedProjectileScript.new()
					var dmg: int = maxi(1, int(float(_roll_attack_damage(get_attack_damage_range())) * (0.45 + float(lvl) * 0.08)))
					proj.setup(self, game_world, w_sg, facing_dir, dmg, float(facing_dir) * 38.0, 0.0, 18, is_last_attack_crit, kb_sg, false)
					var spread_idx: float = float(i) - float(pellets - 1) * 0.5
					proj.vel_y = spread_idx * 1.4
					proj.position = global_position + Vector2(float(facing_dir) * 20.0, -4.0 + spread_idx * 3.0)
					parent_sg.add_child(proj)
			else:
				_damage_skill_aoe(global_position + Vector2(facing_dir * 90.0, 0.0), 100.0, 1.10 + float(lvl) * 0.18)
			_play_skill_sfx("shotgun attack")
			attack_triggered.emit("shotgun attack", facing_dir)
			return true
		"jump grenade":
			if w_cls != "cowboy" or not spend_mp(level_mp(5)):
				return false
			is_ducking = false
			vel_y = -11.0
			vel_x = -float(facing_dir) * 6.0
			on_ground = false
			if animator != null:
				animator.play("jumping")
			_spawn_grenade(true, lvl)
			_play_skill_sfx("jump grenade")
			attack_triggered.emit("jump grenade", facing_dir)
			return true
	return false


func _spawn_grenade(is_jump: bool, skill_lvl: int) -> void:
	var dmg_mult: float = (1.10 + float(skill_lvl) * 0.16) if is_jump else (1.20 + float(skill_lvl) * 0.20)
	var blast_radius: float = 95.0 if is_jump else 105.0
	var dmg: int = maxi(1, int(float(_roll_attack_damage(get_attack_damage_range())) * dmg_mult))
	var parent_node: Node = _get_projectile_parent()
	if parent_node == null:
		var fallback_pos: Vector2 = global_position + Vector2(facing_dir * (50.0 if is_jump else 130.0), 45.0 if is_jump else 0.0)
		_damage_skill_aoe(fallback_pos, blast_radius, dmg_mult)
		return

	var gren := GrenadeProjectileVFX.new()
	gren.creator = self
	gren.game_world = game_world
	gren.damage = dmg
	gren.is_crit = is_last_attack_crit
	gren.blast_radius = blast_radius
	gren.knockback_mult = 1.0 + float(get_skill_level("bullet knockback")) * 0.15
	gren.vel_x = float(facing_dir) * (4.0 if is_jump else 11.0)
	gren.vel_y = 6.0 if is_jump else -9.0
	gren.fuse_ticks = 9 if is_jump else 12
	gren.position = global_position + Vector2(float(facing_dir) * 16.0, 8.0 if is_jump else -10.0)
	parent_node.add_child(gren)


func _spawn_ring_vfx(world_pos: Vector2, col: Color, radius: float) -> void:
	var parent_node: Node = _get_projectile_parent()
	if parent_node == null:
		return
	var fx := SkillEffectNode.new()
	fx.kind = "ring"
	fx.effect_color = col
	fx.radius = radius
	fx.position = world_pos
	parent_node.add_child(fx)


func _spawn_beam_vfx(world_pos: Vector2) -> void:
	var parent_node: Node = _get_projectile_parent()
	if parent_node == null:
		return
	var fx := SkillEffectNode.new()
	fx.kind = "beam"
	fx.effect_color = Color(1.0, 0.92, 0.45, 0.9)
	fx.radius = 80.0
	fx.position = world_pos
	parent_node.add_child(fx)


func _spawn_thunder_vfx(world_pos: Vector2, bolts: int = 3) -> void:
	var parent_node: Node = _get_projectile_parent()
	if parent_node == null:
		return
	var fx := SkillEffectNode.new()
	fx.kind = "thunder"
	fx.effect_color = Color(0.55, 0.88, 1.0, 0.95)
	fx.radius = float(bolts)
	fx.position = world_pos
	parent_node.add_child(fx)


class GrenadeProjectileVFX extends Area2D:
	var creator: PersonEntity = null
	var game_world: Node = null
	var damage: int = 1
	var is_crit: bool = false
	var blast_radius: float = 100.0
	var knockback_mult: float = 1.0
	var vel_x: float = 0.0
	var vel_y: float = 0.0
	var fuse_ticks: int = 12
	var _ticks: int = 0
	var _accum: float = 0.0
	var _exploded: bool = false

	func _ready() -> void:
		collision_layer = 0
		collision_mask = 4 | 1
		var cs := CollisionShape2D.new()
		var circle := CircleShape2D.new()
		circle.radius = 12.0
		cs.shape = circle
		add_child(cs)

		var spr := Sprite2D.new()
		var img := Image.create(14, 14, false, Image.FORMAT_RGBA8)
		for y: int in range(14):
			for x: int in range(14):
				var d: float = Vector2(float(x) - 6.5, float(y) - 6.5).length()
				if d <= 6.2:
					img.set_pixel(x, y, Color(0.22, 0.25, 0.28, 1.0) if d > 2.5 else Color(0.95, 0.35, 0.15, 1.0))
		spr.texture = ImageTexture.create_from_image(img)
		add_child(spr)
		body_entered.connect(_on_body_entered)

	func _physics_process(delta: float) -> void:
		if _exploded:
			return
		_accum += delta
		while _accum >= 1.0 / 30.0:
			_accum -= 1.0 / 30.0
			_ticks += 1
			vel_y += 1.1
			position += Vector2(vel_x, vel_y)
			if _ticks >= fuse_ticks:
				_detonate()
				return

	func _on_body_entered(body: Node2D) -> void:
		if _exploded or body == creator:
			return
		if body.has_method("take_damage") and body.get("health") != null and int(body.get("health")) > 0:
			_detonate()
		elif body is TileMapLayer or body is StaticBody2D:
			vel_y = -absf(vel_y) * 0.45
			vel_x *= 0.6

	func _detonate() -> void:
		if _exploded:
			return
		_exploded = true
		if game_world != null and game_world.has_method("damage_enemies_in_range"):
			game_world.damage_enemies_in_range(global_position, blast_radius, damage, creator, is_crit)
		if creator != null and is_instance_valid(creator):
			creator._spawn_ring_vfx(global_position, Color(1.0, 0.55, 0.15, 0.9), blast_radius)
		queue_free()


class SkillEffectNode extends Node2D:
	var kind: String = "ring"
	var effect_color: Color = Color(1.0, 0.9, 0.4, 0.9)
	var radius: float = 70.0
	var _age: float = 0.0
	var _duration: float = 0.38

	func _ready() -> void:
		z_index = 20

	func _process(delta: float) -> void:
		_age += delta
		if _age >= _duration:
			queue_free()
			return
		queue_redraw()

	func _draw() -> void:
		var t: float = clampf(_age / _duration, 0.0, 1.0)
		var col: Color = effect_color
		col.a = effect_color.a * (1.0 - t)
		if kind == "beam":
			var w: float = lerp(28.0, 74.0, t)
			draw_rect(Rect2(-w * 0.5, -360.0, w, 400.0), Color(col.r, col.g, col.b, col.a * 0.45))
			draw_rect(Rect2(-w * 0.22, -360.0, w * 0.44, 400.0), col)
			draw_circle(Vector2(0, 18), lerp(20.0, radius, t), Color(col.r, col.g, col.b, col.a * 0.5))
		elif kind == "thunder":
			draw_circle(Vector2(0, -190.0), 42.0, Color(0.32, 0.36, 0.48, col.a * 0.75))
			draw_circle(Vector2(-26, -182.0), 28.0, Color(0.28, 0.32, 0.44, col.a * 0.75))
			draw_circle(Vector2(28, -182.0), 30.0, Color(0.28, 0.32, 0.44, col.a * 0.75))
			var bolt_cnt: int = maxi(1, int(radius))
			for b: int in range(bolt_cnt):
				var bx: float = (float(b) - float(bolt_cnt - 1) * 0.5) * 26.0
				var pts := PackedVector2Array([
					Vector2(bx, -170.0),
					Vector2(bx - 10.0, -110.0),
					Vector2(bx + 12.0, -55.0),
					Vector2(bx, 18.0)
				])
				draw_polyline(pts, col, 4.0)
		else:
			draw_arc(Vector2.ZERO, lerp(16.0, radius, t), 0.0, TAU, 28, col, 4.0)
			draw_circle(Vector2.ZERO, lerp(10.0, radius * 0.65, t), Color(col.r, col.g, col.b, col.a * 0.3))


func die() -> void:
	if is_dead:
		return
	is_dead = true
	is_attacking = false
	is_blocking = false
	is_ducking = false
	vel_x = 0.0
	vel_y = 0.0
	energy = 0

	if animator != null:
		animator.hold_frame("standing", 0)
		animator.rotation = -PI / 2.0 # Упасть на землю как в Flash (Person.as:758)
	if shadow_sprite != null:
		shadow_sprite.visible = false

	died.emit()

	if is_inside_tree():
		var timer: SceneTreeTimer = get_tree().create_timer(2.0)
		timer.timeout.connect(func() -> void:
			if is_instance_valid(self) and is_dead:
				respawn()
		)


func respawn() -> void:
	is_dead = false
	health = max_health
	mana = max_mana
	vel_x = 0.0
	vel_y = 0.0
	if spawn_position != Vector2.ZERO:
		global_position = spawn_position
	if animator != null:
		animator.rotation = 0.0
		animator.play("standing")
	if shadow_sprite != null:
		shadow_sprite.visible = on_ground
	health_changed.emit(health, max_health)
	mp_changed.emit(mana, max_mana)
