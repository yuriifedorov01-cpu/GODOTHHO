class_name ProtobufCodec
extends RefCounted
## ProtobufCodec — Кодировщик/декодировщик Google Protocol Buffers wire-формата и всех
## HTTP RPC сообщений PlayerIO (порт com.protobuf.* и playerio.generated.messages.*).
##
## Поддерживает:
## - Wire types: 0 (Varint / ZigZag / Bool / Enum), 1 (64-bit Fixed / Double),
##   2 (Length-delimited String / ByteArray / Embedded Message), 5 (32-bit Fixed / Float).
## - Конверт PlayerIO HTTPChannel (обновление playertoken + статус успеха/ошибки).
## - Полная конвертация BigDBObject <-> Dictionary (с поддержкой ValueType 0..10:
##   STRING, INT, UINT, LONG, BOOL, FLOAT, DOUBLE, BYTEARRAY, DATETIME, ARRAY, OBJ).

## Номера HTTP RPC методов PlayerIO (из PlayerIO.as, QuickConnect.as, Multiplayer.as, BigDB.as, PayVault.as)
enum RPCMethod {
	CONNECT = 10,
	AUTHENTICATE = 13,
	CREATE_ROOM = 21,
	JOIN_ROOM = 24,
	CREATE_JOIN_ROOM = 27,
	LIST_ROOMS = 30,
	WRITE_ERROR = 50,
	CREATE_OBJECTS = 82,
	LOAD_OBJECTS = 85,
	SAVE_OBJECT_CHANGES = 88,
	DELETE_OBJECTS = 91,
	LOAD_MATCHING_OBJECTS = 94,
	LOAD_INDEX_RANGE = 97,
	DELETE_INDEX_RANGE = 100,
	LOAD_MY_PLAYER_OBJECT = 103,
	PAY_VAULT_READ_HISTORY = 160,
	PAY_VAULT_REFRESH = 163,
	PAY_VAULT_CONSUME = 166,
	PAY_VAULT_CREDIT = 169,
	PAY_VAULT_DEBIT = 172,
	PAY_VAULT_BUY = 175,
	PAY_VAULT_GIVE = 178,
	PAY_VAULT_PAYMENT_INFO = 181,
	PAY_VAULT_USE_PAYMENT_INFO = 184,
	SIMPLE_CONNECT = 400,
	SIMPLE_REGISTER = 403,
	SIMPLE_RECOVER_PASSWORD = 406,
	KONGREGATE_CONNECT = 412,
	SIMPLE_GET_CAPTCHA = 415,
	FACEBOOK_OAUTH_CONNECT = 418,
	STEAM_CONNECT = 421,
	SIMPLE_USER_GET_SECURE_LOGIN_INFO = 424
}

## Типы значений BigDB (из playerio/generated/ValueType.as и ValueObject.as)
enum BigDBValueType {
	STRING = 0,     # field 2 (string)
	INT = 1,        # field 3 (int32)
	UINT = 2,       # field 4 (uint32)
	LONG = 3,       # field 5 (int64)
	BOOL = 4,       # field 6 (bool)
	FLOAT = 5,      # field 7 (float)
	DOUBLE = 6,     # field 8 (double)
	BYTE_ARRAY = 7, # field 9 (bytes)
	DATETIME = 8,   # field 10 (int64 unix timestamp ms)
	ARRAY = 9,      # field 11 (repeated ArrayProperty)
	OBJ = 10        # field 12 (repeated ObjectProperty)
}

## Wire types Protobuf
const WIRE_VARINT: int = 0
const WIRE_FIXED64: int = 1
const WIRE_LENGTH_DELIMITED: int = 2
const WIRE_FIXED32: int = 5


# ============================================================================
# НИЗКОУРОВНЕВЫЕ ПРИМИТИВЫ PROTOBUF WIRE FORMAT
# ============================================================================

static func encode_varint(value: int) -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	var uval: int = value
	for _i: int in range(10):
		if (uval & ~0x7F) == 0:
			out.append(uval & 0x7F)
			return out
		out.append((uval & 0x7F) | 0x80)
		# В GDScript int — знаковый 64-битный, поэтому сдвигаем логически через маску
		uval = (uval >> 7) & 0x01FFFFFFFFFFFFFF
	return out


static func decode_varint(buf: PackedByteArray, offset: int) -> Dictionary:
	var result: int = 0
	var shift: int = 0
	var pos: int = offset
	var size: int = buf.size()
	while pos < size and shift < 64:
		var b: int = buf[pos]
		pos += 1
		result |= ((b & 0x7F) << shift)
		if (b & 0x80) == 0:
			return {"value": result, "next": pos}
		shift += 7
	return {"value": result, "next": pos}


static func encode_zigzag32(n: int) -> int:
	return ((n << 1) ^ (n >> 31)) & 0xFFFFFFFF


static func decode_zigzag32(n: int) -> int:
	var u: int = n & 0xFFFFFFFF
	return (u >> 1) ^ -(u & 1)


static func encode_zigzag64(n: int) -> int:
	return (n << 1) ^ (n >> 63)


static func decode_zigzag64(n: int) -> int:
	return ((n >> 1) & 0x7FFFFFFFFFFFFFFF) ^ -(n & 1)


static func encode_tag(field_number: int, wire_type: int) -> PackedByteArray:
	return encode_varint((field_number << 3) | (wire_type & 0x07))


static func write_varint_field(out: PackedByteArray, field_number: int, value: int) -> void:
	out.append_array(encode_tag(field_number, WIRE_VARINT))
	out.append_array(encode_varint(value))


static func write_bool_field(out: PackedByteArray, field_number: int, value: bool) -> void:
	write_varint_field(out, field_number, 1 if value else 0)


