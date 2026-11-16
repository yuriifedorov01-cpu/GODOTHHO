class_name PlayerIOConnection
extends Node
## PlayerIOConnection — Мультиплеерное TCP-соединение с сервером комнаты PlayerIO
## (порт playerio/Connection.as + диспетчер всех 101 входящих и 110 исходящих сообщений из NetworkController.as).
##
## Протокол подключения (Connection.as):
## 1. Устанавливается TCP-соединение с ServerEndpoint (address:port, обычно 8184 или 80).
## 2. Как только сокет переходит в STATUS_CONNECTED:
##    - Отправляется 1 нулевой байт `[0x00]`.
##    - Сразу же сериализуется и отправляется сообщение `"join"` с аргументами:
##      `joinKey`, затем пары `(key, value)` из `joinData`.
## 3. Первый ответ от сервера — сообщение `"playerio.joinresult"`:
##    - `msg.get_bool(0)` == true -> успешный вход в комнату!
##    - `msg.get_bool(0)` == false -> ошибка `msg.get_int(1)`, `msg.get_string(2)`.

signal join_succeeded(connection: PlayerIOConnection)
signal join_failed(error_code: int, error_message: String)
signal message_received(message: BinarySerializer.PlayerIOMessage)
signal disconnected()

## Все 101 входящих типов сообщений (S2C) из NetworkController.as
const INCOMING_MESSAGE_TYPES: PackedStringArray = [
	"init", "init2", "update", "left", "NewMap", "respawn", "Jump", "Attack", "Block",
	"MapObject", "MapObjectUpdate", "ChangeHelm", "ChangeShirt", "ChangeLegs", "ChangeShoes",
	"ChangeWeapon", "ChangeAcc", "ChangeWeaponMode", "Hit", "EnemyMove", "EnemyHit", "EnemyDie",
	"EnemyJump", "EnemyProjectile", "NewEnemy", "EnemyTarget", "LootBag", "LootItem", "RemoveBag",
	"GetBag", "Equip", "Unequip", "DropItem", "UseItem", "UseQuickItem", "DeleteItem", "SwapItem",
	"CraftItem", "UpgradeItem", "BuyItem", "SellItem", "BankAction", "StatUp", "ExpUp", "LevelUp",
	"SkillExp", "Chat", "PM", "GlobalMsg", "ServerMsg", "TradeRequest", "TradeStart", "TradeUpdate",
	"TradeAccept", "TradeCancel", "TradeComplete", "GuildInvite", "GuildJoin", "GuildLeave",
	"GuildKick", "GuildRank", "GuildChat", "GuildInfo", "GuildList", "GuildBuff", "PartyInvite",
	"PartyJoin", "PartyLeave", "PartyUpdate", "FriendUpdate", "QuestUpdate", "QuestComplete",
	"PetEquip", "PetUnequip", "PetMove", "PetAttack", "PetHit", "PetHeal", "PetBuff", "PetBubble",
	"PetMode", "PetLevel", "PetControl", "Mount", "FishStart", "FishBite", "FishCatch", "ChopTree",
	"TreeFall", "PlantSeed", "WaterPlant", "HarvestPlant", "PlantUpdate", "PvPState", "DuelRequest",
	"DuelStart", "DuelEnd", "BossEvent", "Weather", "TimeSync", "Teleport", "Cowduct", "MysteryBox",
	"MarketList", "MarketBuy", "LotteryInfo", "CasinoSpin", "AdminCmd", "Ping", "Kick"
]

## Все 110 исходящих типов сообщений (C2S) из NetworkController.as
const OUTGOING_MESSAGE_TYPES: PackedStringArray = [
	"init", "init2", "u", "NewMap", "respawn", "Jump", "Attack", "Block", "ChangeWeaponMode",
	"HitEnemy", "HitPlayer", "ShootProj", "GetBag", "PickupLoot", "Equip", "Unequip", "Drop",
	"UseItem", "QuickItem", "DeleteItem", "SwapInv", "Craft", "Upgrade", "Repair", "BuyShop",
	"SellShop", "BuyVault", "BankDeposit", "BankWithdraw", "BankSwap", "BankExpand", "AddStat",
	"ResetStats", "Chat", "PM", "TradeReq", "TradeAcceptReq", "TradeAddItem", "TradeRemoveItem",
	"TradeSetCoins", "TradeLock", "TradeConfirm", "TradeCancel", "GuildCreate", "GuildInvite",
	"GuildAccept", "GuildLeave", "GuildKick", "GuildPromote", "GuildDemote", "GuildChat",
	"GuildMotd", "GuildRage", "GuildHeal", "SelfRage", "SelfHeal", "Fart", "Unleash", "PartyInvite",
	"PartyAccept", "PartyLeave", "PartyKick", "FriendAdd", "FriendRemove", "FriendList",
	"IgnoreAdd", "IgnoreRemove", "QuestAccept", "QuestAbandon", "QuestTurnIn", "DialogChoice",
	"PetEquip", "PetUnequip", "PetRename", "PetMode", "PetControl", "PetUpdate", "PetAttack",
	"PetSkill", "PetBubble", "PetFeed", "PetRelease", "MountToggle", "StartFish", "PullFish",
	"CancelFish", "Chop", "Plant", "Water", "Harvest", "RemovePlant", "DuelReq", "DuelAccept",
	"DuelDecline", "ArenaJoin", "ArenaLeave", "MarketSearch", "MarketList", "MarketBuy",
	"MarketCancel", "MarketClaim", "LotteryBuy", "SlotSpin", "ScratchCard", "MysteryOpen",
	"CodeRedeem", "ReportPlayer", "AdminAction", "Ping", "Save"
]

