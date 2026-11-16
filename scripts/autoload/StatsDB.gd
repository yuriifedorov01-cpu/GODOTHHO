extends Node
## StatsDB — Глобальная база данных игры Helmet Heroes (порт com.stats.Stats).
## Загружает все JSON-таблицы предметов, экипировки, питомцев, врагов, NPC и карт map_1..map_145,
## а также синхронизирует их с BigDB (PayVaultItems / Items) и локальным кешем user://db_items_cache.json.

signal database_loaded()
signal database_synced_with_bigdb()

const GameConfigRef = preload("res://scripts/autoload/GameConfig.gd")
const DATA_DIR: String = "res://assets/client_data/data"
const EXTRACTED_DIR: String = "res://assets/extracted"
const LOCAL_CACHE_PATH: String = "user://db_items_cache.json"

const MAP_LAYER_NAMES: PackedStringArray = [
	"mapMain",
	"mapG2",
	"mapG3",
	"mapWater",
	"mapArt",
	"mapFG"
]

## Сырые JSON-таблицы из data/*.json (индексированы как по строковому "key", так и по целочисленному 1-based ID и "f" frame)
var helmet_stats: Dictionary = {}
var shirt_stats: Dictionary = {}
var leg_stats: Dictionary = {}
var shoe_stats: Dictionary = {}
var weapon_stats: Dictionary = {}
var acc_stats: Dictionary = {}
var item_data: Dictionary = {}
var item_descs: Dictionary = {}
var pet_helmets: Dictionary = {}
var base_pet_data: Dictionary = {}
var enemy_stats: Dictionary = {}
var pay_vault_items: Dictionary = {}
var npcs_data: Dictionary = {}
var npcs_list: Array = []

## Расширенные метаданные из assets/extracted/
var areas_meta: Dictionary = {}
var moves_data: Dictionary = {}
var skills_meta: Dictionary = {}
var missions_data: Dictionary = {}
var body_animator_data: Dictionary = {}
var npc_dialogs: Dictionary = {}

## Унифицированный реестр экипировки и предметов:
## category ("helmet", "shirt", "legs", "shoes", "weapon", "acc", "item", "pet", "pet_helmet") -> Dictionary[id_or_key -> Dictionary]
var items_by_category: Dictionary = {
	"helmet": {},
	"shirt": {},
	"legs": {},
	"shoes": {},
	"weapon": {},
	"acc": {},
	"item": {},
	"pet": {},
	"pet_helmet": {}
}

## Крафтовая древесина / материалы (GameMain.as:7765-7768), билет и все 43 вида рыб (Stats.as:298-340),
## отсутствующие в статическом itemData.json.
const CRAFT_WOOD_ITEMS: PackedStringArray = [
	"palm tree wood",
	"blue mushroom cube",
	"red mushroom cube",
	"purple sheet wood",
	"willow wood",
	"junk wood",
	"colored wood",
	"chestnut wood",
	"pine block",
	"robot bar",
	"jungle wood",
	"stacked wood",
	"thorn wood",
	"snow covered wood",
	"maple wood",
	"cloud tree wood"
]
const EXTRA_GAME_ITEMS: PackedStringArray = ["ticket"]
const FISH_ITEM_NAMES: PackedStringArray = [
	"sliver", "swerm", "puffer", "shroomer", "mufungi", "furry feen", "hairloom",
	"hertle", "plant fungus", "spud", "flipper", "coconut fish", "mud fish",
	"glopper", "plant bacteria", "metal guppy", "iron minnow", "peep fish",
	"dark tadpole", "evil pupe", "dark toad", "mushroom coy", "shroom serpent",
	"lion fish", "stagnant scum", "omate", "greenspot", "sharktooth", "glowshine",
	"subordinate", "dark reaper", "clipper", "pootnick", "root fish",
	"pumpkin shell fish", "pumphin", "snow fish", "ice fish", "lava reef fish",
	"lava spud", "flame coy", "beholder guppy", "krimper"
]

## Канонические (дедуплицированные) списки предметов и врагов для UI/поиска:
## category -> Array[Dictionary] (каждая запись ровно один раз, без числовых ID и lowercase-дублей)
var unique_items_by_category: Dictionary = {}
var unique_enemies: Array[Dictionary] = []

## Кеш загруженных карт: map_id (int) -> Dictionary
var _maps_cache: Dictionary = {}
## Кеш скорректированных метаданных зон: stage_id (int) -> Dictionary
var _area_meta_cache: Dictionary = {}

## Таблица опыта уровней (индекс = уровень 1..250)
var level_exp_table: PackedInt64Array = PackedInt64Array()

## Описания режимов питомцев (из Stats.setPetMode)
var pet_mode_descriptions: Dictionary = {}

## Описания скиллов (из Stats.setNewSkill)
var skill_data: Dictionary = {}

## Описания миссий (из Stats.setNewMission)
var mission_descriptions: Dictionary = {}

var is_loaded: bool = false


func _ready() -> void:
	_init_level_exp_table()
	_init_pet_mode_descriptions()
	_init_skill_data()
	load_all_local_json()
	load_local_bigdb_cache()
	is_loaded = true
	database_loaded.emit()


