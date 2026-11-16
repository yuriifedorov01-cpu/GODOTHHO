extends Control
class_name PayVaultMenu
## PayVaultMenu — Окно PayVault (порт com.menus.PayVaultMenu.as).
## В стиле StarlingGameMenu с честным отображением PayVaultItems и баланса тикетов
## из PlayerIOClient и StatsDB.
## Примечание: оригинальная графика PayVaultMenu (symbol1386 из assets.swf) не извлечена.

signal closed()

@export var is_draggable: bool = true

const TICKET_PACKAGES: Array[int] = [10, 50, 100, 220, 450, 1300, 2800, 6000]
const COSTS_USD: Array[float] = [0.99, 2.99, 4.99, 9.99, 19.99, 49.99, 99.99, 199.99]

const PAYVAULT_LABELS: Dictionary = {
	"3000gamemoney": "$3,000 game money",
	"20000gamemoney": "$20,000 game money",
	"100000gamemoney": "$100,000 game money",
	"500000gamemoney": "$500,000 game money",
	"permSale": "60% resale",
	"teleport": "area teleport",
	"zombie": "zombie skin",
	"doublejump": "double jump",
	"moreitems": "+10 item capacity",
	"moremoreitems": "+10 item capacity",
	"morefriends": "+10 friends/enemies",
	"moremorefriends": "+10 friends/enemies",
	"halo": "protection halo",
	"abilitypointreset": "ability & skills reset",
	"morepets": "+4 pet capacity",
	"removecompanion": "Remove companion",
	"evolutioncrystal": "Evolution Crystal",
	"doubledrop": "Double Drop Rate",
	"petxp": "10% & 70% XP Split",
	"orbfocus": "Orb Specialization",
	"bullhorn": "Bullhorn",
	"itemvendor": "Item Vendor (2wk)",
	"guildmoney3x": "Triple Guild Money",
	"greenspawnball": "Green Spawn Ball",
	"bluespawnball": "Blue Spawn Ball",
	"yellowspawnball": "Yellow Spawn Ball",
	"orangespawnball": "Orange Spawn Ball",
	"fishnet": "Fishing Net",
	"baitextend": "Bait Extension",
	"bankitems": "Item Storage",
	"chainsaw": "Chainsaw",
	"chickensuit": "Chicken Suit",
	"privateserver": "Private Server",
	"fishradar": "Shiny Fish Radar",
	"petvendor": "Pet Vendor (2wk)",
	"manualcontrol": "Manual Pet Control",
	"enemycontrol": "Manual Enemy Control",
	"maxenergy": "Max Energy",
	"pet2": "Active Pets +1",
	"redcape": "red cape",
	"jetpack": "jetpack",
	"monkeytail": "monkey tail",
	"dinotail": "dino tail",
	"wings": "wings",
	"pinkballoon": "pink balloon",
	"balloonpack": "balloon pack",
	"evilwings": "evil wings",
	"butterflywings": "butterfly wings",
	"helipack": "heli pack"
}

var _get_tickets_tex: Texture2D = null
var _ticket_badge_tex: Texture2D = null
var _payvault_bg_tex: Texture2D = null
var _buy_btn_tex: Texture2D = null
var _icon_cache: Dictionary = {}

var person: Node = null
var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

var panel_bg: ColorRect = null
var border_panel: Panel = null
var close_btn: TextureButton = null
var title_label: Label = null
var notice_label: Label = null
var tickets_label: Label = null
var refresh_btn: Button = null

var items_scroll: ScrollContainer = null
var items_container: GridContainer = null
var packages_label: Label = null
var status_label: Label = null


func _ready() -> void:
	custom_minimum_size = Vector2(802, 522)
	size = Vector2(802, 522)
	_load_extracted_ui_textures()
	_build_ui()
	_connect_playerio()
	refresh()


func _load_extracted_ui_textures() -> void:
	_payvault_bg_tex = _load_png_tex("res://assets/extracted/payvault_menu/payvault_bg.png")
	_get_tickets_tex = _load_png_tex("res://assets/extracted/payvault_menu/get_tickets_btn.png")
	_ticket_badge_tex = _load_png_tex("res://assets/extracted/payvault_menu/ticket_badge.png")
	_buy_btn_tex = _load_png_tex("res://assets/extracted/payvault_menu/buy_btn.png")