static func write_string_field(out: PackedByteArray, field_number: int, value: String) -> void:
	var utf8: PackedByteArray = value.to_utf8_buffer()
	write_bytes_field(out, field_number, utf8)


static func write_bytes_field(out: PackedByteArray, field_number: int, payload: PackedByteArray) -> void:
	out.append_array(encode_tag(field_number, WIRE_LENGTH_DELIMITED))
	out.append_array(encode_varint(payload.size()))
	out.append_array(payload)


static func write_float_field(out: PackedByteArray, field_number: int, value: float) -> void:
	out.append_array(encode_tag(field_number, WIRE_FIXED32))
	var spb: StreamPeerBuffer = StreamPeerBuffer.new()
	spb.big_endian = false
	spb.put_float(value)
	out.append_array(spb.data_array)


static func write_double_field(out: PackedByteArray, field_number: int, value: float) -> void:
	out.append_array(encode_tag(field_number, WIRE_FIXED64))
	var spb: StreamPeerBuffer = StreamPeerBuffer.new()
	spb.big_endian = false
	spb.put_double(value)
	out.append_array(spb.data_array)


## Декодирует произвольное Protobuf-сообщение в словарь сырых полей:
## field_number (int) -> Array[Dictionary{"wire": int, "value": Variant}]
static func decode_raw_fields(buf: PackedByteArray, start_offset: int = 0, end_offset: int = -1) -> Dictionary:
	var fields: Dictionary = {}
	var pos: int = start_offset
	var limit: int = buf.size() if end_offset < 0 else min(end_offset, buf.size())

	while pos < limit:
		var tag_res: Dictionary = decode_varint(buf, pos)
		pos = tag_res["next"]
		var tag: int = tag_res["value"]
		if tag == 0:
			break
		var field_num: int = tag >> 3
		var wire_type: int = tag & 0x07
		var val: Variant = null

		match wire_type:
			WIRE_VARINT:
				var v_res: Dictionary = decode_varint(buf, pos)
				pos = v_res["next"]
				val = v_res["value"]
			WIRE_FIXED64:
				if pos + 8 > limit:
					break
				val = buf.slice(pos, pos + 8)
				pos += 8
			WIRE_LENGTH_DELIMITED:
				var len_res: Dictionary = decode_varint(buf, pos)
				pos = len_res["next"]
				var length: int = len_res["value"]
				if length < 0 or pos + length > limit:
					break
				val = buf.slice(pos, pos + length)
				pos += length
			WIRE_FIXED32:
				if pos + 4 > limit:
					break
				val = buf.slice(pos, pos + 4)
				pos += 4
			_:
				push_warning("[ProtobufCodec] Unknown wire_type=%d at pos=%d" % [wire_type, pos])
				break

		if not fields.has(field_num):
			fields[field_num] = []
		fields[field_num].append({"wire": wire_type, "value": val})

	return fields


static func raw_get_string(fields: Dictionary, field_num: int, default_val: String = "") -> String:
	if not fields.has(field_num) or fields[field_num].is_empty():
		return default_val
	var item: Dictionary = fields[field_num][-1]
	if item["value"] is PackedByteArray:
		var ba: PackedByteArray = item["value"]
		return ba.get_string_from_utf8()
	return default_val


static func raw_get_strings(fields: Dictionary, field_num: int) -> PackedStringArray:
	var arr: PackedStringArray = PackedStringArray()
	if not fields.has(field_num):
		return arr
	for item: Dictionary in fields[field_num]:
		if item["value"] is PackedByteArray:
			var ba: PackedByteArray = item["value"]
			arr.append(ba.get_string_from_utf8())
	return arr


static func raw_get_int(fields: Dictionary, field_num: int, default_val: int = 0) -> int:
	if not fields.has(field_num) or fields[field_num].is_empty():
		return default_val
	var v: int = int(fields[field_num][-1]["value"])
	# Приведение 32-битных отрицательных varint если они закодированы в 32 или 64 битах
	if (v & 0x80000000) != 0 and (v >> 32) == 0:
		return v - 0x100000000
	return v


static func raw_get_uint(fields: Dictionary, field_num: int, default_val: int = 0) -> int:
	if not fields.has(field_num) or fields[field_num].is_empty():
		return default_val
	return int(fields[field_num][-1]["value"]) & 0xFFFFFFFF


static func raw_get_int64(fields: Dictionary, field_num: int, default_val: int = 0) -> int:
	if not fields.has(field_num) or fields[field_num].is_empty():
		return default_val
	return int(fields[field_num][-1]["value"])


static func raw_get_bool(fields: Dictionary, field_num: int, default_val: bool = false) -> bool:
	if not fields.has(field_num) or fields[field_num].is_empty():
		return default_val
	return int(fields[field_num][-1]["value"]) != 0


static func raw_get_float(fields: Dictionary, field_num: int, default_val: float = 0.0) -> float:
	if not fields.has(field_num) or fields[field_num].is_empty():
		return default_val
	var item: Dictionary = fields[field_num][-1]
	if item["value"] is PackedByteArray and (item["value"] as PackedByteArray).size() == 4:
		var spb: StreamPeerBuffer = StreamPeerBuffer.new()
		spb.big_endian = false
		spb.data_array = item["value"]
		return spb.get_float()
	return default_val


static func raw_get_double(fields: Dictionary, field_num: int, default_val: float = 0.0) -> float:
	if not fields.has(field_num) or fields[field_num].is_empty():
		return default_val
	var item: Dictionary = fields[field_num][-1]
	if item["value"] is PackedByteArray and (item["value"] as PackedByteArray).size() == 8:
		var spb: StreamPeerBuffer = StreamPeerBuffer.new()
		spb.big_endian = false
		spb.data_array = item["value"]
		return spb.get_double()
	return default_val


