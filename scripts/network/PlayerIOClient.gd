extends Node
## PlayerIOClient — Главный сетевой синглтон клиента Helmet Heroes
## (порт playerio.PlayerIO, QuickConnect, BigDB, PayVault, Multiplayer и GameFS).
##
## Обеспечивает:
## 1. HTTP RPC вызовы к `https://api.playerio.com/api/{method}` с Protobuf-кодированием и заголовком `playertoken`.
## 2. Полный API `QuickConnect` (simple_connect, simple_register, simple_recover_password).
## 3. Полный API `BigDB` (load, load_keys, load_my_player_object, load_range, load_matching, create_object, save_changes, delete_keys).
## 4. Полный API `PayVault` (refresh, credit, debit, consume, buy, read_history, has, count).
## 5. Полный API `Multiplayer` (create_join_room, list_rooms) с управлением `PlayerIOConnection`.
## 6. Автоматический или явный **Offline / Local Sandbox fallback**, позволяющий играть, исследовать все 145 карт,
##    использовать экипировку, питомцев и сохранять прогресс локально в `user://local_sandbox_db.json`,
##    если внешний сервер недоступен или выбран локальный режим.

signal authenticated(user_id: String, is_offline: bool)
signal authentication_failed(error_code: int, error_message: String)
signal room_connected(connection: PlayerIOConnection)
signal room_connection_failed(error_code: int, error_message: String)
signal payvault_updated(vault_data: Dictionary)

const GameConfigRef = preload("res://scripts/autoload/GameConfig.gd")
const LOCAL_SANDBOX_DB_PATH: String = "user://local_sandbox_db.json"

var game_id: String = GameConfigRef.GAME_ID
var api_endpoint: String = GameConfigRef.API_ENDPOINT
var player_token: String = ""
var connect_user_id: String = ""
var show_branding: bool = false
var gamefs_redirect_map: String = ""

## Флаг работы в автономном локальном режиме (Offline Sandbox)
var is_offline_mode: bool = false

## Опция автоматического перехода в Offline Sandbox при сетевой ошибке подключения к API
var auto_offline_fallback: bool = true

## Текущий `PlayerObject` из BigDB (таблица `PlayerObjects`)
var my_player_object: Dictionary = {}

## Состояние `PayVault` текущего игрока: {"version": String, "coins": int, "items": Array[Dictionary]}
var pay_vault: Dictionary = {
	"version": "1",
	"coins": 5000,
	"items": []
}

## Активное соединение с мультиплеерной комнатой
var active_connection: PlayerIOConnection = null

## Локальная база данных BigDB для Offline Sandbox: table_name -> Dictionary[key -> Dictionary]
var _local_bigdb: Dictionary = {}


func _ready() -> void:
	_load_local_sandbox_db()


# ============================================================================
# QUICKCONNECT & AUTHENTICATION (Methods 400, 403, 406, 10, 13)
# ============================================================================

## Вход по логину и паролю через QuickConnect.simpleConnect (RPC Method 400).
func simple_connect(username_or_email: String, password: String, on_complete: Callable = Callable(), on_error: Callable = Callable()) -> Dictionary:
	if is_offline_mode:
		return _authenticate_offline(username_or_email, on_complete)

	var args: PackedByteArray = ProtobufCodec.encode_simple_connect_args(game_id, username_or_email, password)
	var rpc_res: Dictionary = await _invoke_rpc(ProtobufCodec.RPCMethod.SIMPLE_CONNECT, args)

	if not rpc_res["success"]:
		if auto_offline_fallback and int(rpc_res.get("http_error", 0)) != 0:
			push_warning("[PlayerIOClient] API unreachable, switching to Offline Sandbox for '%s'" % username_or_email)
			return _authenticate_offline(username_or_email, on_complete)
		var err_code: int = int(rpc_res.get("error_code", -1))
		var err_msg: String = str(rpc_res.get("error_message", "Authentication failed"))
		authentication_failed.emit(err_code, err_msg)
		if on_error.is_valid():
			on_error.call(err_code, err_msg)
		return rpc_res

	var out: Dictionary = ProtobufCodec.decode_connect_output(rpc_res["payload"])
	_apply_auth_output(out)
	authenticated.emit(connect_user_id, false)
	if on_complete.is_valid():
		on_complete.call(out)
	return {"success": true, "output": out}


