extends GravityBody
class_name EnemyEntity
## EnemyEntity — Сущность врага / монстра (порт com.game_objects.enemies.Enemy.as и EnemyAI.as).
## Загружает характеристики из StatsDB.get_enemy_data(), анимации из SwfSpriteLoader,
## реализует базовый ИИ движения, получение урона, анимацию смерти и дроп лута.

const FloatingDamageRef = preload("res://scripts/effects/FloatingDamage.gd")

@export var enemy_type: String = "green bouncer"

# Таблица хитбоксов из com/game_objects/enemies/*.as (передаются в HitTester.as:43-55 как Rectangle(x, y, w, h))
const ENEMY_HITBOXES: Dictionary = {
	"aipster": Rect2(-26, -57, 74, 120), # Aipster.as:10
	"dark beholder": Rect2(-129, -325, 188, 314), # Beholder.as:10
	"bionic bird": Rect2(-69, -72, 101, 76), # BionicBird.as:13
	"block bot": Rect2(-30, -92, 56, 97), # BlockBot.as:10
	"bouncing mushroom": Rect2(-29, -100, 52, 111), # BouncingMushroom.as:14
	"brick monster": Rect2(-68, -161, 114, 162), # BrickMonster.as:10
	"bullopede": Rect2(-216, -189, 645, 204), # Bullopede.as:10
	"Carnelia": Rect2(-105, -239, 239, 296), # Carnelia.as:10
	"chirplet": Rect2(-34, -52, 69, 68), # Chirplet.as:13
	"crab": Rect2(-26, -35, 59, 43), # Crab.as:10
	"drill bot": Rect2(-61, -153, 119, 153), # DrillBot.as:10
	"fishurn": Rect2(-21, -58, 47, 65), # Fishurn.as:10
	"flockling": Rect2(-20, -31, 83, 63), # Flockling.as:13
	"giant goo cube": Rect2(-187, -242, 365, 256), # GiantGooCube.as:10
	"glord": Rect2(-101, -194, 212, 195), # Glord.as:10
	"goo cube": Rect2(-97, -145, 206, 142), # GooCube.as:10
	"great frog": Rect2(-32, -83, 75, 101), # GreatFrog.as:10
	"green bouncer": Rect2(-16, -32, 34, 31), # GreenBouncer.as:14
	"green walker": Rect2(-22, -34, 51, 42), # GreenWalker.as:10
	"horned monster": Rect2(-23, -57, 40, 64), # HornedMonster.as:10
	"kraken": Rect2(-95, -364, 241, 369), # Kraken.as:10
	"kraw": Rect2(-44, -59, 87, 71), # Kraw.as:13
	"kreeton": Rect2(-106, -210, 193, 202), # Kreeton.as:10
	"Kreetus": Rect2(-111, -314, 211, 354), # Kreetus.as:11
	"leaflet": Rect2(-22, -29, 41, 34), # Leaflet.as:10
	"leafling": Rect2(-29, -98, 58, 104), # Leafling.as:10
	"lotus eye": Rect2(-96, -173, 176, 171), # LotusEye.as:10
	"magmagon": Rect2(-161, -383, 374, 357), # Magmagon.as:10
	"mongrel": Rect2(-153, -4, 450, 356), # Mongrel.as:10
	"mushroom ball": Rect2(-21, -40, 42, 50), # MushroomBall.as:13
	"mushroom bird": Rect2(-39, -89, 104, 86), # MushroomBird.as:13
	"mushroom squish": Rect2(-22, -37, 44, 45), # MushroomSquish.as:10
	"night stalker": Rect2(-35, -96, 80, 105), # Nightstalker.as:10
	"omega fluff": Rect2(-150, -300, 275, 385), # OmegaFluff.as:10
	"orange crazy": Rect2(-22, -50, 50, 60), # OrangeCrazy.as:10
	"penguin": Rect2(-22, -75, 45, 81), # Penguin.as:10
	"plant monster": Rect2(-25, -97, 57, 107), # PlantMonster.as:10
	"proteum": Rect2(-202, -288, 431, 306), # Proteum.as:10
	"pumpkin creeper": Rect2(-31, -53, 67, 59), # PumpkinCreeper.as:10
	"purple goo": Rect2(-14, -24, 31, 33), # PurpleGoo.as:14
	"red bouncer": Rect2(-16, -20, 38, 29), # RedBouncer.as:14
	"repguana": Rect2(-198, -243, 416, 240), # Repguana.as:10
	"sasquatch": Rect2(-28, -137, 87, 146), # Sasquatch.as:10
	"titanium vulture": Rect2(-272, -359, 411, 333), # TitaniumVulture.as:13
	"yellow hairy monster": Rect2(-16, -37, 33, 43), # YellowHairyMonster.as:10
	"yellow puff monster": Rect2(-26, -81, 62, 89), # YellowPuffMonster.as:10
}