static func raw_get_bytes(fields: Dictionary, field_num: int) -> PackedByteArray:
	if not fields.has(field_num) or fields[field_num].is_empty():
		return PackedByteArray()
	var item: Dictionary = fields[field_num][-1]
	if item["value"] is PackedByteArray:
		return item["value"]
	return PackedByteArray()


static func raw_get_bytes_list(fields: Dictionary, field_num: int) -> Array[PackedByteArray]:
	var out: Array[PackedByteArray] = []
	if not fields.has(field_num):
		return out
	for item: Dictionary in fields[field_num]:
		if item["value"] is PackedByteArray:
			out.append(item["value"])
	return out


# ============================================================================
# КОНВЕРТ HTTP КАНАЛА PLAYERIO (playerio/utils/HTTPChannel.as)
# ============================================================================

## Подготавливает тело HTTP-запроса: если сообщение пустое (0 байт), PlayerIO требует 2 байта [0x08, 0x00].
static func finalize_http_request_body(serialized_args: PackedByteArray) -> PackedByteArray:
	if serialized_args.is_empty():
		var empty_body: PackedByteArray = PackedByteArray()
		empty_body.append(0x08)
		empty_body.append(0x00)
		return empty_body
	return serialized_args


## Распаковывает HTTP-ответ от https://api.playerio.com/api/{method}.
## Возвращает Dictionary:
## {
##   "success": bool,
##   "new_token": String,
##   "payload": PackedByteArray,
##   "error_code": int,
##   "error_message": String,
##   "error_details": Dictionary
## }
static func parse_http_response_envelope(response_bytes: PackedByteArray) -> Dictionary:
	var result: Dictionary = {
		"success": false,
		"new_token": "",
		"payload": PackedByteArray(),
		"error_code": -1,
		"error_message": "",
		"error_details": {}
	}
	if response_bytes.size() < 2:
		result["error_message"] = "Empty or truncated HTTP response from PlayerIO"
		return result

	var pos: int = 0
	var has_token_byte: int = response_bytes[pos]
	pos += 1

	if has_token_byte != 0:
		if pos + 2 > response_bytes.size():
			result["error_message"] = "Truncated token length in HTTP response"
			return result
		var token_len: int = (response_bytes[pos] << 8) | response_bytes[pos + 1]
		pos += 2
		if pos + token_len > response_bytes.size():
			result["error_message"] = "Truncated token string in HTTP response"
			return result
		result["has_new_token"] = true
		result["new_token"] = response_bytes.slice(pos, pos + token_len).get_string_from_utf8()
		pos += token_len
	else:
		result["has_new_token"] = false

	if pos >= response_bytes.size():
		result["error_message"] = "Missing status byte in HTTP response"
		return result

	var status_byte: int = response_bytes[pos]
	pos += 1
	var payload: PackedByteArray = response_bytes.slice(pos)
	result["payload"] = payload

	if status_byte == 1:
		result["success"] = true
	else:
		result["success"] = false
		var err_fields: Dictionary = decode_raw_fields(payload)
		result["error_code"] = raw_get_int(err_fields, 1, 0)
		result["error_message"] = raw_get_string(err_fields, 2, "Unknown PlayerIO RPC Error")
		# Для SimpleRegisterError также бывают поля 3..6 (usernameError, passwordError, emailError, captchaError)
		result["error_details"] = {
			"username_error": raw_get_string(err_fields, 3, ""),
			"password_error": raw_get_string(err_fields, 4, ""),
			"email_error": raw_get_string(err_fields, 5, ""),
			"captcha_error": raw_get_string(err_fields, 6, "")
		}

	return result


## Алиас для распаковки HTTPChannel-ответа (эквивалент parse_http_response_envelope).
static func unwrap_http_channel_response(response_bytes: PackedByteArray) -> Dictionary:
	return parse_http_response_envelope(response_bytes)


## Упаковывает ответ сервера в конверт PlayerIO HTTPChannel (для тестирования и локального мок-сервера).
static func wrap_http_channel_response(payload: PackedByteArray, success: bool = true, new_token: String = "", error_code: int = 0, error_message: String = "") -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	if new_token.is_empty():
		out.append(0)
	else:
		out.append(1)
		var token_utf8: PackedByteArray = new_token.to_utf8_buffer()
		out.append((token_utf8.size() >> 8) & 0xFF)
		out.append(token_utf8.size() & 0xFF)
		out.append_array(token_utf8)
	if success:
		out.append(1)
		out.append_array(payload)
	else:
		out.append(0)
		var err_buf: PackedByteArray = PackedByteArray()
		write_varint_field(err_buf, 1, error_code)
		write_string_field(err_buf, 2, error_message)
		out.append_array(err_buf)
	return out


# ============================================================================
# BIGDB КОДИРОВАНИЕ / ДЕКОДИРОВАНИЕ (BigDBObject, ValueObject, ObjectProperty)
# ============================================================================

## Сериализует KeyValuePair {1: key, 2: value}
static func encode_key_value_pair(key: String, value: String) -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	if not key.is_empty():
		write_string_field(out, 1, key)
	if not value.is_empty():
		write_string_field(out, 2, value)
	return out


## Десериализует массив KeyValuePair в Dictionary
static func decode_key_value_pairs(blobs: Array[PackedByteArray]) -> Dictionary:
	var out: Dictionary = {}
	for b: PackedByteArray in blobs:
		var f: Dictionary = decode_raw_fields(b)
		var k: String = raw_get_string(f, 1, "")
		var v: String = raw_get_string(f, 2, "")
		out[k] = v
	return out