## Загружает все 13 JSON-файлов из data/.
func load_all_local_json() -> void:
	helmet_stats = _load_json_dict("helmetStats.json")
	shirt_stats = _load_json_dict("shirtStats.json")
	leg_stats = _load_json_dict("legStats.json")
	shoe_stats = _load_json_dict("shoeStats.json")
	weapon_stats = _load_json_dict("weaponStats.json")
	acc_stats = _load_json_dict("accStats.json")
	item_data = _load_json_dict("itemData.json")
	item_descs = _load_json_dict("itemDescs.json")
	pet_helmets = _load_json_dict("petHelmets.json")
	base_pet_data = _load_json_dict("basePetData.json")
	enemy_stats = _load_json_dict("enemyStats.json")
	pay_vault_items = _load_json_dict("PayVaultItems.json")
	npcs_data = _load_json_dict("npcs.json")

	# Загрузка расширенных таблиц из assets/extracted/
	areas_meta = _load_json_file("%s/areas_meta.json" % EXTRACTED_DIR)
	moves_data = _load_json_file("%s/moves_data.json" % EXTRACTED_DIR)
	skills_meta = _load_json_file("%s/skills_meta.json" % EXTRACTED_DIR)
	missions_data = _load_json_file("%s/missions_data.json" % EXTRACTED_DIR)
	body_animator_data = _load_json_file("%s/body_animator_data.json" % EXTRACTED_DIR)
	npc_dialogs = _load_json_file("%s/npc_dialogs.json" % EXTRACTED_DIR)

	_rebuild_unified_indices()


func _rebuild_unified_indices() -> void:
	items_by_category["helmet"] = _index_by_int_or_str(helmet_stats, "helmet")
	items_by_category["shirt"] = _index_by_int_or_str(shirt_stats, "shirt")
	items_by_category["legs"] = _index_by_int_or_str(leg_stats, "legs")
	items_by_category["shoes"] = _index_by_int_or_str(shoe_stats, "shoes")
	items_by_category["weapon"] = _index_by_int_or_str(weapon_stats, "weapon")
	items_by_category["acc"] = _index_by_int_or_str(acc_stats, "acc")
	items_by_category["item"] = _index_by_int_or_str(item_data, "item")
	items_by_category["pet"] = _index_by_int_or_str(base_pet_data, "pet")
	items_by_category["pet_helmet"] = _index_by_int_or_str(pet_helmets, "pet_helmet")

	# Регистрируем крафтовую древесину, ticket и 43 рыбы, отсутствующие в itemData.json
	var extra_groups: Array[Dictionary] = [
		{"names": CRAFT_WOOD_ITEMS, "kind": "material", "craft": true},
		{"names": EXTRA_GAME_ITEMS, "kind": "item", "craft": false},
		{"names": FISH_ITEM_NAMES, "kind": "fish", "craft": false}
	]
	var synth_id: int = 1000
	for grp: Dictionary in extra_groups:
		var names_arr: PackedStringArray = grp["names"]
		var kind_str: String = str(grp["kind"])
		var is_craft: bool = bool(grp["craft"])
		for extra_name: String in names_arr:
			var low: String = extra_name.to_lower()
			if not items_by_category["item"].has(low):
				synth_id += 1
				var extra_rec: Dictionary = {
					"id": synth_id,
					"key": extra_name,
					"_key": extra_name,
					"_category": "item",
					"_item_kind": kind_str,
					"c": 0
				}
				if is_craft:
					extra_rec["_craft_only"] = true
				items_by_category["item"][synth_id] = extra_rec
				items_by_category["item"][extra_name] = extra_rec
				items_by_category["item"][low] = extra_rec

	# Мержим описания из itemDescs.json во все соответствующие категории (включая net и chainsaw из weapon)
	for key: Variant in item_descs.keys():
		var desc_entry: Variant = item_descs[key]
		if not (desc_entry is Dictionary):
			continue
		var key_str: String = str(key)
		var target_key: String = str(desc_entry.get("key", desc_entry.get("name", key_str))).strip_edges()
		if target_key.is_empty():
			target_key = key_str
		for cat: String in ["item", "weapon", "helmet", "shirt", "legs", "shoes", "acc", "pet_helmet", "pet"]:
			var cat_dict: Dictionary = items_by_category.get(cat, {})
			if cat_dict.has(target_key):
				var target: Dictionary = cat_dict[target_key]
				for dk: Variant in desc_entry.keys():
					target[dk] = desc_entry[dk]
			elif target_key.is_valid_int() and cat_dict.has(target_key.to_int()):
				var target_int: Dictionary = cat_dict[target_key.to_int()]
				for dk: Variant in desc_entry.keys():
					target_int[dk] = desc_entry[dk]

	# Строим дедуплицированные канонические списки всех предметов и врагов
	unique_items_by_category.clear()
	for cat: String in ["helmet", "shirt", "legs", "shoes", "weapon", "acc", "item", "pet", "pet_helmet"]:
		var seen_keys: Dictionary = {}
		var cat_list: Array[Dictionary] = []
		var cat_dict: Dictionary = items_by_category.get(cat, {})
		for rec_val: Variant in cat_dict.values():
			if not (rec_val is Dictionary):
				continue
			var rec: Dictionary = rec_val
			var rec_name: String = str(rec.get("_key", rec.get("key", ""))).strip_edges()
			if rec_name.is_empty() or rec_name.to_lower() == "none" or rec_name.is_valid_int():
				continue
			var low_name: String = rec_name.to_lower()
			if seen_keys.has(low_name):
				continue
			seen_keys[low_name] = true
			cat_list.append(rec)
		cat_list.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
			return int(a.get("id", 0)) < int(b.get("id", 0))
		)
		unique_items_by_category[cat] = cat_list

	unique_enemies.clear()
	var seen_enemies: Dictionary = {}
	for e_val: Variant in enemy_stats.values():
		if not (e_val is Dictionary):
			continue
		var e_rec: Dictionary = e_val
		var e_name: String = str(e_rec.get("key", e_rec.get("name", ""))).strip_edges()
		if e_name.is_empty() or e_name.is_valid_int():
			continue
		var e_low: String = e_name.to_lower()
		if seen_enemies.has(e_low):
			continue
		seen_enemies[e_low] = true
		unique_enemies.append(e_rec)
	unique_enemies.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var xp_a: int = int(a.get("xp", 0))
		var xp_b: int = int(b.get("xp", 0))
		if xp_a == xp_b:
			return str(a.get("key", "")).to_lower() < str(b.get("key", "")).to_lower()
		return xp_a < xp_b
	)

	_area_meta_cache.clear()

	# Дополняем информацией из PayVaultItems.json (цены в золоте/кредитах/жетонах)
	for pv_key: Variant in pay_vault_items.keys():
		var pv_obj: Variant = pay_vault_items[pv_key]
		if not (pv_obj is Dictionary):
			continue
		var parsed_key: Dictionary = _parse_payvault_key(str(pv_key))
		if parsed_key.is_empty():
			continue
		var cat: String = parsed_key["category"]
		var item_id: int = parsed_key["id"]
		if items_by_category.has(cat) and items_by_category[cat].has(item_id):
			var item_rec: Dictionary = items_by_category[cat][item_id]
			if pv_obj.has("PriceCoins"):
				item_rec["PriceCoins"] = int(pv_obj["PriceCoins"])
			if pv_obj.has("PriceGold"):
				item_rec["PriceGold"] = int(pv_obj["PriceGold"])
			if pv_obj.has("PriceTokens"):
				item_rec["PriceTokens"] = int(pv_obj["PriceTokens"])