const BOUNCER_TYPES: PackedStringArray = [
	"green bouncer", "red bouncer", "purple goo", "bouncing mushroom"
]
const FLYER_TYPES: PackedStringArray = [
	"bionic bird", "titanium vulture", "chirplet", "flockling", "kraw", "mushroom bird"
]
const DASH_ENEMY_TYPES: PackedStringArray = [
	"crab", "night stalker", "drill bot", "repguana", "proteum",
	"mongrel", "magmagon", "bullopede", "omega fluff"
]
const SELF_HEAL_BOSS_TYPES: PackedStringArray = [
	"Carnelia", "giant goo cube", "Kreetus"
]
const RANGED_ENEMY_TYPES: PackedStringArray = [
	"dark beholder", "lotus eye"
]

# Статы врага
var health: int = 18
var max_health: int = 18
var defense_stat: int = 2
var power_stat: int = 6
var move_speed_stat: float = 3.2
var jump_power_stat: float = 14.0
var xp_reward: int = 6
var worth: int = 2
var display_height_scale: float = 2.6

# Параметры ИИ
var move_dir: int = 1
var _saved_move_dir: int = 1
var ai_is_paused: bool = false
var wall_turn_cooldown: int = 0
var dir_change_timer: float = 0.0
var dir_change_interval: float = 2.5
var target_player: Node2D = null
var has_dash: bool = false
var dash_cooldown: int = 0
var dash_timer: int = 0

# Визуализация и хитбокс контакта
var sprite: AnimatedSprite2D = null
var collision_shape: CollisionShape2D = null
var hit_area: Area2D = null
var contact_damage_cooldown: int = 0
var shadow_sprite: Sprite2D = null
var health_bar: FloatingHealthBar = null

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


class FloatingHealthBar extends Node2D:
	var current_hp: int = 18
	var max_hp: int = 18

	func update_bar(cur: int, max_val: int) -> void:
		current_hp = cur
		max_hp = max_val
		queue_redraw()

	func _draw() -> void:
		var bar_w: float = 38.0
		var bar_h: float = 4.0
		var half_w: float = bar_w * 0.5
		# Border
		draw_rect(Rect2(-half_w - 1.0, -1.0, bar_w + 2.0, bar_h + 2.0), Color(0.0, 0.0, 0.0, 0.9), true)
		# Dark background
		draw_rect(Rect2(-half_w, 0.0, bar_w, bar_h), Color(0.25, 0.05, 0.05, 0.9), true)
		# Health fill
		var ratio: float = clampf(float(current_hp) / maxf(1.0, float(max_hp)), 0.0, 1.0)
		if ratio > 0.0:
			var fill_color: Color = Color(0.2, 0.85, 0.2, 0.95)
			if ratio < 0.25:
				fill_color = Color(0.9, 0.2, 0.2, 0.95)
			elif ratio < 0.5:
				fill_color = Color(0.95, 0.75, 0.1, 0.95)
			draw_rect(Rect2(-half_w, 0.0, bar_w * ratio, bar_h), fill_color, true)