## Сериализует GDScript Variant в ValueObject (playerio/generated/messages/ValueObject.as)
static func encode_bigdb_value_object(val: Variant) -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	match typeof(val):
		TYPE_NIL:
			write_varint_field(out, 1, BigDBValueType.STRING)
			write_string_field(out, 2, "")
		TYPE_STRING, TYPE_STRING_NAME:
			write_varint_field(out, 1, BigDBValueType.STRING)
			write_string_field(out, 2, str(val))
		TYPE_BOOL:
			write_varint_field(out, 1, BigDBValueType.BOOL)
			write_bool_field(out, 6, bool(val))
		TYPE_INT:
			var iv: int = int(val)
			if iv >= -2147483648 and iv <= 2147483647:
				write_varint_field(out, 1, BigDBValueType.INT)
				write_varint_field(out, 3, iv)
			else:
				write_varint_field(out, 1, BigDBValueType.LONG)
				write_varint_field(out, 5, iv)
		TYPE_FLOAT:
			write_varint_field(out, 1, BigDBValueType.DOUBLE)
			write_double_field(out, 8, float(val))
		TYPE_PACKED_BYTE_ARRAY:
			write_varint_field(out, 1, BigDBValueType.BYTE_ARRAY)
			write_bytes_field(out, 9, val as PackedByteArray)
		TYPE_ARRAY:
			write_varint_field(out, 1, BigDBValueType.ARRAY)
			var arr: Array = val
			for idx: int in range(arr.size()):
				if arr[idx] == null:
					continue
				var prop: PackedByteArray = PackedByteArray()
				write_varint_field(prop, 1, idx)
				write_bytes_field(prop, 2, encode_bigdb_value_object(arr[idx]))
				write_bytes_field(out, 11, prop)
		TYPE_DICTIONARY:
			var d: Dictionary = val
			# Специальная метка для DateTime или Long/UInt/Float при необходимости
			if d.has("__bigdb_type__"):
				var btype: int = int(d["__bigdb_type__"])
				write_varint_field(out, 1, btype)
				match btype:
					BigDBValueType.UINT:
						write_varint_field(out, 4, int(d.get("value", 0)) & 0xFFFFFFFF)
					BigDBValueType.LONG:
						write_varint_field(out, 5, int(d.get("value", 0)))
					BigDBValueType.FLOAT:
						write_float_field(out, 7, float(d.get("value", 0.0)))
					BigDBValueType.DATETIME:
						write_varint_field(out, 10, int(d.get("value", 0)))
					_:
						write_string_field(out, 2, str(d.get("value", "")))
			else:
				write_varint_field(out, 1, BigDBValueType.OBJ)
				for prop_name: Variant in d.keys():
					var p_str: String = str(prop_name)
					if p_str == "_key" or p_str == "_version" or p_str == "_table":
						continue
					var prop_msg: PackedByteArray = encode_bigdb_object_property(p_str, d[prop_name])
					write_bytes_field(out, 12, prop_msg)
		_:
			write_varint_field(out, 1, BigDBValueType.STRING)
			write_string_field(out, 2, str(val))
	return out


static func encode_bigdb_object_property(prop_name: String, prop_val: Variant) -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	write_string_field(out, 1, prop_name)
	write_bytes_field(out, 2, encode_bigdb_value_object(prop_val))
	return out


static func decode_bigdb_value_object(buf: PackedByteArray) -> Variant:
	var f: Dictionary = decode_raw_fields(buf)
	var vtype: int = raw_get_int(f, 1, BigDBValueType.STRING)
	match vtype:
		BigDBValueType.STRING:
			return raw_get_string(f, 2, "")
		BigDBValueType.INT:
			return raw_get_int(f, 3, 0)
		BigDBValueType.UINT:
			return raw_get_uint(f, 4, 0)
		BigDBValueType.LONG:
			return raw_get_int64(f, 5, 0)
		BigDBValueType.BOOL:
			return raw_get_bool(f, 6, false)
		BigDBValueType.FLOAT:
			return raw_get_float(f, 7, 0.0)
		BigDBValueType.DOUBLE:
			return raw_get_double(f, 8, 0.0)
		BigDBValueType.BYTE_ARRAY:
			return raw_get_bytes(f, 9)
		BigDBValueType.DATETIME:
			return raw_get_int64(f, 10, 0)
		BigDBValueType.ARRAY:
			var arr_blobs: Array[PackedByteArray] = raw_get_bytes_list(f, 11)
			var max_idx: int = -1
			var indexed_items: Dictionary = {}
			for ab: PackedByteArray in arr_blobs:
				var af: Dictionary = decode_raw_fields(ab)
				var idx: int = raw_get_int(af, 1, 0)
				var val_bytes: PackedByteArray = raw_get_bytes(af, 2)
				indexed_items[idx] = decode_bigdb_value_object(val_bytes)
				if idx > max_idx:
					max_idx = idx
			var result_arr: Array = []
			if max_idx >= 0:
				result_arr.resize(max_idx + 1)
				for idx_key: int in indexed_items.keys():
					if idx_key >= 0 and idx_key < result_arr.size():
						result_arr[idx_key] = indexed_items[idx_key]
			return result_arr
		BigDBValueType.OBJ:
			var obj_blobs: Array[PackedByteArray] = raw_get_bytes_list(f, 12)
			return decode_bigdb_object_properties(obj_blobs)
		_:
			return null


static func decode_bigdb_object_properties(prop_blobs: Array[PackedByteArray]) -> Dictionary:
	var result: Dictionary = {}
	for pb: PackedByteArray in prop_blobs:
		var pf: Dictionary = decode_raw_fields(pb)
		var pname: String = raw_get_string(pf, 1, "")
		var val_bytes: PackedByteArray = raw_get_bytes(pf, 2)
		if not pname.is_empty():
			result[pname] = decode_bigdb_value_object(val_bytes)
	return result


