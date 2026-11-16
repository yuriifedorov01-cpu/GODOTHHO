extends Node
## StarlingAtlasLoader (AssetManager) — Загрузчик и парсер Starling TextureAtlas (XML+PNG),
## координат частей тела питомцев (pet_body_locations.xml / .json) и шрифтов (.fnt).
## Точно воспроизводит логику starling.textures.TextureAtlas, SubTexture и com.utilities.Assets.

const SPRITE_SHEETS_DIR: String = "res://assets/client_data/dynamic_content/sprite_sheets"
const BACKGROUNDS_DIR: String = "res://assets/client_data/dynamic_content/backgrounds"
const MISC_DIR: String = "res://assets/client_data/dynamic_content/misc"
const FONTS_DIR: String = "res://assets/client_data/includes"
const EXTRACTED_TREES_FISH_DIR: String = "res://assets/extracted/trees_fish"
const EXTRACTED_BITMAP_FONTS_DIR: String = "res://assets/extracted/bitmap_fonts"

## Список стандартных атласов из Assets.as (dynamic_content/sprite_sheets)
const SPRITE_SHEET_NAMES: PackedStringArray = [
	"items_pets_bodies",
	"character menu",
	"item menu",
	"map menu",
	"char create menu",
	"pet menu",
	"controls",
	"energy menu",
	"guild member menu",
	"heropedia menu",
	"pet mode menu",
	"skills menu",
	"friends menu",
	"talk box",
	"load screen",
	"skill images",
	"trees_fish",
	"power_up"
]

const BACKGROUND_SHEET_NAMES: PackedStringArray = [
	"backgrounds1",
	"backgrounds2",
	"backgrounds3",
	"backgrounds4",
	"backgrounds5",
	"backgrounds6",
	"backgrounds7",
	"backgrounds8",
	"backgrounds9",
	"backgrounds10",
	"backgrounds11",
	"backgrounds12",
	"backgrounds13",
	"backgrounds14",
	"backgrounds15",
	"backgrounds16",
	"backgrounds17",
	"backgrounds18",
	"backgrounds19",
	"backgrounds20",
	"backgrounds21",
	"backgrounds22",
	"backgrounds23",
	"backgrounds24",
	"backgrounds25",
	"backgrounds26",
	"backgrounds27",
	"backgrounds28",
	"backgrounds29",
	"backgrounds30"
]

## Встроенные в SWF динамические атласы (Assets.as: TreeFishContainer -> treesFish_textureAtlas, PowerUpContainer -> powerUp_textureAtlas)
const RUNTIME_ATLAS_ALIASES: Dictionary = {
	"trees_fish": "items_pets_bodies",
	"treesFish": "items_pets_bodies",
	"trees and fish": "items_pets_bodies",
	"power_up": "items_pets_bodies",
	"powerUp": "items_pets_bodies"
}