func _index_by_int_or_str(source: Dictionary, category: String) -> Dictionary:
	var out: Dictionary = {}
	for k: Variant in source.keys():
		var entry: Variant = source[k]
		var rec: Dictionary = {}
		if entry is Dictionary:
			rec = entry.duplicate(true)
		else:
			rec = {"value": entry}
		rec["_category"] = category
		var key_str: String = str(rec.get("key", rec.get("name", k)))
		rec["_key"] = key_str
		if k is int:
			rec["id"] = int(k)
			out[int(k)] = rec
		elif str(k).is_valid_int():
			var id_num: int = str(k).to_int()
			rec["id"] = id_num
			out[id_num] = rec
		if rec.has("f") and str(rec["f"]).is_valid_int():
			var frame_id: int = int(rec["f"])
			if not out.has(frame_id):
				out[frame_id] = rec
		out[key_str] = rec
		out[key_str.to_lower()] = rec
	return out


func _parse_payvault_key(pv_key: String) -> Dictionary:
	var prefixes: Dictionary = {
		"helm_": "helmet",
		"helmet_": "helmet",
		"shirt_": "shirt",
		"legs_": "legs",
		"leg_": "legs",
		"shoes_": "shoes",
		"shoe_": "shoes",
		"weapon_": "weapon",
		"acc_": "acc",
		"item_": "item",
		"pet_": "pet"
	}
	for prefix: String in prefixes.keys():
		if pv_key.begins_with(prefix):
			var rest: String = pv_key.substr(prefix.length())
			if rest.is_valid_int():
				return {"category": prefixes[prefix], "id": rest.to_int()}
	return {}


## Возвращает статы экипировки/предмета по категории и ID или строковому имени (эквивалент Stats.getItemStatsData).
func get_item_stats_data(category: String, item_id: Variant) -> Dictionary:
	var norm_cat: String = _normalize_category(category)
	if not items_by_category.has(norm_cat):
		return {}
	var cat_dict: Dictionary = items_by_category[norm_cat]
	if item_id is int and cat_dict.has(item_id):
		return cat_dict[item_id]
	var str_id: String = str(item_id)
	if str_id.is_valid_int() and cat_dict.has(str_id.to_int()):
		return cat_dict[str_id.to_int()]
	if cat_dict.has(str_id):
		return cat_dict[str_id]
	if cat_dict.has(str_id.to_lower()):
		return cat_dict[str_id.to_lower()]
	return {}


## Ищет данные предмета по имени во всех категориях (эквивалент Stats.getItemArray / getItemType).
func get_item_data(item_name: String) -> Dictionary:
	var clean_name: String = item_name.strip_edges()
	if clean_name.is_empty():
		return {}
	var candidates: Array[String] = [clean_name]
	if clean_name.to_lower().begins_with("shiny "):
		candidates.append(clean_name.substr(6).strip_edges())
	for candidate: String in candidates:
		for cat: String in ["helmet", "shirt", "legs", "shoes", "weapon", "acc", "item", "pet_helmet", "pet"]:
			var d: Dictionary = get_item_stats_data(cat, candidate)
			if not d.is_empty():
				return d
	return {}


## Возвращает нормализованную категорию предмета ("helmet", "shirt", "legs", "shoes", "weapon", "acc", "item", "pet", "pet_helmet").
func get_item_category(item_name: String) -> String:
	var d: Dictionary = get_item_data(item_name)
	return str(d.get("_category", ""))