## Кодирует BigDBObject {1: key, 2: version, 3: repeated ObjectProperty, 4: creator}
static func encode_bigdb_object(key: String, properties: Dictionary, version: String = "1", creator: int = 0) -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	if not key.is_empty():
		write_string_field(out, 1, key)
	if not version.is_empty():
		write_string_field(out, 2, version)
	for prop_name: Variant in properties.keys():
		var p_str: String = str(prop_name)
		if p_str == "_key" or p_str == "_version" or p_str == "_table" or p_str == "_creator":
			continue
		write_bytes_field(out, 3, encode_bigdb_object_property(p_str, properties[prop_name]))
	if creator != 0:
		write_varint_field(out, 4, creator)
	return out


## Декодирует BigDBObject {1: key, 2: version, 3: repeated ObjectProperty, 4: creator}
static func decode_bigdb_object(buf: PackedByteArray) -> Dictionary:
	if buf.is_empty():
		return {}
	var f: Dictionary = decode_raw_fields(buf)
	var key: String = raw_get_string(f, 1, "")
	var version: String = raw_get_string(f, 2, "")
	var creator: int = raw_get_uint(f, 4, 0)
	var props: Dictionary = decode_bigdb_object_properties(raw_get_bytes_list(f, 3))
	props["_key"] = key
	props["_version"] = version
	if creator != 0:
		props["_creator"] = creator
	return props


# ============================================================================
# AUTHENTICATE / QUICKCONNECT / CONNECT RPC MESSAGES
# ============================================================================

## Method 400: SimpleConnectArgs {1: gameId, 2: usernameOrEmail, 3: password, 4: playerInsightSegments, 5: clientAPI, 6: clientInfo}
static func encode_simple_connect_args(game_id: String, username_or_email: String, password: String, client_api: String = "as3", client_info: Dictionary = {}) -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	write_string_field(out, 1, game_id)
	write_string_field(out, 2, username_or_email)
	write_string_field(out, 3, password)
	write_string_field(out, 5, client_api)
	for k: Variant in client_info.keys():
		write_bytes_field(out, 6, encode_key_value_pair(str(k), str(client_info[k])))
	return out


## Method 403: SimpleRegisterArgs {1: gameId, 2: username, 3: password, 4: email, 5: captchaKey, 6: captchaValue, 7: extraData, 8: partnerId, 9: playerInsightSegments, 10: clientAPI, 11: clientInfo}
static func encode_simple_register_args(game_id: String, username: String, password: String, email: String, extra_data: Dictionary = {}, captcha_key: String = "", captcha_value: String = "", partner_id: String = "") -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	write_string_field(out, 1, game_id)
	write_string_field(out, 2, username)
	write_string_field(out, 3, password)
	if not email.is_empty():
		write_string_field(out, 4, email)
	if not captcha_key.is_empty():
		write_string_field(out, 5, captcha_key)
	if not captcha_value.is_empty():
		write_string_field(out, 6, captcha_value)
	for k: Variant in extra_data.keys():
		write_bytes_field(out, 7, encode_key_value_pair(str(k), str(extra_data[k])))
	if not partner_id.is_empty():
		write_string_field(out, 8, partner_id)
	write_string_field(out, 10, "as3")
	return out


## Method 406: SimpleRecoverPasswordArgs {1: gameId, 2: usernameOrEmail}
static func encode_simple_recover_password_args(game_id: String, username_or_email: String) -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	write_string_field(out, 1, game_id)
	write_string_field(out, 2, username_or_email)
	return out


## Method 10: ConnectArgs {1: gameId, 2: connectionId, 3: userId, 4: auth, 5: partnerId, 6: playerInsightSegments, 7: clientAPI, 8: clientInfo}
static func encode_connect_args(game_id: String, connection_id: String, user_id: String, auth: String = "", partner_id: String = "") -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	write_string_field(out, 1, game_id)
	write_string_field(out, 2, connection_id)
	write_string_field(out, 3, user_id)
	if not auth.is_empty():
		write_string_field(out, 4, auth)
	if not partner_id.is_empty():
		write_string_field(out, 5, partner_id)
	write_string_field(out, 7, "as3")
	return out


## Method 13: AuthenticateArgs {1: gameId, 2: connectionId, 3: authenticationArguments, 4: playerInsightSegments, 5: clientAPI, 6: clientInfo, 7: playCodes}
static func encode_authenticate_args(game_id: String, connection_id: String, auth_args: Dictionary, client_info: Dictionary = {}) -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	write_string_field(out, 1, game_id)
	write_string_field(out, 2, connection_id)
	for k: Variant in auth_args.keys():
		write_bytes_field(out, 3, encode_key_value_pair(str(k), str(auth_args[k])))
	write_string_field(out, 5, "as3")
	for ck: Variant in client_info.keys():
		write_bytes_field(out, 6, encode_key_value_pair(str(ck), str(client_info[ck])))
	return out


## Декодирует ConnectOutput / SimpleConnectOutput / SimpleRegisterOutput / AuthenticateOutput
## {1: token, 2: userId, 3: showBranding, 4: gameFSRedirectMap, 5: partnerId, ...}
static func decode_connect_output(payload: PackedByteArray) -> Dictionary:
	var f: Dictionary = decode_raw_fields(payload)
	return {
		"token": raw_get_string(f, 1, ""),
		"user_id": raw_get_string(f, 2, ""),
		"show_branding": raw_get_bool(f, 3, false),
		"gamefs_redirect_map": raw_get_string(f, 4, ""),
		"partner_id": raw_get_string(f, 5, "")
	}


