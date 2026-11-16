extends Node2D
class_name BodyAnimatorNode
## BodyAnimatorNode — Порт скелетного аниматора персонажа (BodyAnimator.as, 2,953 строк).
## Управляет 15 слоями персонажа из атласа items_pets_bodies:
##   accessory, weaponRight (off-hand/shield), handRight, rightArm, rightLeg,
##   leftLeg, body (shirt), head, eyes, hair, helmet, leftArm, weaponLeft (main), handLeft.
## Применяет трансформации Matrix (a, b, c, d, tx, ty) и itemOffsets из body_animator_data.json.

signal animation_finished(anim_name: String)
signal frame_changed(current_frame: int)

const BARE_ARM_SHIRTS: Array[String] = [
	"white shirt",
	"none",
	"coconut armor",
	"archer shirt",
	"bronze plate armor",
	"super hero shirt",
	"ballerina outfit",
]
const BARE_LEG_PANTS: Array[String] = [
	"none",
	"green shorts",
	"bronze plate legs",
	"ballerina stockings",
]

# Слои персонажа (узлы Flash DisplayObject / Sprite2D)
var accessory_sprite: Node2D = null
var accessory_image: Sprite2D = null
var weapon_right_sprite: Node2D = null
var weapon_right_image: Sprite2D = null
var hand_right_image: Sprite2D = null
var right_arm_sprite: Node2D = null
var right_arm_bare_image: Sprite2D = null
var right_arm_image: Sprite2D = null
var right_leg_sprite: Node2D = null
var right_leg_bare_image: Sprite2D = null
var right_leg_image: Sprite2D = null
var shoe_right_image: Sprite2D = null
var left_leg_sprite: Node2D = null
var left_leg_bare_image: Sprite2D = null
var left_leg_image: Sprite2D = null
var shoe_left_image: Sprite2D = null
var body_sprite: Node2D = null
var body_image: Sprite2D = null
var head_sprite: Node2D = null
var head_image: Sprite2D = null
var eyes_image: Sprite2D = null
var hair_image: Sprite2D = null
var beard_image: Sprite2D = null
var helmet_image: Sprite2D = null
var left_arm_sprite: Node2D = null
var left_arm_bare_image: Sprite2D = null
var left_arm_image: Sprite2D = null
var weapon_left_sprite: Node2D = null
var weapon_left_image: Sprite2D = null
var hand_left_image: Sprite2D = null

# Данные анимаций из StatsDB / body_animator_data.json
var anim_data: Dictionary = {}
var matrices_data: Dictionary = {}
var animations_meta: Dictionary = {}
var item_offsets: Dictionary = {}

# Состояние аниматора
var current_frame: int = 0
var current_anim_name: String = "standing"
var is_playing: bool = true
var is_looping: bool = true
var anim_start_frame: int = 0
var anim_end_frame: int = 49

# Параметры внешнего вида (пустые по умолчанию; BodyAnimator.as:219-231)
var skin_id: int = 1
var gender: String = "male"
var eyes_id: int = 1
var hair_id: int = 1
var beard_id: int = 0
var helmet_name: String = ""
var shirt_name: String = ""
var pants_name: String = ""
var shoe_name: String = ""
var weapon_main_name: String = ""
var weapon_off_name: String = ""
var accessory_name: String = ""

# Переопределения циклов и стоп-кадров по PersonFrameHandler.as:534-543, Person.as:525, 554-561
const LOOP_FRAME_OVERRIDES: Dictionary = {
	"running": {"start": 50, "end": 74},
	"jumping": {"start": 214, "end": 229},
}
const BLOCK_HOLD_FRAME: int = 857
const DUCK_HOLD_FRAME: int = 99

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

func _ready() -> void:
	_init_layers()
	_load_anim_data()
	apply_appearance()
	play("standing")


static func _new_sprite(sprite_name: String) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.name = sprite_name
	sprite.centered = false
	return sprite


