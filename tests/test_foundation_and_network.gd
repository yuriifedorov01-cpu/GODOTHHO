extends SceneTree
## Автоматический верификационный тест Этапов 3–5 портирования Helmet Heroes на Godot 4.3:
## 1. BinarySerializer round-trip (все типы PlayerIOMessage, потоковая склейка, побайтовая подача, реальные пакеты).
## 2. ProtobufCodec round-trip (Authenticate, SimpleConnect, CreateJoinRoom, LoadObjects со сложным BigDBObject, HTTPChannel envelope).
## 3. StarlingAtlasLoader (items_pets_bodies, controls, trees_fish, backgrounds1, AtlasTexture, pet_body_locations).
## 4. StatsDB & Maps (144 карты map_1..map_145 кроме 51, декодирование Base64 тайловых слоев в int16, предметы/оружие/шлемы/питомцы/монстры/NPC).
## 5. Offline Sandbox Flow (PlayerIOClient локальный вход, PlayerObjects, подключение к локальной комнате).

var _passed_assertions: int = 0
var _failed_assertions: int = 0
var _failure_messages: Array[String] = []


func _init() -> void:
	call_deferred("_run_all_tests")


func _assert_true(cond: bool, msg: String) -> void:
	if cond:
		_passed_assertions += 1
	else:
		_failed_assertions += 1
		var err_str: String = "FAIL: %s" % msg
		_failure_messages.append(err_str)
		push_error(err_str)


func _assert_eq(actual: Variant, expected: Variant, msg: String) -> void:
	if actual == expected:
		_passed_assertions += 1
	else:
		_failed_assertions += 1
		var err_str: String = "FAIL: %s | expected=%s (%s), actual=%s (%s)" % [
			msg, str(expected), type_string(typeof(expected)), str(actual), type_string(typeof(actual))
		]
		_failure_messages.append(err_str)
		push_error(err_str)


func _assert_approx(actual: float, expected: float, eps: float, msg: String) -> void:
	if absf(actual - expected) <= eps:
		_passed_assertions += 1
	else:
		_failed_assertions += 1
		var err_str: String = "FAIL: %s | expected≈%f, actual=%f" % [msg, expected, actual]
		_failure_messages.append(err_str)
		push_error(err_str)


func _run_all_tests() -> void:
	print("==================================================================")
	print("[QA_VERIFIER] Starting Foundation & Network Verification (Stages 3-5)")
	print("==================================================================")

	_test_1_binary_serializer()
	_test_2_protobuf_codec()
	_test_3_starling_atlas_loader()
	_test_4_stats_db_and_maps()
	await _test_5_offline_sandbox_flow()

	print("==================================================================")
	print("[QA_VERIFIER] Assertions passed: %d | failed: %d" % [_passed_assertions, _failed_assertions])
	if _failed_assertions > 0:
		for f: String in _failure_messages:
			print("  -> ", f)
		print("[QA_VERIFIER] RESULT: FAILED")
		quit(1)
	else:
		print("[QA_VERIFIER] RESULT: 100% PASSED")
		quit(0)