const TREE_FISH_SYNTHETIC_REGIONS: Dictionary = {
	"white pixel": Rect2(825, 1034, 1, 1),
	"black pixel": Rect2(502, 1304, 1, 1),
	"energy orb": Rect2(30, 1466, 30, 30),
	"portal": Rect2(0, 1496, 30, 30),
	"atm": Rect2(301, 117, 36, 33),
	"click to interact": Rect2(30, 1496, 30, 30),
	"splash_00": Rect2(52, 1643, 60, 52),
	"chestnut tree": Rect2(855, 974, 40, 46),
	"chestnut tree leaf": Rect2(215, 1517, 12, 12),
	"cloud tree": Rect2(193, 1853, 47, 37),
	"cloud tree leaf": Rect2(202, 1517, 12, 12),
	"dead tree": Rect2(220, 710, 58, 13),
	"dead tree leaf": Rect2(190, 1504, 12, 12),
	"goof tree": Rect2(134, 1227, 54, 20),
	"goof tree leaf": Rect2(241, 1517, 12, 12),
	"jungle tree": Rect2(867, 898, 47, 44),
	"jungle tree leaf": Rect2(254, 1517, 12, 12),
	"maple tree": Rect2(437, 632, 69, 37),
	"maple tree leaf": Rect2(190, 1517, 12, 12),
	"palm tree": Rect2(728, 266, 70, 53),
	"palm tree leaf": Rect2(215, 1517, 12, 12),
	"pine tree": Rect2(841, 942, 61, 32),
	"pine tree leaf": Rect2(254, 1517, 12, 12),
	"purple tree": Rect2(659, 1034, 57, 30),
	"purple tree leaf": Rect2(190, 1529, 12, 12),
	"robot tree": Rect2(501, 866, 73, 29),
	"robot tree leaf": Rect2(203, 1504, 12, 12),
	"snowy tree": Rect2(724, 878, 65, 32),
	"snowy tree leaf": Rect2(203, 1529, 12, 12),
	"thorn tree": Rect2(875, 702, 73, 33),
	"thorn tree leaf": Rect2(190, 1504, 12, 12),
	"tropical tree": Rect2(473, 800, 53, 42),
	"tropical tree leaf": Rect2(241, 1517, 12, 12),
	"weeping willow": Rect2(841, 942, 61, 32),
	"weeping willow leaf": Rect2(215, 1517, 12, 12),
	"blue mushroom": Rect2(30, 1466, 30, 30),
	"blue mushroom leaf": Rect2(202, 1517, 12, 12),
	"red mushroom": Rect2(120, 1496, 30, 30),
	"red mushroom leaf": Rect2(242, 1529, 12, 12),
	"sliver": Rect2(60, 1466, 30, 30),
	"swerm": Rect2(30, 1466, 30, 30),
	"puffer": Rect2(0, 1496, 30, 30),
	"shroomer": Rect2(120, 1496, 30, 30),
	"mufungi": Rect2(75, 1436, 30, 30),
	"furry feen": Rect2(0, 1466, 30, 30),
	"hairloom": Rect2(90, 1496, 30, 30),
	"hertle": Rect2(75, 1436, 30, 30),
	"plant fungus": Rect2(150, 1466, 30, 30),
	"spud": Rect2(75, 1436, 30, 30),
	"flipper": Rect2(30, 1466, 30, 30),
	"coconut fish": Rect2(75, 1436, 30, 30),
	"mud fish": Rect2(75, 1436, 30, 30),
	"glopper": Rect2(75, 1436, 30, 30),
	"plant bacteria": Rect2(120, 1466, 30, 30),
	"metal guppy": Rect2(105, 1436, 30, 30),
	"iron minnow": Rect2(105, 1436, 30, 30),
	"peep fish": Rect2(105, 1436, 30, 30),
	"dark tadpole": Rect2(90, 1466, 30, 30),
	"evil pupe": Rect2(0, 1496, 30, 30),
	"dark toad": Rect2(90, 1466, 30, 30),
	"mushroom coy": Rect2(120, 1496, 30, 30),
	"shroom serpent": Rect2(0, 1496, 30, 30),
	"lion fish": Rect2(0, 1466, 30, 30),
	"stagnant scum": Rect2(150, 1466, 30, 30),
	"omate": Rect2(75, 1436, 30, 30),
	"greenspot": Rect2(60, 1466, 30, 30),
	"sharktooth": Rect2(105, 1436, 30, 30),
	"glowshine": Rect2(90, 1496, 30, 30),
	"subordinate": Rect2(105, 1436, 30, 30),
	"dark reaper": Rect2(90, 1466, 30, 30),
	"clipper": Rect2(0, 1466, 30, 30),
	"pootnick": Rect2(120, 1466, 30, 30),
	"root fish": Rect2(75, 1436, 30, 30),
	"pumpkin shell fish": Rect2(0, 1466, 30, 30),
	"pumphin": Rect2(0, 1466, 30, 30),
	"snow fish": Rect2(30, 1496, 30, 30),
	"ice fish": Rect2(30, 1466, 30, 30),
	"lava reef fish": Rect2(120, 1496, 30, 30),
	"lava spud": Rect2(0, 1466, 30, 30),
	"flame coy": Rect2(120, 1496, 30, 30),
	"beholder guppy": Rect2(0, 1496, 30, 30),
	"krimper": Rect2(60, 1496, 30, 30)
}

## Кеш базовых текстур атласов: atlas_name -> Texture2D
var _atlas_pages: Dictionary = {}

## Кеш метаданных всех регионов по атласам: atlas_name -> Dictionary[subtexture_name -> Dictionary]
var _atlas_entries: Dictionary = {}

## Глобальный индекс имен регионов: subtexture_name -> Dictionary
var _global_subtextures: Dictionary = {}

## Кеш созданных AtlasTexture: "atlas_name::subtexture_name" -> AtlasTexture
var _texture_cache: Dictionary = {}

## Кеш отсортированных префиксных списков (для getTextures(prefix)): "atlas_name::prefix" -> Array[AtlasTexture]
var _prefix_cache: Dictionary = {}

## Кеш SpriteFrames для анимаций: "atlas_name::prefix::fps" -> SpriteFrames
var _sprite_frames_cache: Dictionary = {}

## Координаты привязки частей тела питомцев из pet_body_locations.xml:
## Индексируются как по строковому ключу питомца ("tebra", "marshy", "civic", ...),
## так и по 1-based целочисленному индексу (1..N).
var pet_body_locations: Dictionary = {}

## Кеш загруженных шрифтов: font_name -> FontFile
var _fonts_cache: Dictionary = {}

var is_initialized: bool = false


func _ready() -> void:
	load_pet_body_locations()
	is_initialized = true


## Загружает все XML-индексы стандартных атласов (ленивая подгрузка PNG при запросе или сразу по желанию).
func preload_all_atlas_metadata(load_png_immediately: bool = false) -> void:
	for sheet_name: String in SPRITE_SHEET_NAMES:
		register_starling_atlas(sheet_name, SPRITE_SHEETS_DIR, load_png_immediately)
	for bg_name: String in BACKGROUND_SHEET_NAMES:
		register_starling_atlas(bg_name, BACKGROUNDS_DIR, load_png_immediately)


## Совместимый алиас для загрузки атласа (принимает имя атласа, например "items_pets_bodies", "controls", "trees_fish", "backgrounds1").
func load_atlas(atlas_name: String, load_png_now: bool = true) -> bool:
	return register_starling_atlas(atlas_name, SPRITE_SHEETS_DIR, load_png_now)


## Проверяет, загружен ли атлас.
func has_atlas(atlas_name: String) -> bool:
	return _atlas_entries.has(atlas_name) and not _atlas_entries[atlas_name].is_empty()


