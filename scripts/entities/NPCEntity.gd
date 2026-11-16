extends Node2D
class_name NPCEntity
## NPCEntity — Мировой NPC (порт GameMain.as:13509-13629, MainStarlingStage.as:2845-2853).

signal talk_requested(npc_data: Dictionary, npc_node: Node2D)

const BodyAnimatorScript = preload("res://scripts/entities/BodyAnimatorNode.gd")

const HAIR_NAME_TO_ID: Dictionary = {
	"brown": 1, "fro": 2, "bald": 3, "red curly": 4, "mohawk": 5,
	"thin black": 6, "slick black": 7, "spiked blond": 8, "blond bowl": 9,
	"medium brown": 10, "blonde tails": 11, "brown sag": 12, "granny hair": 13,
	"long black": 14, "black ponytail": 15, "red spiked": 16, "short brown": 17,
	"comb over": 18, "curly black": 19, "drooping blonde": 20, "brown ponytails": 21,
	"ratty blonde": 22, "blonde ponytail": 23, "brown emo": 24, "blonde stylin": 25,
	"light blonde emo": 26,
}

var npc_data: Dictionary = {}
var npc_name: String = ""
var stage_id: int = 1
var trigger_id: int = -1
var animator: Node2D = null
var shadow_sprite: Sprite2D = null
var name_label: Label = null
var talk_bubble_btn: BaseButton = null
var _is_unconscious: bool = false
var _ground_snapped: bool = false


func _physics_process(_delta: float) -> void:
	if not _ground_snapped:
		_snap_to_floor()
	if animator != null and animator.is_playing:
		animator.advance_frame()


func _snap_to_floor() -> void:
	if _is_unconscious or not is_inside_tree():
		_ground_snapped = true
		return
	var world_2d: World2D = get_world_2d()
	if world_2d == null:
		return
	var space: PhysicsDirectSpaceState2D = world_2d.direct_space_state
	if space == null:
		return
	_ground_snapped = true
	var from_pt: Vector2 = global_position + Vector2(0.0, -10.0)
	var to_pt: Vector2 = global_position + Vector2(0.0, 70.0)
	var query := PhysicsRayQueryParameters2D.create(from_pt, to_pt, 1 | 16)
	var result: Dictionary = space.intersect_ray(query)
	if not result.is_empty():
		var hit_pos: Vector2 = result.get("position", global_position)
		# Подошвы BodyAnimatorNode с position.y = 7.0 находятся на +48.0 от корня NPC
		global_position.y = hit_pos.y - 48.0


func setup(p_npc_data: Dictionary) -> void:
	npc_data = p_npc_data.duplicate(true)
	npc_name = str(npc_data.get("name", "NPC"))
	var origin: Dictionary = npc_data.get("origin", {}) if npc_data.get("origin") is Dictionary else {}
	var app: Dictionary = npc_data.get("appearance", {}) if npc_data.get("appearance") is Dictionary else {}

	stage_id = int(origin.get("area", 1))
	trigger_id = int(origin.get("trigger", -1))

	# GameMain.as:13516-13517: person.x = _npc.x; person.y = _npc.y + 50;
	var spawn_x: float = float(origin.get("x", 0.0))
	var spawn_y: float = float(origin.get("y", 0.0)) + 50.0
	position = Vector2(spawn_x, spawn_y)
	_ground_snapped = false

	# Спец-хук оригинала: Stage 1 William лежит без сознания (GameMain.as:13540-13547)
	_is_unconscious = (stage_id == 1 and npc_name == "William")
	if _is_unconscious:
		position.y += 30.0

	_build_visuals(app, _is_unconscious)


