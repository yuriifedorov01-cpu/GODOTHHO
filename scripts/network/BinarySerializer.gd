class_name BinarySerializer
extends RefCounted
## BinarySerializer — 100% точный побитовый порт playerio/utils/BinarySerializer.as
## для упаковки и распаковки PlayerIOMessage по TCP-сокету (StreamPeerTCP).
##
## Таблица битовых заголовков (в порядке проверки в оригинальном switch):
## - ShortStringPattern      = 0xC0 (11000000): младшие 6 бит = длина UTF-8 строки (0..63)
## - ShortUnsignedIntPattern = 0x80 (10000000): младшие 6 бит = число (0..63), без доп. байт
## - ShortByteArrayPattern   = 0x40 (01000000): младшие 6 бит = длина массива байт (0..63)
## - UnsignedLongPattern     = 0x38 (00111000): младшие 3 бита + 1 = длина (8 байт big-endian uint64)
## - LongPattern             = 0x30 (00110000): младшие 3 бита + 1 = длина (8 байт big-endian int64)
## - ByteArrayPattern        = 0x10 (00010000): младшие 2 бита + 1 = длина счетчика байт (1..4), затем байты
## - StringPattern           = 0x0C (00001100): младшие 2 бита + 1 = длина счетчика байт (1..4), затем UTF-8
## - UnsignedIntPattern      = 0x08 (00001000): младшие 2 бита + 1 = число байт (1..4 big-endian uint32)
## - IntPattern              = 0x04 (00000100): младшие 2 бита + 1 = число байт (1..4 big-endian int32)
## - DoublePattern           = 0x03 (00000011): 8 байт IEEE 754 double (big-endian)
## - FloatPattern            = 0x02 (00000010): 4 байта IEEE 754 float (big-endian)
## - BooleanTruePattern      = 0x01 (00000001): 0 доп. байт -> true
## - BooleanFalsePattern     = 0x00 (00000000): 0 доп. байт -> false

const SHORT_STRING_PATTERN: int = 0xC0
const SHORT_UNSIGNED_INT_PATTERN: int = 0x80
const SHORT_BYTE_ARRAY_PATTERN: int = 0x40
const UNSIGNED_LONG_PATTERN: int = 0x38
const LONG_PATTERN: int = 0x30
const BYTE_ARRAY_PATTERN: int = 0x10
const STRING_PATTERN: int = 0x0C
const UNSIGNED_INT_PATTERN: int = 0x08
const INT_PATTERN: int = 0x04
const DOUBLE_PATTERN: int = 0x03
const FLOAT_PATTERN: int = 0x02
const BOOLEAN_TRUE_PATTERN: int = 0x01
const BOOLEAN_FALSE_PATTERN: int = 0x00

enum State {
	INIT = 0,
	HEADER = 1,
	DATA = 2
}


## Класс-контейнер одного мультиплеерного сообщения PlayerIO (аналог playerio.Message / MessageImpl)
class PlayerIOMessage extends RefCounted:
	var type: String = ""
	var items: Array = []

	func _init(msg_type: String = "", initial_items: Array = []) -> void:
		type = msg_type
		items = initial_items.duplicate()

	func add(val: Variant) -> PlayerIOMessage:
		items.append(val)
		return self

	func size() -> int:
		return items.size()

	func get_arg(index: int, default_val: Variant = null) -> Variant:
		if index >= 0 and index < items.size():
			return items[index]
		return default_val

	func get_string(index: int, default_val: String = "") -> String:
		if index >= 0 and index < items.size():
			return str(items[index])
		return default_val

	func get_int(index: int, default_val: int = 0) -> int:
		if index >= 0 and index < items.size():
			var v: Variant = items[index]
			if v is int or v is float or v is bool:
				return int(v)
			if v is String and (v as String).is_valid_int():
				return (v as String).to_int()
		return default_val

	func get_uint(index: int, default_val: int = 0) -> int:
		return get_int(index, default_val) & 0xFFFFFFFF

	func get_long(index: int, default_val: int = 0) -> int:
		return get_int(index, default_val)

	func get_ulong(index: int, default_val: int = 0) -> int:
		return get_int(index, default_val)

	func get_number(index: int, default_val: Variant = 0) -> Variant:
		if index >= 0 and index < items.size():
			var v: Variant = items[index]
			if v is int or v is float:
				return v
		return default_val

	func get_boolean(index: int, default_val: bool = false) -> bool:
		return get_bool(index, default_val)

	func get_double(index: int, default_val: float = 0.0) -> float:
		return get_float(index, default_val)

	func get_byte_array(index: int) -> PackedByteArray:
		return get_bytes(index)

	func get_float(index: int, default_val: float = 0.0) -> float:
		if index >= 0 and index < items.size():
			var v: Variant = items[index]
			if v is float or v is int:
				return float(v)
			if v is String and (v as String).is_valid_float():
				return (v as String).to_float()
		return default_val

	func get_bool(index: int, default_val: bool = false) -> bool:
		if index >= 0 and index < items.size():
			var v: Variant = items[index]
			if v is bool:
				return v
			if v is int:
				return v != 0
			if v is String:
				return (v as String).to_lower() == "true" or v == "1"
		return default_val

	func get_bytes(index: int) -> PackedByteArray:
		if index >= 0 and index < items.size() and items[index] is PackedByteArray:
			return items[index]
		return PackedByteArray()

	func _to_string() -> String:
		return "PlayerIOMessage(type='%s', args=%s)" % [type, str(items)]