static var _cached_projectile_tex: Texture2D = null

static func _get_projectile_texture() -> Texture2D:
	if _cached_projectile_tex != null:
		return _cached_projectile_tex
	var img: Image = Image.create(16, 16, false, Image.FORMAT_RGBA8)
	var center: Vector2 = Vector2(8.0, 8.0)
	for y: int in range(16):
		for x: int in range(16):
			var d: float = Vector2(float(x) + 0.5, float(y) + 0.5).distance_to(center) / 7.5
			if d < 1.0:
				var alpha: float = clampf((1.0 - d) * 1.8, 0.0, 1.0)
				var col: Color = Color(0.95, 0.25, 0.85, alpha).lerp(Color(1.0, 0.9, 1.0, alpha), clampf(1.0 - d * 1.5, 0.0, 1.0))
				img.set_pixel(x, y, col)
	_cached_projectile_tex = ImageTexture.create_from_image(img)
	return _cached_projectile_tex


class EnemyProjectile extends Area2D:
	var velocity: Vector2 = Vector2.ZERO
	var damage: int = 10
	var lifetime: float = 3.0

	func _ready() -> void:
		collision_layer = 0
		collision_mask = 2
		var shape_node: CollisionShape2D = CollisionShape2D.new()
		var circle: CircleShape2D = CircleShape2D.new()
		circle.radius = 10.0
		shape_node.shape = circle
		add_child(shape_node)

		var spr: Sprite2D = Sprite2D.new()
		spr.texture = EnemyEntity._get_projectile_texture()
		add_child(spr)

	func _physics_process(delta: float) -> void:
		position += velocity * delta
		lifetime -= delta
		if lifetime <= 0.0:
			queue_free()
			return
		for body: Node2D in get_overlapping_bodies():
			if body.has_method("take_damage") and bool(body.get("is_local_player")):
				body.take_damage(damage)
				queue_free()
				return


signal enemy_damaged(cur_hp: int, max_hp: int)
signal enemy_died(enemy: EnemyEntity)

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

func _ready() -> void:
	_init_stats()
	_setup_collision()
	_setup_drop_shadow()
	_setup_sprite()
	_setup_health_bar()


func _setup_drop_shadow() -> void:
	shadow_sprite = Sprite2D.new()
	shadow_sprite.name = "DropShadow"
	shadow_sprite.texture = _get_shadow_texture()
	shadow_sprite.z_index = -1
	shadow_sprite.position = Vector2(0.0, hit_offset.y + body_height)
	add_child(shadow_sprite)


func _setup_health_bar() -> void:
	health_bar = FloatingHealthBar.new()
	health_bar.name = "HealthBar"
	health_bar.position = Vector2(0.0, minf(-52.0, hit_offset.y - 10.0))
	health_bar.z_index = 2
	add_child(health_bar)
	health_bar.update_bar(health, max_health)


func _normalize_enemy_key(raw_key: String) -> String:
	var spaced: String = ""
	var cleaned: String = raw_key.replace("_", " ").strip_edges()
	for i: int in range(cleaned.length()):
		var ch: String = cleaned[i]
		if i > 0 and ch == ch.to_upper() and ch != ch.to_lower() and cleaned[i - 1] != " ":
			spaced += " "
		spaced += ch.to_lower()
	return spaced.strip_edges()


func _init_stats() -> void:
	var sdb: Node = _get_stats_db()
	var stats: Dictionary = sdb.get_enemy_data(enemy_type)
	if stats.is_empty():
		var normalized: String = _normalize_enemy_key(enemy_type)
		stats = sdb.get_enemy_data(normalized)
	if not stats.is_empty():
		enemy_type = str(stats.get("key", enemy_type))
		health = int(stats.get("h", 18))
		max_health = health
		defense_stat = int(stats.get("d", 2))
		power_stat = int(stats.get("p", 6))
		move_speed_stat = float(stats.get("s", 3.2))
		jump_power_stat = float(stats.get("jump", 14.0))
		xp_reward = int(stats.get("xp", 6))
		worth = int(stats.get("w", 2))
		display_height_scale = float(stats.get("height", 2.6))
	if enemy_type in FLYER_TYPES or enemy_type in ["Carnelia", "Kreetus"]:
		do_apply_gravity = false
	has_dash = (enemy_type in DASH_ENEMY_TYPES)


