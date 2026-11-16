extends GravityBody
class_name LootItemEntity
## LootItemEntity — Дропнутый предмет или монета в мире (порт com.game_objects.Item.as).

@export var item_name: String = "apple"
@export var is_coin: bool = false
@export var coin_amount: int = 10
@export var owner_name: String = ""
@export var steal_wait_timer: float = 0.0
var _age_seconds: float = 0.0
var _is_picked_up: bool = false

var sprite: Sprite2D = null
var collision_shape: CollisionShape2D = null
var area_trigger: Area2D = null

signal item_picked_up(item: LootItemEntity, collector: Node2D)

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
	_setup_trigger()
	# Начальный подброс вверх при дропе
	vel_y = -8.0
	vel_x = randf_range(-3.0, 3.0)


func _setup_visual() -> void:
	sprite = Sprite2D.new()
	sprite.name = "ItemSprite"
	var atlas: Node = _get_atlas_loader()
	atlas.register_starling_atlas("items_pets_bodies")
	atlas.register_starling_atlas("trees_fish")
	var tex: Texture2D = null
	var candidates: Array = ["coin", "gold coin"] if is_coin else [item_name, "item " + item_name]
	for cand_v: Variant in candidates:
		var cand: String = str(cand_v)
		tex = atlas.get_starling_texture("items_pets_bodies", cand)
		if tex != null:
			break
		tex = atlas.get_starling_texture("trees_fish", cand)
		if tex != null:
			break
	if tex != null:
		sprite.texture = tex
		# Выравниваем низ спрайта по уровню земли (circle.radius = 12.0)
		sprite.position = Vector2(0.0, 12.0 - float(tex.get_height()) * 0.5)
	if not is_coin:
		var tree: SceneTree = Engine.get_main_loop() as SceneTree
		var sdb: Node = tree.root.get_node_or_null("StatsDB") if tree != null else null
		if sdb != null and sdb.has_method("get_item_data"):
			var idata: Dictionary = sdb.call("get_item_data", item_name)
			if str(idata.get("type", "")) == "weapon":
				sprite.rotation_degrees = -55.0
	add_child(sprite)


func _setup_collision() -> void:
	collision_layer = 0
	collision_mask = 1 | ONE_WAY_PLATFORM_BIT
	collision_shape = CollisionShape2D.new()
	var circle: CircleShape2D = CircleShape2D.new()
	circle.radius = 12.0
	collision_shape.shape = circle
	add_child(collision_shape)


func _setup_trigger() -> void:
	area_trigger = Area2D.new()
	area_trigger.collision_layer = 0
	area_trigger.collision_mask = 3
	var trigger_shape: CollisionShape2D = CollisionShape2D.new()
	var circle: CircleShape2D = CircleShape2D.new()
	circle.radius = 35.0
	trigger_shape.shape = circle
	area_trigger.add_child(trigger_shape)
	add_child(area_trigger)

	area_trigger.body_entered.connect(_on_collector_entered)


func _physics_process(delta: float) -> void:
	if _is_picked_up:
		return
	super._physics_process(delta)
	_age_seconds += delta
	if is_coin and sprite != null:
		sprite.scale.x = cos(_age_seconds * 6.0)
	if sprite != null:
		var tree: SceneTree = get_tree()
		var local_p: Node2D = tree.get_first_node_in_group("local_player") as Node2D if tree != null else null
		if local_p != null and not can_be_picked_up_by(local_p):
			sprite.modulate.a = 0.5
		else:
			sprite.modulate.a = 1.0


func can_be_picked_up_by(body: Node2D) -> bool:
	if _is_picked_up:
		return false
	if not (body is PersonEntity) or not body.is_local_player:
		return false
	if owner_name.is_empty() or owner_name == body.character_name:
		return true
	var required_wait: float = steal_wait_timer
	if required_wait <= 0.0:
		required_wait = body.get_loot_steal_wait_seconds()
	return _age_seconds >= required_wait


func try_pickup(body: Node2D) -> bool:
	if not can_be_picked_up_by(body):
		return false
	_is_picked_up = true
	set_physics_process(false)
	if area_trigger != null:
		area_trigger.set_deferred("monitoring", false)
	item_picked_up.emit(self, body)
	var tree: SceneTree = get_tree()
	var amgr: Node = tree.root.get_node_or_null("AudioManager") if tree != null else null
	if amgr != null and amgr.has_method("play_sfx"):
		amgr.call("play_sfx", "SFX/coin get" if is_coin else "SFX/pickup")
	if is_inside_tree() and body != null:
		var tw: Tween = create_tween()
		tw.set_parallel(true)
		tw.set_trans(Tween.TRANS_BACK)
		tw.set_ease(Tween.EASE_OUT)
		tw.tween_property(self, "global_position", body.global_position + Vector2(0.0, -30.0), 0.35)
		tw.tween_property(self, "modulate:a", 0.0, 0.35)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
	return true


func _on_collector_entered(body: Node2D) -> void:
	if not is_coin:
		return
	try_pickup(body)
