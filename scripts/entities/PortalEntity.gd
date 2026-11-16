extends Area2D
class_name PortalEntity
## PortalEntity — Интерактивный портал между локациями (порт GameMain.createPortal и ambient_objects.Portal).

@export var target_stage: int = 2
@export var portal_id: int = 1
@export var current_stage_id: int = 0

var sprite: Sprite2D = null
var collision_shape: CollisionShape2D = null
var player_inside: PersonEntity = null

var _anim_accum: float = 0.0
var _anim_dir: float = 1.0

signal player_entered_portal(target_stage: int, portal_id: int)

static func _get_atlas_loader() -> Node:
	if Engine.has_singleton("StarlingAtlasLoader"):
		return Engine.get_singleton("StarlingAtlasLoader")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("StarlingAtlasLoader"):
		return tree.root.get_node("StarlingAtlasLoader")
	return load("res://scripts/autoload/StarlingAtlasLoader.gd").new()

func _ready() -> void:
	_setup_visual()
	_setup_collision()
	if current_stage_id == 1 and portal_id == 2:
		visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _physics_process(delta: float) -> void:
	# AS3 onEnter 30Hz animation: sprite.scale.y oscillates between 0.6 and 1.4 in steps of 0.03
	if sprite != null and visible:
		_anim_accum += delta
		while _anim_accum >= (1.0 / 30.0):
			_anim_accum -= (1.0 / 30.0)
			sprite.scale.y += _anim_dir * 0.03
			if sprite.scale.y >= 1.4:
				sprite.scale.y = 1.4
				_anim_dir = -1.0
			elif sprite.scale.y <= 0.6:
				sprite.scale.y = 0.6
				_anim_dir = 1.0

	if not visible:
		return
	if player_inside == null or not is_instance_valid(player_inside):
		return
	if player_inside.is_dead:
		return
	if not player_inside.on_ground:
		return
	if target_stage <= 0:
		return
	if Input.is_action_just_pressed("move_down"):
		trigger_portal()


func trigger_portal() -> void:
	if not visible or target_stage <= 0:
		return
	if player_inside != null and is_instance_valid(player_inside) and player_inside.is_dead:
		return
	var gw: Node = player_inside.game_world if (player_inside != null and is_instance_valid(player_inside)) else null
	if gw != null and gw.has_method("can_use_portal") and not gw.call("can_use_portal"):
		return
	player_entered_portal.emit(target_stage, portal_id)


func _setup_visual() -> void:
	sprite = Sprite2D.new()
	sprite.name = "PortalSprite"
	var atlas: Node = _get_atlas_loader()
	atlas.register_starling_atlas("trees_fish")
	var tex: Texture2D = atlas.get_starling_texture("trees_fish", "portal")
	if tex != null:
		sprite.texture = tex
		# Pivot внизу по центру
		sprite.offset = Vector2(0, -tex.get_height() * 0.5)
	add_child(sprite)


func _setup_collision() -> void:
	collision_layer = 0
	collision_mask = 2
	collision_shape = CollisionShape2D.new()
	var rect: RectangleShape2D = RectangleShape2D.new()
	rect.size = Vector2(63, 77)
	collision_shape.shape = rect
	collision_shape.position = Vector2(0, -38.5)
	add_child(collision_shape)


func _on_body_entered(body: Node2D) -> void:
	if body is PersonEntity and body.is_local_player:
		player_inside = body


func _on_body_exited(body: Node2D) -> void:
	if body == player_inside:
		player_inside = null