func _get_hitbox_rect() -> Rect2:
	if ENEMY_HITBOXES.has(enemy_type):
		return ENEMY_HITBOXES[enemy_type]
	var low_type: String = enemy_type.to_lower()
	for k: Variant in ENEMY_HITBOXES.keys():
		if str(k).to_lower() == low_type:
			return ENEMY_HITBOXES[k]
	var swf: Node = _get_swf_loader()
	if swf != null and swf.has_method("get_enemy_sprite_frames"):
		var frames: SpriteFrames = swf.get_enemy_sprite_frames(enemy_type)
		if frames != null and frames.has_animation("default") and frames.get_frame_count("default") > 0:
			var tex: Texture2D = frames.get_frame_texture("default", 0)
			if tex != null:
				var sz: Vector2 = tex.get_size()
				if sz.x > 0.0 and sz.y > 0.0:
					return Rect2(-sz.x * 0.5, -sz.y, sz.x, sz.y)
	var fallback_h: float = maxf(24.0, display_height_scale * 10.0)
	return Rect2(-fallback_h * 0.5, -fallback_h, fallback_h, fallback_h)


func _setup_collision() -> void:
	# Враги не сталкиваются физически с игроком и другими врагами (только с картой)
	collision_layer = 4
	collision_mask = 1 | ONE_WAY_PLATFORM_BIT

	collision_shape = CollisionShape2D.new()
	# HitTester.as:43-55: hit_rect = Rectangle(x, y, w, h), hitOffsetX = x, hitOffsetY = y
	var hb: Rect2 = _get_hitbox_rect()
	hit_offset = hb.position
	body_width = hb.size.x
	body_height = hb.size.y

	var rect: RectangleShape2D = RectangleShape2D.new()
	rect.size = hb.size
	collision_shape.shape = rect
	collision_shape.position = hb.position + hb.size * 0.5
	add_child(collision_shape)

	# Area2D для контактного урона игроку (GameMain.as:13026, counter % 32 == 0)
	hit_area = Area2D.new()
	hit_area.name = "HitArea"
	hit_area.collision_layer = 0
	hit_area.collision_mask = 2
	var area_shape: CollisionShape2D = CollisionShape2D.new()
	area_shape.shape = rect
	area_shape.position = hb.position + hb.size * 0.5
	hit_area.add_child(area_shape)
	add_child(hit_area)


func _setup_sprite() -> void:
	sprite = AnimatedSprite2D.new()
	sprite.name = "EnemySprite"
	sprite.position = Vector2(0, -24)
	add_child(sprite)

	var swf: Node = _get_swf_loader()
	var frames: SpriteFrames = swf.get_enemy_sprite_frames(enemy_type)
	if frames != null:
		sprite.sprite_frames = frames
		sprite.animation_finished.connect(_on_sprite_animation_finished)
		_align_sprite_to_hitbox(frames)
		_update_locomotion_animation()


func _align_sprite_to_hitbox(frames: SpriteFrames) -> void:
	if sprite == null or frames == null:
		return
	var ref_tex: Texture2D = null
	for anim_name: String in ["standing", "default", "running"]:
		if frames.has_animation(anim_name) and frames.get_frame_count(anim_name) > 0:
			ref_tex = frames.get_frame_texture(anim_name, 0)
			if ref_tex != null:
				break
	if ref_tex == null:
		for anim_name: String in frames.get_animation_names():
			if frames.get_frame_count(anim_name) > 0:
				ref_tex = frames.get_frame_texture(anim_name, 0)
				if ref_tex != null:
					break
	if ref_tex != null:
		var tex_h: float = ref_tex.get_size().y
		if tex_h > 0.0:
			sprite.position = Vector2(0.0, (hit_offset.y + body_height) - tex_h * 0.5)