func _init_layers() -> void:
	# Порядок добавления слоев (Flash depth order из BodyAnimator.as:637-725)
	accessory_sprite = Node2D.new()
	accessory_sprite.name = "Accessory"
	accessory_image = _new_sprite("AccessoryImg")
	accessory_image.visible = false
	accessory_sprite.add_child(accessory_image)
	add_child(accessory_sprite)

	weapon_right_sprite = Node2D.new()
	weapon_right_sprite.name = "WeaponRight"
	weapon_right_image = _new_sprite("WeaponRightImg")
	hand_right_image = _new_sprite("HandRightImg")
	weapon_right_sprite.add_child(weapon_right_image)
	weapon_right_sprite.add_child(hand_right_image)
	add_child(weapon_right_sprite)

	right_arm_sprite = Node2D.new()
	right_arm_sprite.name = "RightArm"
	right_arm_bare_image = _new_sprite("RightArmBareImg")
	right_arm_bare_image.visible = false
	right_arm_image = _new_sprite("RightArmImg")
	right_arm_sprite.add_child(right_arm_bare_image)
	right_arm_sprite.add_child(right_arm_image)
	add_child(right_arm_sprite)

	right_leg_sprite = Node2D.new()
	right_leg_sprite.name = "RightLeg"
	shoe_right_image = _new_sprite("ShoeRightImg")
	right_leg_bare_image = _new_sprite("RightLegBareImg")
	right_leg_bare_image.visible = false
	right_leg_image = _new_sprite("RightLegImg")
	right_leg_sprite.add_child(shoe_right_image)
	right_leg_sprite.add_child(right_leg_bare_image)
	right_leg_sprite.add_child(right_leg_image)
	add_child(right_leg_sprite)

	left_leg_sprite = Node2D.new()
	left_leg_sprite.name = "LeftLeg"
	shoe_left_image = _new_sprite("ShoeLeftImg")
	left_leg_bare_image = _new_sprite("LeftLegBareImg")
	left_leg_bare_image.visible = false
	left_leg_image = _new_sprite("LeftLegImg")
	left_leg_sprite.add_child(shoe_left_image)
	left_leg_sprite.add_child(left_leg_bare_image)
	left_leg_sprite.add_child(left_leg_image)
	add_child(left_leg_sprite)

	body_sprite = Node2D.new()
	body_sprite.name = "Body"
	body_image = _new_sprite("BodyImg")
	body_sprite.add_child(body_image)
	add_child(body_sprite)

	head_sprite = Node2D.new()
	head_sprite.name = "Head"
	head_image = _new_sprite("HeadImg")
	beard_image = _new_sprite("BeardImg")
	eyes_image = _new_sprite("EyesImg")
	hair_image = _new_sprite("HairImg")
	helmet_image = _new_sprite("HelmetImg")
	head_sprite.add_child(head_image)
	head_sprite.add_child(beard_image)
	head_sprite.add_child(eyes_image)
	head_sprite.add_child(hair_image)
	head_sprite.add_child(helmet_image)
	add_child(head_sprite)

	left_arm_sprite = Node2D.new()
	left_arm_sprite.name = "LeftArm"
	left_arm_bare_image = _new_sprite("LeftArmBareImg")
	left_arm_bare_image.visible = false
	left_arm_image = _new_sprite("LeftArmImg")
	left_arm_sprite.add_child(left_arm_bare_image)
	left_arm_sprite.add_child(left_arm_image)
	add_child(left_arm_sprite)

	weapon_left_sprite = Node2D.new()
	weapon_left_sprite.name = "WeaponLeft"
	weapon_left_image = _new_sprite("WeaponLeftImg")
	hand_left_image = _new_sprite("HandLeftImg")
	weapon_left_sprite.add_child(weapon_left_image)
	weapon_left_sprite.add_child(hand_left_image)
	add_child(weapon_left_sprite)


func _load_anim_data() -> void:
	var sdb: Node = _get_stats_db()
	anim_data = sdb.get_body_anim_data()
	if anim_data.is_empty():
		return
	matrices_data = anim_data.get("matrices", {})
	animations_meta = anim_data.get("animationsByName", {})
	item_offsets = anim_data.get("itemOffsets", {})