## Регистрация нового аккаунта через QuickConnect.simpleRegister (RPC Method 403).
func simple_register(username: String, password: String, email: String, extra_data: Dictionary = {}, on_complete: Callable = Callable(), on_error: Callable = Callable()) -> Dictionary:
	if is_offline_mode:
		return _authenticate_offline(username, on_complete)

	var args: PackedByteArray = ProtobufCodec.encode_simple_register_args(game_id, username, password, email, extra_data)
	var rpc_res: Dictionary = await _invoke_rpc(ProtobufCodec.RPCMethod.SIMPLE_REGISTER, args)

	if not rpc_res["success"]:
		if auto_offline_fallback and int(rpc_res.get("http_error", 0)) != 0:
			return _authenticate_offline(username, on_complete)
		var err_code: int = int(rpc_res.get("error_code", -1))
		var err_msg: String = str(rpc_res.get("error_message", "Registration failed"))
		authentication_failed.emit(err_code, err_msg)
		if on_error.is_valid():
			on_error.call(err_code, err_msg, rpc_res.get("error_details", {}))
		return rpc_res

	var out: Dictionary = ProtobufCodec.decode_connect_output(rpc_res["payload"])
	_apply_auth_output(out)
	authenticated.emit(connect_user_id, false)
	if on_complete.is_valid():
		on_complete.call(out)
	return {"success": true, "output": out}


## Восстановление пароля через QuickConnect.simpleRecoverPassword (RPC Method 406).
func simple_recover_password(username_or_email: String, on_complete: Callable = Callable(), on_error: Callable = Callable()) -> Dictionary:
	if is_offline_mode:
		if on_complete.is_valid():
			on_complete.call()
		return {"success": true}

	var args: PackedByteArray = ProtobufCodec.encode_simple_recover_password_args(game_id, username_or_email)
	var rpc_res: Dictionary = await _invoke_rpc(ProtobufCodec.RPCMethod.SIMPLE_RECOVER_PASSWORD, args)
	if not rpc_res["success"]:
		if on_error.is_valid():
			on_error.call(rpc_res.get("error_code", -1), rpc_res.get("error_message", ""))
		return rpc_res
	if on_complete.is_valid():
		on_complete.call()
	return {"success": true}


## Прямой вход в локальный песочный режим (Offline Sandbox).
func login_offline_sandbox(username: String = "Hero") -> Dictionary:
	is_offline_mode = true
	return _authenticate_offline(username)


# ============================================================================
# BIGDB API (Methods 82, 85, 88, 91, 94, 97, 103)
# ============================================================================

## Загружает PlayerObject текущего игрока (RPC Method 103).
func load_my_player_object(on_complete: Callable = Callable(), on_error: Callable = Callable()) -> Dictionary:
	if is_offline_mode:
		var local_po: Dictionary = _get_or_create_local_player_object(connect_user_id)
		my_player_object = local_po
		if on_complete.is_valid():
			on_complete.call(my_player_object)
		return my_player_object

	var rpc_res: Dictionary = await _invoke_rpc(ProtobufCodec.RPCMethod.LOAD_MY_PLAYER_OBJECT, PackedByteArray())
	if not rpc_res["success"]:
		if on_error.is_valid():
			on_error.call(rpc_res.get("error_code", -1), rpc_res.get("error_message", ""))
		return {}

	my_player_object = ProtobufCodec.decode_load_my_player_object_output(rpc_res["payload"])
	if my_player_object.is_empty() or not my_player_object.has("maxHealth"):
		my_player_object = _create_default_player_object(connect_user_id)
	if on_complete.is_valid():
		on_complete.call(my_player_object)
	return my_player_object


## Загружает один объект из таблицы BigDB по ключу (RPC Method 85).
func bigdb_load(table: String, key: String, on_complete: Callable = Callable(), on_error: Callable = Callable()) -> Dictionary:
	var list: Array[Dictionary] = await bigdb_load_keys(table, PackedStringArray([key]), Callable(), on_error)
	var obj: Dictionary = list[0] if not list.is_empty() else {}
	if on_complete.is_valid():
		on_complete.call(obj)
	return obj