## Возвращает список имен всех регионов в указанном атласе.
func get_atlas_texture_names(atlas_name: String) -> PackedStringArray:
	if not _atlas_entries.has(atlas_name):
		register_starling_atlas(atlas_name)
	var entries: Dictionary = _atlas_entries.get(atlas_name, {})
	var names: PackedStringArray = PackedStringArray()
	for k: String in entries.keys():
		names.append(k)
	names.sort()
	return names


## Регистрирует и парсит Starling XML атлас из указанной папки.
func register_starling_atlas(atlas_name: String, base_dir: String = SPRITE_SHEETS_DIR, load_png_now: bool = false) -> bool:
	if _atlas_entries.has(atlas_name):
		if load_png_now and not _atlas_pages.has(atlas_name):
			var first_entry: Dictionary = {}
			var existing_entries: Dictionary = _atlas_entries[atlas_name]
			if not existing_entries.is_empty():
				first_entry = existing_entries[existing_entries.keys()[0]]
			_load_atlas_page_texture(
				atlas_name,
				first_entry.get("base_dir", base_dir),
				first_entry.get("image_path", "").get_file()
			)
		return true

	var xml_path: String = "%s/%s.xml" % [base_dir, atlas_name]
	if not _file_exists(xml_path):
		# Попробуем альтернативную директорию (backgrounds vs sprite_sheets)
		var alt_dir: String = BACKGROUNDS_DIR if base_dir == SPRITE_SHEETS_DIR else SPRITE_SHEETS_DIR
		xml_path = "%s/%s.xml" % [alt_dir, atlas_name]
		if _file_exists(xml_path):
			base_dir = alt_dir
		elif RUNTIME_ATLAS_ALIASES.has(atlas_name):
			return _register_runtime_alias_atlas(atlas_name, str(RUNTIME_ATLAS_ALIASES[atlas_name]), load_png_now)
		else:
			push_warning("[StarlingAtlasLoader] XML atlas not found: %s" % atlas_name)
			return false

	var parser: XMLParser = XMLParser.new()
	var err: Error = parser.open(_resolve_path(xml_path))
	if err != OK:
		push_error("[StarlingAtlasLoader] Failed to open XML: %s (err=%d)" % [xml_path, err])
		return false

	var entries: Dictionary = {}
	var image_path_attr: String = "%s.png" % atlas_name

	while parser.read() == OK:
		if parser.get_node_type() != XMLParser.NODE_ELEMENT:
			continue
		var node_name: String = parser.get_node_name()
		if node_name == "TextureAtlas":
			if parser.has_attribute("imagePath"):
				image_path_attr = parser.get_named_attribute_value("imagePath")
		elif node_name == "SubTexture":
			var sub_name: String = parser.get_named_attribute_value_safe("name")
			if sub_name.is_empty():
				continue
			var x: float = parser.get_named_attribute_value_safe("x").to_float()
			var y: float = parser.get_named_attribute_value_safe("y").to_float()
			var width: float = parser.get_named_attribute_value_safe("width").to_float()
			var height: float = parser.get_named_attribute_value_safe("height").to_float()
			var frame_x: float = parser.get_named_attribute_value_safe("frameX").to_float()
			var frame_y: float = parser.get_named_attribute_value_safe("frameY").to_float()
			var frame_width: float = parser.get_named_attribute_value_safe("frameWidth").to_float()
			var frame_height: float = parser.get_named_attribute_value_safe("frameHeight").to_float()
			var pivot_x: float = parser.get_named_attribute_value_safe("pivotX").to_float()
			var pivot_y: float = parser.get_named_attribute_value_safe("pivotY").to_float()
			var rotated_str: String = parser.get_named_attribute_value_safe("rotated").to_lower()
			var rotated: bool = (rotated_str == "true" or rotated_str == "1")

			var margin_rect: Rect2 = Rect2(0.0, 0.0, 0.0, 0.0)
			var frame_rect: Rect2 = Rect2(0.0, 0.0, 0.0, 0.0)
			if frame_width > 0.0 and frame_height > 0.0:
				margin_rect = Rect2(
					-frame_x,
					-frame_y,
					maxf(0.0, frame_width - width),
					maxf(0.0, frame_height - height)
				)
				frame_rect = Rect2(frame_x, frame_y, frame_width, frame_height)

			var entry: Dictionary = {
				"atlas": atlas_name,
				"base_dir": base_dir,
				"image_path": "%s/%s" % [base_dir, image_path_attr],
				"name": sub_name,
				"region": Rect2(x, y, width, height),
				"margin": margin_rect,
				"frame": frame_rect,
				"pivot": Vector2(pivot_x, pivot_y),
				"rotated": rotated
			}
			entries[sub_name] = entry
			if not _global_subtextures.has(sub_name):
				_global_subtextures[sub_name] = entry
			# В Assets.as (строки 302-308) если имя кончается на "_00", pivot также сохраняется без "_00"
			if sub_name.length() > 3 and sub_name.ends_with("_00"):
				var trimmed_name: String = sub_name.substr(0, sub_name.length() - 3)
				if not entries.has(trimmed_name):
					var alias_entry: Dictionary = entry.duplicate()
					alias_entry["name"] = trimmed_name
					entries[trimmed_name] = alias_entry
				if not _global_subtextures.has(trimmed_name):
					_global_subtextures[trimmed_name] = entries[trimmed_name]

	_atlas_entries[atlas_name] = entries
	if load_png_now:
		_load_atlas_page_texture(atlas_name, base_dir, image_path_attr)
	return true