## Обновляет текстуры и Starling-координаты всех частей тела персонажа
func apply_appearance() -> void:
	var atlas: Node = _get_atlas_loader()
	var sdb: Node = _get_stats_db()
	atlas.register_starling_atlas("items_pets_bodies")

	# Голова и лицо (BodyAnimator.as:690-703, 1738-1745, 1796-1833, 1987-2050)
	var head_tex_name: String = "zombie head" if skin_id == 5 else "%s head %d" % [gender, skin_id]
	head_image.texture = atlas.get_starling_texture("items_pets_bodies", head_tex_name)
	_apply_unpivoted_pose(head_image, Vector2(-14.0, -13.0))

	eyes_image.texture = atlas.get_starling_texture("items_pets_bodies", "eyes %d" % eyes_id)
	_apply_unpivoted_pose(eyes_image, Vector2(-3.0, -5.0))

	var has_helmet: bool = not helmet_name.is_empty() and helmet_name != "none"
	var helmet_allows_hair: bool = true
	if has_helmet:
		var helmet_record: Dictionary = sdb.get_helmet_data(helmet_name)
		helmet_allows_hair = bool(helmet_record.get("hair", true))
	if hair_id != 3 and helmet_allows_hair:
		hair_image.texture = atlas.get_starling_texture("items_pets_bodies", "hair %d" % hair_id)
		hair_image.visible = hair_image.texture != null
		_apply_unpivoted_pose(hair_image, Vector2(-34.0, -45.0))
	else:
		hair_image.texture = null
		hair_image.visible = false
		_apply_unpivoted_pose(hair_image, Vector2.ZERO)

	if beard_id > 1:
		beard_image.texture = atlas.get_starling_texture("items_pets_bodies", "beard %d" % beard_id)
		beard_image.visible = beard_image.texture != null
		_apply_pivoted_pose(beard_image, Vector2(6.0, 8.0))
	else:
		beard_image.texture = null
		beard_image.visible = false
		_apply_unpivoted_pose(beard_image, Vector2.ZERO)

	# Кисти рук (BodyAnimator.as:641-644, 721-724, 1312-1323)
	var hand_tex: Texture2D = atlas.get_starling_texture("items_pets_bodies", "bare hand %d" % skin_id)
	hand_right_image.texture = hand_tex
	_apply_unpivoted_pose(hand_right_image, Vector2(0.0, 38.0))
	hand_left_image.texture = hand_tex
	_apply_unpivoted_pose(hand_left_image, Vector2(0.0, 38.0))

	# Тело / рубашка и голые руки (BodyAnimator.as:1543-1588)
	var effective_shirt: String = "none" if shirt_name.is_empty() else shirt_name
	body_image.texture = atlas.get_starling_texture("items_pets_bodies", effective_shirt)
	body_image.visible = body_image.texture != null
	_apply_item_alignment(body_image, "shirt", effective_shirt, "shirtX_array", "shirtY_array")

	var arm_tex: Texture2D = atlas.get_starling_texture("items_pets_bodies", "%s arm" % effective_shirt)
	left_arm_image.texture = arm_tex
	right_arm_image.texture = arm_tex
	left_arm_image.visible = arm_tex != null
	right_arm_image.visible = arm_tex != null
	_apply_item_alignment(left_arm_image, "shirt", effective_shirt, "armX_array", "armY_array")
	_apply_item_alignment(right_arm_image, "shirt", effective_shirt, "armRX_array", "armRY_array")

	if effective_shirt in BARE_ARM_SHIRTS:
		var bare_arm_tex: Texture2D = atlas.get_starling_texture("items_pets_bodies", "bare arm %d" % skin_id)
		var bare_arm_pivot: Vector2 = atlas.get_pivot("bare arm 1", "items_pets_bodies")
		left_arm_bare_image.texture = bare_arm_tex
		right_arm_bare_image.texture = bare_arm_tex
		left_arm_bare_image.visible = bare_arm_tex != null
		right_arm_bare_image.visible = bare_arm_tex != null
		_apply_pivoted_pose(left_arm_bare_image, Vector2.ZERO, bare_arm_pivot)
		_apply_pivoted_pose(right_arm_bare_image, Vector2.ZERO, bare_arm_pivot)
	else:
		left_arm_bare_image.texture = null
		right_arm_bare_image.texture = null
		left_arm_bare_image.visible = false
		right_arm_bare_image.visible = false

	# Ноги / штаны и голые ноги (BodyAnimator.as:1617-1655)
	var effective_pants: String = "none" if pants_name.is_empty() else pants_name
	var pants_tex: Texture2D = atlas.get_starling_texture("items_pets_bodies", effective_pants)
	left_leg_image.texture = pants_tex
	right_leg_image.texture = pants_tex
	left_leg_image.visible = pants_tex != null
	right_leg_image.visible = pants_tex != null
	_apply_item_alignment(left_leg_image, "legs", effective_pants, "legX_array", "legY_array")
	_apply_item_alignment(right_leg_image, "legs", effective_pants, "legRX_array", "legRY_array")

	if effective_pants in BARE_LEG_PANTS:
		var bare_leg_tex: Texture2D = atlas.get_starling_texture("items_pets_bodies", "bare leg %d" % skin_id)
		var bare_leg_pivot: Vector2 = atlas.get_pivot("bare leg 1", "items_pets_bodies")
		left_leg_bare_image.texture = bare_leg_tex
		right_leg_bare_image.texture = bare_leg_tex
		left_leg_bare_image.visible = bare_leg_tex != null
		right_leg_bare_image.visible = bare_leg_tex != null
		_apply_pivoted_pose(left_leg_bare_image, Vector2.ZERO, bare_leg_pivot)
		_apply_pivoted_pose(right_leg_bare_image, Vector2.ZERO, bare_leg_pivot)
	else:
		left_leg_bare_image.texture = null
		right_leg_bare_image.texture = null
		left_leg_bare_image.visible = false
		right_leg_bare_image.visible = false

	# Обувь (BodyAnimator.as:1696-1717)
	if not shoe_name.is_empty():
		var shoe_tex: Texture2D = atlas.get_starling_texture("items_pets_bodies", shoe_name)
		shoe_left_image.texture = shoe_tex
		shoe_right_image.texture = shoe_tex
		shoe_left_image.visible = shoe_tex != null
		shoe_right_image.visible = shoe_tex != null
		_apply_item_alignment(shoe_left_image, "shoes", shoe_name, "shoesX_array", "shoesY_array")
		_apply_item_alignment(shoe_right_image, "shoes", shoe_name, "shoesX_array", "shoesY_array")
	else:
		shoe_left_image.texture = null
		shoe_right_image.texture = null
		shoe_left_image.visible = false
		shoe_right_image.visible = false

	# Шлем (BodyAnimator.as:1199-1242)
	if has_helmet:
		helmet_image.texture = atlas.get_starling_texture("items_pets_bodies", helmet_name)
		helmet_image.visible = helmet_image.texture != null
		_apply_item_alignment(helmet_image, "helmet", helmet_name, "helmetsX_array", "helmetsY_array")
	else:
		helmet_image.texture = null
		helmet_image.visible = false
		_apply_unpivoted_pose(helmet_image, Vector2.ZERO)

	# Оружие основное (BodyAnimator.as:1275-1334)
	if not weapon_main_name.is_empty() and weapon_main_name != "none":
		weapon_left_image.texture = atlas.get_starling_texture("items_pets_bodies", weapon_main_name)
		weapon_left_image.visible = weapon_left_image.texture != null
		_apply_item_alignment(weapon_left_image, "weapon", weapon_main_name, "weaponsX_array", "weaponsY_array")
		var weapon_record: Dictionary = sdb.get_weapon_data(weapon_main_name)
		hand_left_image.visible = int(weapon_record.get("def", 0)) == 0
	else:
		weapon_left_image.texture = null
		weapon_left_image.visible = false
		_apply_unpivoted_pose(weapon_left_image, Vector2.ZERO)
		hand_left_image.visible = true

	# Оружие второстепенное (BodyAnimator.as:1367-1420)
	if not weapon_off_name.is_empty() and weapon_off_name != "none":
		weapon_right_image.texture = atlas.get_starling_texture("items_pets_bodies", weapon_off_name)
		weapon_right_image.visible = weapon_right_image.texture != null
		_apply_item_alignment(weapon_right_image, "weapon", weapon_off_name, "weapons2X_array", "weapons2Y_array")
	else:
		weapon_right_image.texture = null
		weapon_right_image.visible = false
		_apply_unpivoted_pose(weapon_right_image, Vector2.ZERO)

	# Аксессуар (BodyAnimator.as:1453-1503)
	if not accessory_name.is_empty() and accessory_name != "none" and accessory_name != "nothing":
		accessory_image.texture = atlas.get_starling_texture("items_pets_bodies", accessory_name)
		accessory_image.visible = accessory_image.texture != null
		_apply_item_alignment(accessory_image, "acc", accessory_name, "miscX_array", "miscY_array")
	else:
		accessory_image.texture = null
		accessory_image.visible = false
		_apply_unpivoted_pose(accessory_image, Vector2.ZERO)