func get_world_hitbox() -> Rect2:
	return Rect2(global_position + hit_offset, Vector2(body_width, body_height))


var _is_playing_hit: bool = false
var _hit_tween: Tween = null


func _on_sprite_animation_finished() -> void:
	if sprite != null and sprite.animation == "hit":
		_is_playing_hit = false
		_update_locomotion_animation()


func _update_locomotion_animation() -> void:
	if sprite == null or sprite.sprite_frames == null:
		return
	if _is_playing_hit:
		return
	var target_anim: String = "default"
	if not on_ground and sprite.sprite_frames.has_animation("jump"):
		target_anim = "jump"
	elif sprite.sprite_frames.has_animation("walk"):
		target_anim = "walk"
	if sprite.animation != target_anim or not sprite.is_playing():
		sprite.play(target_anim)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if health > 0:
		_process_ai(delta)

	_update_locomotion_animation()

	if shadow_sprite != null:
		shadow_sprite.visible = on_ground

	if contact_damage_cooldown > 0:
		contact_damage_cooldown -= 1
	if health > 0 and hit_area != null and tick_counter % 32 == 0 and contact_damage_cooldown == 0:
		for body: Node2D in hit_area.get_overlapping_bodies():
			if body != self and body.has_method("take_damage") and bool(body.get("is_local_player")):
				body.take_damage(power_stat)
				contact_damage_cooldown = 32
				break


func _get_target_player() -> Node2D:
	if target_player != null and is_instance_valid(target_player):
		var hp_val: Variant = target_player.get("health")
		if hp_val == null or int(hp_val) > 0:
			return target_player
	if game_world != null and "local_player" in game_world:
		var lp: Variant = game_world.get("local_player")
		if lp is Node2D and is_instance_valid(lp):
			target_player = lp as Node2D
			return target_player
	var parent_node: Node = get_parent()
	if parent_node != null:
		var best_player: Node2D = null
		var best_dist: float = INF
		for child: Node in parent_node.get_children():
			if child != self and child is Node2D and bool(child.get("is_local_player")):
				var c_hp: Variant = child.get("health")
				if c_hp != null and int(c_hp) <= 0:
					continue
				var d: float = global_position.distance_squared_to((child as Node2D).global_position)
				if d < best_dist:
					best_dist = d
					best_player = child as Node2D
		if best_player != null:
			target_player = best_player
			return target_player
	return null


func _process_patrol_direction(delta: float) -> void:
	if is_on_wall() and wall_turn_cooldown == 0:
		if move_dir != 0:
			move_dir = -move_dir
		else:
			move_dir = -_saved_move_dir if _saved_move_dir != 0 else 1
		_saved_move_dir = move_dir
		ai_is_paused = false
		dir_change_timer = 0.0
		wall_turn_cooldown = 15

	dir_change_timer += delta
	if dir_change_timer >= dir_change_interval:
		dir_change_timer = 0.0
		ai_is_paused = false
		move_dir = -move_dir if move_dir != 0 else (-_saved_move_dir if _saved_move_dir != 0 else 1)
		_saved_move_dir = move_dir
		var base_interval: float = clampf(300.0 / (maxf(move_speed_stat, 1.0) * 15.0) / 30.0, 0.5, 1.8)
		dir_change_interval = base_interval * randf_range(0.85, 1.15)


