extends "res://scripts/ui/menus/ItemMenu.gd"
class_name ShopMenu
## ShopMenu — Окно покупки и продажи предметов у NPC (порт ItemMenu("buy"/"sale") из ItemMenu.as / ItemGameMenu.as).
## Наследует оригинальный UI ItemMenu (атлас "item menu", stats_font.fnt, 40 слотов, карточки сравнения).

var player: PersonEntity = null
var npc_data: Dictionary = {}
var mode: String = "buy" # "buy" или "sale"
var _shop_entries: Array[Dictionary] = []

var btn_buy: TextureButton = null
var btn_sell: TextureButton = null


func _ready() -> void:
	visible = false
	super._ready()
	var atlas_loader: Node = _get_atlas_loader()

	# buy_btn: ItemMenu.as:156-161 (82x39)
	btn_buy = TextureButton.new()
	btn_buy.name = "BtnBuy"
	btn_buy.texture_normal = atlas_loader.get_starling_texture("item menu", "buy_btn")
	btn_buy.position = Vector2(91.0 - 41.0, 248.0 - 19.5) + FLASH_OFFSET
	btn_buy.visible = false
	btn_buy.focus_mode = Control.FOCUS_NONE
	btn_buy.pressed.connect(_on_action_pressed)
	add_child(btn_buy)

	# sell_btn_00: ItemMenu.as:149-155 (82x39)
	btn_sell = TextureButton.new()
	btn_sell.name = "BtnSell"
	btn_sell.texture_normal = atlas_loader.get_starling_texture("item menu", "sell_btn_00")
	btn_sell.position = Vector2(91.0 - 41.0, 248.0 - 19.5) + FLASH_OFFSET
	btn_sell.visible = false
	btn_sell.focus_mode = Control.FOCUS_NONE
	btn_sell.pressed.connect(_on_action_pressed)
	add_child(btn_sell)

	if btn_equip != null:
		btn_equip.visible = false
	if btn_unequip != null:
		btn_unequip.visible = false
	if btn_use != null:
		btn_use.visible = false
	if btn_drop != null:
		btn_drop.visible = false


func open_buy(p_npc: Dictionary, p_player: PersonEntity) -> void:
	npc_data = p_npc
	player = p_player
	person = p_player
	mode = "buy"
	if title_label != null:
		title_label.text = "SHOP"
	selected_row_index = -1
	visible = true
	refresh()


func open_sell(p_npc: Dictionary, p_player: PersonEntity) -> void:
	npc_data = p_npc
	player = p_player
	person = p_player
	mode = "sale"
	if title_label != null:
		title_label.text = "SELL"
	selected_row_index = -1
	visible = true
	refresh()


func close_menu() -> void:
	visible = false
	closed.emit()


func refresh() -> void:
	if row_name_labels.is_empty():
		return
	_display_entries.clear()
	_shop_entries.clear()

	var atlas_loader: Node = _get_atlas_loader()
	var sdb: Node = _get_stats_db()

	if mode == "buy":
		var raw_items: Array = []
		var shop_dict: Variant = npc_data.get("shop", null)
		if shop_dict is Dictionary and (shop_dict as Dictionary).get("items") is Array:
			raw_items = (shop_dict as Dictionary)["items"]
		elif npc_data.get("items") is Array:
			raw_items = npc_data["items"]

		for it_v: Variant in raw_items:
			if _display_entries.size() >= INVENTORY_CAPACITY:
				break
			var item_name: String = ""
			var override_price: int = 0
			if it_v is Dictionary:
				var it_d: Dictionary = it_v
				item_name = str(it_d.get("item", it_d.get("name", ""))).strip_edges()
				override_price = int(it_d.get("price", 0))
			else:
				item_name = str(it_v).strip_edges()
			if item_name.is_empty():
				continue
			var itm_data: Dictionary = _lookup_item_stats(sdb, item_name)
			var price: int = override_price if override_price > 0 else _safe_int(itm_data.get("c", 0))
			var entry: Dictionary = {
				"name": item_name,
				"equipped": false,
				"slot": "",
				"inv_index": -1,
				"price": price,
			}
			_display_entries.append(entry)
			_shop_entries.append(entry)
	else:
		if player != null:
			var inv: Array = player.inventory if player.inventory is Array else []
			for inv_idx: int in range(inv.size()):
				if _display_entries.size() >= INVENTORY_CAPACITY:
					break
				var item_name: String = str(inv[inv_idx]).strip_edges()
				if item_name.is_empty():
					continue
				var itm_data: Dictionary = _lookup_item_stats(sdb, item_name)
				var base_cost: int = _safe_int(itm_data.get("c", 0))
				var sell_price: int = int(floor(float(base_cost) * 0.35)) if base_cost > 0 else 0
				var entry: Dictionary = {
					"name": item_name,
					"equipped": false,
					"slot": "",
					"inv_index": inv_idx,
					"price": sell_price,
					"base_cost": base_cost,
				}
				_display_entries.append(entry)
				_shop_entries.append(entry)

			var eq_dict: Dictionary = player.equipment if player.equipment is Dictionary else {}
			for slot_id: String in ["weapon", "weapon2", "helmet", "shirt", "legs", "shoes", "accessory"]:
				if _display_entries.size() >= INVENTORY_CAPACITY:
					break
				var eq_name: String = str(eq_dict.get(slot_id, "")).strip_edges()
				if eq_name.is_empty() or eq_name == "none" or eq_name == "nothing":
					continue
				var itm_data: Dictionary = _lookup_item_stats(sdb, eq_name, slot_id)
				var base_cost: int = _safe_int(itm_data.get("c", 0))
				var sell_price: int = int(floor(float(base_cost) * 0.35)) if base_cost > 0 else 0
				var entry: Dictionary = {
					"name": eq_name,
					"equipped": true,
					"slot": slot_id,
					"inv_index": -1,
					"price": sell_price,
					"base_cost": base_cost,
				}
				_display_entries.append(entry)
				_shop_entries.append(entry)

	if selected_row_index >= _display_entries.size():
		selected_row_index = -1

	for i: int in range(INVENTORY_CAPACITY):
		var lbl: Label = row_name_labels[i]
		var icon: Sprite2D = row_icon_sprites[i]
		var eq_badge: TextureRect = row_equip_icons[i]

		if i < _display_entries.size():
			var entry: Dictionary = _display_entries[i]
			var item_name: String = str(entry["name"])
			lbl.text = item_name
			eq_badge.visible = (mode == "sale" and bool(entry.get("equipped", false)))
			_apply_item_sprite(icon, item_name, atlas_loader, sdb)
			icon.visible = (icon.texture != null)
		else:
			lbl.text = "(empty)"
			eq_badge.visible = false
			icon.texture = null
			icon.visible = false

	_refresh_row_highlights()
	_update_selection_details()