static func _load_png_tex(res_path: String) -> Texture2D:
	if not FileAccess.file_exists(res_path):
		return null
	var img := Image.load_from_file(ProjectSettings.globalize_path(res_path))
	if img != null and not img.is_empty():
		return ImageTexture.create_from_image(img)
	return null


func _connect_playerio() -> void:
	var pio: Node = get_node_or_null("/root/PlayerIOClient")
	if pio != null and pio.has_signal("payvault_updated"):
		if not pio.is_connected("payvault_updated", _on_payvault_updated):
			pio.connect("payvault_updated", _on_payvault_updated)


func _on_payvault_updated(_vault_data: Dictionary) -> void:
	refresh()


func _build_ui() -> void:
	var atlas_loader: Node = _get_atlas_loader()
	atlas_loader.register_starling_atlas("item menu")
	atlas_loader.register_starling_atlas("items_pets_bodies")
	var stats_font: Font = atlas_loader.get_bitmap_font("stats_font.fnt")
	var readable_font: Font = atlas_loader.get_bitmap_font("readable_font.fnt")

	# Оригинальная зелёная панель PayVault (DefineSprite_1386_com.menus.PayVaultMenu, 802x522)
	if _payvault_bg_tex != null:
		var bg_tex_rect := TextureRect.new()
		bg_tex_rect.name = "PanelBG"
		bg_tex_rect.texture = _payvault_bg_tex
		bg_tex_rect.position = Vector2.ZERO
		bg_tex_rect.size = Vector2(802, 522)
		bg_tex_rect.mouse_filter = Control.MOUSE_FILTER_PASS
		add_child(bg_tex_rect)
	else:
		panel_bg = ColorRect.new()
		panel_bg.name = "PanelBG"
		panel_bg.color = Color(0.192, 0.573, 0.094, 0.98)
		panel_bg.size = Vector2(802, 522)
		panel_bg.mouse_filter = Control.MOUSE_FILTER_PASS
		add_child(panel_bg)

	# Прозрачная кнопка закрытия поверх X на payvault_bg (или текстурная)
	close_btn = TextureButton.new()
	close_btn.name = "CloseButton"
	if _payvault_bg_tex == null:
		close_btn.texture_normal = atlas_loader.get_starling_texture("item menu", "x_btn_00")
		close_btn.texture_hover = atlas_loader.get_starling_texture("item menu", "x_btn_01")
	close_btn.custom_minimum_size = Vector2(44, 44)
	close_btn.position = Vector2(756, 0)
	close_btn.focus_mode = Control.FOCUS_NONE
	close_btn.pressed.connect(close_menu)
	add_child(close_btn)

	# Заголовок (если нет текстуры фона)
	title_label = Label.new()
	title_label.name = "TitleLabel"
	title_label.text = "PAYVAULT"
	title_label.visible = (_payvault_bg_tex == null)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.position = Vector2(240, 6)
	title_label.size = Vector2(320, 30)
	title_label.add_theme_font_override("font", stats_font)
	title_label.add_theme_font_size_override("font_size", 24)
	title_label.add_theme_color_override("font_color", Color.WHITE)
	add_child(title_label)

	# Баланс тикетов (PayVaultMenu.as:447: yourTickets_txt)
	tickets_label = Label.new()
	tickets_label.name = "YourTicketsLabel"
	tickets_label.text = "Your Tickets: 0"
	tickets_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tickets_label.position = Vector2(220, 48)
	tickets_label.size = Vector2(320, 30)
	tickets_label.add_theme_font_override("font", stats_font)
	tickets_label.add_theme_font_size_override("font_size", 22)
	tickets_label.add_theme_color_override("font_color", Color.WHITE)
	add_child(tickets_label)

	if _get_tickets_tex != null:
		var gt_btn := TextureButton.new()
		gt_btn.name = "RefreshBtn"
		gt_btn.texture_normal = _get_tickets_tex
		gt_btn.position = Vector2(568, 40)
		gt_btn.focus_mode = Control.FOCUS_NONE
		gt_btn.pressed.connect(_on_refresh_pressed)
		add_child(gt_btn)
	else:
		refresh_btn = Button.new()
		refresh_btn.name = "RefreshBtn"
		refresh_btn.text = "GET TICKETS"
		refresh_btn.position = Vector2(580, 46)
		refresh_btn.size = Vector2(160, 32)
		refresh_btn.focus_mode = Control.FOCUS_NONE
		refresh_btn.add_theme_font_override("font", stats_font)
		refresh_btn.add_theme_font_size_override("font_size", 14)
		refresh_btn.pressed.connect(_on_refresh_pressed)
		add_child(refresh_btn)

	items_scroll = ScrollContainer.new()
	items_scroll.name = "PayVaultItemsScroll"
	items_scroll.position = Vector2(24, 94)
	items_scroll.size = Vector2(754, 398)
	items_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(items_scroll)

	items_container = GridContainer.new()
	items_container.name = "PayVaultItemsContainer"
	items_container.columns = 4
	items_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	items_container.add_theme_constant_override("h_separation", 8)
	items_container.add_theme_constant_override("v_separation", 12)
	items_scroll.add_child(items_container)

	status_label = Label.new()
	status_label.name = "StatusLabel"
	status_label.text = ""
	status_label.position = Vector2(24, 492)
	status_label.size = Vector2(754, 22)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.add_theme_font_override("font", readable_font)
	status_label.add_theme_font_size_override("font_size", 12)
	status_label.add_theme_color_override("font_color", Color(1.0, 0.92, 0.4))
	add_child(status_label)