func _register_runtime_alias_atlas(atlas_name: String, source_atlas_name: String, load_png_now: bool) -> bool:
	if not _atlas_entries.has(source_atlas_name):
		if not register_starling_atlas(source_atlas_name, SPRITE_SHEETS_DIR, load_png_now):
			return false
	var source_entries: Dictionary = _atlas_entries.get(source_atlas_name, {})
	var entries: Dictionary = {}
	var image_path_str: String = "%s/%s.png" % [SPRITE_SHEETS_DIR, source_atlas_name]

	for sub_name: String in source_entries.keys():
		var src_entry: Dictionary = source_entries[sub_name]
		image_path_str = str(src_entry.get("image_path", image_path_str))
		if sub_name.find("tree") != -1 or sub_name.find("fish") != -1 or sub_name.find("orb") != -1 or sub_name.find("particle") != -1 or sub_name.find("pixel") != -1 or sub_name.find("cloud") != -1:
			var cloned: Dictionary = src_entry.duplicate()
			cloned["atlas"] = atlas_name
			entries[sub_name] = cloned

	for synth_name: String in TREE_FISH_SYNTHETIC_REGIONS.keys():
		var rect: Rect2 = TREE_FISH_SYNTHETIC_REGIONS[synth_name]
		var entry: Dictionary = {
			"atlas": atlas_name,
			"base_dir": SPRITE_SHEETS_DIR,
			"image_path": image_path_str,
			"name": synth_name,
			"region": rect,
			"margin": Rect2(0.0, 0.0, 0.0, 0.0),
			"frame": Rect2(0.0, 0.0, 0.0, 0.0),
			"pivot": rect.size * 0.5,
			"rotated": false
		}
		entries[synth_name] = entry
		if not _global_subtextures.has(synth_name):
			_global_subtextures[synth_name] = entry

	if atlas_name in ["trees_fish", "treesFish", "trees and fish"]:
		var dir: DirAccess = DirAccess.open(_resolve_path(EXTRACTED_TREES_FISH_DIR))
		if dir != null:
			dir.list_dir_begin()
			var fname: String = dir.get_next()
			while not fname.is_empty():
				if not dir.current_is_dir() and fname.ends_with(".png"):
					var sub_name: String = fname.get_basename()
					var extracted_path: String = "%s/%s" % [EXTRACTED_TREES_FISH_DIR, fname]
					var ext_entry: Dictionary = {
						"atlas": atlas_name,
						"base_dir": EXTRACTED_TREES_FISH_DIR,
						"image_path": extracted_path,
						"extracted_path": extracted_path,
						"name": sub_name,
						"region": Rect2(),
						"margin": Rect2(0.0, 0.0, 0.0, 0.0),
						"frame": Rect2(0.0, 0.0, 0.0, 0.0),
						"pivot": Vector2.ZERO,
						"rotated": false
					}
					entries[sub_name] = ext_entry
					_global_subtextures[sub_name] = ext_entry
				fname = dir.get_next()
			dir.list_dir_end()

	_atlas_entries[atlas_name] = entries
	if load_png_now:
		var tex: Texture2D = _load_atlas_page_texture(source_atlas_name, SPRITE_SHEETS_DIR, image_path_str.get_file())
		if tex != null:
			_atlas_pages[atlas_name] = tex
	return true


## Возвращает Texture2D (AtlasTexture или ImageTexture для повернутых спрайтов) по имени подтекстуры и (опционально) имени атласа.
## Если atlas_name пустой, ищет во всех зарегистрированных атласах.
func get_texture(subtexture_name: String, atlas_name: String = "") -> Texture2D:
	if not atlas_name.is_empty():
		var cache_key: String = "%s::%s" % [atlas_name, subtexture_name]
		if _texture_cache.has(cache_key):
			return _texture_cache[cache_key]
		if not _atlas_entries.has(atlas_name):
			register_starling_atlas(atlas_name)
		var atlas_dict: Dictionary = _atlas_entries.get(atlas_name, {})
		if atlas_dict.has(subtexture_name):
			return _build_atlas_texture(atlas_dict[subtexture_name])
		
		# Поддержка вариаций с пробелами/без (например, 'background1' vs 'background 1')
		var variants: Array[String] = []
		if subtexture_name.contains(" "):
			variants.append(subtexture_name.replace(" ", ""))
		else:
			# Пробуем вставить пробел перед последней цифрой (background1 -> background 1)
			var len_s: int = subtexture_name.length()
			if len_s > 1 and subtexture_name[len_s - 1].is_valid_int():
				variants.append(subtexture_name.substr(0, len_s - 1) + " " + subtexture_name[len_s - 1])
		for v: String in variants:
			if atlas_dict.has(v):
				return _build_atlas_texture(atlas_dict[v])

		var lower_target: String = subtexture_name.to_lower()
		for k: String in atlas_dict.keys():
			if k.to_lower() == lower_target:
				return _build_atlas_texture(atlas_dict[k])
		var lower_00: String = lower_target + "_00"
		for k: String in atlas_dict.keys():
			if k.to_lower() == lower_00:
				return _build_atlas_texture(atlas_dict[k])
		return null

	# Поиск по глобальному индексу
	if _global_subtextures.is_empty():
		preload_all_atlas_metadata(false)

	if _global_subtextures.has(subtexture_name):
		var entry: Dictionary = _global_subtextures[subtexture_name]
		return _build_atlas_texture(entry)

	var global_lower: String = subtexture_name.to_lower()
	for k: String in _global_subtextures.keys():
		if k.to_lower() == global_lower:
			return _build_atlas_texture(_global_subtextures[k])
	var global_lower_00: String = global_lower + "_00"
	for k: String in _global_subtextures.keys():
		if k.to_lower() == global_lower_00:
			return _build_atlas_texture(_global_subtextures[k])

	return null