signal message_deserialized(message: PlayerIOMessage)
signal value_deserialized(value: Variant)

var _state: int = State.INIT
var _pattern: int = 0
var _length: int = 0
var _bytes: PackedByteArray = PackedByteArray()
var _message_buffer: PlayerIOMessage = null
var _message_length: int = -1


## Потоково добавляет один байт из TCP-сокета (100% эквивалент BinarySerializer.AddByte).
func add_byte(b: int) -> void:
	var byte_val: int = b & 0xFF
	match _state:
		State.INIT:
			for mask: int in [
				SHORT_STRING_PATTERN,
				SHORT_UNSIGNED_INT_PATTERN,
				SHORT_BYTE_ARRAY_PATTERN,
				UNSIGNED_LONG_PATTERN,
				LONG_PATTERN,
				BYTE_ARRAY_PATTERN,
				STRING_PATTERN,
				UNSIGNED_INT_PATTERN,
				INT_PATTERN,
				DOUBLE_PATTERN,
				FLOAT_PATTERN,
				BOOLEAN_TRUE_PATTERN,
				BOOLEAN_FALSE_PATTERN
			]:
				if (byte_val & mask) == mask:
					_pattern = mask
					break

			match _pattern:
				SHORT_STRING_PATTERN:
					_length = byte_val & 0x3F
					if _length > 0:
						_state = State.DATA
					else:
						_on_value("")
				SHORT_UNSIGNED_INT_PATTERN:
					_on_value(byte_val & 0x3F)
				SHORT_BYTE_ARRAY_PATTERN:
					_length = byte_val & 0x3F
					if _length > 0:
						_state = State.DATA
					else:
						_on_value(PackedByteArray())
				UNSIGNED_LONG_PATTERN, LONG_PATTERN:
					_length = (byte_val & 0x07) + 1
					_state = State.DATA
				BYTE_ARRAY_PATTERN:
					_length = (byte_val & 0x03) + 1
					_state = State.HEADER
				STRING_PATTERN:
					_length = (byte_val & 0x03) + 1
					_state = State.HEADER
				UNSIGNED_INT_PATTERN, INT_PATTERN:
					_length = (byte_val & 0x03) + 1
					_state = State.DATA
				DOUBLE_PATTERN:
					_length = 8
					_state = State.DATA
				FLOAT_PATTERN:
					_length = 4
					_state = State.DATA
				BOOLEAN_TRUE_PATTERN:
					_on_value(true)
				BOOLEAN_FALSE_PATTERN:
					_on_value(false)

		State.HEADER:
			_bytes.append(byte_val)
			if _bytes.size() == _length:
				_length = _read_unsigned_int(_bytes)
				_bytes.clear()
				if _length > 0:
					_state = State.DATA
				else:
					_state = State.INIT
					if _pattern == STRING_PATTERN:
						_on_value("")
					elif _pattern == BYTE_ARRAY_PATTERN:
						_on_value(PackedByteArray())

		State.DATA:
			_bytes.append(byte_val)
			if _bytes.size() == _length:
				var payload: PackedByteArray = _bytes.duplicate()
				_bytes.clear()
				_state = State.INIT

				match _pattern:
					SHORT_STRING_PATTERN, STRING_PATTERN:
						_on_value(payload.get_string_from_utf8())
					UNSIGNED_LONG_PATTERN:
						_on_value(_read_int64_be(payload, false))
					LONG_PATTERN:
						_on_value(_read_int64_be(payload, true))
					UNSIGNED_INT_PATTERN:
						_on_value(_read_unsigned_int(payload))
					INT_PATTERN:
						_on_value(_read_signed_int(payload))
					DOUBLE_PATTERN:
						var spb_d: StreamPeerBuffer = StreamPeerBuffer.new()
						spb_d.big_endian = true
						spb_d.data_array = payload
						_on_value(spb_d.get_double())
					FLOAT_PATTERN:
						var spb_f: StreamPeerBuffer = StreamPeerBuffer.new()
						spb_f.big_endian = true
						spb_f.data_array = payload
						_on_value(spb_f.get_float())
					SHORT_BYTE_ARRAY_PATTERN, BYTE_ARRAY_PATTERN:
						_on_value(payload)


