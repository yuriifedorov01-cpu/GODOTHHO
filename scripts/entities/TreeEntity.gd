extends Node2D
class_name TreeEntity
## TreeEntity — Интерактивное дерево для рубки (порт Tree.as + GameCode.Trees.cs).
## HP = 5000, урон * 40 (TreeDamageScale), +4 chopXP каждые 1..10 ударов, дроп 1..3 брёвен, респавн 900с.

const TOTAL_HP: int = 5000
const DAMAGE_SCALE: int = 40
const RESPAWN_SECONDS: float = 900.0

@export var tree_type: String = "pine tree"
var hp: int = TOTAL_HP
var is_chopped: bool = false
var _respawn_timer: float = 0.0
var _hits_until_xp: int = 0

var sprite: Sprite2D = null
var _hp_bg: ColorRect = null
var _hp_fill: ColorRect = null

signal tree_chopped(tree_kind: String, world_pos: Vector2, log_count: int)


static func _get_atlas_loader() -> Node:
	if Engine.has_singleton("StarlingAtlasLoader"):
		return Engine.get_singleton("StarlingAtlasLoader")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("StarlingAtlasLoader"):
		return tree.root.get_node("StarlingAtlasLoader")
	return load("res://scripts/autoload/StarlingAtlasLoader.gd").new()


func _ready() -> void:
	_hits_until_xp = randi_range(1, 10)
	var atlas: Node = _get_atlas_loader()
	atlas.register_starling_atlas("trees_fish")
	var tex: Texture2D = atlas.get_starling_texture("trees_fish", tree_type)
	if tex != null:
		sprite = Sprite2D.new()
		sprite.texture = tex
		sprite.offset = Vector2(0.0, -tex.get_height() * 0.5)
		add_child(sprite)

	_hp_bg = ColorRect.new()
	_hp_bg.color = Color(0.1, 0.1, 0.1, 0.85)
	_hp_bg.size = Vector2(64.0, 7.0)
	_hp_bg.position = Vector2(-32.0, -140.0)
	_hp_bg.visible = false
	add_child(_hp_bg)

	_hp_fill = ColorRect.new()
	_hp_fill.color = Color(0.25, 0.85, 0.25, 1.0)
	_hp_fill.size = Vector2(62.0, 5.0)
	_hp_fill.position = Vector2(1.0, 1.0)
	_hp_bg.add_child(_hp_fill)


func _process(delta: float) -> void:
	if is_chopped and _respawn_timer > 0.0:
		_respawn_timer -= delta
		if _respawn_timer <= 0.0:
			_respawn()


func take_chop_damage(raw_dmg: int, attacker: Node = null) -> Dictionary:
	if is_chopped:
		return {"hit": false}

	var chop_lvl: int = 0
	if attacker != null and "chopping_level" in attacker:
		chop_lvl = int(attacker.chopping_level)
	var dmg: int = maxi(1, int(float(maxi(1, raw_dmg) * DAMAGE_SCALE) * (1.0 + float(chop_lvl) * 0.1)))
	hp = maxi(0, hp - dmg)

	var got_xp: bool = false
	_hits_until_xp -= 1
	if _hits_until_xp <= 0:
		got_xp = true
		_hits_until_xp = randi_range(1, 10)
		if attacker != null and attacker.has_method("gain_chopping_xp"):
			attacker.call("gain_chopping_xp", 4)

	if _hp_bg != null and _hp_fill != null:
		_hp_bg.visible = hp > 0 and hp < TOTAL_HP
		_hp_fill.size.x = 62.0 * (float(hp) / float(TOTAL_HP))

	if sprite != null:
		var tw: Tween = create_tween()
		tw.tween_property(sprite, "position:x", 4.0, 0.04)
		tw.tween_property(sprite, "position:x", -4.0, 0.04)
		tw.tween_property(sprite, "position:x", 0.0, 0.04)

	if has_node("/root/AudioManager"):
		var am: Node = get_node("/root/AudioManager")
		if am.has_method("play_sfx"):
			am.call("play_sfx", "SFX/wood split" if hp <= 0 else "SFX/wood hit")

	var died: bool = hp <= 0
	if died:
		is_chopped = true
		visible = false
		_respawn_timer = RESPAWN_SECONDS
		var log_count: int = randi_range(1, 3)
		tree_chopped.emit(tree_type, global_position + Vector2(0.0, -40.0), log_count)

	return {"hit": true, "damage": dmg, "hp": hp, "got_xp": got_xp, "died": died}


func _respawn() -> void:
	hp = TOTAL_HP
	is_chopped = false
	_respawn_timer = 0.0
	visible = true
	if _hp_bg != null:
		_hp_bg.visible = false
	if _hp_fill != null:
		_hp_fill.size.x = 62.0