## Алиас для совместимости с кодом Stage 7
func get_starling_texture(atlas_name: String, subtexture_name: String) -> Texture2D:
	return get_texture(subtexture_name, atlas_name)


## Эквивалент Starling TextureAtlas.getTextures(prefix):
## возвращает массив Texture2D, отсортированных в алфавитном порядке по имени региона.
func get_textures_by_prefix(prefix: String, atlas_name: String = "") -> Array[Texture2D]:
	var cache_key: String = "%s::%s" % [atlas_name, prefix]
	if _prefix_cache.has(cache_key):
		return _prefix_cache[cache_key]

	var matched_names: PackedStringArray = PackedStringArray()
	var source_dict: Dictionary = {}

	if not atlas_name.is_empty():
		if not _atlas_entries.has(atlas_name):
			register_starling_atlas(atlas_name)
		source_dict = _atlas_entries.get(atlas_name, {})
	else:
		if _global_subtextures.is_empty():
			preload_all_atlas_metadata(false)
		source_dict = _global_subtextures

	for sub_name: String in source_dict.keys():
		if sub_name.begins_with(prefix):
			matched_names.append(sub_name)

	matched_names.sort()

	var result: Array[Texture2D] = []
	for sub_name: String in matched_names:
		var entry: Dictionary = source_dict[sub_name]
		var tex: Texture2D = _build_atlas_texture(entry)
		if tex != null:
			result.append(tex)

	_prefix_cache[cache_key] = result
	return result


## Возвращает метаданные региона (включая pivotX/pivotY и оригинальный Starling frame).
func get_subtexture_meta(subtexture_name: String, atlas_name: String = "") -> Dictionary:
	if not atlas_name.is_empty():
		if not _atlas_entries.has(atlas_name):
			register_starling_atlas(atlas_name)
		var atlas_dict: Dictionary = _atlas_entries.get(atlas_name, {})
		return atlas_dict.get(subtexture_name, {})
	if _global_subtextures.is_empty():
		preload_all_atlas_metadata(false)
	return _global_subtextures.get(subtexture_name, {})


## Возвращает точку привязки (pivotX, pivotY) из XML атласа для заданного спрайта.
func get_pivot(subtexture_name: String, atlas_name: String = "") -> Vector2:
	var meta: Dictionary = get_subtexture_meta(subtexture_name, atlas_name)
	return meta.get("pivot", Vector2.ZERO)


## Строит ресурс SpriteFrames из одного или нескольких префиксов анимаций Starling.
func build_sprite_frames(animations: Dictionary, atlas_name: String = "", default_fps: float = 30.0) -> SpriteFrames:
	var sf: SpriteFrames = SpriteFrames.new()
	if sf.has_animation("default"):
		sf.remove_animation("default")

	for anim_name: String in animations.keys():
		var spec: Variant = animations[anim_name]
		var prefix: String = ""
		var fps: float = default_fps
		var loop: bool = true
		if spec is String:
			prefix = spec
		elif spec is Dictionary:
			prefix = str(spec.get("prefix", anim_name))
			fps = float(spec.get("fps", default_fps))
			loop = bool(spec.get("loop", true))

		sf.add_animation(anim_name)
		sf.set_animation_speed(anim_name, fps)
		sf.set_animation_loop(anim_name, loop)

		var frames: Array[Texture2D] = get_textures_by_prefix(prefix, atlas_name)
		for tex: Texture2D in frames:
			sf.add_frame(anim_name, tex)

	return sf