func _apply_unpivoted_pose(sprite: Sprite2D, pos: Vector2) -> void:
	if sprite == null:
		return
	sprite.centered = false
	sprite.offset = Vector2.ZERO
	sprite.position = pos


## Устанавливает точную Starling Image трансформацию: centered = false, offset = -pivot.
func _apply_pivoted_pose(sprite: Sprite2D, pos: Vector2, pivot_override: Variant = null) -> void:
	if sprite == null:
		return
	sprite.centered = false
	sprite.position = pos
	var pivot: Vector2 = Vector2.ZERO
	if pivot_override is Vector2:
		pivot = pivot_override
	elif sprite.texture != null and sprite.texture.has_meta("pivot"):
		pivot = sprite.texture.get_meta("pivot", Vector2.ZERO)
	sprite.offset = -pivot


func _apply_item_alignment(sprite: Sprite2D, category: String, item_name: String, x_arr_key: String, y_arr_key: String) -> void:
	if sprite == null:
		return
	if sprite.texture == null:
		_apply_unpivoted_pose(sprite, Vector2.ZERO)
		return
	var sdb: Node = _get_stats_db()
	var record: Dictionary = sdb.get_item_stats_data(category, item_name)
	var frame: int = int(record.get("f", 0))
	var frame_index: int = frame - 1
	var x_offsets: Variant = item_offsets.get(x_arr_key, [])
	var y_offsets: Variant = item_offsets.get(y_arr_key, [])
	var pos := Vector2.ZERO
	if frame_index >= 0 and x_offsets is Array and y_offsets is Array and frame_index < x_offsets.size() and frame_index < y_offsets.size():
		pos = Vector2(float(x_offsets[frame_index]), float(y_offsets[frame_index]))
	_apply_pivoted_pose(sprite, pos)