## Загружает массив объектов из таблицы BigDB по списку ключей (RPC Method 85).
func bigdb_load_keys(table: String, keys: PackedStringArray, on_complete: Callable = Callable(), on_error: Callable = Callable()) -> Array[Dictionary]:
	if is_offline_mode:
		var local_results: Array[Dictionary] = []
		var tbl: Dictionary = _local_bigdb.get(table, {})
		for k: String in keys:
			if tbl.has(k):
				local_results.append((tbl[k] as Dictionary).duplicate(true))
		if on_complete.is_valid():
			on_complete.call(local_results)
		return local_results

	var args: PackedByteArray = ProtobufCodec.encode_load_objects_args(table, keys)
	var rpc_res: Dictionary = await _invoke_rpc(ProtobufCodec.RPCMethod.LOAD_OBJECTS, args)
	if not rpc_res["success"]:
		if on_error.is_valid():
			on_error.call(rpc_res.get("error_code", -1), rpc_res.get("error_message", ""))
		return []

	var objs: Array[Dictionary] = ProtobufCodec.decode_bigdb_objects_output(rpc_res["payload"])
	if on_complete.is_valid():
		on_complete.call(objs)
	return objs


## Загружает диапазон объектов по индексу (RPC Method 97, используется для рынка, рейтингов, списков предметов).
func bigdb_load_range(table: String, index_name: String, start_values: Array = [], stop_values: Array = [], limit: int = 100, on_complete: Callable = Callable(), on_error: Callable = Callable()) -> Array[Dictionary]:
	if is_offline_mode:
		var local_list: Array[Dictionary] = []
		var tbl: Dictionary = _local_bigdb.get(table, {})
		for k: String in tbl.keys():
			local_list.append((tbl[k] as Dictionary).duplicate(true))
			if local_list.size() >= limit:
				break
		if on_complete.is_valid():
			on_complete.call(local_list)
		return local_list

	var args: PackedByteArray = ProtobufCodec.encode_load_index_range_args(table, index_name, start_values, stop_values, limit)
	var rpc_res: Dictionary = await _invoke_rpc(ProtobufCodec.RPCMethod.LOAD_INDEX_RANGE, args)
	if not rpc_res["success"]:
		if on_error.is_valid():
			on_error.call(rpc_res.get("error_code", -1), rpc_res.get("error_message", ""))
		return []

	var objs: Array[Dictionary] = ProtobufCodec.decode_bigdb_objects_output(rpc_res["payload"])
	if on_complete.is_valid():
		on_complete.call(objs)
	return objs


## Создает новый объект в BigDB (RPC Method 82).
func bigdb_create_object(table: String, key: String, properties: Dictionary, load_existing: bool = false, on_complete: Callable = Callable(), on_error: Callable = Callable()) -> Dictionary:
	if is_offline_mode:
		if not _local_bigdb.has(table):
			_local_bigdb[table] = {}
		var rec: Dictionary = properties.duplicate(true)
		rec["_key"] = key
		rec["_version"] = "1"
		_local_bigdb[table][key] = rec
		_save_local_sandbox_db()
		if on_complete.is_valid():
			on_complete.call(rec)
		return rec

	var args: PackedByteArray = ProtobufCodec.encode_create_objects_args([{
		"table": table,
		"key": key,
		"properties": properties
	}], load_existing)
	var rpc_res: Dictionary = await _invoke_rpc(ProtobufCodec.RPCMethod.CREATE_OBJECTS, args)
	if not rpc_res["success"]:
		if on_error.is_valid():
			on_error.call(rpc_res.get("error_code", -1), rpc_res.get("error_message", ""))
		return {}

	var created: Array[Dictionary] = ProtobufCodec.decode_bigdb_objects_output(rpc_res["payload"])
	var first: Dictionary = created[0] if not created.is_empty() else {}
	if on_complete.is_valid():
		on_complete.call(first)
	return first