func _update_selection_details() -> void:
	super._update_selection_details()
	if btn_equip != null:
		btn_equip.visible = false
	if btn_unequip != null:
		btn_unequip.visible = false
	if btn_use != null:
		btn_use.visible = false
	if btn_drop != null:
		btn_drop.visible = false

	if selected_row_index < 0 or selected_row_index >= _display_entries.size():
		if btn_buy != null:
			btn_buy.visible = false
		if btn_sell != null:
			btn_sell.visible = false
		return

	var entry: Dictionary = _display_entries[selected_row_index]
	var price: int = int(entry.get("price", 0))
	if item_stats_label != null:
		var price_line: String = ("Cost: $%s" % _format_comma(price)) if mode == "buy" else ("Sell for $%s" % _format_comma(price))
		if item_stats_label.text.is_empty():
			item_stats_label.text = price_line
		else:
			item_stats_label.text += "\n" + price_line

	if btn_buy != null:
		btn_buy.visible = (mode == "buy")
	if btn_sell != null:
		btn_sell.visible = (mode == "sale")


func _on_row_gui_input(event: InputEvent, index: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if index < _display_entries.size():
			select_item(index)


func _on_action_pressed() -> void:
	if player == null or selected_row_index < 0 or selected_row_index >= _display_entries.size():
		return
	var entry: Dictionary = _display_entries[selected_row_index]
	var item_name: String = str(entry.get("name", ""))
	var price: int = int(entry.get("price", 0))
	if item_name.is_empty():
		return

	if mode == "buy":
		if player.coins < price:
			_show_alert("Not enough money!")
			return
		var max_inv: int = int(player.get("max_inventory_size")) if "max_inventory_size" in player else 40
		if player.inventory.size() >= max_inv:
			_show_alert("Max amount of items!")
			return
		player.coins -= price
		if player.has_method("add_item_to_bag"):
			player.add_item_to_bag(item_name, 1)
		else:
			player.inventory.append(item_name)
			player.inventory_updated.emit()
		player.coins_changed.emit(player.coins)
		var amgr: Node = get_node_or_null("/root/AudioManager")
		if amgr != null and amgr.has_method("play_sfx"):
			amgr.call("play_sfx", "item bought")
	else:
		if bool(entry.get("equipped", false)):
			_show_alert("Cannot sell equipped items!")
			return
		var base_cost: int = int(entry.get("base_cost", 0))
		if base_cost <= 0 or price <= 0:
			_show_alert("Cannot sell this item!")
			return
		var inv_idx: int = int(entry.get("inv_index", -1))
		if inv_idx >= 0 and inv_idx < player.inventory.size():
			player.inventory.remove_at(inv_idx)
		else:
			var found_idx: int = player.inventory.find(item_name)
			if found_idx < 0:
				return
			player.inventory.remove_at(found_idx)
		player.coins += price
		player.coins_changed.emit(player.coins)
		player.inventory_updated.emit()
		var amgr: Node = get_node_or_null("/root/AudioManager")
		if amgr != null and amgr.has_method("play_sfx"):
			amgr.call("play_sfx", "cash register")
		refresh()


static func _format_comma(val: int) -> String:
	var s: String = str(val)
	var out: String = ""
	var cnt: int = 0
	for i: int in range(s.length() - 1, -1, -1):
		if cnt > 0 and cnt % 3 == 0:
			out = "," + out
		out = s[i] + out
		cnt += 1
	return out
