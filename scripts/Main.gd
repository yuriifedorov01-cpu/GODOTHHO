extends Control
## Main — Стартовая точка входа клиента Helmet Heroes на Godot 4.3.
## Инициализирует GameFlow, Foundation-синглтоны и переходит в главное меню.

@onready var game_flow: GameFlow = GameFlow.new()

func _ready() -> void:
	_verify_foundation_modules()
	game_flow.setup_flow(self)


func _verify_foundation_modules() -> void:
	var sdb: Node = get_node_or_null("/root/StatsDB")
	if sdb == null:
		sdb = load("res://scripts/autoload/StatsDB.gd").new()
		add_child(sdb)

	var atlas: Node = get_node_or_null("/root/StarlingAtlasLoader")
	if atlas == null:
		atlas = load("res://scripts/autoload/StarlingAtlasLoader.gd").new()
		add_child(atlas)

	# 1. Проверка загрузки базы данных StatsDB (JSON-таблицы и карты)
	var helm_1: Dictionary = sdb.get_helmet_data(1)
	var weapon_1: Dictionary = sdb.get_weapon_data(1)
	var map_1: Dictionary = sdb.get_map_data(1)

	# 2. Проверка парсера Starling XML+PNG и pet_body_locations.xml
	atlas.register_starling_atlas("items_pets_bodies")
	atlas.register_starling_atlas("load screen")
	atlas.register_starling_atlas("char create menu")
	atlas.register_starling_atlas("controls")
	var pet_loc_1: Dictionary = atlas.get_pet_body_location(1)

	# 3. Проверка круговой сериализации BinarySerializer
	var test_msg: BinarySerializer.PlayerIOMessage = BinarySerializer.PlayerIOMessage.new(
		"init",
		["player_1", 42, -12345, 3.14159, true, false, PackedByteArray([1, 2, 3, 4])]
	)
	var raw_packet: PackedByteArray = BinarySerializer.serialize_message(test_msg)
	var serializer: BinarySerializer = BinarySerializer.new()
	var decoded_msgs: Array[BinarySerializer.PlayerIOMessage] = serializer.feed_bytes(raw_packet)
	assert(decoded_msgs.size() == 1 and decoded_msgs[0].type == "init", "BinarySerializer roundtrip failed")

	# 4. Проверка ProtobufCodec (SimpleConnectArgs и BigDB ValueObject)
	var sc_bytes: PackedByteArray = ProtobufCodec.encode_simple_connect_args(GameConfig.GAME_ID, "test_user", "secret")
	var sc_fields: Dictionary = ProtobufCodec.decode_raw_fields(sc_bytes)
	assert(ProtobufCodec.raw_get_string(sc_fields, 1) == GameConfig.GAME_ID, "ProtobufCodec SimpleConnectArgs check failed")

	var bigdb_val_bytes: PackedByteArray = ProtobufCodec.encode_bigdb_value_object({"hp": 100, "tags": ["a", "b"]})
	var bigdb_val_decoded: Variant = ProtobufCodec.decode_bigdb_value_object(bigdb_val_bytes)
	assert(bigdb_val_decoded is Dictionary and int(bigdb_val_decoded["hp"]) == 100, "ProtobufCodec BigDB check failed")

	print("[HelmetHeroes Godot 4.3] Foundation ready | Helm#1=%s | Weapon#1=%s | Map#1 keys=%d | PetBody#1=%s" % [
		str(helm_1.get("name", "OK")),
		str(weapon_1.get("name", "OK")),
		map_1.size(),
		str(pet_loc_1.get("body_num", 1))
	])