func _process_flyer_ai(delta: float) -> void:
	var player: Node2D = _get_target_player()
	var aggro_range: float = 850.0 if enemy_type == "titanium vulture" else 650.0
	var is_chasing: bool = false
	var max_fly_speed: float = minf(move_speed_stat * 2.0, 12.0)
	if player != null:
		var target_pos: Vector2 = player.global_position + Vector2(0.0, -32.0)
		var to_player: Vector2 = target_pos - global_position
		if to_player.length() <= aggro_range:
			is_chasing = true
			var dir_vec: Vector2 = to_player.normalized() if to_player.length_squared() > 1.0 else Vector2.ZERO
			var accel: float = move_speed_stat / 4.0
			vel_x += dir_vec.x * accel
			vel_y += dir_vec.y * accel
			if absf(dir_vec.x) > 0.05:
				move_dir = 1 if dir_vec.x > 0.0 else -1

	if not is_chasing:
		_process_patrol_direction(delta)
		var accel_x: float = (move_speed_stat / 4.0) * float(move_dir)
		vel_x += accel_x
		vel_y = sin(float(tick_counter) * 0.08) * 1.2

	var fly_vel := Vector2(vel_x, vel_y)
	if fly_vel.length() > max_fly_speed:
		fly_vel = fly_vel.normalized() * max_fly_speed
		vel_x = fly_vel.x
		vel_y = fly_vel.y

	if sprite != null and move_dir != 0:
		sprite.flip_h = (move_dir < 0)


func _fire_ranged_projectile(target: Node2D) -> void:
	var parent_node: Node = get_parent()
	if parent_node == null or target == null:
		return
	var spawn_pos: Vector2 = global_position + Vector2(0.0, -body_height * 0.5)
	var aim_pos: Vector2 = target.global_position + Vector2(0.0, -32.0)
	var dir_vec: Vector2 = (aim_pos - spawn_pos).normalized()
	if dir_vec == Vector2.ZERO:
		dir_vec = Vector2(float(move_dir if move_dir != 0 else 1), 0.0)
	var proj: EnemyProjectile = EnemyProjectile.new()
	proj.position = spawn_pos
	proj.velocity = dir_vec * 360.0
	proj.damage = power_stat
	parent_node.add_child(proj)
	if sprite != null and absf(dir_vec.x) > 0.05:
		sprite.flip_h = (dir_vec.x < 0.0)


func _process_ai(delta: float) -> void:
	if wall_turn_cooldown > 0:
		wall_turn_cooldown -= 1
	if dash_cooldown > 0:
		dash_cooldown -= 1
	if dash_timer > 0:
		dash_timer -= 1

	# GameMain.as:13030-13065: периодическое самолечение боссов
	if enemy_type in SELF_HEAL_BOSS_TYPES and tick_counter % 60 == 0 and health > 0 and health < max_health:
		var heal_amt: int = maxi(1, int(max_health / 500))
		health = mini(max_health, health + heal_amt)
		if health_bar != null:
			health_bar.update_bar(health, max_health)

	# Ranged/cannon projectile behavior (dark beholder, lotus eye)
	if enemy_type in RANGED_ENEMY_TYPES and tick_counter % 90 == 0:
		var ranged_target: Node2D = _get_target_player()
		if ranged_target != null and global_position.distance_to(ranged_target.global_position) <= 650.0:
			_fire_ranged_projectile(ranged_target)

	# BionicBirdAI.as, TitaniumVultureAI.as: летающие враги
	if enemy_type in FLYER_TYPES:
		_process_flyer_ai(delta)
		return

	# EnemyAI.as:27-58 (basicMovement) + паузы ИИ (Enemy.as:159-162) + разворот от стены (Enemy.as:217-221)
	if enemy_type == "Carnelia":
		move_dir = -1
	elif enemy_type == "Kreetus":
		# Kreetus.as:18-27: цикл 24-тиковой паузы движения
		if (tick_counter / 24) % 2 == 0:
			move_dir = 1
			ai_is_paused = false
		else:
			move_dir = 0
			ai_is_paused = true
			vel_x = 0.0
	else:
		_process_patrol_direction(delta)

	if sprite != null and move_dir != 0:
		sprite.flip_h = (move_dir < 0)

	# Enemy.as __hasDash: периодический короткий рывок на земле
	if has_dash and on_ground and move_dir != 0 and dash_cooldown == 0 and tick_counter % 90 == 0:
		dash_timer = 12
		dash_cooldown = 90

	# Enemy.as:254-287 + Enemy.as:442: умеренное ускорение на земле и ограничение скорости, чтобы мобы не обгоняли игрока (~9.05 px/tick)
	var is_dashing: bool = (dash_timer > 0 and move_dir != 0)
	var accel_x: float = move_speed_stat * 0.48 * (2.0 if is_dashing else 1.0) * float(move_dir)
	var max_ground_speed: float = minf(move_speed_stat * (3.2 if is_dashing else 2.2), 14.0 if is_dashing else 8.8)
	if on_ground:
		vel_x = clampf(vel_x + accel_x, -max_ground_speed, max_ground_speed)
	elif absf(vel_x) < max_ground_speed:
		vel_x = clampf(vel_x + accel_x * 0.5, -max_ground_speed, max_ground_speed)

	# BouncingMushroomAI.as, PurpleGooAI.as, RedBouncerAI.as, GreenBouncer.as
	if enemy_type in BOUNCER_TYPES:
		if on_ground and absf(vel_x) > 0.1:
			jump(jump_power_stat)
		vel_x *= 0.95
	# MushroomBallAI.as: прыжок каждые 180 тиков на земле
	elif enemy_type == "mushroom ball":
		if on_ground and tick_counter % 180 == 0:
			jump(jump_power_stat)