# ============================================================================
# MULTIPLAYER RPC MESSAGES (CreateJoinRoom 27, ListRooms 30)
# ============================================================================

## Method 27: CreateJoinRoomArgs {1: roomId, 2: roomType, 3: visible, 4: roomData, 5: joinData, 6: isDevRoom}
static func encode_create_join_room_args(room_id: String, room_type: String, visible: bool, room_data: Dictionary = {}, join_data: Dictionary = {}, is_dev_room: bool = false) -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	if not room_id.is_empty():
		write_string_field(out, 1, room_id)
	write_string_field(out, 2, room_type)
	write_bool_field(out, 3, visible)
	for rk: Variant in room_data.keys():
		write_bytes_field(out, 4, encode_key_value_pair(str(rk), str(room_data[rk])))
	for jk: Variant in join_data.keys():
		write_bytes_field(out, 5, encode_key_value_pair(str(jk), str(join_data[jk])))
	if is_dev_room:
		write_bool_field(out, 6, true)
	return out


## Декодирует CreateJoinRoomOutput {1: roomId, 2: joinKey, 3: endpoints (repeated ServerEndpoint {1: address, 2: port})}
static func decode_create_join_room_output(payload: PackedByteArray) -> Dictionary:
	var f: Dictionary = decode_raw_fields(payload)
	var endpoints: Array[Dictionary] = []
	for ep_bytes: PackedByteArray in raw_get_bytes_list(f, 3):
		var ef: Dictionary = decode_raw_fields(ep_bytes)
		endpoints.append({
			"address": raw_get_string(ef, 1, ""),
			"port": raw_get_int(ef, 2, 8184)
		})
	return {
		"room_id": raw_get_string(f, 1, ""),
		"join_key": raw_get_string(f, 2, ""),
		"endpoints": endpoints
	}


## Method 30: ListRoomsArgs {1: roomType, 2: searchCriteria, 3: resultLimit, 4: resultOffset, 5: onlyDevRooms}
static func encode_list_rooms_args(room_type: String, search_criteria: Dictionary = {}, result_limit: int = 50, result_offset: int = 0, only_dev_rooms: bool = false) -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	write_string_field(out, 1, room_type)
	for k: Variant in search_criteria.keys():
		write_bytes_field(out, 2, encode_key_value_pair(str(k), str(search_criteria[k])))
	if result_limit > 0:
		write_varint_field(out, 3, result_limit)
	if result_offset > 0:
		write_varint_field(out, 4, result_offset)
	if only_dev_rooms:
		write_bool_field(out, 5, true)
	return out


## Декодирует ListRoomsOutput {1: repeated RoomInfo {1: id, 2: roomType, 3: onlineUsers, 4: roomData}}
static func decode_list_rooms_output(payload: PackedByteArray) -> Array[Dictionary]:
	var f: Dictionary = decode_raw_fields(payload)
	var rooms: Array[Dictionary] = []
	for r_bytes: PackedByteArray in raw_get_bytes_list(f, 1):
		var rf: Dictionary = decode_raw_fields(r_bytes)
		rooms.append({
			"id": raw_get_string(rf, 1, ""),
			"room_type": raw_get_string(rf, 2, ""),
			"online_users": raw_get_int(rf, 3, 0),
			"room_data": decode_key_value_pairs(raw_get_bytes_list(rf, 4))
		})
	return rooms


# ============================================================================
# BIGDB RPC MESSAGES (82, 85, 88, 91, 94, 97, 100, 103)
# ============================================================================

## Method 85: LoadObjectsArgs {1: repeated BigDBObjectId {1: table, 2: repeated key}}
static func encode_load_objects_args(table: String, keys: PackedStringArray) -> PackedByteArray:
	var obj_id: PackedByteArray = PackedByteArray()
	write_string_field(obj_id, 1, table)
	for k: String in keys:
		write_string_field(obj_id, 2, k)
	var out: PackedByteArray = PackedByteArray()
	write_bytes_field(out, 1, obj_id)
	return out


## Декодирует LoadObjectsOutput / CreateObjectsOutput / LoadMatchingObjectsOutput / LoadIndexRangeOutput
## {1: repeated BigDBObject}
static func decode_bigdb_objects_output(payload: PackedByteArray) -> Array[Dictionary]:
	var f: Dictionary = decode_raw_fields(payload)
	var list: Array[Dictionary] = []
	for obj_bytes: PackedByteArray in raw_get_bytes_list(f, 1):
		list.append(decode_bigdb_object(obj_bytes))
	return list


## Method 103: LoadMyPlayerObjectArgs (пустой запрос -> [0x08, 0x00]), Output {1: playerObject (BigDBObject)}
static func decode_load_my_player_object_output(payload: PackedByteArray) -> Dictionary:
	var f: Dictionary = decode_raw_fields(payload)
	var obj_bytes: PackedByteArray = raw_get_bytes(f, 1)
	return decode_bigdb_object(obj_bytes)


## Method 97: LoadIndexRangeArgs {1: table, 2: index, 3: startIndexValue (repeated ValueObject), 4: stopIndexValue (repeated ValueObject), 5: limit}
static func encode_load_index_range_args(table: String, index_name: String, start_values: Array = [], stop_values: Array = [], limit: int = 100) -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	write_string_field(out, 1, table)
	write_string_field(out, 2, index_name)
	for sv: Variant in start_values:
		write_bytes_field(out, 3, encode_bigdb_value_object(sv))
	for ev: Variant in stop_values:
		write_bytes_field(out, 4, encode_bigdb_value_object(ev))
	write_varint_field(out, 5, limit)
	return out