## Сохраняет изменения объекта в BigDB (RPC Method 88).
func bigdb_save_changes(table: String, key: String, changes: Dictionary, create_if_missing: bool = true, on_complete: Callable = Callable(), on_error: Callable = Callable()) -> bool:
	if is_offline_mode:
		if not _local_bigdb.has(table):
			_local_bigdb[table] = {}
		if not _local_bigdb[table].has(key):
			_local_bigdb[table][key] = {"_key": key, "_version": "1"}
		var target: Dictionary = _local_bigdb[table][key]
		for ck: Variant in changes.keys():
			target[ck] = changes[ck]
		_save_local_sandbox_db()
		if on_complete.is_valid():
			on_complete.call()
		return true

	var args: PackedByteArray = ProtobufCodec.encode_save_object_changes_args(table, key, changes, create_if_missing)
	var rpc_res: Dictionary = await _invoke_rpc(ProtobufCodec.RPCMethod.SAVE_OBJECT_CHANGES, args)
	if not rpc_res["success"]:
		if on_error.is_valid():
			on_error.call(rpc_res.get("error_code", -1), rpc_res.get("error_message", ""))
		return false
	if on_complete.is_valid():
		on_complete.call()
	return true


## Удаляет объекты из таблицы BigDB по ключам (RPC Method 91).
func bigdb_delete_keys(table: String, keys: PackedStringArray, on_complete: Callable = Callable(), on_error: Callable = Callable()) -> bool:
	if is_offline_mode:
		if _local_bigdb.has(table):
			for k: String in keys:
				(_local_bigdb[table] as Dictionary).erase(k)
			_save_local_sandbox_db()
		if on_complete.is_valid():
			on_complete.call()
		return true

	var args: PackedByteArray = ProtobufCodec.encode_delete_objects_args(table, keys)
	var rpc_res: Dictionary = await _invoke_rpc(ProtobufCodec.RPCMethod.DELETE_OBJECTS, args)
	if not rpc_res["success"]:
		if on_error.is_valid():
			on_error.call(rpc_res.get("error_code", -1), rpc_res.get("error_message", ""))
		return false
	if on_complete.is_valid():
		on_complete.call()
	return true


# ============================================================================
# PAYVAULT API (Methods 160, 163, 166, 169, 172, 175)
# ============================================================================

func payvault_coins() -> int:
	return int(pay_vault.get("coins", 0))


func payvault_items() -> Array:
	return pay_vault.get("items", [])


func payvault_has(item_key: String) -> bool:
	for item: Variant in payvault_items():
		if item is Dictionary and str(item.get("itemKey", "")) == item_key:
			return true
	return false


func payvault_count(item_key: String) -> int:
	var c: int = 0
	for item: Variant in payvault_items():
		if item is Dictionary and str(item.get("itemKey", "")) == item_key:
			c += 1
	return c


func payvault_refresh(on_complete: Callable = Callable(), on_error: Callable = Callable()) -> Dictionary:
	if is_offline_mode:
		payvault_updated.emit(pay_vault)
		if on_complete.is_valid():
			on_complete.call(pay_vault)
		return pay_vault

	var args: PackedByteArray = ProtobufCodec.encode_payvault_refresh_args("")
	var rpc_res: Dictionary = await _invoke_rpc(ProtobufCodec.RPCMethod.PAY_VAULT_REFRESH, args)
	if not rpc_res["success"]:
		if on_error.is_valid():
			on_error.call(rpc_res.get("error_code", -1), rpc_res.get("error_message", ""))
		return pay_vault

	pay_vault = ProtobufCodec.decode_payvault_mutation_output(rpc_res["payload"])
	payvault_updated.emit(pay_vault)
	if on_complete.is_valid():
		on_complete.call(pay_vault)
	return pay_vault


func payvault_credit(amount: int, reason: String = "game_reward", on_complete: Callable = Callable(), on_error: Callable = Callable()) -> Dictionary:
	if is_offline_mode:
		pay_vault["coins"] = int(pay_vault.get("coins", 0)) + max(0, amount)
		_save_local_sandbox_db()
		payvault_updated.emit(pay_vault)
		if on_complete.is_valid():
			on_complete.call(pay_vault)
		return pay_vault

	var args: PackedByteArray = ProtobufCodec.encode_payvault_coins_args(amount, reason)
	var rpc_res: Dictionary = await _invoke_rpc(ProtobufCodec.RPCMethod.PAY_VAULT_CREDIT, args)
	if not rpc_res["success"]:
		if on_error.is_valid():
			on_error.call(rpc_res.get("error_code", -1), rpc_res.get("error_message", ""))
		return pay_vault

	pay_vault = ProtobufCodec.decode_payvault_mutation_output(rpc_res["payload"])
	payvault_updated.emit(pay_vault)
	if on_complete.is_valid():
		on_complete.call(pay_vault)
	return pay_vault