func _on_refresh_pressed() -> void:
	var pio: Node = get_node_or_null("/root/PlayerIOClient")
	if pio != null and pio.has_method("payvault_refresh"):
		pio.call("payvault_refresh")
	refresh()


func refresh() -> void:
	var pio: Node = get_node_or_null("/root/PlayerIOClient")
	var sdb: Node = _get_stats_db()
	var atlas_loader: Node = _get_atlas_loader()
	var stats_font: Font = atlas_loader.get_bitmap_font("stats_font.fnt")
	var readable_font: Font = atlas_loader.get_bitmap_font("readable_font.fnt")

	if pio != null and pio.has_method("payvault_coins"):
		var coins: int = int(pio.call("payvault_coins"))
		tickets_label.text = "Your Tickets: %d" % coins
	else:
		tickets_label.text = "Your Tickets: 0"

	for child: Node in items_container.get_children():
		items_container.remove_child(child)
		child.queue_free()

	if sdb == null or not ("pay_vault_items" in sdb) or sdb.pay_vault_items.is_empty():
		var empty_lbl := Label.new()
		empty_lbl.text = "PayVaultItems не загружены в StatsDB."
		empty_lbl.add_theme_font_override("font", readable_font)
		empty_lbl.add_theme_font_size_override("font_size", 13)
		items_container.add_child(empty_lbl)
		return

	var int_keys: Array[int] = []
	for k: Variant in sdb.pay_vault_items.keys():
		if k is int:
			int_keys.append(k)
	int_keys.sort()

	for idx: int in int_keys:
		var entry: Variant = sdb.pay_vault_items[idx]
		if not (entry is Dictionary):
			continue
		var item_dict: Dictionary = entry
		var item_key: String = str(item_dict.get("key", ""))
		var price_coins: int = int(item_dict.get("PriceCoins", item_dict.get("c", 0)))
		var owned_cnt: int = 0
		if pio != null and pio.has_method("payvault_count"):
			owned_cnt = int(pio.call("payvault_count", item_key))

		var card := VBoxContainer.new()
		card.custom_minimum_size = Vector2(176, 118)
		card.alignment = BoxContainer.ALIGNMENT_CENTER
		card.add_theme_constant_override("separation", 3)

		var badge_row := HBoxContainer.new()
		badge_row.alignment = BoxContainer.ALIGNMENT_CENTER
		var ticket_lbl := Label.new()
		ticket_lbl.text = "%d" % price_coins
		ticket_lbl.add_theme_font_override("font", stats_font)
		ticket_lbl.add_theme_font_size_override("font_size", 16)
		ticket_lbl.add_theme_color_override("font_color", Color.WHITE)
		badge_row.add_child(ticket_lbl)
		if _ticket_badge_tex != null:
			var badge_rect := TextureRect.new()
			badge_rect.texture = _ticket_badge_tex
			badge_rect.custom_minimum_size = Vector2(52, 26)
			badge_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			badge_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			badge_row.add_child(badge_rect)
		card.add_child(badge_row)

		var icon_tex: Texture2D = _find_payvault_icon(atlas_loader, item_key)
		var icon_rect := TextureRect.new()
		icon_rect.texture = icon_tex
		icon_rect.custom_minimum_size = Vector2(44, 38)
		icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		card.add_child(icon_rect)

		var buy_tex: Texture2D = _buy_btn_tex if _buy_btn_tex != null else atlas_loader.get_starling_texture("item menu", "buy_btn")
		if buy_tex != null:
			var buy_tbtn := TextureButton.new()
			buy_tbtn.texture_normal = buy_tex
			buy_tbtn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			buy_tbtn.focus_mode = Control.FOCUS_NONE
			buy_tbtn.pressed.connect(_on_buy_payvault_item.bind(item_key, price_coins))
			card.add_child(buy_tbtn)
		else:
			var buy_btn := Button.new()
			buy_btn.text = "BUY"
			buy_btn.custom_minimum_size = Vector2(82, 28)
			buy_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			buy_btn.focus_mode = Control.FOCUS_NONE
			buy_btn.pressed.connect(_on_buy_payvault_item.bind(item_key, price_coins))
			card.add_child(buy_btn)

		var row_lbl := Label.new()
		row_lbl.text = str(PAYVAULT_LABELS.get(item_key, item_key))
		row_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		row_lbl.add_theme_font_override("font", readable_font)
		row_lbl.add_theme_font_size_override("font_size", 12)
		row_lbl.add_theme_color_override("font_color", Color.WHITE)
		card.add_child(row_lbl)

		items_container.add_child(card)