var room_id: String = ""
var join_key: String = ""
var join_data: Dictionary = {}
var is_connected_to_room: bool = false
var is_mock_connection: bool = false

var _tcp: StreamPeerTCP = null
var _serializer: BinarySerializer = null
var _endpoints: Array[Dictionary] = []
var _current_endpoint_idx: int = 0
var _handshake_sent: bool = false
var _connecting: bool = false

## Таблица подписок по типам сообщений: message_type ("*" для всех) -> Array[Callable]
var _handlers: Dictionary = {}


func _ready() -> void:
	_serializer = BinarySerializer.new()
	_serializer.message_deserialized.connect(_on_serializer_message)


func _process(_delta: float) -> void:
	if is_mock_connection or _tcp == null:
		return

	_tcp.poll()
	var status: StreamPeerTCP.Status = _tcp.get_status()

	if status == StreamPeerTCP.STATUS_CONNECTED:
		if not _handshake_sent:
			_send_handshake()
		var avail: int = _tcp.get_available_bytes()
		if avail > 0:
			var res: Array = _tcp.get_partial_data(avail)
			var err: int = int(res[0])
			if err == OK:
				var chunk: PackedByteArray = res[1]
				for i: int in range(chunk.size()):
					_serializer.add_byte(chunk[i])
	elif status == StreamPeerTCP.STATUS_ERROR or status == StreamPeerTCP.STATUS_NONE:
		if _connecting and not is_connected_to_room:
			# Пробуем следующий endpoint из списка
			_current_endpoint_idx += 1
			if _current_endpoint_idx < _endpoints.size():
				_connect_to_current_endpoint()
			else:
				_connecting = false
				join_failed.emit(1, "Unable to connect to any multiplayer server endpoint")
		elif is_connected_to_room:
			is_connected_to_room = false
			_connecting = false
			disconnected.emit()


## Начинает подключение к серверу комнаты по списку endpoints из CreateJoinRoomOutput.
func connect_to_endpoints(p_room_id: String, p_join_key: String, p_endpoints: Array[Dictionary], p_join_data: Dictionary = {}) -> void:
	room_id = p_room_id
	join_key = p_join_key
	join_data = p_join_data.duplicate()
	_endpoints = p_endpoints.duplicate()
	_current_endpoint_idx = 0
	is_mock_connection = false
	is_connected_to_room = false
	_handshake_sent = false

	if _endpoints.is_empty():
		join_failed.emit(1, "No server endpoints provided for room %s" % room_id)
		return

	_connect_to_current_endpoint()


## Инициализирует локальное (Offline / Sandbox) соединение без реального TCP сокета.
func connect_as_local_sandbox(p_room_id: String = "LocalSandboxRoom", p_join_data: Dictionary = {}) -> void:
	room_id = p_room_id
	join_key = "local_sandbox_key"
	join_data = p_join_data.duplicate()
	is_mock_connection = true
	is_connected_to_room = true
	_connecting = false
	join_succeeded.emit(self)



## Регистрирует обработчик входящего сообщения определенного типа (или "*" для всех сообщений).
func add_message_listener(msg_type: String, callback: Callable) -> void:
	if not _handlers.has(msg_type):
		_handlers[msg_type] = []
	var list: Array = _handlers[msg_type]
	if not list.has(callback):
		list.append(callback)


func remove_message_listener(msg_type: String, callback: Callable) -> void:
	if _handlers.has(msg_type):
		(_handlers[msg_type] as Array).erase(callback)


## Создает сообщение PlayerIOMessage (аналог connection.createMessage(type, ...args)).
func create_message(msg_type: String, args: Array = []) -> BinarySerializer.PlayerIOMessage:
	return BinarySerializer.PlayerIOMessage.new(msg_type, args)