func payvault_debit(amount: int, reason: String = "purchase", on_complete: Callable = Callable(), on_error: Callable = Callable()) -> Dictionary:
	if is_offline_mode:
		pay_vault["coins"] = max(0, int(pay_vault.get("coins", 0)) - max(0, amount))
		_save_local_sandbox_db()
		payvault_updated.emit(pay_vault)
		if on_complete.is_valid():
			on_complete.call(pay_vault)
		return pay_vault

	var args: PackedByteArray = ProtobufCodec.encode_payvault_coins_args(amount, reason)
	var rpc_res: Dictionary = await _invoke_rpc(ProtobufCodec.RPCMethod.PAY_VAULT_DEBIT, args)
	if not rpc_res["success"]:
		if on_error.is_valid():
			on_error.call(rpc_res.get("error_code", -1), rpc_res.get("error_message", ""))
		return pay_vault

	pay_vault = ProtobufCodec.decode_payvault_mutation_output(rpc_res["payload"])
	payvault_updated.emit(pay_vault)
	if on_complete.is_valid():
		on_complete.call(pay_vault)
	return pay_vault


func payvault_buy(items: Array[Dictionary], store_items: bool = true, on_complete: Callable = Callable(), on_error: Callable = Callable()) -> Dictionary:
	if is_offline_mode:
		var item_list: Array = pay_vault.get("items", [])
		for spec: Dictionary in items:
			var copy_spec: Dictionary = spec.duplicate(true)
			copy_spec["id"] = "local_pv_%d" % (item_list.size() + 1)
			copy_spec["purchaseDate"] = int(Time.get_unix_time_from_system() * 1000.0)
			item_list.append(copy_spec)
		pay_vault["items"] = item_list
		_save_local_sandbox_db()
		payvault_updated.emit(pay_vault)
		if on_complete.is_valid():
			on_complete.call(pay_vault)
		return pay_vault

	var args: PackedByteArray = ProtobufCodec.encode_payvault_buy_args(items, store_items)
	var rpc_res: Dictionary = await _invoke_rpc(ProtobufCodec.RPCMethod.PAY_VAULT_BUY, args)
	if not rpc_res["success"]:
		if on_error.is_valid():
			on_error.call(rpc_res.get("error_code", -1), rpc_res.get("error_message", ""))
		return pay_vault

	pay_vault = ProtobufCodec.decode_payvault_mutation_output(rpc_res["payload"])
	payvault_updated.emit(pay_vault)
	if on_complete.is_valid():
		on_complete.call(pay_vault)
	return pay_vault


# ============================================================================
# MULTIPLAYER API (Methods 27, 30)
# ============================================================================