## Синхронизирует экипировку из PersonEntity и обновляет текстуры
func apply_equipment_from_person(person_node: Node) -> void:
	if person_node == null:
		return
	var eq: Variant = person_node.get("equipment")
	if eq is Dictionary:
		helmet_name = str(eq.get("helmet", ""))
		shirt_name = str(eq.get("shirt", ""))
		pants_name = str(eq.get("legs", ""))
		shoe_name = str(eq.get("shoes", ""))
		weapon_main_name = str(eq.get("weapon", ""))
		weapon_off_name = str(eq.get("weapon2", ""))
		accessory_name = str(eq.get("accessory", ""))
	apply_appearance()


func refresh_equipment_textures() -> void:
	apply_appearance()


## Останавливает воспроизведение на текущем кадре (BodyAnimator.as:1128)
func stop() -> void:
	is_playing = false


## Переходит на указанный кадр анимации и удерживает его (gotoAndStop)
func hold_frame(anim_name: String, frame_idx: int = -1) -> void:
	if not animations_meta.has(anim_name):
		anim_name = "standing"
	var meta: Dictionary = animations_meta.get(anim_name, {})
	current_anim_name = anim_name
	anim_start_frame = int(meta.get("startFrame", 0))
	anim_end_frame = int(meta.get("endFrame", 49))
	is_looping = false
	current_frame = frame_idx if frame_idx >= 0 else anim_start_frame
	is_playing = false
	update_frame()


var _bow_charge_sprite: Sprite2D = null


## BodyAnimator.as:896-916 — визуальный след удара воина ("slash 1", "slash 2", "yellow slash 1")
func create_slash(slash_type: String = "slash 1", dir: int = 1, rot_deg: float = 0.0) -> void:
	var loader: Node = _get_atlas_loader()
	if loader == null or not loader.has_method("get_texture"):
		return
	var tex: Texture2D = loader.get_texture(slash_type, "items_pets_bodies")
	if tex == null:
		return
	var s := Sprite2D.new()
	s.texture = tex
	s.position = Vector2(float(dir) * 28.0, -4.0)
	s.scale = Vector2(float(dir), 1.0)
	s.rotation_degrees = rot_deg
	s.z_index = 20
	add_child(s)
	var t: SceneTreeTimer = get_tree().create_timer(0.2)
	t.timeout.connect(func() -> void:
		if is_instance_valid(s):
			s.queue_free()
	)


## BodyAnimator.as:956-964 — шар зарядки лука ("bow charge glow")
func set_bow_charge_glow(active: bool, scale_val: float = 0.3, dir: int = 1) -> void:
	if not active:
		if _bow_charge_sprite != null and is_instance_valid(_bow_charge_sprite):
			_bow_charge_sprite.queue_free()
			_bow_charge_sprite = null
		return
	if _bow_charge_sprite == null or not is_instance_valid(_bow_charge_sprite):
		var loader: Node = _get_atlas_loader()
		if loader == null or not loader.has_method("get_texture"):
			return
		var tex: Texture2D = loader.get_texture("bow charge glow", "items_pets_bodies")
		if tex == null:
			return
		_bow_charge_sprite = Sprite2D.new()
		_bow_charge_sprite.texture = tex
		_bow_charge_sprite.z_index = 25
		add_child(_bow_charge_sprite)
	_bow_charge_sprite.position = Vector2(float(dir) * 13.0, -4.0)
	_bow_charge_sprite.scale = Vector2(scale_val, scale_val)