func _build_visuals(app: Dictionary, is_unconscious: bool) -> void:
	var scale_x: float = float(app.get("scaleX", 1.0))
	if scale_x == 0.0:
		scale_x = 1.0

	if not is_unconscious:
		var sh_tex: Texture2D = EnemyEntity._get_shadow_texture()
		if sh_tex != null:
			shadow_sprite = Sprite2D.new()
			shadow_sprite.name = "DropShadow"
			shadow_sprite.texture = sh_tex
			shadow_sprite.z_index = -1
			shadow_sprite.position = Vector2(0.0, 48.0)
			add_child(shadow_sprite)

	animator = BodyAnimatorScript.new()
	animator.name = "BodyAnimator"
	animator.position = Vector2(0.0, 7.0)
	animator.gender = str(app.get("gender", "male"))
	animator.skin_id = int(app.get("skin", 2))
	animator.eyes_id = int(app.get("eyeFrame", 1))
	var raw_hair: Variant = app.get("hair", "bald")
	if raw_hair is int or (raw_hair is String and str(raw_hair).is_valid_int()):
		animator.hair_id = int(raw_hair)
	else:
		var h_str: String = str(raw_hair).to_lower().strip_edges()
		animator.hair_id = int(HAIR_NAME_TO_ID.get(h_str, 1))
	animator.beard_id = int(app.get("beard", 0))
	animator.helmet_name = str(app.get("helmet", "none"))
	animator.shirt_name = str(app.get("shirt", "none"))
	animator.pants_name = str(app.get("legs", "none"))
	var raw_shoe: String = str(app.get("shoes", "brown shoe")).strip_edges()
	animator.shoe_name = "brown shoe" if raw_shoe.is_empty() else raw_shoe
	animator.weapon_main_name = str(app.get("weapon1", "none"))
	animator.weapon_off_name = str(app.get("weapon2", "none"))
	animator.accessory_name = str(app.get("accessory", ""))
	animator.scale.x = scale_x
	if is_unconscious:
		animator.rotation = deg_to_rad(-90.0)
	add_child(animator)
	if animator.has_method("play"):
		animator.call("play", "standing")

	var atlas: Node = get_node_or_null("/root/StarlingAtlasLoader")
	var names_font: Font = atlas.call("get_bitmap_font", "names_font.fnt") as Font if (atlas != null and atlas.has_method("get_bitmap_font")) else null
	var readable_font: Font = atlas.call("get_bitmap_font", "readable_font.fnt") as Font if (atlas != null and atlas.has_method("get_bitmap_font")) else null

	name_label = Label.new()
	name_label.name = "NameLabel"
	name_label.text = npc_name
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.position = Vector2(-58, 37)
	name_label.size = Vector2(116, 27)
	if names_font != null:
		name_label.add_theme_font_override("font", names_font)
	name_label.add_theme_font_size_override("font_size", 12)
	name_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	name_label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.95))
	name_label.add_theme_constant_override("outline_size", 3)
	add_child(name_label)

	if trigger_id > -1:
		var tb := TextureButton.new()
		tb.name = "TalkBubbleButton"
		tb.focus_mode = Control.FOCUS_NONE
		tb.tooltip_text = "Поговорить: %s" % npc_name
		var bubble_tex: Texture2D = atlas.call("get_starling_texture", "items_pets_bodies", "talk bubble") as Texture2D if (atlas != null and atlas.has_method("get_starling_texture")) else null
		if bubble_tex != null:
			tb.texture_normal = bubble_tex
			var b_sz: Vector2 = bubble_tex.get_size()
			tb.size = b_sz
			tb.position = Vector2(-b_sz.x * 0.5, -b_sz.y - 45.0)
			var b_lbl := Label.new()
			b_lbl.text = "click to talk"
			b_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			b_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			b_lbl.position = Vector2(4, 2)
			b_lbl.size = Vector2(maxf(20.0, b_sz.x - 8.0), maxf(14.0, b_sz.y - 10.0))
			if readable_font != null:
				b_lbl.add_theme_font_override("font", readable_font)
			b_lbl.add_theme_font_size_override("font_size", 10)
			b_lbl.add_theme_color_override("font_color", Color(0.08, 0.08, 0.08, 1.0))
			b_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
			tb.add_child(b_lbl)
		else:
			tb.position = Vector2(-40, -104)
			tb.size = Vector2(80, 26)
		tb.pressed.connect(interact)
		talk_bubble_btn = tb
		add_child(tb)


func interact() -> void:
	if trigger_id < 0:
		return
	talk_requested.emit(npc_data, self)