## Загружает координаты сборки частей тела питомцев из pet_body_locations.xml (или .json).
## В оригинальном pet_body_locations.xml структура:
## <pets>
##   <tebra>
##     <walkFrame>41</walkFrame>
##     <helmetOffsetX>-7</helmetOffsetX>
##     <headX>4,4,4,...</headX>
##     ...
##   </tebra>
##   ...
## </pets>
func load_pet_body_locations() -> Dictionary:
	pet_body_locations.clear()

	var json_path: String = "%s/pet_body_locations.json" % MISC_DIR
	if _file_exists(json_path):
		var text: String = FileAccess.get_file_as_string(_resolve_path(json_path))
		var parsed: Variant = JSON.parse_string(text)
		if parsed is Dictionary:
			var idx: int = 1
			for k: Variant in parsed.keys():
				var key_str: String = str(k)
				pet_body_locations[key_str] = parsed[k]
				pet_body_locations[key_str.to_lower()] = parsed[k]
				if key_str.is_valid_int():
					pet_body_locations[key_str.to_int()] = parsed[k]
				else:
					pet_body_locations[idx] = parsed[k]
					idx += 1
			return pet_body_locations

	var xml_path: String = "%s/pet_body_locations.xml" % MISC_DIR
	if not _file_exists(xml_path):
		push_warning("[StarlingAtlasLoader] pet_body_locations.xml not found at %s" % xml_path)
		return pet_body_locations

	var parser: XMLParser = XMLParser.new()
	if parser.open(_resolve_path(xml_path)) != OK:
		return pet_body_locations

	var current_pet_key: String = ""
	var current_field_tag: String = ""
	var current_record: Dictionary = {}
	var pet_index: int = 0

	while parser.read() == OK:
		var node_type: XMLParser.NodeType = parser.get_node_type()
		if node_type == XMLParser.NODE_ELEMENT:
			var tag: String = parser.get_node_name().strip_edges()
			if tag == "pets":
				continue
			if current_pet_key.is_empty():
				current_pet_key = tag.to_lower()
				pet_index += 1
				current_record = {
					"key": current_pet_key,
					"body_num": pet_index
				}
			else:
				current_field_tag = tag
		elif node_type == XMLParser.NODE_TEXT:
			if not current_pet_key.is_empty() and not current_field_tag.is_empty():
				var raw_text: String = parser.get_node_data().strip_edges()
				current_record[current_field_tag] = _parse_pet_xml_value(current_field_tag, raw_text)
		elif node_type == XMLParser.NODE_ELEMENT_END:
			var end_tag: String = parser.get_node_name().strip_edges()
			if end_tag.to_lower() == current_pet_key and not current_pet_key.is_empty():
				# Обеспечиваем наличие пустых массивов для пустых тегов (<bodyX></bodyX>)
				for array_field: String in ["headX", "headY", "helmetX", "helmetY", "leftLegX", "leftLegY", "rightLegX", "rightLegY", "bodyX", "bodyY", "leftLegRotation", "rightLegRotation", "bodyScaleX", "bodyScaleY"]:
					if not current_record.has(array_field):
						current_record[array_field] = PackedFloat32Array()
				pet_body_locations[current_pet_key] = current_record
				pet_body_locations[pet_index] = current_record
				current_pet_key = ""
				current_field_tag = ""
				current_record = {}
			elif end_tag == current_field_tag:
				current_field_tag = ""

	return pet_body_locations


func _parse_pet_xml_value(field_name: String, raw_text: String) -> Variant:
	if raw_text.is_empty():
		return PackedFloat32Array()
	if field_name == "bodyFrames":
		var parts: PackedStringArray = raw_text.split(",", false)
		var out_names: PackedStringArray = PackedStringArray()
		for p: String in parts:
			out_names.append(p.strip_edges())
		return out_names
	if raw_text.find(",") != -1:
		var nums: PackedFloat32Array = PackedFloat32Array()
		for part: String in raw_text.split(",", false):
			var clean: String = part.strip_edges()
			if clean.is_valid_float():
				nums.append(clean.to_float())
		return nums
	if raw_text.is_valid_int():
		return raw_text.to_int()
	if raw_text.is_valid_float():
		return raw_text.to_float()
	return raw_text


## Возвращает словарь координат привязки для тела питомца по имени ("tebra", "Baby Bounce") или номеру (1..38).
func get_pet_body_location(pet_key_or_num: Variant) -> Dictionary:
	if pet_body_locations.is_empty():
		load_pet_body_locations()
	if pet_key_or_num is int:
		return pet_body_locations.get(pet_key_or_num, {})
	var clean_key: String = str(pet_key_or_num).to_lower().replace(" ", "").replace("\t", "").replace("\r", "").replace("\n", "")
	if pet_body_locations.has(clean_key):
		return pet_body_locations[clean_key]
	if clean_key.is_valid_int():
		return pet_body_locations.get(clean_key.to_int(), {})
	return {}


## Загружает BitmapFont (.fnt) или TTF шрифт из includes/ или sprite_sheets/.
func get_bitmap_font(font_filename: String = "bitmap_font_1.fnt") -> Font:
	var lookup_name: String = font_filename

	if _fonts_cache.has(lookup_name):
		return _fonts_cache[lookup_name]

	for dir_path: String in [FONTS_DIR, SPRITE_SHEETS_DIR, EXTRACTED_BITMAP_FONTS_DIR]:
		var path: String = "%s/%s" % [dir_path, lookup_name]
		if ResourceLoader.exists(path):
			var res: Resource = ResourceLoader.load(path)
			if res is Font:
				_fonts_cache[lookup_name] = res
				return res

		var global_path: String = _resolve_path(path)
		if FileAccess.file_exists(global_path):
			var font_file: FontFile = FontFile.new()
			var err: Error = OK
			if lookup_name.ends_with(".fnt"):
				var probe: FileAccess = FileAccess.open(global_path, FileAccess.READ)
				var head: String = probe.get_line().strip_edges() if probe != null else ""
				if probe != null:
					probe.close()
				if head.begins_with("<"):
					var xml_font: FontFile = _load_xml_bitmap_font(global_path)
					if xml_font != null:
						_fonts_cache[lookup_name] = xml_font
						return xml_font
					err = ERR_PARSE_ERROR
				else:
					err = font_file.load_bitmap_font(global_path)
					if err == OK:
						font_file.fixed_size_scale_mode = TextServer.FIXED_SIZE_SCALE_ENABLED
			elif lookup_name.ends_with(".ttf") or lookup_name.ends_with(".otf"):
				err = font_file.load_dynamic_font(global_path)
			if err == OK:
				_fonts_cache[lookup_name] = font_file
				return font_file

	return ThemeDB.fallback_font