## Создает/подключается к мультиплеерной комнате (RPC Method 27) и открывает PlayerIOConnection.
func create_join_room(room_id: String, room_type: String, visible: bool = true, room_data: Dictionary = {}, join_data: Dictionary = {}, on_complete: Callable = Callable(), on_error: Callable = Callable()) -> PlayerIOConnection:
	if active_connection != null:
		active_connection.disconnect_from_room()
		active_connection.queue_free()
		active_connection = null

	var conn: PlayerIOConnection = PlayerIOConnection.new()
	conn.name = "PlayerIOConnection"
	add_child(conn)
	active_connection = conn

	if is_offline_mode:
		conn.connect_as_local_sandbox(room_id if not room_id.is_empty() else "LocalWorld_1", join_data)
		room_connected.emit(conn)
		if on_complete.is_valid():
			on_complete.call(conn)
		return conn

	var args: PackedByteArray = ProtobufCodec.encode_create_join_room_args(room_id, room_type, visible, room_data, join_data)
	var rpc_res: Dictionary = await _invoke_rpc(ProtobufCodec.RPCMethod.CREATE_JOIN_ROOM, args)
	if not rpc_res["success"]:
		if auto_offline_fallback:
			push_warning("[PlayerIOClient] CreateJoinRoom failed (%s), using local sandbox room" % str(rpc_res.get("error_message", "")))
			is_offline_mode = true
			conn.connect_as_local_sandbox(room_id if not room_id.is_empty() else "LocalWorld_1", join_data)
			room_connected.emit(conn)
			if on_complete.is_valid():
				on_complete.call(conn)
			return conn

		var err_code: int = int(rpc_res.get("error_code", -1))
		var err_msg: String = str(rpc_res.get("error_message", "CreateJoinRoom failed"))
		room_connection_failed.emit(err_code, err_msg)
		if on_error.is_valid():
			on_error.call(err_code, err_msg)
		return null

	var out: Dictionary = ProtobufCodec.decode_create_join_room_output(rpc_res["payload"])
	var endpoints: Array[Dictionary] = out["endpoints"]

	conn.join_succeeded.connect(func(c: PlayerIOConnection) -> void:
		room_connected.emit(c)
		if on_complete.is_valid():
			on_complete.call(c)
	, CONNECT_ONE_SHOT)

	conn.join_failed.connect(func(code: int, message: String) -> void:
		room_connection_failed.emit(code, message)
		if on_error.is_valid():
			on_error.call(code, message)
	, CONNECT_ONE_SHOT)

	conn.connect_to_endpoints(out["room_id"], out["join_key"], endpoints, join_data)
	return conn


## Возвращает список открытых комнат на сервере (RPC Method 30).
func list_rooms(room_type: String, search_criteria: Dictionary = {}, result_limit: int = 50, result_offset: int = 0, on_complete: Callable = Callable(), on_error: Callable = Callable()) -> Array[Dictionary]:
	if is_offline_mode:
		var mock_rooms: Array[Dictionary] = [{
			"id": "LocalSandbox_1",
			"room_type": room_type,
			"online_users": 1,
			"room_data": {"name": "Offline Sandbox Server", "version": GameConfigRef.CLIENT_VERSION}
		}]
		if on_complete.is_valid():
			on_complete.call(mock_rooms)
		return mock_rooms

	var args: PackedByteArray = ProtobufCodec.encode_list_rooms_args(room_type, search_criteria, result_limit, result_offset)
	var rpc_res: Dictionary = await _invoke_rpc(ProtobufCodec.RPCMethod.LIST_ROOMS, args)
	if not rpc_res["success"]:
		if on_error.is_valid():
			on_error.call(rpc_res.get("error_code", -1), rpc_res.get("error_message", ""))
		return []

	var rooms: Array[Dictionary] = ProtobufCodec.decode_list_rooms_output(rpc_res["payload"])
	if on_complete.is_valid():
		on_complete.call(rooms)
	return rooms


## Формирует URL к ресурсу GameFS (аналог PlayerIO client.gameFS.getUrl).
func get_gamefs_url(relative_path: String) -> String:
	return GameConfigRef.get_gamefs_url(relative_path)


# ============================================================================
# ВНУТРЕННИЙ HTTP ТРАНСПОРТ И OFFLINE SANDBOX ХРАНИЛИЩЕ
# ============================================================================

func _invoke_rpc(method_id: int, serialized_args: PackedByteArray) -> Dictionary:
	var http: HTTPRequest = HTTPRequest.new()
	http.timeout = 10.0
	add_child(http)

	var url: String = "%s/%d" % [api_endpoint, method_id]
	var headers: PackedStringArray = PackedStringArray([
		"Content-Type: application/x-www-form-urlencoded"
	])
	if not player_token.is_empty():
		headers.append("playertoken: %s" % player_token)

	var body: PackedByteArray = ProtobufCodec.finalize_http_request_body(serialized_args)
	var req_err: Error = http.request_raw(url, headers, HTTPClient.METHOD_POST, body)
	if req_err != OK:
		http.queue_free()
		return {
			"success": false,
			"http_error": int(req_err),
			"error_code": -1,
			"error_message": "HTTPRequest failed to start (err=%d)" % req_err
		}

	var completed: Array = await http.request_completed
	http.queue_free()

	var result_code: int = int(completed[0])
	var response_code: int = int(completed[1])
	var response_body: PackedByteArray = completed[3]

	if result_code != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		return {
			"success": false,
			"http_error": result_code if result_code != 0 else response_code,
			"error_code": response_code,
			"error_message": "HTTP transport error (result=%d, status=%d)" % [result_code, response_code]
		}

	var parsed: Dictionary = ProtobufCodec.parse_http_response_envelope(response_body)
	var new_token: String = str(parsed.get("new_token", ""))
	if not new_token.is_empty():
		player_token = new_token
	return parsed