# =============================================================================
# 1. BinarySerializer Round-Trip & Streaming Deserialization
# =============================================================================
func _test_1_binary_serializer() -> void:
	print("[TEST 1] BinarySerializer round-trip & streaming...")

	# 1.1 Все элементарные типы данных PlayerIOMessage
	var msg_types: BinarySerializer.PlayerIOMessage = BinarySerializer.PlayerIOMessage.new("all_types_test")
	var short_ascii: String = "hello_pio"
	var long_ascii: String = "A".repeat(300) + "_end_of_long_ascii_string"
	var short_utf8: String = "Привет, Мир! ⚔️🛡️"
	var long_utf8: String = ("Герои Шлемов UTF-8 тест 🏆 ").repeat(20)
	var small_int_0: int = 0
	var small_int_63: int = 63
	var medium_int: int = 64
	var large_int: int = 1234567890
	var neg_int_small: int = -1
	var neg_int_large: int = -2147483648
	var uint_val: int = 3500000000
	var long_pos: int = 5000000000123
	var long_neg: int = -5000000000123
	var ulong_val: int = 9000000000456
	var float_val: float = 3.1415927
	var double_val: float = 2.718281828459045
	var short_ba: PackedByteArray = PackedByteArray([0, 1, 2, 127, 128, 255])
	var long_ba: PackedByteArray = PackedByteArray()
	long_ba.resize(1540)
	for i: int in range(1540):
		long_ba[i] = (i * 37 + 13) & 0xFF

	msg_types.add(short_ascii)                                              # 0
	msg_types.add(long_ascii)                                               # 1
	msg_types.add(short_utf8)                                               # 2
	msg_types.add(long_utf8)                                                # 3
	msg_types.add(small_int_0)                                              # 4
	msg_types.add(small_int_63)                                             # 5
	msg_types.add(medium_int)                                               # 6
	msg_types.add(large_int)                                                # 7
	msg_types.add(neg_int_small)                                            # 8
	msg_types.add(neg_int_large)                                            # 9
	msg_types.add({"__pio_type__": "uint", "value": uint_val})              # 10
	msg_types.add({"__pio_type__": "long", "value": long_pos})              # 11
	msg_types.add({"__pio_type__": "long", "value": long_neg})              # 12
	msg_types.add({"__pio_type__": "ulong", "value": ulong_val})            # 13
	msg_types.add({"__pio_type__": "float", "value": float_val})            # 14
	msg_types.add(double_val)                                               # 15
	msg_types.add(true)                                                     # 16
	msg_types.add(false)                                                    # 17
	msg_types.add(short_ba)                                                 # 18
	msg_types.add(long_ba)                                                  # 19

	var raw_types: PackedByteArray = BinarySerializer.serialize_message(msg_types)
	_assert_true(raw_types.size() > 2000, "Serialized all_types_test size > 2000")

	var recv_list: Array[BinarySerializer.PlayerIOMessage] = []
	var deserializer: BinarySerializer = BinarySerializer.new()
	deserializer.message_deserialized.connect(func(m: BinarySerializer.PlayerIOMessage) -> void:
		recv_list.append(m)
	)
	# Побайтовая подача!
	for idx: int in range(raw_types.size()):
		deserializer.add_byte(raw_types[idx])

	_assert_eq(recv_list.size(), 1, "Byte-by-byte deserialized 1 message for all_types_test")
	if recv_list.size() == 1:
		var rm: BinarySerializer.PlayerIOMessage = recv_list[0]
		_assert_eq(rm.type, "all_types_test", "all_types_test message type")
		_assert_eq(rm.size(), 20, "all_types_test argument count")
		_assert_eq(rm.get_string(0), short_ascii, "short ASCII string")
		_assert_eq(rm.get_string(1), long_ascii, "long ASCII string")
		_assert_eq(rm.get_string(2), short_utf8, "short UTF-8 string")
		_assert_eq(rm.get_string(3), long_utf8, "long UTF-8 string")
		_assert_eq(rm.get_int(4), small_int_0, "small int 0")
		_assert_eq(rm.get_int(5), small_int_63, "small int 63")
		_assert_eq(rm.get_int(6), medium_int, "medium int 64")
		_assert_eq(rm.get_int(7), large_int, "large int")
		_assert_eq(rm.get_int(8), neg_int_small, "negative int -1")
		_assert_eq(rm.get_int(9), neg_int_large, "negative int -2147483648")
		_assert_eq(rm.get_uint(10), uint_val, "uint 3500000000")
		_assert_eq(rm.get_number(11), long_pos, "long positive")
		_assert_eq(rm.get_number(12), long_neg, "long negative")
		_assert_eq(rm.get_number(13), ulong_val, "ulong positive")
		_assert_approx(rm.get_float(14), float_val, 0.0001, "32-bit float")
		_assert_approx(rm.get_float(15), double_val, 0.000000001, "64-bit double")
		_assert_eq(rm.get_boolean(16), true, "bool true")
		_assert_eq(rm.get_boolean(17), false, "bool false")
		_assert_eq(rm.get_byte_array(18), short_ba, "short ByteArray")
		_assert_eq(rm.get_byte_array(19), long_ba, "long ByteArray (1540 bytes)")

	# 1.2 Реальные игровые пакеты Helmet Heroes + склейка в один буфер + побайтовая подача
	# Пакет 1: "join"
	var pkt_join: BinarySerializer.PlayerIOMessage = BinarySerializer.create_message("join", [
		"join_key_abc_123456", "HeroTester", 1, true
	])

	# Пакет 2: "pLoaded" (31 аргумент)
	var pkt_ploaded_args: Array = [
		"user_1001", "HeroTester", 45, 125000, 500, 30,
		120, 85, 60, 40, 55, 15,
		12, 8, 9, 4, 15, 3,
		"1,2,3,4,5", "10,20,30", "Tebra", 10,
		150, 150, 80, 80, 1, 3,
		false, true, "GuildOfHeroes"
	]
	_assert_eq(pkt_ploaded_args.size(), 31, "pLoaded has 31 arguments")
	var pkt_ploaded: BinarySerializer.PlayerIOMessage = BinarySerializer.create_message("pLoaded", pkt_ploaded_args)

	# Пакет 3: "sP" (34 аргумента)
	var pkt_sp_args: Array = [
		"user_2002", "OtherPlayer", 480.5, 320.25, 1, 80,
		2500, 2500, 14, 22, 18, 7,
		31, 5, 2, 1, 1, 2,
		"Marshy", 25, 4, 5, "fa", false,
		false, true, " Knights ", 3, 99, 100,
		0.0, 0.0, "standing", 42
	]
	_assert_eq(pkt_sp_args.size(), 34, "sP has 34 arguments")
	var pkt_sp: BinarySerializer.PlayerIOMessage = BinarySerializer.create_message("sP", pkt_sp_args)

	# Пакет 4: "tD" (7 аргументов: 6 тайловых слоев ByteArray по 35*22*2 = 1540 байт + ширина 35)
	var td_layers: Array[PackedByteArray] = []
	for layer_idx: int in range(6):
		var ba_layer: PackedByteArray = PackedByteArray()
		ba_layer.resize(35 * 22 * 2) # 1540 bytes
		for b_idx: int in range(ba_layer.size()):
			ba_layer[b_idx] = (layer_idx * 31 + b_idx) & 0xFF
		td_layers.append(ba_layer)
	var pkt_td: BinarySerializer.PlayerIOMessage = BinarySerializer.create_message("tD", [
		td_layers[0], td_layers[1], td_layers[2], td_layers[3], td_layers[4], td_layers[5], 35
	])
	_assert_eq(pkt_td.size(), 7, "tD has 7 arguments")

	# Пакет 5: "eD" (9 аргументов)
	var pkt_ed: BinarySerializer.PlayerIOMessage = BinarySerializer.create_message("eD", [
		"enemy_14", "green bouncer", 640.0, 440.0, 18, 18, 1, false, 6
	])
	_assert_eq(pkt_ed.size(), 9, "eD has 9 arguments")

	# Пакет 6: "m" (движение)
	var pkt_m: BinarySerializer.PlayerIOMessage = BinarySerializer.create_message("m", [
		"user_2002", 512.75, 318.0, 7.25, -4.5, 1, true
	])

	# Склеиваем все 6 пакетов в единый поток байт
	var concatenated_stream: PackedByteArray = PackedByteArray()
	concatenated_stream.append_array(BinarySerializer.serialize_message(pkt_join))
	concatenated_stream.append_array(BinarySerializer.serialize_message(pkt_ploaded))
	concatenated_stream.append_array(BinarySerializer.serialize_message(pkt_sp))
	concatenated_stream.append_array(BinarySerializer.serialize_message(pkt_td))
	concatenated_stream.append_array(BinarySerializer.serialize_message(pkt_ed))
	concatenated_stream.append_array(BinarySerializer.serialize_message(pkt_m))

	# Проверка 1.2a: подача всего склеенного буфера целиком (add_bytes)
	var batch_deserializer: BinarySerializer = BinarySerializer.new()
	var batch_msgs: Array[BinarySerializer.PlayerIOMessage] = []
	batch_deserializer.message_deserialized.connect(func(m: BinarySerializer.PlayerIOMessage) -> void:
		batch_msgs.append(m)
	)
	batch_deserializer.add_bytes(concatenated_stream)
	_assert_eq(batch_msgs.size(), 6, "Concatenated stream add_bytes decoded all 6 game packets")

	# Проверка 1.2b: побайтовая подача всего склеенного буфера (add_byte)
	var stream_deserializer: BinarySerializer = BinarySerializer.new()
	var stream_msgs: Array[BinarySerializer.PlayerIOMessage] = []
	stream_deserializer.message_deserialized.connect(func(m: BinarySerializer.PlayerIOMessage) -> void:
		stream_msgs.append(m)
	)
	for b_i: int in range(concatenated_stream.size()):
		stream_deserializer.add_byte(concatenated_stream[b_i])

	_assert_eq(stream_msgs.size(), 6, "Concatenated stream byte-by-byte decoded all 6 game packets")
	if stream_msgs.size() == 6:
		_assert_eq(stream_msgs[0].type, "join", "Packet 0 type == join")
		_assert_eq(stream_msgs[0].size(), 4, "Packet 0 size == 4")
		_assert_eq(stream_msgs[1].type, "pLoaded", "Packet 1 type == pLoaded")
		_assert_eq(stream_msgs[1].size(), 31, "Packet 1 size == 31")
		_assert_eq(stream_msgs[1].get_string(30), "GuildOfHeroes", "pLoaded last arg")
		_assert_eq(stream_msgs[2].type, "sP", "Packet 2 type == sP")
		_assert_eq(stream_msgs[2].size(), 34, "Packet 2 size == 34")
		_assert_eq(stream_msgs[2].get_int(33), 42, "sP 34th arg == 42")
		_assert_eq(stream_msgs[3].type, "tD", "Packet 3 type == tD")
		_assert_eq(stream_msgs[3].size(), 7, "Packet 3 size == 7")
		for l_i: int in range(6):
			_assert_eq(stream_msgs[3].get_byte_array(l_i).size(), 1540, "tD layer %d size == 1540" % l_i)
			_assert_eq(stream_msgs[3].get_byte_array(l_i), td_layers[l_i], "tD layer %d content match" % l_i)
		_assert_eq(stream_msgs[3].get_int(6), 35, "tD map width == 35")
		_assert_eq(stream_msgs[4].type, "eD", "Packet 4 type == eD")
		_assert_eq(stream_msgs[4].size(), 9, "Packet 4 size == 9")
		_assert_eq(stream_msgs[4].get_string(1), "green bouncer", "eD enemy type")
		_assert_eq(stream_msgs[5].type, "m", "Packet 5 type == m")
		_assert_eq(stream_msgs[5].size(), 7, "Packet 5 size == 7")
		_assert_approx(stream_msgs[5].get_float(1), 512.75, 0.0001, "m pos x")