## Возвращает BitmapFont для всплывающих чисел урона (Assets.damage_font / Yikes! damage).
## При отсутствии файла в headless-режиме плавно откатывается на stats_font.fnt или системный шрифт.
func get_damage_font() -> Font:
	var dmg_font: Font = get_bitmap_font("damage_font.fnt")
	if dmg_font != null and dmg_font != ThemeDB.fallback_font:
		return dmg_font
	var stats_font: Font = get_bitmap_font("stats_font.fnt")
	if stats_font != null:
		return stats_font
	return ThemeDB.fallback_font


func _load_xml_bitmap_font(global_path: String) -> FontFile:
	var parser: XMLParser = XMLParser.new()
	if parser.open(global_path) != OK:
		return null

	var font_file: FontFile = FontFile.new()
	var face_name: String = ""
	var font_size: int = 16
	var line_height: float = 16.0
	var base_val: float = 12.0
	var pages: Dictionary = {}
	var glyph_rows: Array[Dictionary] = []
	var kernings: Array[Dictionary] = []

	while parser.read() == OK:
		if parser.get_node_type() != XMLParser.NODE_ELEMENT:
			continue
		var tag: String = parser.get_node_name()
		if tag == "info":
			face_name = parser.get_named_attribute_value_safe("face")
			var sz_str: String = parser.get_named_attribute_value_safe("size")
			if sz_str.is_valid_int():
				font_size = maxi(1, sz_str.to_int())
		elif tag == "common":
			var lh_str: String = parser.get_named_attribute_value_safe("lineHeight")
			if lh_str.is_valid_float():
				line_height = lh_str.to_float()
			var b_str: String = parser.get_named_attribute_value_safe("base")
			if b_str.is_valid_float():
				base_val = b_str.to_float()
		elif tag == "page":
			var pid: int = parser.get_named_attribute_value_safe("id").to_int()
			var pfile: String = parser.get_named_attribute_value_safe("file")
			if not pfile.is_empty():
				pages[pid] = pfile
		elif tag == "char":
			glyph_rows.append({
				"id": parser.get_named_attribute_value_safe("id").to_int(),
				"x": parser.get_named_attribute_value_safe("x").to_float(),
				"y": parser.get_named_attribute_value_safe("y").to_float(),
				"width": parser.get_named_attribute_value_safe("width").to_float(),
				"height": parser.get_named_attribute_value_safe("height").to_float(),
				"xoffset": parser.get_named_attribute_value_safe("xoffset").to_float(),
				"yoffset": parser.get_named_attribute_value_safe("yoffset").to_float(),
				"xadvance": parser.get_named_attribute_value_safe("xadvance").to_float(),
				"page": parser.get_named_attribute_value_safe("page").to_int()
			})
		elif tag == "kerning":
			kernings.append({
				"first": parser.get_named_attribute_value_safe("first").to_int(),
				"second": parser.get_named_attribute_value_safe("second").to_int(),
				"amount": parser.get_named_attribute_value_safe("amount").to_float()
			})

	if pages.is_empty() or glyph_rows.is_empty():
		return null

	font_file.font_name = face_name
	font_file.fixed_size = font_size
	font_file.fixed_size_scale_mode = TextServer.FIXED_SIZE_SCALE_ENABLED
	var cache_idx: int = 0
	var size_key: Vector2i = Vector2i(font_size, 0)
	font_file.set_cache_ascent(cache_idx, font_size, base_val)
	font_file.set_cache_descent(cache_idx, font_size, maxf(0.0, line_height - base_val))

	var base_dir: String = global_path.get_base_dir()
	var page_indices: Dictionary = {}
	var page_ids: Array = pages.keys()
	page_ids.sort()
	for i: int in range(page_ids.size()):
		var pid: int = int(page_ids[i])
		var img_path: String = base_dir.path_join(str(pages[pid]))
		if not FileAccess.file_exists(img_path):
			return null
		var img: Image = Image.load_from_file(img_path)
		if img == null:
			return null
		font_file.set_texture_image(cache_idx, size_key, i, img)
		page_indices[pid] = i

	for row: Dictionary in glyph_rows:
		var cid: int = int(row["id"])
		var tex_idx: int = int(page_indices.get(int(row["page"]), 0))
		font_file.set_glyph_advance(cache_idx, font_size, cid, Vector2(float(row["xadvance"]), 0.0))
		font_file.set_glyph_offset(cache_idx, size_key, cid, Vector2(float(row["xoffset"]), float(row["yoffset"]) - base_val))
		font_file.set_glyph_size(cache_idx, size_key, cid, Vector2(float(row["width"]), float(row["height"])))
		font_file.set_glyph_uv_rect(cache_idx, size_key, cid, Rect2(float(row["x"]), float(row["y"]), float(row["width"]), float(row["height"])))
		font_file.set_glyph_texture_idx(cache_idx, size_key, cid, tex_idx)

	for k: Dictionary in kernings:
		font_file.set_kerning(cache_idx, font_size, Vector2i(int(k["first"]), int(k["second"])), Vector2(float(k["amount"]), 0.0))

	return font_file