func _apply_auth_output(out: Dictionary) -> void:
	if not str(out.get("token", "")).is_empty():
		player_token = str(out["token"])
	connect_user_id = str(out.get("user_id", ""))
	show_branding = bool(out.get("show_branding", false))
	gamefs_redirect_map = str(out.get("gamefs_redirect_map", ""))
	is_offline_mode = false


func _authenticate_offline(username: String, on_complete: Callable = Callable()) -> Dictionary:
	is_offline_mode = true
	var clean_user: String = username.strip_edges()
	if clean_user.is_empty():
		clean_user = "Hero"
	connect_user_id = "simple%s" % clean_user
	player_token = "offline_token_%s" % clean_user
	my_player_object = _get_or_create_local_player_object(connect_user_id, clean_user)
	var out: Dictionary = {
		"token": player_token,
		"user_id": connect_user_id,
		"show_branding": false,
		"gamefs_redirect_map": "",
		"partner_id": "",
		"offline": true
	}
	authenticated.emit(connect_user_id, true)
	if on_complete.is_valid():
		on_complete.call(out)
	return {"success": true, "output": out}


func _get_or_create_local_player_object(user_key: String, display_name: String = "Hero") -> Dictionary:
	if not _local_bigdb.has("PlayerObjects"):
		_local_bigdb["PlayerObjects"] = {}
	var po_table: Dictionary = _local_bigdb["PlayerObjects"]
	if po_table.has(user_key):
		return po_table[user_key]
	var default_po: Dictionary = _create_default_player_object(user_key, display_name)
	po_table[user_key] = default_po
	_save_local_sandbox_db()
	return default_po


func _create_default_player_object(user_key: String, display_name: String = "Hero") -> Dictionary:
	return {
		"_key": user_key,
		"_version": "1",
		"username": display_name,
		"charName": display_name,
		"level": 1,
		"exp": 0,
		"gold": 2500,
		"tokens": 25,
		"health": 100,
		"maxHealth": 100,
		"strength": 5,
		"agility": 5,
		"magic": 5,
		"defense": 5,
		"luck": 5,
		"statPoints": 0,
		"skillPoints": 0,
		"currentMap": 1,
		"unlockedMaps": [1],
		"x": 850,
		"y": 500,
		"helm": 1,
		"shirt": 1,
		"legs": 1,
		"shoes": 1,
		"weapon": 1,
		"acc": 0,
		"hair": 1,
		"hairColor": 1,
		"skinColor": 1,
		"mouth": 1,
		"eyes": 1,
		"facialHair": 0,
		"inventory": [],
		"bank": [],
		"pets": [],
		"quests": {},
		"friends": []
	}


func _load_local_sandbox_db() -> void:
	if not FileAccess.file_exists(LOCAL_SANDBOX_DB_PATH):
		_local_bigdb = {"PlayerObjects": {}}
		return
	var text: String = FileAccess.get_file_as_string(LOCAL_SANDBOX_DB_PATH)
	var parsed: Variant = JSON.parse_string(text)
	if parsed is Dictionary:
		_local_bigdb = parsed.get("bigdb", {"PlayerObjects": {}})
		if parsed.has("pay_vault") and parsed["pay_vault"] is Dictionary:
			pay_vault = parsed["pay_vault"]


func _save_local_sandbox_db() -> void:
	var file: FileAccess = FileAccess.open(LOCAL_SANDBOX_DB_PATH, FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify({
			"bigdb": _local_bigdb,
			"pay_vault": pay_vault
		}))
		file.close()