# =============================================================================
# 2. ProtobufCodec Round-Trip & HTTPChannel Envelope
# =============================================================================
func _test_2_protobuf_codec() -> void:
	print("[TEST 2] ProtobufCodec round-trip...")

	var game_cfg_script: GDScript = load("res://scripts/autoload/GameConfig.gd")
	var gid: String = game_cfg_script.GAME_ID

	# 2.1 AuthenticateArgs / AuthenticateOutput
	var auth_args_bytes: PackedByteArray = ProtobufCodec.encode_authenticate_args(
		gid,
		"public",
		{"userId": "hero_99", "auth": "token_xyz"},
		{"os": "Windows", "version": "9.50"}
	)
	var auth_args_dec: Dictionary = ProtobufCodec.decode_authenticate_args(auth_args_bytes)
	_assert_eq(auth_args_dec["game_id"], gid, "AuthenticateArgs game_id")
	_assert_eq(auth_args_dec["connection_id"], "public", "AuthenticateArgs connection_id")
	_assert_eq(auth_args_dec["auth_args"].get("userId", ""), "hero_99", "AuthenticateArgs userId")
	_assert_eq(auth_args_dec["client_info"].get("version", ""), "9.50", "AuthenticateArgs client_info")

	var auth_out_bytes: PackedByteArray = ProtobufCodec.encode_authenticate_output(
		"pio_session_token_777", "user_hero_99", true, "redirect_map_data", "kongregate"
	)
	var auth_out_dec: Dictionary = ProtobufCodec.decode_authenticate_output(auth_out_bytes)
	_assert_eq(auth_out_dec["token"], "pio_session_token_777", "AuthenticateOutput token")
	_assert_eq(auth_out_dec["user_id"], "user_hero_99", "AuthenticateOutput user_id")
	_assert_eq(auth_out_dec["show_branding"], true, "AuthenticateOutput show_branding")
	_assert_eq(auth_out_dec["gamefs_redirect_map"], "redirect_map_data", "AuthenticateOutput redirect_map")
	_assert_eq(auth_out_dec["partner_id"], "kongregate", "AuthenticateOutput partner_id")

	# 2.2 SimpleConnectArgs
	var sc_bytes: PackedByteArray = ProtobufCodec.encode_simple_connect_args(
		gid, "player@example.com", "secret_pass_123", "as3", {"flash": "WIN 32,0,0,0"}
	)
	var sc_dec: Dictionary = ProtobufCodec.decode_simple_connect_args(sc_bytes)
	_assert_eq(sc_dec["game_id"], gid, "SimpleConnectArgs game_id")
	_assert_eq(sc_dec["username_or_email"], "player@example.com", "SimpleConnectArgs username_or_email")
	_assert_eq(sc_dec["password"], "secret_pass_123", "SimpleConnectArgs password")
	_assert_eq(sc_dec["client_api"], "as3", "SimpleConnectArgs client_api")
	_assert_eq(sc_dec["client_info"].get("flash", ""), "WIN 32,0,0,0", "SimpleConnectArgs client_info")

	# 2.3 CreateJoinRoomArgs / CreateJoinRoomOutput
	var cjr_args_bytes: PackedByteArray = ProtobufCodec.encode_create_join_room_args(
		"9.50-r1_Pve Server", "MyCode", true, {"level": "1", "pvp": "false"}, {"name": "HeroTester"}, false
	)
	var cjr_args_dec: Dictionary = ProtobufCodec.decode_create_join_room_args(cjr_args_bytes)
	_assert_eq(cjr_args_dec["room_id"], "9.50-r1_Pve Server", "CreateJoinRoomArgs room_id")
	_assert_eq(cjr_args_dec["room_type"], "MyCode", "CreateJoinRoomArgs room_type")
	_assert_eq(cjr_args_dec["visible"], true, "CreateJoinRoomArgs visible")
	_assert_eq(cjr_args_dec["room_data"].get("level", ""), "1", "CreateJoinRoomArgs room_data")
	_assert_eq(cjr_args_dec["join_data"].get("name", ""), "HeroTester", "CreateJoinRoomArgs join_data")

	var cjr_out_bytes: PackedByteArray = ProtobufCodec.encode_create_join_room_output(
		"9.50-r1_Pve Server",
		"join_key_room_1_secret",
		[{"address": "127.0.0.1", "port": 8184}, {"address": "45.33.22.11", "port": 443}]
	)
	var cjr_out_dec: Dictionary = ProtobufCodec.decode_create_join_room_output(cjr_out_bytes)
	_assert_eq(cjr_out_dec["room_id"], "9.50-r1_Pve Server", "CreateJoinRoomOutput room_id")
	_assert_eq(cjr_out_dec["join_key"], "join_key_room_1_secret", "CreateJoinRoomOutput join_key")
	_assert_eq(cjr_out_dec["endpoints"].size(), 2, "CreateJoinRoomOutput 2 endpoints")
	_assert_eq(cjr_out_dec["endpoints"][0]["address"], "127.0.0.1", "Endpoint 0 address")
	_assert_eq(cjr_out_dec["endpoints"][0]["port"], 8184, "Endpoint 0 port")

	# 2.4 LoadObjectsArgs / LoadObjectsOutput со всеми типами ValueType BigDBObject
	var lo_args_bytes: PackedByteArray = ProtobufCodec.encode_load_objects_args(
		"PlayerObjects", PackedStringArray(["user_hero_99", "user_hero_100"])
	)
	var lo_args_dec: Dictionary = ProtobufCodec.decode_load_objects_args(lo_args_bytes)
	_assert_eq(lo_args_dec["table"], "PlayerObjects", "LoadObjectsArgs table")
	_assert_eq(lo_args_dec["keys"].size(), 2, "LoadObjectsArgs 2 keys")
	_assert_eq(lo_args_dec["keys"][0], "user_hero_99", "LoadObjectsArgs key 0")

	var sample_bytes: PackedByteArray = PackedByteArray([10, 20, 30, 40, 250])
	var complex_player_obj: Dictionary = {
		"_key": "user_hero_99",
		"_version": "v42",
		"str_prop": "Helmet Hero Character",
		"int_pos": -42000,
		"uint_prop": {"__bigdb_type__": ProtobufCodec.BigDBValueType.UINT, "value": 4000000000},
		"long_prop": {"__bigdb_type__": ProtobufCodec.BigDBValueType.LONG, "value": 9876543210123},
		"bool_true": true,
		"bool_false": false,
		"float_prop": {"__bigdb_type__": ProtobufCodec.BigDBValueType.FLOAT, "value": 1.5},
		"double_prop": 12345.67890123,
		"bytes_prop": sample_bytes,
		"datetime_prop": {"__bigdb_type__": ProtobufCodec.BigDBValueType.DATETIME, "value": 1700000000000},
		"array_prop": [
			"sword",
			100,
			true,
			{"nested_in_arr": "ok", "lvl": 5}
		],
		"obj_prop": {
			"char1": {
				"name": "Warrior",
				"level": 99,
				"inventory": [1, 2, 3, 4]
			}
		}
	}
	var lo_out_bytes: PackedByteArray = ProtobufCodec.encode_load_objects_output([complex_player_obj])
	var lo_out_dec: Array[Dictionary] = ProtobufCodec.decode_load_objects_output(lo_out_bytes)
	_assert_eq(lo_out_dec.size(), 1, "LoadObjectsOutput decoded 1 BigDBObject")
	if lo_out_dec.size() == 1:
		var dobj: Dictionary = lo_out_dec[0]
		_assert_eq(dobj["_key"], "user_hero_99", "BigDBObject _key")
		_assert_eq(dobj["_version"], "v42", "BigDBObject _version")
		_assert_eq(dobj["str_prop"], "Helmet Hero Character", "BigDB ValueType.STRING")
		_assert_eq(dobj["int_pos"], -42000, "BigDB ValueType.INT (negative)")
		_assert_eq(dobj["uint_prop"], 4000000000, "BigDB ValueType.UINT")
		_assert_eq(dobj["long_prop"], 9876543210123, "BigDB ValueType.LONG")
		_assert_eq(dobj["bool_true"], true, "BigDB ValueType.BOOL true")
		_assert_eq(dobj["bool_false"], false, "BigDB ValueType.BOOL false")
		_assert_approx(float(dobj["float_prop"]), 1.5, 0.0001, "BigDB ValueType.FLOAT")
		_assert_approx(float(dobj["double_prop"]), 12345.67890123, 0.000001, "BigDB ValueType.DOUBLE")
		_assert_eq(dobj["bytes_prop"], sample_bytes, "BigDB ValueType.BYTEARRAY")
		_assert_eq(dobj["datetime_prop"], 1700000000000, "BigDB ValueType.DATETIME")
		var d_arr: Array = dobj["array_prop"]
		_assert_eq(d_arr.size(), 4, "BigDB ValueType.ARRAY size")
		_assert_eq(d_arr[0], "sword", "BigDB ARRAY[0] string")
		_assert_eq(d_arr[1], 100, "BigDB ARRAY[1] int")
		_assert_eq(d_arr[2], true, "BigDB ARRAY[2] bool")
		_assert_eq(d_arr[3]["nested_in_arr"], "ok", "BigDB ARRAY[3] nested OBJ")
		_assert_eq(dobj["obj_prop"]["char1"]["name"], "Warrior", "BigDB ValueType.OBJ nested name")
		_assert_eq(dobj["obj_prop"]["char1"]["level"], 99, "BigDB ValueType.OBJ nested level")
		_assert_eq(dobj["obj_prop"]["char1"]["inventory"].size(), 4, "BigDB ValueType.OBJ nested array")

	# 2.5 Проверка unwrap_http_channel_response (с новым токеном, без токена и с ошибкой)
	var wrapped_ok_token: PackedByteArray = ProtobufCodec.wrap_http_channel_response(
		auth_out_bytes, true, "updated_session_token_999"
	)
	var unwrapped_1: Dictionary = ProtobufCodec.unwrap_http_channel_response(wrapped_ok_token)
	_assert_eq(unwrapped_1["success"], true, "unwrap_http_channel_response success=true")
	_assert_eq(unwrapped_1["has_new_token"], true, "unwrap_http_channel_response has_new_token=true")
	_assert_eq(unwrapped_1["new_token"], "updated_session_token_999", "unwrap_http_channel_response new_token")
	_assert_eq(unwrapped_1["payload"], auth_out_bytes, "unwrap_http_channel_response payload match")

	var wrapped_err: PackedByteArray = ProtobufCodec.wrap_http_channel_response(
		PackedByteArray(), false, "", 10, "Invalidauth: Incorrect username or password"
	)
	var unwrapped_err: Dictionary = ProtobufCodec.unwrap_http_channel_response(wrapped_err)
	_assert_eq(unwrapped_err["success"], false, "unwrap_http_channel_response error success=false")
	_assert_eq(unwrapped_err["error_code"], 10, "unwrap_http_channel_response error_code=10")
	_assert_true(str(unwrapped_err["error_message"]).find("Invalidauth") != -1, "unwrap_http_channel_response error_message")


