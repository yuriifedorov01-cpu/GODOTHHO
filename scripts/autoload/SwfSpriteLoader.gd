extends Node
## SwfSpriteLoader — Кэширование и загрузка векторных спрайтов SWF (тайлы и монстры).
## Отрезает тайлы 165x165 из листов DefineSprite_*Tiles/1.png и создает SpriteFrames для монстров.

const SWF_SPRITES_DIR: String = "res://assets/extracted/swf_sprites"
const ENEMY_ANIM_DATA_PATH: String = "res://assets/extracted/enemy_animator_data.json"
const TILE_SIZE: int = 165

# Кэш атласов тайлов: tile_sheet_name (String) -> Dictionary[tile_id (int) -> AtlasTexture]
var _tile_textures_cache: Dictionary = {}
# Кэш базовых текстур листов: sheet_name -> Texture2D
var _sheet_base_textures: Dictionary = {}
# Кэш анимаций монстров: enemy_type (String) -> SpriteFrames
var _enemy_frames_cache: Dictionary = {}
# Индекс папок DefineSprite_* по имени класса
var _class_to_folder: Dictionary = {}
# Метки клипов врагов из MyGame.swf: class_name_lower -> {"clips": {"walk": [s,e], "jump": [s,e], "hit": [s,e]}}
var _enemy_clips_by_class: Dictionary = {}

func _init() -> void:
	_index_swf_folders()
	_load_enemy_anim_data()


func _load_enemy_anim_data() -> void:
	if not FileAccess.file_exists(ENEMY_ANIM_DATA_PATH):
		return
	var f := FileAccess.open(ENEMY_ANIM_DATA_PATH, FileAccess.READ)
	if f == null:
		return
	var parsed: Variant = JSON.parse_string(f.get_as_text())
	f.close()
	if parsed is Dictionary:
		for cls_key: Variant in (parsed as Dictionary).keys():
			var rec: Variant = (parsed as Dictionary)[cls_key]
			if rec is Dictionary:
				_enemy_clips_by_class[str(cls_key).to_lower()] = rec


## Сканирует папки DefineSprite_* и строит соответствие имени класса -> путь к папке
func _index_swf_folders() -> void:
	var global_dir: String = ProjectSettings.globalize_path(SWF_SPRITES_DIR)
	var dir: DirAccess = DirAccess.open(global_dir)
	if dir == null:
		return
	dir.list_dir_begin()
	var folder_name: String = dir.get_next()
	while folder_name != "":
		if dir.current_is_dir() and folder_name.begins_with("DefineSprite_"):
			# Формат DefineSprite_1234_ClassName или DefineSprite_1234_package.name.ClassName
			var parts: PackedStringArray = folder_name.split("_", false, 2)
			if parts.size() >= 3:
				var class_name_full: String = parts[2]
				var simple_name: String = class_name_full.split(".")[-1]
				_class_to_folder[class_name_full.to_lower()] = folder_name
				_class_to_folder[simple_name.to_lower()] = folder_name
			else:
				_class_to_folder[folder_name.to_lower()] = folder_name
		folder_name = dir.get_next()
	dir.list_dir_end()


## Возвращает AtlasTexture для тайла по имени листа тайлов и 0-based или 1-based номеру тайла.
## В Flash: номер тайла tile_0 .. tile_N (1-based или 0-based в зависимости от слоя).
## В tile_*.json пустой тайл = -1 или 255.
func get_tile_texture(sheet_name: String, tile_id: int) -> Texture2D:
	if tile_id < 0 or tile_id == 255:
		return null
	var key: String = sheet_name.to_lower()
	if not _tile_textures_cache.has(key):
		_tile_textures_cache[key] = {}
	var sheet_cache: Dictionary = _tile_textures_cache[key]
	if sheet_cache.has(tile_id):
		return sheet_cache[tile_id]

	var base_tex: Texture2D = _get_or_load_sheet_texture(key)
	if base_tex == null:
		return null

	var img_w: int = base_tex.get_width()
	var img_h: int = base_tex.get_height()
	var cols: int = img_w / TILE_SIZE
	var rows: int = img_h / TILE_SIZE
	if cols <= 0 or rows <= 0:
		return null

	# В Flash (createTileAtlasXML):
	# Основной лист: param1 = 1980, cols = 12 (1980 / 165)
	# Передний план: param1 = 825, cols = 5 (825 / 165)
	# Тайлы генерируются: tile_0, tile_1, tile_2 ...
	# index = tile_id (0-based)
	var col: int = tile_id % cols
	var row: int = tile_id / cols
	if row >= rows:
		return null

	var atlas_tex: AtlasTexture = AtlasTexture.new()
	atlas_tex.atlas = base_tex
	# Используем Rect2(col * TILE_SIZE, row * TILE_SIZE, TILE_SIZE, TILE_SIZE)
	atlas_tex.region = Rect2(col * TILE_SIZE, row * TILE_SIZE, TILE_SIZE, TILE_SIZE)
	atlas_tex.filter_clip = true
	sheet_cache[tile_id] = atlas_tex
	return atlas_tex