## Получение урона
func take_damage(damage: int, attacker: Node2D = null, is_crit: bool = false, is_avoided: bool = false, knockback_mult: float = 1.0) -> void:
	if health <= 0:
		return

	var net_dmg: int = 0 if is_avoided else (0 if damage <= 0 else maxi(1, damage - defense_stat))
	if get_parent() != null:
		FloatingDamageRef.spawn_damage(
			get_parent(),
			net_dmg,
			Vector2(global_position.x, global_position.y - body_height * 0.5),
			false,
			is_crit,
			is_avoided
		)

	if is_avoided:
		return

	health -= net_dmg
	if health_bar != null:
		health_bar.update_bar(health, max_health)
	enemy_damaged.emit(health, max_health)

	# Отбрасывание
	if attacker != null and knockback_mult > 0.0:
		var push_dir: float = sign(global_position.x - attacker.global_position.x)
		if push_dir == 0.0:
			push_dir = 1.0
		vel_x = push_dir * 8.0 * knockback_mult
		vel_y = -6.0 * knockback_mult
		on_ground = false

	# Анимация получения урона из оригинала (GameMain.as:3176-3197):
	# 1) Клип "hit" (у 42/46 монстров с FrameLabel "hit")
	# 2) Bounce.easeOut сквош/растяжение scale (0.7, 1.3) -> (1.0, 1.0) за 0.5s
	if sprite != null:
		if sprite.sprite_frames != null and sprite.sprite_frames.has_animation("hit"):
			_is_playing_hit = true
			sprite.play("hit")
			sprite.frame = 0
		if _hit_tween != null and is_instance_valid(_hit_tween):
			_hit_tween.kill()
		sprite.scale = Vector2(0.7, 1.3)
		_hit_tween = create_tween()
		_hit_tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		_hit_tween.tween_property(sprite, "scale", Vector2.ONE, 0.5)

	var amgr: Node = get_node_or_null("/root/AudioManager")
	if amgr != null and amgr.has_method("play_sfx"):
		amgr.call("play_sfx", "hit")

	if health <= 0:
		die()


func die() -> void:
	health = 0
	if xp_reward > 0 and get_parent() != null:
		FloatingDamageRef.spawn_xp(get_parent(), xp_reward, Vector2(global_position.x, global_position.y - 50.0))
	enemy_died.emit(self)
	# Спавн дропа обрабатывается GameWorld._on_enemy_died; fallback только если GameWorld без обработчика
	if game_world != null and not game_world.has_method("_on_enemy_died") and game_world.has_method("spawn_enemy_loot"):
		game_world.spawn_enemy_loot(global_position, enemy_type)

	# Исчезновение
	queue_free()