func _build_atlas_texture(entry: Dictionary) -> Texture2D:
	var atlas_name: String = entry["atlas"]
	var sub_name: String = entry["name"]
	var cache_key: String = "%s::%s" % [atlas_name, sub_name]
	if _texture_cache.has(cache_key):
		return _texture_cache[cache_key]

	if entry.has("extracted_path"):
		var ext_path: String = str(entry["extracted_path"])
		var ext_tex: Texture2D = _load_extracted_png_texture(ext_path)
		if ext_tex != null:
			ext_tex.set_meta("pivot", ext_tex.get_size() * 0.5)
			ext_tex.set_meta("frame", entry.get("frame", Rect2()))
			ext_tex.set_meta("rotated", false)
			ext_tex.set_meta("atlas_name", atlas_name)
			ext_tex.set_meta("subtexture_name", sub_name)
			_texture_cache[cache_key] = ext_tex
			return ext_tex

	var page_tex: Texture2D = _load_atlas_page_texture(
		atlas_name,
		entry.get("base_dir", SPRITE_SHEETS_DIR),
		entry.get("image_path", "").get_file()
	)
	if page_tex == null:
		return null

	var is_rotated: bool = entry.get("rotated", false)
	if is_rotated:
		var page_img: Image = page_tex.get_image()
		if page_img != null:
			var reg: Rect2 = entry["region"]
			var sub_img: Image = page_img.get_region(Rect2i(int(reg.position.x), int(reg.position.y), int(reg.size.x), int(reg.size.y)))
			sub_img.rotate_90(COUNTERCLOCKWISE)
			var img_tex: ImageTexture = ImageTexture.create_from_image(sub_img)
			img_tex.set_meta("pivot", entry["pivot"])
			img_tex.set_meta("frame", entry["frame"])
			img_tex.set_meta("rotated", true)
			img_tex.set_meta("atlas_name", atlas_name)
			img_tex.set_meta("subtexture_name", sub_name)
			_texture_cache[cache_key] = img_tex
			return img_tex

	var atlas_tex: AtlasTexture = AtlasTexture.new()
	atlas_tex.atlas = page_tex
	atlas_tex.region = entry["region"]
	var margin: Rect2 = entry["margin"]
	if margin.position != Vector2.ZERO or margin.size != Vector2.ZERO:
		atlas_tex.margin = margin
	atlas_tex.filter_clip = true

	# Сохраняем Starling-метаданные прямо в мета-данных ресурса AtlasTexture
	atlas_tex.set_meta("pivot", entry["pivot"])
	atlas_tex.set_meta("frame", entry["frame"])
	atlas_tex.set_meta("rotated", entry["rotated"])
	atlas_tex.set_meta("atlas_name", atlas_name)
	atlas_tex.set_meta("subtexture_name", sub_name)

	_texture_cache[cache_key] = atlas_tex
	return atlas_tex


func _load_extracted_png_texture(res_path: String) -> AtlasTexture:
	var base_tex: Texture2D = null
	var global_path: String = _resolve_path(res_path)
	if FileAccess.file_exists(global_path):
		var img: Image = Image.load_from_file(global_path)
		if img != null and not img.is_empty():
			base_tex = ImageTexture.create_from_image(img)
	elif ResourceLoader.exists(res_path):
		var loaded: Resource = ResourceLoader.load(res_path)
		if loaded is Texture2D:
			base_tex = loaded
	if base_tex == null:
		return null
	if base_tex is AtlasTexture:
		return base_tex
	var at := AtlasTexture.new()
	at.atlas = base_tex
	at.region = Rect2(Vector2.ZERO, base_tex.get_size())
	return at


func _load_atlas_page_texture(atlas_name: String, base_dir: String = SPRITE_SHEETS_DIR, image_file: String = "") -> Texture2D:
	if _atlas_pages.has(atlas_name):
		return _atlas_pages[atlas_name]

	if image_file.is_empty():
		image_file = "%s.png" % atlas_name

	var res_path: String = "%s/%s" % [base_dir, image_file]
	var global_path: String = _resolve_path(res_path)

	if FileAccess.file_exists(global_path):
		var img: Image = Image.load_from_file(global_path)
		if img != null and not img.is_empty():
			var tex: ImageTexture = ImageTexture.create_from_image(img)
			_atlas_pages[atlas_name] = tex
			return tex

	if ResourceLoader.exists(res_path):
		var loaded: Resource = ResourceLoader.load(res_path)
		if loaded is Texture2D:
			_atlas_pages[atlas_name] = loaded
			return loaded

	push_error("[StarlingAtlasLoader] Failed to load PNG page for atlas: %s (%s)" % [atlas_name, res_path])
	return null


func _resolve_path(res_path: String) -> String:
	if res_path.begins_with("res://") or res_path.begins_with("user://"):
		return ProjectSettings.globalize_path(res_path)
	return res_path


func _file_exists(res_path: String) -> bool:
	return FileAccess.file_exists(_resolve_path(res_path)) or ResourceLoader.exists(res_path)