func _find_payvault_icon(atlas_loader: Node, item_key: String) -> Texture2D:
	if _icon_cache.has(item_key):
		return _icon_cache[item_key] as Texture2D
	var extracted_path: String = "res://assets/extracted/payvault_menu/icons/%s.png" % item_key
	var ext_tex: Texture2D = _load_png_tex(extracted_path)
	if ext_tex != null:
		_icon_cache[item_key] = ext_tex
		return ext_tex
	var map_names: Dictionary = {
		"chainsaw": "chainsaw", "fishnet": "net", "bullhorn": "bullhorn",
		"evolutioncrystal": "evolution crystal", "chickensuit": "chicken hat",
		"greenspawnball": "green spawn ball", "bluespawnball": "blue spawn ball",
		"yellowspawnball": "yellow spawn ball", "orangespawnball": "orange spawn ball",
		"redcape": "red cape", "jetpack": "jet pack", "monkeytail": "monkey tail",
		"dinotail": "dino tail", "wings": "wings", "pinkballoon": "pink balloon",
		"balloonpack": "balloon pack", "evilwings": "evil wings",
		"butterflywings": "butterfly wings", "helipack": "heli pack"
	}
	var sprite_name: String = str(map_names.get(item_key, item_key))
	var tex: Texture2D = atlas_loader.get_starling_texture("items_pets_bodies", sprite_name)
	if tex == null:
		tex = atlas_loader.get_starling_texture("items_pets_bodies", "item " + sprite_name)
	return tex


func _on_buy_payvault_item(item_key: String, price_coins: int) -> void:
	var pio: Node = get_node_or_null("/root/PlayerIOClient")
	if pio == null:
		status_label.text = "PlayerIOClient недоступен."
		return
	if "my_player_object" in pio and pio.my_player_object is Dictionary:
		var pv_owned: Variant = pio.my_player_object.get("payvault_owned", {})
		if not (pv_owned is Dictionary):
			pv_owned = {}
		var cur_cnt: int = int((pv_owned as Dictionary).get(item_key, 0))
		(pv_owned as Dictionary)[item_key] = cur_cnt + 1
		pio.my_player_object["payvault_owned"] = pv_owned
		_grant_payvault_effect(item_key)
		if pio.has_method("save_sandbox_profile"):
			pio.call("save_sandbox_profile")
	status_label.text = "Получено: %s (цена %d Tickets)" % [item_key, price_coins]
	refresh()


func bind_person(target_person: Node) -> void:
	person = target_person


func _find_local_player() -> Node:
	if person != null and is_instance_valid(person):
		return person
	var tree: SceneTree = get_tree()
	if tree == null:
		return null
	var grouped: Node = tree.get_first_node_in_group("local_player")
	if grouped != null:
		return grouped
	for child: Node in tree.root.get_children():
		if "local_player" in child and child.get("local_player") != null:
			return child.get("local_player")
		var lp: Node = child.find_child("LocalPlayer", true, false)
		if lp != null:
			return lp
	return null