# =============================================================================
# 3. StarlingAtlasLoader Verification
# =============================================================================
func _test_3_starling_atlas_loader() -> void:
	print("[TEST 3] StarlingAtlasLoader verification...")

	var atlas_loader: Node = load("res://scripts/autoload/StarlingAtlasLoader.gd").new()
	root.add_child(atlas_loader)

	var required_atlases: Array[String] = ["items_pets_bodies", "controls", "trees_fish", "backgrounds1"]
	for atlas_name: String in required_atlases:
		var ok: bool = atlas_loader.register_starling_atlas(atlas_name, atlas_loader.SPRITE_SHEETS_DIR, true)
		_assert_true(ok, "StarlingAtlasLoader loaded atlas '%s'" % atlas_name)
		_assert_true(atlas_loader.has_atlas(atlas_name), "StarlingAtlasLoader has_atlas('%s')" % atlas_name)
		var tex_names: PackedStringArray = atlas_loader.get_atlas_texture_names(atlas_name)
		_assert_true(tex_names.size() > 0, "Atlas '%s' has > 0 subtextures (actual=%d)" % [atlas_name, tex_names.size()])
		if tex_names.size() > 0:
			var sample_name: String = tex_names[0]
			var atex: AtlasTexture = atlas_loader.get_texture(sample_name, atlas_name)
			_assert_true(atex != null, "AtlasTexture '%s' from '%s' is not null" % [sample_name, atlas_name])
			if atex != null:
				_assert_true(atex.atlas != null, "AtlasTexture '%s' base Texture2D is not null" % sample_name)
				_assert_true(atex.region.size.x > 0 and atex.region.size.y > 0, "AtlasTexture '%s' region > 0" % sample_name)
				_assert_true(atex.get_width() > 0 and atex.get_height() > 0, "AtlasTexture '%s' dimensions > 0" % sample_name)

	# Проверим конкретные ключевые текстуры из каждого атласа
	var tex_ak47: AtlasTexture = atlas_loader.get_texture("ak47", "items_pets_bodies")
	_assert_true(tex_ak47 != null and tex_ak47.region.size == Vector2(86, 25), "items_pets_bodies 'ak47' 86x25")

	var tex_attack_btn: AtlasTexture = atlas_loader.get_texture("attack button", "controls")
	_assert_true(tex_attack_btn != null and tex_attack_btn.region.size == Vector2(175, 175), "controls 'attack button' 175x175")

	var tex_pine_tree: AtlasTexture = atlas_loader.get_texture("pine tree", "trees_fish")
	_assert_true(tex_pine_tree != null and tex_pine_tree.region.size.x > 0, "trees_fish 'pine tree' non-empty")

	var tex_bg1: AtlasTexture = atlas_loader.get_texture("background 1", "backgrounds1")
	_assert_true(tex_bg1 != null and tex_bg1.region.size == Vector2(1308, 498), "backgrounds1 'background 1' 1308x498")

	# Проверим pet_body_locations
	var pet_locs: Dictionary = atlas_loader.load_pet_body_locations()
	_assert_true(pet_locs.size() >= 38, "pet_body_locations loaded (entries=%d)" % pet_locs.size())
	var tebra_loc: Dictionary = atlas_loader.get_pet_body_location("tebra")
	_assert_true(not tebra_loc.is_empty(), "pet_body_locations has 'tebra'")
	_assert_eq(int(tebra_loc.get("walkFrame", 0)), 41, "tebra walkFrame == 41")
	_assert_true(tebra_loc.get("headX", PackedFloat32Array()).size() > 40, "tebra headX array has > 40 frames")
	var first_pet_by_id: Dictionary = atlas_loader.get_pet_body_location(1)
	_assert_true(not first_pet_by_id.is_empty(), "pet_body_locations indexed by int 1")


