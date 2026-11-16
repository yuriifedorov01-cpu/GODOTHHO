extends Node2D
class_name FishEntity
## FishEntity — Плавающая рыба в воде карты (порт Fish.as + GameCode.Trees.cs:325-388 + GameCode.Fish.cs).

const RESPAWN_SECONDS: float = 900.0

@export var fish_type: String = "goldfish"
@export var is_shiny: bool = false
var game_world: Node = null
var _swim_dir: float = 1.0
var _swim_speed: float = 42.0
var _turn_timer: float = 0.0
var is_caught: bool = false
var _respawn_timer: float = 0.0
var _spawn_pos: Vector2 = Vector2.ZERO

var sprite: Sprite2D = null

signal fish_caught(fish_item_name: String, fish_node: FishEntity)


static func _get_atlas_loader() -> Node:
	if Engine.has_singleton("StarlingAtlasLoader"):
		return Engine.get_singleton("StarlingAtlasLoader")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("StarlingAtlasLoader"):
		return tree.root.get_node("StarlingAtlasLoader")
	return load("res://scripts/autoload/StarlingAtlasLoader.gd").new()


func _ready() -> void:
	_spawn_pos = position
	_swim_dir = 1.0 if randf() < 0.5 else -1.0
	_turn_timer = randf_range(2.0, 5.0)

	var atlas: Node = _get_atlas_loader()
	atlas.register_starling_atlas("trees_fish")
	var tex: Texture2D = atlas.get_starling_texture("trees_fish", fish_type)
	if tex != null:
		sprite = Sprite2D.new()
		sprite.texture = tex
		sprite.flip_h = (_swim_dir < 0.0)
		if is_shiny:
			sprite.modulate = Color(1.4, 1.35, 0.75, 1.0)
		add_child(sprite)


func _physics_process(delta: float) -> void:
	if is_caught:
		_respawn_timer -= delta
		if _respawn_timer <= 0.0:
			_respawn()
		return

	_turn_timer -= delta
	var next_x: float = position.x + _swim_dir * _swim_speed * delta
	var stay_in_water: bool = true
	if game_world != null and game_world.has_method("is_point_in_water"):
		stay_in_water = bool(game_world.call("is_point_in_water", next_x + _swim_dir * 24.0, position.y))
	if not stay_in_water or _turn_timer <= 0.0:
		_swim_dir = -_swim_dir
		_turn_timer = randf_range(2.0, 5.0)
		if sprite != null:
			sprite.flip_h = (_swim_dir < 0.0)
	else:
		position.x = next_x


func catch_fish() -> String:
	if is_caught:
		return ""
	is_caught = true
	visible = false
	_respawn_timer = RESPAWN_SECONDS
	var item_name: String = ("shiny " + fish_type) if is_shiny else fish_type
	if has_node("/root/AudioManager"):
		var am: Node = get_node("/root/AudioManager")
		if am.has_method("play_sfx"):
			am.call("play_sfx", "SFX/water swish")
	fish_caught.emit(item_name, self)
	return item_name


func _respawn() -> void:
	is_caught = false
	_respawn_timer = 0.0
	position = _spawn_pos
	visible = true