func get_helmet_data(id: Variant) -> Dictionary:
	return get_item_stats_data("helmet", id)


func get_shirt_data(id: Variant) -> Dictionary:
	return get_item_stats_data("shirt", id)


func get_leg_data(id: Variant) -> Dictionary:
	return get_item_stats_data("legs", id)


func get_shoe_data(id: Variant) -> Dictionary:
	return get_item_stats_data("shoes", id)


func get_weapon_data(id: Variant) -> Dictionary:
	return get_item_stats_data("weapon", id)


func get_acc_data(id: Variant) -> Dictionary:
	return get_item_stats_data("acc", id)


func get_consumable_or_material_data(id: Variant) -> Dictionary:
	return get_item_stats_data("item", id)


func get_pet_base_data(id: Variant) -> Dictionary:
	return get_item_stats_data("pet", id)


func get_pet_helmet_data(id: Variant) -> Dictionary:
	return get_item_stats_data("pet_helmet", id)


## Возвращает данные врага по строковому типу (например "green bouncer", "Carnelia") или числовому ID.
func get_enemy_data(enemy_key: Variant) -> Dictionary:
	if enemy_key is int and enemy_stats.has(enemy_key):
		return enemy_stats[enemy_key]
	var key_str: String = str(enemy_key)
	if enemy_stats.has(key_str):
		var rec: Variant = enemy_stats[key_str]
		if rec is Dictionary:
			return rec
	if enemy_stats.has(key_str.to_lower()):
		var rec_low: Variant = enemy_stats[key_str.to_lower()]
		if rec_low is Dictionary:
			return rec_low
	if key_str.is_valid_int() and enemy_stats.has(key_str.to_int()):
		return enemy_stats[key_str.to_int()]
	for k: Variant in enemy_stats.keys():
		var entry: Variant = enemy_stats[k]
		if entry is Dictionary:
			if str(entry.get("key", "")).to_lower() == key_str.to_lower() or str(entry.get("type", "")) == key_str or str(entry.get("id", "")) == key_str:
				return entry
	return {}


## Возвращает данные NPC по ID (1..N) или имени ("Ronald", "Snoop", ...).
func get_npc_data(npc_id_or_name: Variant) -> Dictionary:
	if npc_id_or_name is int and npcs_data.has(npc_id_or_name):
		return npcs_data[npc_id_or_name]
	var key_str: String = str(npc_id_or_name)
	if npcs_data.has(key_str):
		var rec: Variant = npcs_data[key_str]
		if rec is Dictionary:
			return rec
	if npcs_data.has(key_str.to_lower()):
		var rec_low: Variant = npcs_data[key_str.to_lower()]
		if rec_low is Dictionary:
			return rec_low
	if key_str.is_valid_int() and npcs_data.has(key_str.to_int()):
		var rec_int: Variant = npcs_data[key_str.to_int()]
		if rec_int is Dictionary:
			return rec_int
	return {}


## Загружает и кеширует карту map_{map_id}.json (1..145, кроме 51 -> редирект на 46 при желании или пустая).
func get_map_data(map_id: int) -> Dictionary:
	if _maps_cache.has(map_id):
		return _maps_cache[map_id]

	var file_name: String = "map_%d.json" % map_id
	var raw_map: Dictionary = _load_json_dict(file_name)
	if raw_map.is_empty():
		return {}

	_maps_cache[map_id] = raw_map
	return raw_map


## Загружает все 144 карты (map_1 .. map_145, кроме 51) и возвращает количество успешно загруженных карт.
func preload_all_maps() -> int:
	var count: int = 0
	for map_id: int in range(1, GameConfigRef.TOTAL_MAP_COUNT + 1):
		if map_id == GameConfigRef.REDIRECTED_STAGE_FROM:
			continue
		var m: Dictionary = get_map_data(map_id)
		if not m.is_empty():
			count += 1
	return count


## Декодирует тайловый слой карты (из Base64 строки, PackedByteArray или JSON Array) в массив int16 (PackedInt32Array).
## Поддерживает:
## 1) Base64-строку (2 байта Little-Endian или Big-Endian int16 на тайл, либо 1 байт на тайл, где 255 -> -1),
## 2) PackedByteArray (например из сетевого пакета "tD" / "geTiles"),
## 3) JSON Array[int] из локальных файлов map_*.json.
func decode_map_layer_int16(layer_data: Variant, as_int16_pairs: bool = true) -> PackedInt32Array:
	var out: PackedInt32Array = PackedInt32Array()
	if layer_data is Array:
		var arr: Array = layer_data
		out.resize(arr.size())
		for i: int in range(arr.size()):
			var v: int = int(arr[i])
			out[i] = -1 if v == 255 else v
		return out
	elif layer_data is PackedInt32Array:
		return layer_data.duplicate()

	var raw_bytes: PackedByteArray = PackedByteArray()
	if layer_data is String:
		var s: String = layer_data.strip_edges()
		if s.is_empty():
			return out
		raw_bytes = Marshalls.base64_to_raw(s)
	elif layer_data is PackedByteArray:
		raw_bytes = layer_data
	else:
		return out

	if as_int16_pairs and raw_bytes.size() >= 2 and (raw_bytes.size() % 2) == 0:
		var num_tiles: int = raw_bytes.size() / 2
		out.resize(num_tiles)
		for i: int in range(num_tiles):
			var lo: int = raw_bytes[i * 2] & 0xFF
			var hi: int = raw_bytes[i * 2 + 1] & 0xFF
			var val: int = (hi << 8) | lo
			if (val & 0x8000) != 0:
				val -= 0x10000
			out[i] = val
		return out

	out.resize(raw_bytes.size())
	for i: int in range(raw_bytes.size()):
		var b: int = raw_bytes[i] & 0xFF
		out[i] = -1 if b == 255 else b
	return out