# =============================================================================
# 4. StatsDB & All 144 Maps Verification
# =============================================================================
func _test_4_stats_db_and_maps() -> void:
	print("[TEST 4] StatsDB & 144 Maps verification...")

	var stats_db: Node = load("res://scripts/autoload/StatsDB.gd").new()
	root.add_child(stats_db)

	_assert_true(stats_db.is_loaded, "StatsDB is_loaded == true")
	_assert_true(stats_db.helmet_stats.size() > 50, "StatsDB helmets loaded (%d)" % stats_db.helmet_stats.size())
	_assert_true(stats_db.weapon_stats.size() > 50, "StatsDB weapons loaded (%d)" % stats_db.weapon_stats.size())
	_assert_true(stats_db.shirt_stats.size() > 30, "StatsDB shirts loaded (%d)" % stats_db.shirt_stats.size())
	_assert_true(stats_db.leg_stats.size() > 30, "StatsDB legs loaded (%d)" % stats_db.leg_stats.size())
	_assert_true(stats_db.shoe_stats.size() > 20, "StatsDB shoes loaded (%d)" % stats_db.shoe_stats.size())
	_assert_true(stats_db.acc_stats.size() > 10, "StatsDB accessories loaded (%d)" % stats_db.acc_stats.size())
	_assert_true(stats_db.item_data.size() > 15, "StatsDB items loaded (%d)" % stats_db.item_data.size())
	_assert_true(stats_db.base_pet_data.size() > 30, "StatsDB pets loaded (%d)" % stats_db.base_pet_data.size())
	_assert_true(stats_db.pet_helmets.size() > 20, "StatsDB pet_helmets loaded (%d)" % stats_db.pet_helmets.size())
	_assert_true(stats_db.enemy_stats.size() > 35, "StatsDB monsters/enemies loaded (%d)" % stats_db.enemy_stats.size())
	_assert_true(stats_db.npcs_data.size() > 50, "StatsDB NPCs loaded (%d)" % stats_db.npcs_data.size())

	# Проверим конкретные записи по имени и по ID
	var helm_hair_flower: Dictionary = stats_db.get_helmet_data("hair flower")
	_assert_true(not helm_hair_flower.is_empty() and int(helm_hair_flower.get("def", 0)) == 1, "Helmet 'hair flower' def == 1")

	var wep_stick: Dictionary = stats_db.get_weapon_data("stick")
	_assert_true(not wep_stick.is_empty() and int(wep_stick.get("max", 0)) == 5, "Weapon 'stick' max == 5")

	var item_apple: Dictionary = stats_db.get_consumable_or_material_data("apple")
	_assert_true(not item_apple.is_empty() and int(item_apple.get("c", 0)) == 50, "Item 'apple' cost == 50")

	var pet_tebra: Dictionary = stats_db.get_pet_base_data("Tebra")
	_assert_true(not pet_tebra.is_empty() and int(pet_tebra.get("h", 0)) == 16, "Pet 'Tebra' health == 16")

	var enemy_gb: Dictionary = stats_db.get_enemy_data("green bouncer")
	_assert_true(not enemy_gb.is_empty() and int(enemy_gb.get("h", 0)) == 18, "Monster 'green bouncer' health == 18")

	var npc_ronald: Dictionary = stats_db.get_npc_data("Ronald")
	_assert_true(not npc_ronald.is_empty(), "NPC 'Ronald' exists")
	var npc_1: Dictionary = stats_db.get_npc_data(1)
	_assert_true(not npc_1.is_empty(), "NPC ID 1 exists")

	# Проверим загрузку всех 144 карт (map_1 .. map_145, кроме 51)
	var loaded_maps_count: int = 0
	for map_id: int in range(1, 146):
		if map_id == 51:
			continue
		var map_dict: Dictionary = stats_db.get_map_data(map_id)
		if not map_dict.is_empty():
			loaded_maps_count += 1
			var w: int = int(map_dict.get("width", 0))
			var h: int = int(map_dict.get("height", 0))
			var layers: Dictionary = map_dict.get("layers", {})
			var main_layer: Array = layers.get("mapMain", [])
			if w <= 0 or h <= 0 or main_layer.size() != w * h:
				_assert_true(false, "Map %d invalid dimensions or mapMain size" % map_id)
	_assert_eq(loaded_maps_count, 144, "All 144 maps (map_1..map_145 except 51) loaded and validated")

	# Проверим декодирование Base64 тайловых слоев карт в массив int16
	var map1_main_int16: PackedInt32Array = stats_db.get_map_layer_int16(1, "mapMain")
	_assert_eq(map1_main_int16.size(), 36 * 13, "map_1 mapMain layer int16 count == 468")
	var b64_encoded_layer: String = stats_db.encode_map_layer_base64_int16(map1_main_int16)
	_assert_true(not b64_encoded_layer.is_empty(), "Base64 encoded map_1 layer is non-empty")
	var b64_decoded_layer: PackedInt32Array = stats_db.decode_map_layer_int16(b64_encoded_layer, true)
	_assert_eq(b64_decoded_layer, map1_main_int16, "Base64 -> int16 array round-trip matches map_1 mapMain")