## Method 94: LoadMatchingObjectsArgs {1: table, 2: index, 3: indexValue (repeated ValueObject), 4: limit}
static func encode_load_matching_objects_args(table: String, index_name: String, index_values: Array, limit: int = 100) -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	write_string_field(out, 1, table)
	write_string_field(out, 2, index_name)
	for iv: Variant in index_values:
		write_bytes_field(out, 3, encode_bigdb_value_object(iv))
	write_varint_field(out, 4, limit)
	return out


## Method 82: CreateObjectsArgs {1: repeated NewBigDBObject {1: table, 2: key, 3: repeated ObjectProperty}, 2: loadExisting}
static func encode_create_objects_args(objects_spec: Array[Dictionary], load_existing: bool = false) -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	for spec: Dictionary in objects_spec:
		var new_obj: PackedByteArray = PackedByteArray()
		write_string_field(new_obj, 1, str(spec.get("table", "")))
		write_string_field(new_obj, 2, str(spec.get("key", "")))
		var props: Dictionary = spec.get("properties", {})
		for pk: Variant in props.keys():
			var p_str: String = str(pk)
			if p_str.begins_with("_"):
				continue
			write_bytes_field(new_obj, 3, encode_bigdb_object_property(p_str, props[pk]))
		write_bytes_field(out, 1, new_obj)
	write_bool_field(out, 2, load_existing)
	return out


## Method 88: SaveObjectChangesArgs {1: lockType, 2: repeated BigDBChangeset {1: table, 2: key, 3: onlyIfVersion, 4: changes, 5: fullOverwrite}, 3: createIfMissing}
static func encode_save_object_changes_args(table: String, key: String, changes: Dictionary, create_if_missing: bool = true, full_overwrite: bool = false, only_if_version: String = "") -> PackedByteArray:
	var cs: PackedByteArray = PackedByteArray()
	write_string_field(cs, 1, table)
	write_string_field(cs, 2, key)
	if not only_if_version.is_empty():
		write_string_field(cs, 3, only_if_version)
	for pk: Variant in changes.keys():
		var p_str: String = str(pk)
		if p_str.begins_with("_"):
			continue
		write_bytes_field(cs, 4, encode_bigdb_object_property(p_str, changes[pk]))
	if full_overwrite:
		write_bool_field(cs, 5, true)

	var out: PackedByteArray = PackedByteArray()
	write_varint_field(out, 1, 0) # LockType = NoLocks (0)
	write_bytes_field(out, 2, cs)
	write_bool_field(out, 3, create_if_missing)
	return out


## Method 91: DeleteObjectsArgs {1: repeated BigDBObjectId {1: table, 2: repeated key}}
static func encode_delete_objects_args(table: String, keys: PackedStringArray) -> PackedByteArray:
	return encode_load_objects_args(table, keys)


# ============================================================================
# PAYVAULT RPC MESSAGES (160, 163, 166, 169, 172, 175, 178, 181, 184)
# ============================================================================

## Декодирует PayVaultContents {1: version, 2: coins, 3: repeated PayVaultItem {1: id, 2: itemKey, 3: purchaseDate, 4: properties}}
static func decode_payvault_contents(buf: PackedByteArray) -> Dictionary:
	if buf.is_empty():
		return {"version": "", "coins": 0, "items": []}
	var f: Dictionary = decode_raw_fields(buf)
	var items: Array[Dictionary] = []
	for item_bytes: PackedByteArray in raw_get_bytes_list(f, 3):
		var itf: Dictionary = decode_raw_fields(item_bytes)
		var item_dict: Dictionary = decode_bigdb_object_properties(raw_get_bytes_list(itf, 4))
		item_dict["id"] = raw_get_string(itf, 1, "")
		item_dict["itemKey"] = raw_get_string(itf, 2, "")
		item_dict["purchaseDate"] = raw_get_int64(itf, 3, 0)
		items.append(item_dict)
	return {
		"version": raw_get_string(f, 1, ""),
		"coins": raw_get_int(f, 2, 0),
		"items": items
	}


## Декодирует PayVaultRefreshOutput / PayVaultBuyOutput / PayVaultCreditOutput / PayVaultDebitOutput / PayVaultConsumeOutput
## {1: vaultContents (PayVaultContents)}
static func decode_payvault_mutation_output(payload: PackedByteArray) -> Dictionary:
	var f: Dictionary = decode_raw_fields(payload)
	return decode_payvault_contents(raw_get_bytes(f, 1))


## Method 163: PayVaultRefreshArgs {1: lastVersion, 2: targetUserId}
static func encode_payvault_refresh_args(last_version: String = "", target_user_id: String = "") -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	if not last_version.is_empty():
		write_string_field(out, 1, last_version)
	if not target_user_id.is_empty():
		write_string_field(out, 2, target_user_id)
	return out


## Method 169 / 172: PayVaultCreditArgs / PayVaultDebitArgs {1: amount (uint32), 2: reason, 3: targetUserId}
static func encode_payvault_coins_args(amount: int, reason: String, target_user_id: String = "") -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	write_varint_field(out, 1, max(0, amount))
	write_string_field(out, 2, reason)
	if not target_user_id.is_empty():
		write_string_field(out, 3, target_user_id)
	return out


## Method 166: PayVaultConsumeArgs {1: repeated ids, 2: targetUserId}
static func encode_payvault_consume_args(item_ids: PackedStringArray, target_user_id: String = "") -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	for id_str: String in item_ids:
		write_string_field(out, 1, id_str)
	if not target_user_id.is_empty():
		write_string_field(out, 2, target_user_id)
	return out