## Кодирует массив int16 тайлов в Base64 строку (по 2 байта Little-Endian на тайл).
func encode_map_layer_base64_int16(tiles: PackedInt32Array) -> String:
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(tiles.size() * 2)
	for i: int in range(tiles.size()):
		var v: int = tiles[i] & 0xFFFF
		bytes[i * 2] = v & 0xFF
		bytes[i * 2 + 1] = (v >> 8) & 0xFF
	return Marshalls.raw_to_base64(bytes)


## Возвращает декодированный тайловый слой карты по ID карты и имени слоя ("mapMain", "mapG2", "mapG3", "mapWater", "mapArt", "mapFG").
func get_map_layer_int16(map_id: int, layer_name: String = "mapMain") -> PackedInt32Array:
	var map_dict: Dictionary = get_map_data(map_id)
	if map_dict.is_empty():
		return PackedInt32Array()
	var layers: Variant = map_dict.get("layers", {})
	if layers is Dictionary and layers.has(layer_name):
		var layer_val: Variant = layers[layer_name]
		if layer_val is String:
			return decode_map_layer_int16(layer_val, true)
		return decode_map_layer_int16(layer_val, false)
	return PackedInt32Array()


## Возвращает строковый или числовой код тайла по координатам сетки (col, row).
func get_map_tile(map_id: int, col: int, row: int, layer_name: String = "mapMain") -> String:
	var map_dict: Dictionary = get_map_data(map_id)
	if map_dict.is_empty():
		return "n"
	var map_w: int = int(map_dict.get("width", GameConfigRef.MAP_COLS))
	var map_h: int = int(map_dict.get("height", GameConfigRef.MAP_ROWS))
	if col < 0 or col >= map_w or row < 0 or row >= map_h:
		return "n"

	if map_dict.has("layers") and map_dict["layers"] is Dictionary:
		var layers: Dictionary = map_dict["layers"]
		if layers.has(layer_name) and layers[layer_name] is Array:
			var arr: Array = layers[layer_name]
			var idx: int = row * map_w + col
			if idx >= 0 and idx < arr.size():
				var v: int = int(arr[idx])
				return "n" if (v == 255 or v < 0) else str(v)

	var tile_index: int = row * map_w + col + 1
	return str(map_dict.get(str(tile_index), "n"))


## Применяет обновления предметов из BigDB (таблица PayVaultItems или Items) и сохраняет локальный кеш.
func apply_bigdb_items_override(bigdb_objects: Dictionary, save_to_cache: bool = true) -> void:
	for obj_key: Variant in bigdb_objects.keys():
		var obj_val: Variant = bigdb_objects[obj_key]
		if obj_val is Dictionary:
			pay_vault_items[str(obj_key)] = obj_val
	_rebuild_unified_indices()
	if save_to_cache:
		save_local_bigdb_cache(bigdb_objects)
	database_synced_with_bigdb.emit()


func load_local_bigdb_cache() -> void:
	if not FileAccess.file_exists(LOCAL_CACHE_PATH):
		return
	var text: String = FileAccess.get_file_as_string(LOCAL_CACHE_PATH)
	if text.is_empty():
		return
	var parsed: Variant = JSON.parse_string(text)
	if parsed is Dictionary and not parsed.is_empty():
		apply_bigdb_items_override(parsed, false)


func save_local_bigdb_cache(data_to_cache: Dictionary) -> void:
	var file: FileAccess = FileAccess.open(LOCAL_CACHE_PATH, FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify(data_to_cache))
		file.close()


## Возвращает количество опыта, необходимое для достижения указанного уровня.
func get_exp_for_level(level: int) -> int:
	if level <= 1:
		return 0
	if level < level_exp_table.size():
		return level_exp_table[level]
	return int(pow(level, 3.2) * 100.0)


func _normalize_category(category: String) -> String:
	var c: String = category.to_lower().strip_edges()
	match c:
		"helm", "helmet", "helmets":
			return "helmet"
		"shirt", "shirts", "body", "armor":
			return "shirt"
		"leg", "legs", "pants":
			return "legs"
		"shoe", "shoes", "boots", "feet":
			return "shoes"
		"weapon", "weapons", "wep":
			return "weapon"
		"acc", "accessory", "accessories", "shield":
			return "acc"
		"item", "items", "consumable", "material":
			return "item"
		"pet", "pets":
			return "pet"
		"pet_helmet", "pethelmet", "pet_helmets", "pet helmet":
			return "pet_helmet"
		_:
			return c


func _load_json_dict(filename: String) -> Dictionary:
	var res_path: String = "%s/%s" % [DATA_DIR, filename]
	var global_path: String = ProjectSettings.globalize_path(res_path)
	var text: String = ""
	if FileAccess.file_exists(global_path):
		text = FileAccess.get_file_as_string(global_path)
	elif ResourceLoader.exists(res_path):
		text = FileAccess.get_file_as_string(res_path)
	if text.is_empty():
		return {}
	var parsed: Variant = JSON.parse_string(text)
	if parsed is Dictionary:
		# Специальная обработка npcs.json: {"generatedBy": "...", "npcs": [ {"name": "Ronald", ...}, ... ]}
		if parsed.has("npcs") and parsed["npcs"] is Array and filename == "npcs.json":
			npcs_list = (parsed["npcs"] as Array).duplicate(true)
			return _convert_json_array_to_dict(parsed["npcs"])
		return parsed
	elif parsed is Array:
		return _convert_json_array_to_dict(parsed)
	return {}