# =============================================================================
# 5. Offline Sandbox Flow (PlayerIOClient)
# =============================================================================
func _test_5_offline_sandbox_flow() -> void:
	print("[TEST 5] Offline Sandbox Flow (PlayerIOClient)...")

	var game_cfg_script: GDScript = load("res://scripts/autoload/GameConfig.gd")
	var pio_client: Node = load("res://scripts/network/PlayerIOClient.gd").new()
	root.add_child(pio_client)
	pio_client.is_offline_mode = true

	var auth_res: Dictionary = await pio_client.simple_connect("sandbox_hero", "sandbox_pass")
	var auth_out: Dictionary = auth_res.get("output", {})
	var auth_token: String = str(auth_out.get("token", ""))
	var auth_uid: String = str(auth_out.get("user_id", ""))
	_assert_true(bool(auth_res.get("success", false)), "Offline simple_connect succeeded")
	_assert_true(pio_client.is_offline_mode, "PlayerIOClient.is_offline_mode == true")
	_assert_true(not auth_token.is_empty(), "Offline auth token non-empty")
	_assert_true(auth_uid.begins_with("simple"), "Offline user_id starts with 'simple' (%s)" % auth_uid)

	# Загрузка PlayerObjects (load_my_player_object и bigdb_load_keys)
	var po_dict: Dictionary = await pio_client.load_my_player_object()
	_assert_true(not po_dict.is_empty(), "Offline load_my_player_object succeeded")
	_assert_true(po_dict.has("maxHealth"), "Offline PlayerObject has default 'maxHealth'")

	var loaded_objs: Array = await pio_client.bigdb_load_keys("PlayerObjects", PackedStringArray([auth_uid]))
	_assert_eq(loaded_objs.size(), 1, "Offline bigdb_load_keys('PlayerObjects') returned 1 object")

	# Подключение к локальной комнате (create_join_room)
	var room_id: String = game_cfg_script.build_room_id(1, game_cfg_script.DEFAULT_SERVER_NAME)
	var active_conn: PlayerIOConnection = await pio_client.create_join_room(
		room_id,
		game_cfg_script.MULTIPLAYER_ROOM_TYPE,
		true,
		{"level": "1"},
		{"name": "sandbox_hero"}
	)
	_assert_true(active_conn != null, "Offline create_join_room succeeded")
	_assert_true(active_conn != null and active_conn.is_connected_room(), "Local room PlayerIOConnection is connected")
	_assert_eq(active_conn.get_room_id(), room_id, "Connected room_id matches 9.50-r1_Pve Server")

	# Проверим отправку и получение локального сообщения через PlayerIOConnection
	var received_msgs: Array = []
	active_conn.add_message_listener("test_loopback", func(m: BinarySerializer.PlayerIOMessage) -> void:
		if m.size() == 2 and m.get_string(0) == "ping" and m.get_int(1) == 777:
			received_msgs.append(true)
	)
	active_conn.simulate_incoming_message("test_loopback", ["ping", 777])
	_assert_true(received_msgs.size() == 1, "PlayerIOConnection message listener received simulated packet")