## Загружает и кэширует базовую PNG текстуру листа тайлов
func _get_or_load_sheet_texture(sheet_key: String) -> Texture2D:
	if _sheet_base_textures.has(sheet_key):
		return _sheet_base_textures[sheet_key]

	var folder: String = _class_to_folder.get(sheet_key, "")
	if folder.is_empty():
		# Пробуем добавить "tiles" или "areatiles"
		for k: String in _class_to_folder.keys():
			if k.contains(sheet_key):
				folder = _class_to_folder[k]
				break

	if folder.is_empty():
		return null

	var png_path: String = "%s/%s/1.png" % [SWF_SPRITES_DIR, folder]
	var global_path: String = ProjectSettings.globalize_path(png_path)
	if not FileAccess.file_exists(global_path) and not ResourceLoader.exists(png_path):
		return null

	var tex: Texture2D = null
	if FileAccess.file_exists(global_path):
		var img: Image = Image.load_from_file(global_path)
		if img != null:
			tex = ImageTexture.create_from_image(img)
	elif ResourceLoader.exists(png_path):
		tex = load(png_path) as Texture2D

	if tex != null:
		_sheet_base_textures[sheet_key] = tex
	return tex


const ENEMY_VECTOR_ALIASES: Dictionary = {
	"dark beholder": "beholdervector",
	"giant goo cube": "giantgoocubevector",
	"green bouncer": "greenbouncervector",
	"red bouncer": "redbouncervector"
}


## Создает и кэширует SpriteFrames для врага по его типу (например "green bouncer")
func get_enemy_sprite_frames(enemy_type: String) -> SpriteFrames:
	var norm_type: String = enemy_type.to_lower().strip_edges()
	if _enemy_frames_cache.has(norm_type):
		return _enemy_frames_cache[norm_type]

	# Формируем имя вектора: "green bouncer" -> "greenbouncervector"
	var vector_name: String = ENEMY_VECTOR_ALIASES.get(
		norm_type,
		norm_type.replace(" ", "").replace("-", "").replace("_", "") + "vector"
	)
	var folder: String = _class_to_folder.get(vector_name, "")
	if folder.is_empty():
		var compact: String = norm_type.replace(" ", "").replace("-", "").replace("_", "")
		for k: String in _class_to_folder.keys():
			if k.begins_with(compact) and k.ends_with("vector"):
				folder = _class_to_folder[k]
				break

	if folder.is_empty():
		push_warning("[SwfSpriteLoader] Vector folder not found for enemy: " + enemy_type)
		return null

	var folder_path: String = "%s/%s" % [SWF_SPRITES_DIR, folder]
	var global_folder: String = ProjectSettings.globalize_path(folder_path)
	var dir: DirAccess = DirAccess.open(global_folder)
	if dir == null:
		return null

	# Собираем все кадры 1.png .. N.png
	var frame_files: Array[int] = []
	dir.list_dir_begin()
	var fname: String = dir.get_next()
	while fname != "":
		if fname.ends_with(".png"):
			var num_str: String = fname.get_basename()
			if num_str.is_valid_int():
				frame_files.append(num_str.to_int())
		fname = dir.get_next()
	dir.list_dir_end()

	frame_files.sort()
	if frame_files.is_empty():
		return null

	var frames: SpriteFrames = SpriteFrames.new()
	if not frames.has_animation("default"):
		frames.add_animation("default")
	frames.set_animation_speed("default", 30.0)
	frames.set_animation_loop("default", true)

	var ordered_textures: Array[Texture2D] = []
	for num: int in frame_files:
		var frame_path: String = "%s/%d.png" % [folder_path, num]
		var frame_global: String = ProjectSettings.globalize_path(frame_path)
		var tex: Texture2D = null
		if ResourceLoader.exists(frame_path):
			tex = load(frame_path) as Texture2D
		elif FileAccess.file_exists(frame_global):
			var img: Image = Image.load_from_file(frame_global)
			if img != null:
				tex = ImageTexture.create_from_image(img)
		if tex != null:
			frames.add_frame("default", tex)
			ordered_textures.append(tex)

	# Нарезаем клипы по меткам из MyGame.swf ("walk", "jump", "hit", "open chest")
	var folder_parts: PackedStringArray = folder.split("_", false, 2)
	if folder_parts.size() >= 3 and not ordered_textures.is_empty():
		var cls_lower: String = folder_parts[2].to_lower()
		var anim_rec: Dictionary = _enemy_clips_by_class.get(cls_lower, {})
		var clips: Variant = anim_rec.get("clips", {})
		if clips is Dictionary:
			for clip_name_v: Variant in (clips as Dictionary).keys():
				var clip_name: String = str(clip_name_v)
				var rng: Variant = (clips as Dictionary)[clip_name_v]
				if not (rng is Array) or (rng as Array).size() < 2:
					continue
				var start_f: int = clampi(int((rng as Array)[0]), 0, ordered_textures.size() - 1)
				var end_f: int = clampi(int((rng as Array)[1]), start_f, ordered_textures.size() - 1)
				if not frames.has_animation(clip_name):
					frames.add_animation(clip_name)
				frames.set_animation_speed(clip_name, 30.0)
				frames.set_animation_loop(clip_name, clip_name != "hit")
				for fi: int in range(start_f, end_f + 1):
					frames.add_frame(clip_name, ordered_textures[fi])

	_enemy_frames_cache[norm_type] = frames
	return frames