func _convert_json_array_to_dict(arr: Array) -> Dictionary:
	var out: Dictionary = {}
	for i: int in range(arr.size()):
		var elem: Variant = arr[i]
		var idx_1: int = i + 1
		if elem is Dictionary:
			var rec: Dictionary = elem.duplicate(true)
			if not rec.has("id"):
				rec["id"] = idx_1
			out[idx_1] = rec
			out[str(idx_1)] = rec
			var key_name: String = str(rec.get("key", rec.get("name", ""))).strip_edges()
			if not key_name.is_empty():
				out[key_name] = rec
				out[key_name.to_lower()] = rec
		else:
			out[idx_1] = elem
	return out


func _init_level_exp_table() -> void:
	level_exp_table.resize(255)
	level_exp_table[0] = 0
	level_exp_table[1] = 0
	var accum: int = 0
	for lvl: int in range(2, 255):
		var step: int = int(floor(pow(float(lvl - 1), 2.65) * 45.0 + float(lvl - 1) * 55.0))
		accum += step
		level_exp_table[lvl] = accum


func _init_pet_mode_descriptions() -> void:
	pet_mode_descriptions = {
		"fept": {"abrv": "fept", "name": "Full extreme power attack mode", "moveMode": "attack", "desc": "The pet deals 150% damage allowing him to hit things much out of its league."},
		"fpt": {"abrv": "fpt", "name": "Full power attack mode", "moveMode": "attack", "desc": "The pet deals 125% damage allowing him to hit things that are out of his league."},
		"fa": {"abrv": "fa", "name": "Full attack mode", "moveMode": "attack", "desc": "The pet deals 100% damage at a faster rate than full power attack mode."},
		"qa": {"abrv": "qa", "name": "Quick attack mode", "moveMode": "attack", "desc": "The pet deals 75% damage at a faster rate than full attack mode."},
		"fl": {"abrv": "fl", "name": "Full loot mode", "moveMode": "loot", "desc": "The pet does not attack at all and picks up every item it encounters."},
		"m": {"abrv": "m", "name": "Mount mode", "moveMode": "mount", "desc": "Allows you to ride your pet."},
		"hlha": {"abrv": "hlha", "name": "Half loot half attack", "moveMode": "attack", "desc": "Your pet attacks half as often as full attack mode and picks up 50% of the items."},
		"ipd": {"abrv": "ipd", "name": "Increase player dex mode", "moveMode": "follow", "desc": "Increases your dexterity and critical hit by 15%."},
		"il": {"abrv": "il", "name": "Increase luck mode", "moveMode": "follow", "desc": "Increases your chance of getting item drops. Increases your luck by 4."},
		"hfhea": {"abrv": "hfhea", "name": "Half loot half extreme attack mode", "moveMode": "attack", "desc": "Your pet attacks deal 150% damage, half as often and picks up 50% item drops."},
		"qptqa": {"abrv": "qptqa", "name": "25% pick up 75% attack", "moveMode": "attack", "desc": "Your pet attacks 75% as much and picks up 25% of the items."},
		"hcptqa": {"abrv": "hcptqa", "name": "Half coin pickup and 75% attack mode", "moveMode": "attack", "desc": "Your pet picks up 50% of the coins and attacks 75% as often."},
		"fd": {"abrv": "fd", "name": "Full on Defensive Mode", "moveMode": "follow", "desc": "Increases your pets defense by 150%."},
		"hdha": {"abrv": "hdha", "name": "Half defensive mode half attack mode", "moveMode": "attack", "desc": "Increases your pets defense by 125% and attacks half as often."},
		"b": {"abrv": "b", "name": "Booster mode", "moveMode": "follow", "desc": "Increases your pets defense by 115%, increases your critical hit chance by 115%."},
		"n": {"abrv": "n", "name": "Nothing", "moveMode": "follow", "desc": "Your pet will simply follow you around."}
	}


func _init_skill_data() -> void:
	skill_data = {
		"jump height": {"skillName": "jump height", "maxLvl": 10, "required": 2},
		"critical hit": {"skillName": "critical hit", "maxLvl": 20, "required": 3},
		"loot steal": {"skillName": "loot steal", "maxLvl": 45, "required": 1},
		"training": {"skillName": "training", "maxLvl": 2147483647, "required": 16},
		"self rage": {"skillName": "self rage", "maxLvl": 35, "required": 1},
		"guild rage": {"skillName": "guild rage", "maxLvl": 35, "required": 1},
		"mp restore": {"skillName": "mp restore", "maxLvl": 200, "required": 2},
		"avoidability": {"skillName": "avoidability", "maxLvl": 25, "required": 2},
		"speed dash": {"skillName": "speed dash", "maxLvl": 15, "required": 4},
		"accel down": {"skillName": "accel down", "maxLvl": 40, "required": 1},
		"block": {"skillName": "block", "maxLvl": 30, "required": 1}
	}