## Запустить воспроизведение анимации по имени ("standing", "running", "jumping", "attack" и т.д.)
func play(anim_name: String) -> void:
	if not animations_meta.has(anim_name):
		if anim_name != "standing":
			call_deferred("emit_signal", "animation_finished", anim_name)
		# Пробуем fallback к standing
		anim_name = "standing"
	if is_playing and is_looping and current_anim_name == anim_name:
		return
	if anim_name == "block" and current_anim_name == "block" and (is_playing or current_frame == BLOCK_HOLD_FRAME):
		return
	if anim_name == "ducking":
		var duck_meta: Dictionary = animations_meta.get("ducking", {})
		hold_frame("ducking", int(duck_meta.get("startFrame", DUCK_HOLD_FRAME)))
		return

	var meta: Dictionary = animations_meta.get(anim_name, {})
	current_anim_name = anim_name
	if LOOP_FRAME_OVERRIDES.has(anim_name):
		var ov: Dictionary = LOOP_FRAME_OVERRIDES[anim_name]
		anim_start_frame = int(ov["start"])
		anim_end_frame = int(ov["end"])
		is_looping = true
	else:
		anim_start_frame = int(meta.get("startFrame", 0))
		anim_end_frame = int(meta.get("endFrame", 49))
		is_looping = bool(meta.get("loop", true))
	current_frame = anim_start_frame
	is_playing = true
	update_frame()


## Одиночный шаг кадра (30 FPS)
func advance_frame() -> void:
	if not is_playing:
		return

	current_frame += 1
	if current_anim_name == "block" and current_frame >= BLOCK_HOLD_FRAME:
		current_frame = BLOCK_HOLD_FRAME
		is_playing = false
		update_frame()
		return

	if current_frame > anim_end_frame:
		if is_looping:
			current_frame = anim_start_frame
		else:
			var reset_to: Variant = animations_meta.get(current_anim_name, {}).get("resetTo", null)
			if reset_to != null and str(reset_to) != "" and str(reset_to) != current_anim_name and animations_meta.has(str(reset_to)):
				animation_finished.emit(current_anim_name)
				play(str(reset_to))
				return
			current_frame = anim_end_frame
			is_playing = false
			animation_finished.emit(current_anim_name)

	update_frame()


## Применяет трансформации текущего кадра ко всем узлам
func update_frame() -> void:
	if matrices_data.is_empty():
		return

	_apply_matrix_to_node(head_sprite, "headMatrix_array", current_frame)
	_apply_matrix_to_node(body_sprite, "bodyMatrix_array", current_frame)
	_apply_matrix_to_node(left_arm_sprite, "leftArmMatrix_array", current_frame)
	_apply_matrix_to_node(right_arm_sprite, "rightArmMatrix_array", current_frame)
	_apply_matrix_to_node(left_leg_sprite, "leftLegMatrix_array", current_frame)
	_apply_matrix_to_node(right_leg_sprite, "rightLegMatrix_array", current_frame)
	_apply_matrix_to_node(weapon_left_sprite, "weapon1Matrix_array", current_frame)
	_apply_matrix_to_node(weapon_right_sprite, "weapon2Matrix_array", current_frame)
	_apply_matrix_to_node(accessory_sprite, "accMatrix_array", current_frame)

	frame_changed.emit(current_frame)


## Применяет Flash матрицу [a, b, c, d, tx, ty] к 2D узлу Godot через Transform2D
func _apply_matrix_to_node(target_node: CanvasItem, matrix_key: String, frame_idx: int) -> void:
	if target_node == null:
		return
	var mat_list: Variant = matrices_data.get(matrix_key, null)
	if not (mat_list is Array) or frame_idx < 0 or frame_idx >= mat_list.size():
		return
	var m: Array = mat_list[frame_idx]
	if m.size() < 6:
		return

	# Flash Matrix: [a, b, c, d, tx, ty]
	# В 2D: x' = a*x + c*y + tx,  y' = b*x + d*y + ty
	# Godot Transform2D: x_axis = Vector2(a, b), y_axis = Vector2(c, d), origin = Vector2(tx, ty)
	var x_axis: Vector2 = Vector2(float(m[0]), float(m[1]))
	var y_axis: Vector2 = Vector2(float(m[2]), float(m[3]))
	var origin: Vector2 = Vector2(float(m[4]), float(m[5]))
	target_node.transform = Transform2D(x_axis, y_axis, origin)