## Отправляет сообщение на сервер комнаты (принимает либо PlayerIOMessage, либо (type, args)).
func send(type_or_msg: Variant, args: Array = []) -> void:
	var msg: BinarySerializer.PlayerIOMessage = null
	if type_or_msg is BinarySerializer.PlayerIOMessage:
		msg = type_or_msg
	else:
		msg = BinarySerializer.PlayerIOMessage.new(str(type_or_msg), args)

	if is_mock_connection:
		_handle_local_sandbox_outgoing(msg)
		return

	if _tcp == null or _tcp.get_status() != StreamPeerTCP.STATUS_CONNECTED:
		push_warning("[PlayerIOConnection] Cannot send '%s': socket not connected" % msg.type)
		return

	var packet: PackedByteArray = BinarySerializer.serialize_message(msg)
	_tcp.put_data(packet)


## Закрывает TCP-соединение с комнатой.
func disconnect_from_room() -> void:
	if _tcp != null:
		_tcp.disconnect_from_host()
		_tcp = null
	var was_connected: bool = is_connected_to_room
	is_connected_to_room = false
	_connecting = false
	_handshake_sent = false
	if was_connected:
		disconnected.emit()


func get_room_id() -> String:
	return room_id


func is_connected_room() -> bool:
	return is_connected_to_room


## Имитирует получение сообщения от сервера (используется в Offline Sandbox или для тестирования).
func simulate_incoming_message(msg_type: String, args: Array = []) -> void:
	var msg: BinarySerializer.PlayerIOMessage = BinarySerializer.PlayerIOMessage.new(msg_type, args)
	_dispatch_message(msg)


func _connect_to_current_endpoint() -> void:
	if _tcp != null:
		_tcp.disconnect_from_host()
	_tcp = StreamPeerTCP.new()
	_serializer.reset()
	_handshake_sent = false
	_connecting = true

	var ep: Dictionary = _endpoints[_current_endpoint_idx]
	var host: String = str(ep.get("address", "127.0.0.1"))
	var port: int = int(ep.get("port", 8184))
	var err: Error = _tcp.connect_to_host(host, port)
	if err != OK:
		_current_endpoint_idx += 1
		if _current_endpoint_idx < _endpoints.size():
			_connect_to_current_endpoint()
		else:
			_connecting = false
			join_failed.emit(int(err), "Failed to initiate TCP connection to %s:%d" % [host, port])


func _send_handshake() -> void:
	_handshake_sent = true
	_tcp.set_no_delay(true)
	# 1. В соответствии с Connection.as отправляем стартовый нулевой байт
	var zero_byte: PackedByteArray = PackedByteArray([0x00])
	_tcp.put_data(zero_byte)

	# 2. Сразу же отправляем сообщение "join" с joinKey и парами ключ/значение из joinData
	var join_msg: BinarySerializer.PlayerIOMessage = BinarySerializer.PlayerIOMessage.new("join", [join_key])
	for k: Variant in join_data.keys():
		join_msg.add(str(k))
		join_msg.add(str(join_data[k]))
	var packet: PackedByteArray = BinarySerializer.serialize_message(join_msg)
	_tcp.put_data(packet)


func _on_serializer_message(msg: BinarySerializer.PlayerIOMessage) -> void:
	if not is_connected_to_room and msg.type == "playerio.joinresult":
		var ok: bool = msg.get_bool(0, false)
		if not ok:
			_connecting = false
			var err_code: int = msg.get_int(1, 0)
			var err_text: String = msg.get_string(2, "Room join rejected by server")
			join_failed.emit(err_code, err_text)
		else:
			_connecting = false
			is_connected_to_room = true
			join_succeeded.emit(self)
		return

	_dispatch_message(msg)


func _dispatch_message(msg: BinarySerializer.PlayerIOMessage) -> void:
	message_received.emit(msg)
	if _handlers.has(msg.type):
		var callbacks: Array = (_handlers[msg.type] as Array).duplicate()
		for cb: Callable in callbacks:
			if cb.is_valid():
				cb.call(msg)
	if _handlers.has("*"):
		var wildcard_callbacks: Array = (_handlers["*"] as Array).duplicate()
		for wcb: Callable in wildcard_callbacks:
			if wcb.is_valid():
				wcb.call(msg)


## Обработка базовых пакетов в режиме Offline / Local Sandbox, чтобы мир и переходы по картам работали автономно.
func _handle_local_sandbox_outgoing(msg: BinarySerializer.PlayerIOMessage) -> void:
	match msg.type:
		"init":
			# Отвечаем пакетом init подтверждения входа в мир
			call_deferred("simulate_incoming_message", "init", ["local_player", 1, 800, 500])
		"NewMap":
			var target_map: int = msg.get_int(0, 1)
			var spawn_x: int = msg.get_int(1, 800)
			var spawn_y: int = msg.get_int(2, 500)
			call_deferred("simulate_incoming_message", "NewMap", [target_map, spawn_x, spawn_y])
		"Chat":
			var text: String = msg.get_string(0, "")
			call_deferred("simulate_incoming_message", "Chat", ["local_player", text])
		"Ping":
			call_deferred("simulate_incoming_message", "Ping", [])