func _load_json_file(full_res_path: String) -> Dictionary:
	var global_path: String = ProjectSettings.globalize_path(full_res_path)
	var text: String = ""
	if FileAccess.file_exists(global_path):
		text = FileAccess.get_file_as_string(global_path)
	elif ResourceLoader.exists(full_res_path):
		text = FileAccess.get_file_as_string(full_res_path)
	if text.is_empty():
		return {}
	var parsed: Variant = JSON.parse_string(text)
	if parsed is Dictionary:
		return parsed
	return {}


## Возвращает уникальный список всех записей предметов (по одной на каждый предмет, без ID/lowercase-дублей).
func get_all_unique_items(category: String = "") -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if not category.is_empty():
		var norm_cat: String = _normalize_category(category)
		var arr: Variant = unique_items_by_category.get(norm_cat, [])
		if arr is Array:
			for rec: Variant in arr:
				if rec is Dictionary:
					result.append(rec)
		return result
	for cat: String in ["weapon", "helmet", "shirt", "legs", "shoes", "acc", "item", "pet", "pet_helmet"]:
		var arr: Variant = unique_items_by_category.get(cat, [])
		if arr is Array:
			for rec: Variant in arr:
				if rec is Dictionary:
					result.append(rec)
	return result


## Возвращает уникальный список всех 46 мобов, отсортированный по возрастанию XP.
func get_all_unique_enemies() -> Array[Dictionary]:
	return unique_enemies.duplicate()


## Возвращает метаданные уровня stage_id из areas_meta.json с автосинхронизацией themeMain/backgroundAtlas/musicTrack из map_*.json
func get_area_meta(stage_id: int) -> Dictionary:
	if _area_meta_cache.has(stage_id):
		return _area_meta_cache[stage_id]
	if areas_meta.is_empty():
		return {}

	var base_meta: Dictionary = {}
	var by_level: Dictionary = areas_meta.get("areasByLevel", {})
	var stage_str: String = str(stage_id)
	if by_level.has(stage_str) and by_level[stage_str] is Dictionary:
		base_meta = by_level[stage_str]
	else:
		var areas_arr: Variant = areas_meta.get("areas", [])
		if areas_arr is Array:
			for a: Variant in areas_arr:
				if a is Dictionary and int(a.get("level", -1)) == stage_id:
					base_meta = a
					break

	if base_meta.is_empty():
		return {}

	var resolved: Dictionary = base_meta.duplicate(true)
	var map_dict: Dictionary = get_map_data(stage_id)
	if not map_dict.is_empty():
		var map_theme_main: String = str(map_dict.get("themeMain", ""))
		var map_theme_fg: String = str(map_dict.get("themeFg", ""))
		if not map_theme_main.is_empty():
			var themes_dict: Variant = areas_meta.get("themes", {})
			if themes_dict is Dictionary:
				for t_val: Variant in themes_dict.values():
					if t_val is Dictionary and str(t_val.get("mainTilesClass", "")) == map_theme_main:
						resolved["theme"] = int(t_val.get("theme", resolved.get("theme", 1)))
						resolved["mainTilesClass"] = map_theme_main
						if not map_theme_fg.is_empty():
							resolved["foregroundTilesClass"] = map_theme_fg
						elif t_val.get("foregroundTilesClass") != null:
							resolved["foregroundTilesClass"] = str(t_val.get("foregroundTilesClass", ""))
						if t_val.get("backgroundAtlas") != null:
							resolved["backgroundAtlas"] = str(t_val.get("backgroundAtlas", ""))
						else:
							resolved["backgroundAtlas"] = ""
						if t_val.get("musicTrack") != null:
							resolved["musicTrack"] = str(t_val.get("musicTrack", ""))
						break

	_area_meta_cache[stage_id] = resolved
	return resolved


## Возвращает параметры приема/атаки move_name из moves_data.json
func get_move_stat(move_name: String) -> Dictionary:
	if moves_data.is_empty():
		return {}
	var by_name: Dictionary = moves_data.get("movesByName", {})
	if by_name.has(move_name):
		return by_name[move_name]
	if by_name.has(move_name.to_lower()):
		return by_name[move_name.to_lower()]
	var moves_arr: Variant = moves_data.get("moves", [])
	if moves_arr is Array:
		for m: Variant in moves_arr:
			if m is Dictionary and (str(m.get("name", "")).to_lower() == move_name.to_lower() or str(m.get("constName", "")) == move_name):
				return m
	return {}


## Возвращает описание и формулу скилла skill_name из skills_meta.json
func get_skill(skill_name: String) -> Dictionary:
	if skills_meta.is_empty():
		return skill_data.get(skill_name, {})
	var by_id: Dictionary = skills_meta.get("skillsById", {})
	if by_id.has(skill_name):
		return by_id[skill_name]
	if by_id.has(skill_name.to_lower()):
		return by_id[skill_name.to_lower()]
	var s_arr: Variant = skills_meta.get("skills", [])
	if s_arr is Array:
		for s: Variant in s_arr:
			if s is Dictionary and (str(s.get("id", "")).to_lower() == skill_name.to_lower() or str(s.get("title", "")).to_lower() == skill_name.to_lower()):
				return s
	return skill_data.get(skill_name, {})


## Возвращает описание миссии mission_name из missions_data.json
func get_mission(mission_name: String) -> Dictionary:
	if missions_data.is_empty():
		return {}
	var m_arr: Variant = missions_data.get("missions", [])
	if m_arr is Array:
		for mi: Variant in m_arr:
			if mi is Dictionary and str(mi.get("name", "")).to_lower() == mission_name.to_lower():
				return mi
	return {}