## Method 175: PayVaultBuyArgs {1: repeated PayVaultBuyItemInfo {1: itemKey, 2: repeated ObjectProperty}, 2: storeItems, 3: targetUserId}
static func encode_payvault_buy_args(items: Array[Dictionary], store_items: bool = true, target_user_id: String = "") -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	for item_spec: Dictionary in items:
		var b_item: PackedByteArray = PackedByteArray()
		write_string_field(b_item, 1, str(item_spec.get("itemKey", "")))
		for k: Variant in item_spec.keys():
			var ks: String = str(k)
			if ks == "itemKey":
				continue
			write_bytes_field(b_item, 2, encode_bigdb_object_property(ks, item_spec[k]))
		write_bytes_field(out, 1, b_item)
	write_bool_field(out, 2, store_items)
	if not target_user_id.is_empty():
		write_string_field(out, 3, target_user_id)
	return out


## Method 160: PayVaultReadHistoryArgs {1: page (uint32), 2: pageSize (uint32), 3: targetUserId}
static func encode_payvault_read_history_args(page: int = 0, page_size: int = 20, target_user_id: String = "") -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	write_varint_field(out, 1, max(0, page))
	write_varint_field(out, 2, max(1, page_size))
	if not target_user_id.is_empty():
		write_string_field(out, 3, target_user_id)
	return out


# ============================================================================
# ROUND-TRIP DECODERS / ENCODERS FOR VERIFICATION & MOCK SERVER
# ============================================================================

static func decode_simple_connect_args(payload: PackedByteArray) -> Dictionary:
	var f: Dictionary = decode_raw_fields(payload)
	return {
		"game_id": raw_get_string(f, 1, ""),
		"username_or_email": raw_get_string(f, 2, ""),
		"password": raw_get_string(f, 3, ""),
		"client_api": raw_get_string(f, 5, ""),
		"client_info": decode_key_value_pairs(raw_get_bytes_list(f, 6))
	}


static func decode_authenticate_args(payload: PackedByteArray) -> Dictionary:
	var f: Dictionary = decode_raw_fields(payload)
	return {
		"game_id": raw_get_string(f, 1, ""),
		"connection_id": raw_get_string(f, 2, ""),
		"auth_args": decode_key_value_pairs(raw_get_bytes_list(f, 3)),
		"client_api": raw_get_string(f, 5, ""),
		"client_info": decode_key_value_pairs(raw_get_bytes_list(f, 6))
	}


static func encode_authenticate_output(token: String, user_id: String, show_branding: bool = false, gamefs_redirect_map: String = "", partner_id: String = "") -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	if not token.is_empty():
		write_string_field(out, 1, token)
	if not user_id.is_empty():
		write_string_field(out, 2, user_id)
	if show_branding:
		write_bool_field(out, 3, show_branding)
	if not gamefs_redirect_map.is_empty():
		write_string_field(out, 4, gamefs_redirect_map)
	if not partner_id.is_empty():
		write_string_field(out, 5, partner_id)
	return out


static func decode_authenticate_output(payload: PackedByteArray) -> Dictionary:
	return decode_connect_output(payload)


static func decode_create_join_room_args(payload: PackedByteArray) -> Dictionary:
	var f: Dictionary = decode_raw_fields(payload)
	return {
		"room_id": raw_get_string(f, 1, ""),
		"room_type": raw_get_string(f, 2, ""),
		"visible": raw_get_bool(f, 3, true),
		"room_data": decode_key_value_pairs(raw_get_bytes_list(f, 4)),
		"join_data": decode_key_value_pairs(raw_get_bytes_list(f, 5)),
		"is_dev_room": raw_get_bool(f, 6, false)
	}


static func encode_create_join_room_output(room_id: String, join_key: String, endpoints: Array = []) -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	if not room_id.is_empty():
		write_string_field(out, 1, room_id)
	if not join_key.is_empty():
		write_string_field(out, 2, join_key)
	for ep: Variant in endpoints:
		if ep is Dictionary:
			var ep_buf: PackedByteArray = PackedByteArray()
			write_string_field(ep_buf, 1, str(ep.get("address", "127.0.0.1")))
			write_varint_field(ep_buf, 2, int(ep.get("port", 8184)))
			write_bytes_field(out, 3, ep_buf)
	return out


static func decode_load_objects_args(payload: PackedByteArray) -> Dictionary:
	var f: Dictionary = decode_raw_fields(payload)
	var requests: Array[Dictionary] = []
	for obj_id_bytes: PackedByteArray in raw_get_bytes_list(f, 1):
		var oif: Dictionary = decode_raw_fields(obj_id_bytes)
		var keys: PackedStringArray = PackedStringArray()
		for kb: PackedByteArray in raw_get_bytes_list(oif, 2):
			keys.append(kb.get_string_from_utf8())
		requests.append({
			"table": raw_get_string(oif, 1, ""),
			"keys": keys
		})
	if requests.size() == 1:
		return {
			"table": requests[0]["table"],
			"keys": requests[0]["keys"],
			"object_ids": requests
		}
	return {"object_ids": requests}


static func encode_load_objects_output(objects: Array) -> PackedByteArray:
	var out: PackedByteArray = PackedByteArray()
	for obj: Variant in objects:
		if obj is PackedByteArray:
			write_bytes_field(out, 1, obj)
		elif obj is Dictionary:
			var d: Dictionary = obj
			var key: String = str(d.get("_key", d.get("key", "obj_1")))
			var ver: String = str(d.get("_version", d.get("version", "1")))
			var creator: int = int(d.get("_creator", 0))
			write_bytes_field(out, 1, encode_bigdb_object(key, d, ver, creator))
	return out


static func decode_load_objects_output(payload: PackedByteArray) -> Array[Dictionary]:
	return decode_bigdb_objects_output(payload)