## Потоково добавляет буфер байт и возвращает массив всех полностью собранных за этот вызов сообщений.
func feed_bytes(chunk: PackedByteArray) -> Array[PlayerIOMessage]:
	var collected: Array[PlayerIOMessage] = []
	var cb: Callable = func(msg: PlayerIOMessage) -> void:
		collected.append(msg)
	message_deserialized.connect(cb)
	for i: int in range(chunk.size()):
		add_byte(chunk[i])
	message_deserialized.disconnect(cb)
	return collected


## Алиас для потоковой подачи буфера байт.
func add_bytes(chunk: PackedByteArray) -> Array[PlayerIOMessage]:
	return feed_bytes(chunk)


## Сбрасывает внутреннее состояние парсера (например, при реконнекте).
func reset() -> void:
	_state = State.INIT
	_pattern = 0
	_length = 0
	_bytes.clear()
	_message_buffer = null
	_message_length = -1


## Создает новое сообщение PlayerIOMessage.
static func create_message(msg_type: String, args: Array = []) -> PlayerIOMessage:
	return PlayerIOMessage.new(msg_type, args)


## Сериализует PlayerIOMessage в массив байт для отправки по TCP (эквивалент BinarySerializer.SerializeMessage).
static func serialize_message(m: PlayerIOMessage) -> PackedByteArray:
	var ret: PackedByteArray = PackedByteArray()
	ret.append_array(serialize_value(m.items.size()))
	ret.append_array(serialize_value(m.type))
	for i: int in range(m.items.size()):
		ret.append_array(serialize_value(m.items[i]))
	return ret


## Сериализует одиночное значение в бинарный формат PlayerIO (эквивалент BinarySerializer.Serialize).
static func serialize_value(value: Variant) -> PackedByteArray:
	var ret: PackedByteArray = PackedByteArray()
	match typeof(value):
		TYPE_STRING, TYPE_STRING_NAME:
			var utf8: PackedByteArray = str(value).to_utf8_buffer()
			if utf8.size() < 64:
				ret.append(SHORT_STRING_PATTERN | utf8.size())
			else:
				var len_bytes: PackedByteArray = _write_trimmed_int(utf8.size())
				ret.append(STRING_PATTERN | (len_bytes.size() - 1))
				ret.append_array(len_bytes)
			ret.append_array(utf8)

		TYPE_BOOL:
			ret.append(BOOLEAN_TRUE_PATTERN if bool(value) else BOOLEAN_FALSE_PATTERN)

		TYPE_INT:
			var iv: int = int(value)
			if iv >= 0 and iv < 64:
				ret.append(SHORT_UNSIGNED_INT_PATTERN | iv)
			elif iv >= -2147483648 and iv <= 2147483647:
				var int_bytes: PackedByteArray = _write_trimmed_int(iv)
				ret.append(INT_PATTERN | (int_bytes.size() - 1))
				ret.append_array(int_bytes)
			elif iv >= 0 and iv <= 4294967295:
				var uint_bytes: PackedByteArray = _write_trimmed_uint(iv)
				ret.append(UNSIGNED_INT_PATTERN | (uint_bytes.size() - 1))
				ret.append_array(uint_bytes)
			else:
				var long_bytes: PackedByteArray = _write_trimmed_long(iv)
				ret.append(LONG_PATTERN | (long_bytes.size() - 1))
				ret.append_array(long_bytes)

		TYPE_FLOAT:
			var spb: StreamPeerBuffer = StreamPeerBuffer.new()
			spb.big_endian = true
			spb.put_double(float(value))
			ret.append(DOUBLE_PATTERN)
			ret.append_array(spb.data_array)

		TYPE_PACKED_BYTE_ARRAY:
			var ba: PackedByteArray = value
			if ba.size() < 64:
				ret.append(SHORT_BYTE_ARRAY_PATTERN | ba.size())
			else:
				var len_ba: PackedByteArray = _write_trimmed_int(ba.size())
				ret.append(BYTE_ARRAY_PATTERN | (len_ba.size() - 1))
				ret.append_array(len_ba)
			ret.append_array(ba)

		TYPE_DICTIONARY:
			var d: Dictionary = value
			if d.has("__pio_type__"):
				var ptype: String = str(d["__pio_type__"])
				match ptype:
					"uint":
						var uv: int = int(d.get("value", 0)) & 0xFFFFFFFF
						if uv < 64:
							ret.append(SHORT_UNSIGNED_INT_PATTERN | uv)
						else:
							var ub: PackedByteArray = _write_trimmed_uint(uv)
							ret.append(UNSIGNED_INT_PATTERN | (ub.size() - 1))
							ret.append_array(ub)
					"long":
						var lv: int = int(d.get("value", 0))
						var lb: PackedByteArray = _write_trimmed_long(lv)
						ret.append(LONG_PATTERN | (lb.size() - 1))
						ret.append_array(lb)
					"ulong":
						var ulv: int = int(d.get("value", 0))
						var ulb: PackedByteArray = _write_trimmed_long(ulv)
						ret.append(UNSIGNED_LONG_PATTERN | (ulb.size() - 1))
						ret.append_array(ulb)
					"float":
						var spb_fl: StreamPeerBuffer = StreamPeerBuffer.new()
						spb_fl.big_endian = true
						spb_fl.put_float(float(d.get("value", 0.0)))
						ret.append(FLOAT_PATTERN)
						ret.append_array(spb_fl.data_array)
					_:
						ret.append_array(serialize_value(str(d.get("value", ""))))
			else:
				ret.append_array(serialize_value(JSON.stringify(d)))

		_:
			ret.append_array(serialize_value(str(value)))

	return ret