## Возвращает список NPC для локации area_id
func get_npcs_for_area(area_id: int) -> Array:
	var out: Array = []
	if not npcs_list.is_empty():
		for npc_v: Variant in npcs_list:
			if not (npc_v is Dictionary):
				continue
			var npc: Dictionary = npc_v
			var origin: Variant = npc.get("origin", {})
			var npc_area: int = int((origin as Dictionary).get("area", -1)) if origin is Dictionary else int(npc.get("area", -1))
			if npc_area == area_id:
				out.append(npc)
		if not out.is_empty():
			return out

	# Fallback: areas_meta.areasByLevel[area_id].npcs
	var meta: Dictionary = get_area_meta(area_id)
	if meta.has("npcs") and meta["npcs"] is Array and not meta["npcs"].is_empty():
		return meta["npcs"]

	# Fallback: missions_data.npcs
	var m_npcs: Variant = missions_data.get("npcs", [])
	if m_npcs is Array:
		for npc: Variant in m_npcs:
			if npc is Dictionary and int(npc.get("area", -1)) == area_id:
				out.append(npc)
	elif m_npcs is Dictionary:
		for k: Variant in m_npcs.keys():
			var npc: Variant = m_npcs[k]
			if npc is Dictionary and int(npc.get("area", -1)) == area_id:
				out.append(npc)
	return out


func get_npc_dialog_for_trigger(trigger_id: int, npc_data: Dictionary = {}, player: Node = null) -> Dictionary:
	var triggers: Variant = npc_dialogs.get("triggers", {})
	var trig_rec: Dictionary = (triggers as Dictionary).get(str(trigger_id), {}) if triggers is Dictionary else {}
	var branches: Variant = trig_rec.get("branches", [])
	var origin: Dictionary = npc_data.get("origin", {}) if npc_data.get("origin") is Dictionary else {}
	var next_ids: Array = origin.get("nextIds", []) if origin.get("nextIds") is Array else []
	var has_buy: bool = bool(origin.get("buy", false))
	var has_sell: bool = bool(origin.get("sell", false))

	if branches is Array and not (branches as Array).is_empty():
		var chosen: Dictionary = (branches as Array)[0]
		# Если у NPC несколько веток (старт квеста / в процессе / завершён), выбираем актуальную
		if (branches as Array).size() > 1 and player != null:
			var checks: Variant = trig_rec.get("mission_checks", [])
			var completed_list: Array = player.get("completed_missions") if player.get("completed_missions") is Array else []
			var active_list: Array = player.get("active_missions") if player.get("active_missions") is Array else []
			if checks is Array and not (checks as Array).is_empty():
				var m_name: String = str((checks as Array)[0].get("mission", ""))
				if not m_name.is_empty():
					if completed_list.has(m_name):
						chosen = (branches as Array).back()
					elif active_list.has(m_name) and (branches as Array).size() >= 2:
						chosen = (branches as Array)[1]
		var res: Dictionary = chosen.duplicate(true)
		res["hasShop"] = bool(res.get("hasShop", false)) or has_buy
		res["hasSell"] = bool(res.get("hasSell", false)) or has_sell
		return res

	if trigger_id == 83:
		return {
			"text": "Hello there!  How would you like to be rich beyond your wildest dreams?  Well you can be.  All you have to do is win the lottery.  We have two lotteries, the ticket lottery and the coin lottery.  Everytime somebody buys an entry for a lottery the jackpot increases.  Every entry you buy increases your chance of winning.  For those who win, they will have to check their ATM.  Perhaps I could interest you in some lottery entries?",
			"talkID": 50,
			"hasNext": true,
			"hasShop": false,
			"hasSell": false,
		}

	var npc_name: String = str(npc_data.get("name", ""))
	if trigger_id == -1:
		if npc_name == "William":
			return {"text": "...", "talkID": 0, "hasNext": false, "hasShop": false, "hasSell": false}
		elif npc_name == "Item Vendor":
			return {"text": "Welcome to my store, please buy or sell whatever you would like.", "talkID": 0, "hasNext": false, "hasShop": true, "hasSell": true}
		elif npc_name == "Pet Vendor":
			return {"text": "Looking for a loyal companion? Check out my pets!", "talkID": 0, "hasNext": false, "hasShop": true, "hasSell": false}
		elif npc_name == "Ticket Vendor":
			return {"text": "Need tickets? Take a look at what I have in stock!", "talkID": 0, "hasNext": false, "hasShop": true, "hasSell": false}

	# Fallback
	var fallback_tid: int = int(next_ids[0]) if not next_ids.is_empty() else 0
	return {
		"text": "Welcome! How can I help you today?",
		"talkID": fallback_tid,
		"hasNext": fallback_tid > 0,
		"hasShop": has_buy,
		"hasSell": has_sell,
	}


func get_talk_action(talk_id: int) -> Dictionary:
	var actions: Variant = npc_dialogs.get("talk_actions", {})
	if actions is Dictionary:
		var act: Variant = (actions as Dictionary).get(str(talk_id), {})
		if act is Dictionary:
			return (act as Dictionary).duplicate(true)
	return {"action": "dialog", "mission": "", "text": ""}


## Возвращает словарь покадровых матриц и анимаций body_animator_data.json
func get_body_anim_data() -> Dictionary:
	return body_animator_data