func _grant_payvault_effect(item_key: String) -> void:
	var player: Node = _find_local_player()
	if player == null:
		return
	match item_key:
		"3000gamemoney":
			if player.has_method("add_coins"):
				player.call("add_coins", 3000)
		"20000gamemoney":
			if player.has_method("add_coins"):
				player.call("add_coins", 20000)
		"100000gamemoney":
			if player.has_method("add_coins"):
				player.call("add_coins", 100000)
		"500000gamemoney":
			if player.has_method("add_coins"):
				player.call("add_coins", 500000)
		"moreitems", "moremoreitems":
			if "max_inventory_slots" in player:
				player.max_inventory_slots += 10
		"doublejump":
			if "max_jumps" in player:
				player.max_jumps = maxi(int(player.max_jumps), 2)
		"maxenergy":
			if "max_energy" in player and "energy" in player:
				player.max_energy += 50
				player.energy = player.max_energy
		"halo":
			var pio: Node = get_node_or_null("/root/PlayerIOClient")
			if pio != null and "my_player_object" in pio and pio.my_player_object is Dictionary:
				pio.my_player_object["halo"] = true
		"chickensuit":
			for p_item: String in ["chicken hat", "chicken outfit", "chicken pants"]:
				if player.has_method("add_inventory_item"):
					player.call("add_inventory_item", p_item)
		"chainsaw":
			if player.has_method("add_inventory_item"):
				player.call("add_inventory_item", "chainsaw")
		"fishnet":
			if player.has_method("add_inventory_item"):
				player.call("add_inventory_item", "net")
		"bullhorn":
			if player.has_method("add_inventory_item"):
				player.call("add_inventory_item", "bullhorn")
		"evolutioncrystal":
			if player.has_method("add_inventory_item"):
				player.call("add_inventory_item", "evolution crystal")
		"greenspawnball":
			if player.has_method("add_inventory_item"):
				player.call("add_inventory_item", "green spawn ball")
		"bluespawnball":
			if player.has_method("add_inventory_item"):
				player.call("add_inventory_item", "blue spawn ball")
		"yellowspawnball":
			if player.has_method("add_inventory_item"):
				player.call("add_inventory_item", "yellow spawn ball")
		"orangespawnball":
			if player.has_method("add_inventory_item"):
				player.call("add_inventory_item", "orange spawn ball")
		"redcape":
			if player.has_method("add_inventory_item"):
				player.call("add_inventory_item", "red cape")
		"jetpack":
			if player.has_method("add_inventory_item"):
				player.call("add_inventory_item", "jet pack")
		"monkeytail":
			if player.has_method("add_inventory_item"):
				player.call("add_inventory_item", "monkey tail")
		"dinotail":
			if player.has_method("add_inventory_item"):
				player.call("add_inventory_item", "dino tail")
		"wings":
			if player.has_method("add_inventory_item"):
				player.call("add_inventory_item", "wings")
		"pinkballoon":
			if player.has_method("add_inventory_item"):
				player.call("add_inventory_item", "pink balloon")
		"balloonpack":
			if player.has_method("add_inventory_item"):
				player.call("add_inventory_item", "balloon pack")
		"evilwings":
			if player.has_method("add_inventory_item"):
				player.call("add_inventory_item", "evil wings")
		"butterflywings":
			if player.has_method("add_inventory_item"):
				player.call("add_inventory_item", "butterfly wings")
		"helipack":
			if player.has_method("add_inventory_item"):
				player.call("add_inventory_item", "heli pack")
		"abilitypointreset":
			if "power_stat" in player:
				var refunded: int = int(player.power_stat) + int(player.dex_stat) + int(player.def_stat) + int(player.range_stat) + int(player.magic_stat) + int(player.artillery_stat)
				player.power_stat = 0
				player.dex_stat = 0
				player.def_stat = 0
				player.range_stat = 0
				player.magic_stat = 0
				player.artillery_stat = 0
				player.ability_points += refunded
				if player.has_signal("stats_changed"):
					player.stats_changed.emit()


func _gui_input(event: InputEvent) -> void:
	if not is_draggable:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = get_global_mouse_position() - global_position
			move_to_front()
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset


func close_menu() -> void:
	visible = false
	closed.emit()


static func _get_atlas_loader() -> Node:
	if Engine.has_singleton("StarlingAtlasLoader"):
		return Engine.get_singleton("StarlingAtlasLoader")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("StarlingAtlasLoader"):
		return tree.root.get_node("StarlingAtlasLoader")
	return load("res://scripts/autoload/StarlingAtlasLoader.gd").new()


static func _get_stats_db() -> Node:
	if Engine.has_singleton("StatsDB"):
		return Engine.get_singleton("StatsDB")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("StatsDB"):
		return tree.root.get_node("StatsDB")
	return null