func _on_value(val: Variant) -> void:
	value_deserialized.emit(val)
	if _message_length == -1:
		_message_length = int(val)
		_message_buffer = PlayerIOMessage.new("")
	elif _message_buffer.type.is_empty():
		_message_buffer.type = str(val)
		if _message_length == 0:
			var finished_empty: PlayerIOMessage = _message_buffer
			_message_buffer = null
			_message_length = -1
			message_deserialized.emit(finished_empty)
	else:
		_message_buffer.add(val)
		if _message_length == _message_buffer.size():
			var finished_msg: PlayerIOMessage = _message_buffer
			_message_buffer = null
			_message_length = -1
			message_deserialized.emit(finished_msg)


static func _read_unsigned_int(data: PackedByteArray) -> int:
	var res: int = 0
	for i: int in range(data.size()):
		res = ((res << 8) | (data[i] & 0xFF)) & 0xFFFFFFFF
	return res


static func _read_signed_int(data: PackedByteArray) -> int:
	var u: int = _read_unsigned_int(data)
	# В AS3 writeInt всегда пишет 4 байта для отрицательных чисел, а положительные обрезает спереди
	if data.size() == 4 and (u & 0x80000000) != 0:
		return u - 0x100000000
	return u


static func _read_int64_be(data: PackedByteArray, _signed: bool) -> int:
	var res: int = 0
	for i: int in range(data.size()):
		res = (res << 8) | (data[i] & 0xFF)
	return res


static func _write_trimmed_int(v: int) -> PackedByteArray:
	var raw4: PackedByteArray = PackedByteArray([
		(v >> 24) & 0xFF,
		(v >> 16) & 0xFF,
		(v >> 8) & 0xFF,
		v & 0xFF
	])
	return _strip_leading_zeros(raw4)


static func _write_trimmed_uint(v: int) -> PackedByteArray:
	var u: int = v & 0xFFFFFFFF
	var raw4: PackedByteArray = PackedByteArray([
		(u >> 24) & 0xFF,
		(u >> 16) & 0xFF,
		(u >> 8) & 0xFF,
		u & 0xFF
	])
	return _strip_leading_zeros(raw4)


static func _write_trimmed_long(v: int) -> PackedByteArray:
	var raw8: PackedByteArray = PackedByteArray([
		(v >> 56) & 0xFF,
		(v >> 48) & 0xFF,
		(v >> 40) & 0xFF,
		(v >> 32) & 0xFF,
		(v >> 24) & 0xFF,
		(v >> 16) & 0xFF,
		(v >> 8) & 0xFF,
		v & 0xFF
	])
	return _strip_leading_zeros(raw8)


static func _strip_leading_zeros(bytes: PackedByteArray) -> PackedByteArray:
	var start: int = 0
	var last_idx: int = bytes.size() - 1
	while start < last_idx and bytes[start] == 0:
		start += 1
	return bytes.slice(start)
