extends Control
class_name FriendsMenu
## FriendsMenu — Окно социальных списков (порт com.menus.FriendMenu.as).
## Точно воспроизводит Starling-версию:
## - Вкладки: Friends (36, 36) и Guild (161, 36) (enemiesTab_btn в FriendMenu.as отсутствует)
## - Список игроков со слотами friend slot_00 / friend slot_01 и иконкой online clip / offline clip
## - Правая панель: friendName_txt (319, 64), info_txt (324, 250), remove_btn (315, 433), add_btn (318, 468), chat_btn (407, 468)
## - Панель добавления друга (addPanel_image + enterName_txt + addFriendString_btn) в (298, 446)

signal closed()
signal start_chat_with(player_name: String)

@export var is_draggable: bool = true

var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

var panel_bg: TextureRect = null
var close_btn: TextureButton = null
var title_label: Label = null
var scroll_btn: TextureButton = null

# Вкладки
var btn_tab_friends: TextureButton = null
var btn_tab_guild: TextureButton = null
var current_tab: String = "FRIENDS"

# Список игроков
var list_scroll: ScrollContainer = null
var list_container: VBoxContainer = null
var row_buttons: Array[TextureButton] = []
var selected_friend_index: int = -1

# Детали выбранного друга
var friend_name_label: Label = null
var friend_info_label: Label = null
var btn_chat: TextureButton = null
var btn_unfriend: TextureButton = null
var btn_add_menu: TextureButton = null

# Добавление друга (правая нижняя часть)
var add_panel_bg: TextureRect = null
var add_input: LineEdit = null
var add_confirm_btn: TextureButton = null

# Данные списков (загружаются из PlayerIOClient.my_player_object, без фиктивных заглушек)
var friends_data: Array[Dictionary] = []
var guild_data: Array[Dictionary] = []

func _ready() -> void:
	custom_minimum_size = Vector2(512, 515)
	size = Vector2(512, 515)
	_load_from_profile()
	_build_ui()
	_refresh_list()


func _load_from_profile() -> void:
	friends_data.clear()
	guild_data.clear()
	var pio: Node = get_node_or_null("/root/PlayerIOClient")
	if pio == null or not ("my_player_object" in pio) or not (pio.my_player_object is Dictionary):
		return
	var p_obj: Dictionary = pio.my_player_object
	var raw_friends: Variant = p_obj.get("friends", [])
	if raw_friends is Array:
		for f_name: Variant in raw_friends:
			friends_data.append({"name": str(f_name), "online": false, "level": 0, "guild": ""})


func _build_ui() -> void:
	var atlas_loader: Node = _get_atlas_loader()
	atlas_loader.register_starling_atlas("friends menu")
	var stats_font: Font = atlas_loader.get_bitmap_font("stats_font.fnt")
	var readable_font: Font = atlas_loader.get_bitmap_font("readable_font.fnt")

	# Фоновая панель из friends menu.xml ("panel": 512x515, Flash x=-307, y=-236)
	var bg_tex: Texture2D = atlas_loader.get_starling_texture("friends menu", "panel")
	panel_bg = TextureRect.new()
	panel_bg.name = "PanelBG"
	panel_bg.texture = bg_tex
	panel_bg.size = Vector2(512, 515)
	panel_bg.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(panel_bg)

	# Кнопка закрытия (FriendMenu.as:96-99: x=197, y=-222, pivotX=30, pivotY=19 -> (474, -5))
	var close_tex: Texture2D = atlas_loader.get_starling_texture("friends menu", "x_btn_00")
	close_btn = TextureButton.new()
	close_btn.name = "CloseButton"
	close_btn.texture_normal = close_tex
	close_btn.position = Vector2(474, -5)
	close_btn.focus_mode = Control.FOCUS_NONE
	close_btn.pressed.connect(close_menu)
	add_child(close_btn)

	# Заголовок текущей вкладки (FriendMenu.as:173-174: x=-167, y=-236 -> (140, 0))
	title_label = Label.new()
	title_label.name = "TitleLabel"
	title_label.text = "FRIENDS"
	title_label.position = Vector2(140, 0)
	title_label.size = Vector2(261, 33)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_override("font", stats_font)
	title_label.add_theme_font_size_override("font_size", 28)
	title_label.add_theme_color_override("font_color", Color.WHITE)
	add_child(title_label)

	# --- ВКЛАДКИ (FriendMenu.as:125-141: только friendsTab_btn (36, 36) и guildTab_btn (161, 36)) ---
	var f_tab_tex: Texture2D = atlas_loader.get_starling_texture("friends menu", "friendsTab_btn")
	btn_tab_friends = TextureButton.new()
	btn_tab_friends.name = "FriendsTabBtn"
	btn_tab_friends.texture_normal = f_tab_tex
	btn_tab_friends.position = Vector2(36, 36)
	btn_tab_friends.focus_mode = Control.FOCUS_NONE
	btn_tab_friends.pressed.connect(func() -> void: _switch_tab("FRIENDS"))
	add_child(btn_tab_friends)

	var g_tab_tex: Texture2D = atlas_loader.get_starling_texture("friends menu", "guildTab_btn")
	btn_tab_guild = TextureButton.new()
	btn_tab_guild.name = "GuildTabBtn"
	btn_tab_guild.texture_normal = g_tab_tex
	btn_tab_guild.position = Vector2(161, 36)
	btn_tab_guild.focus_mode = Control.FOCUS_NONE
	btn_tab_guild.pressed.connect(func() -> void: _switch_tab("GUILD"))
	add_child(btn_tab_guild)

	# --- КНОПКА СКРОЛЛА (FriendMenu.as:142-146: x=-8, y=-132, pivotX=15, pivotY=19 -> (284, 85)) ---
	var scroll_tex: Texture2D = atlas_loader.get_starling_texture("friends menu", "scroll_btn")
	if scroll_tex != null:
		scroll_btn = TextureButton.new()
		scroll_btn.name = "ScrollBtn"
		scroll_btn.texture_normal = scroll_tex
		scroll_btn.position = Vector2(284, 85)
		scroll_btn.focus_mode = Control.FOCUS_NONE
		add_child(scroll_btn)

	# --- ЛЕВАЯ ПАНЕЛЬ: СПИСОК ИГРОКОВ ---
	list_scroll = ScrollContainer.new()
	list_scroll.name = "ListScroll"
	list_scroll.position = Vector2(10, 84)
	list_scroll.size = Vector2(272, 415)
	list_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	list_scroll.focus_mode = Control.FOCUS_NONE
	add_child(list_scroll)

	list_container = VBoxContainer.new()
	list_container.name = "ListContainer"
	list_container.add_theme_constant_override("separation", 0)
	list_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list_scroll.add_child(list_container)

	# --- ПРАВАЯ ПАНЕЛЬ: ДЕТАЛИ ИГРОКА (FriendMenu.as:176-180) ---
	friend_name_label = Label.new()
	friend_name_label.name = "FriendNameLabel"
	friend_name_label.text = ""
	friend_name_label.position = Vector2(319, 64)
	friend_name_label.size = Vector2(180, 24)
	friend_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	friend_name_label.add_theme_font_override("font", stats_font)
	friend_name_label.add_theme_font_size_override("font_size", 19)
	friend_name_label.add_theme_color_override("font_color", Color.WHITE)
	add_child(friend_name_label)

	friend_info_label = Label.new()
	friend_info_label.name = "FriendInfoLabel"
	friend_info_label.text = ""
	friend_info_label.position = Vector2(324, 250)
	friend_info_label.size = Vector2(165, 174)
	friend_info_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	friend_info_label.add_theme_font_override("font", readable_font)
	friend_info_label.add_theme_font_size_override("font_size", 14)
	add_child(friend_info_label)

	# Кнопка удаления (FriendMenu.as:111-114: x=59, y=212, pivotX=51, pivotY=15 -> (315, 433))
	var unfriend_tex: Texture2D = atlas_loader.get_starling_texture("friends menu", "unFriend_btn_00")
	btn_unfriend = TextureButton.new()
	btn_unfriend.name = "RemoveBtn"
	btn_unfriend.texture_normal = unfriend_tex
	btn_unfriend.position = Vector2(315, 433)
	btn_unfriend.visible = false
	btn_unfriend.focus_mode = Control.FOCUS_NONE
	btn_unfriend.pressed.connect(_on_unfriend_clicked)
	add_child(btn_unfriend)

	# Кнопка открытия панели добавления (FriendMenu.as:118-121: x=44, y=247, pivotX=33, pivotY=15 -> (318, 468))
	var add_btn_tex: Texture2D = atlas_loader.get_starling_texture("friends menu", "addFriendMenu_btn_00")
	btn_add_menu = TextureButton.new()
	btn_add_menu.name = "AddBtn"
	btn_add_menu.texture_normal = add_btn_tex
	btn_add_menu.position = Vector2(318, 468)
	btn_add_menu.focus_mode = Control.FOCUS_NONE
	btn_add_menu.pressed.connect(_show_add_panel)
	add_child(btn_add_menu)

	# Кнопка чата (FriendMenu.as:104-107: x=133, y=247, pivotX=33, pivotY=15 -> (407, 468))
	var chat_btn_tex: Texture2D = atlas_loader.get_starling_texture("friends menu", "chat_btn")
	btn_chat = TextureButton.new()
	btn_chat.name = "ChatBtn"
	btn_chat.texture_normal = chat_btn_tex
	btn_chat.position = Vector2(407, 468)
	btn_chat.visible = false
	btn_chat.focus_mode = Control.FOCUS_NONE
	btn_chat.pressed.connect(_on_chat_clicked)
	add_child(btn_chat)

	# --- ПРАВАЯ НИЖНЯЯ ПАНЕЛЬ: ДОБАВЛЕНИЕ ДРУГА (FriendMenu.as:691-715: (298, 446)) ---
	var add_panel_tex: Texture2D = atlas_loader.get_starling_texture("friends menu", "add friend panel")
	add_panel_bg = TextureRect.new()
	add_panel_bg.name = "AddPanelBG"
	add_panel_bg.texture = add_panel_tex
	add_panel_bg.position = Vector2(298, 446)
	add_panel_bg.size = Vector2(200, 46)
	add_panel_bg.visible = false
	add_child(add_panel_bg)

	add_input = LineEdit.new()
	add_input.name = "EnterNameTxt"
	add_input.placeholder_text = ""
	add_input.position = Vector2(306, 467)
	add_input.size = Vector2(127, 22)
	add_input.alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_input.add_theme_font_override("font", readable_font)
	add_input.add_theme_font_size_override("font_size", 13)
	add_input.visible = false
	add_input.text_submitted.connect(func(txt: String) -> void: _add_friend_by_name(txt))
	add_child(add_input)

	add_confirm_btn = TextureButton.new()
	add_confirm_btn.name = "AddFriendStringBtn"
	add_confirm_btn.texture_normal = add_btn_tex
	add_confirm_btn.position = Vector2(441, 464)
	add_confirm_btn.scale = Vector2(0.7, 0.7)
	add_confirm_btn.visible = false
	add_confirm_btn.focus_mode = Control.FOCUS_NONE
	add_confirm_btn.pressed.connect(func() -> void: _add_friend_by_name(add_input.text))
	add_child(add_confirm_btn)


func _show_add_panel() -> void:
	if add_panel_bg != null:
		add_panel_bg.visible = true
	if add_input != null:
		add_input.visible = true
		add_input.grab_focus()
	if add_confirm_btn != null:
		add_confirm_btn.visible = true
	if btn_add_menu != null:
		btn_add_menu.visible = false
	if btn_chat != null:
		btn_chat.visible = false
	if btn_unfriend != null:
		btn_unfriend.visible = false


func _hide_add_panel() -> void:
	if add_panel_bg != null:
		add_panel_bg.visible = false
	if add_input != null:
		add_input.visible = false
	if add_confirm_btn != null:
		add_confirm_btn.visible = false
	if btn_add_menu != null:
		btn_add_menu.visible = (current_tab == "FRIENDS")


func _switch_tab(tab_name: String) -> void:
	current_tab = tab_name
	title_label.text = tab_name
	selected_friend_index = -1
	friend_name_label.text = ""
	friend_info_label.text = ""
	btn_chat.visible = false
	btn_unfriend.visible = false
	_hide_add_panel()
	_refresh_list()


func _refresh_list() -> void:
	for child: Node in list_container.get_children():
		child.queue_free()
	row_buttons.clear()

	var atlas_loader: Node = _get_atlas_loader()
	var slot_tex_normal: Texture2D = atlas_loader.get_starling_texture("friends menu", "friend slot_00")
	var slot_tex_selected: Texture2D = atlas_loader.get_starling_texture("friends menu", "friend slot_01")
	var on_tex: Texture2D = atlas_loader.get_starling_texture("friends menu", "online clip")
	var off_tex: Texture2D = atlas_loader.get_starling_texture("friends menu", "offline clip")

	var current_array: Array[Dictionary] = friends_data if current_tab == "FRIENDS" else guild_data

	for i: int in range(current_array.size()):
		var entry: Dictionary = current_array[i]
		var idx: int = i

		var row_btn: TextureButton = TextureButton.new()
		row_btn.name = "Row_%d" % i
		row_btn.texture_normal = slot_tex_selected if (i == selected_friend_index) else slot_tex_normal
		row_btn.custom_minimum_size = Vector2(270, 38)
		row_btn.focus_mode = Control.FOCUS_NONE
		row_btn.pressed.connect(func() -> void: _select_entry(idx, entry))

		var name_lbl: Label = Label.new()
		name_lbl.name = "NameLabel"
		name_lbl.position = Vector2(35, 8)
		name_lbl.size = Vector2(180, 22)
		name_lbl.text = str(entry.get("name", "Unknown"))
		name_lbl.add_theme_font_override("font", atlas_loader.get_bitmap_font("stats_font.fnt"))
		name_lbl.add_theme_font_size_override("font_size", 17)
		name_lbl.add_theme_color_override("font_color", Color.WHITE)
		name_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row_btn.add_child(name_lbl)

		if current_tab == "FRIENDS":
			var is_online: bool = bool(entry.get("online", false))
			var status_rect: TextureRect = TextureRect.new()
			status_rect.name = "StatusIcon"
			status_rect.texture = on_tex if is_online else off_tex
			status_rect.position = Vector2(212, 6)
			status_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
			row_btn.add_child(status_rect)

		list_container.add_child(row_btn)
		row_buttons.append(row_btn)


func _select_entry(idx: int, entry: Dictionary) -> void:
	selected_friend_index = idx
	_hide_add_panel()

	var atlas_loader: Node = _get_atlas_loader()
	var slot_tex_normal: Texture2D = atlas_loader.get_starling_texture("friends menu", "friend slot_00")
	var slot_tex_selected: Texture2D = atlas_loader.get_starling_texture("friends menu", "friend slot_01")
	for i: int in range(row_buttons.size()):
		row_buttons[i].texture_normal = slot_tex_selected if (i == idx) else slot_tex_normal

	var p_name: String = str(entry.get("name", ""))
	friend_name_label.text = p_name

	var is_online: bool = bool(entry.get("online", false))
	var lvl: int = int(entry.get("level", 1))
	var guild_str: String = str(entry.get("guild", ""))

	var details: String = "name: %s\nlevel: %d" % [p_name, lvl]
	if not guild_str.is_empty():
		details += "\nguild: %s" % guild_str
	details += "\nonline: %s" % ("yes" if is_online else "no")

	friend_info_label.text = details

	btn_chat.visible = is_online
	btn_unfriend.visible = (current_tab == "FRIENDS")


func _add_friend_by_name(name_to_add: String) -> void:
	var trimmed: String = name_to_add.strip_edges()
	if trimmed.is_empty():
		_hide_add_panel()
		return

	for f: Dictionary in friends_data:
		if str(f.get("name", "")).to_lower() == trimmed.to_lower():
			add_input.text = ""
			_hide_add_panel()
			return

	friends_data.append({
		"name": trimmed,
		"online": false,
		"level": 1,
		"guild": ""
	})
	add_input.text = ""
	_hide_add_panel()
	if current_tab == "FRIENDS":
		_refresh_list()


func _on_chat_clicked() -> void:
	if selected_friend_index >= 0:
		start_chat_with.emit(friend_name_label.text)


func _on_unfriend_clicked() -> void:
	if selected_friend_index < 0:
		return
	if current_tab == "FRIENDS" and selected_friend_index < friends_data.size():
		friends_data.remove_at(selected_friend_index)

	selected_friend_index = -1
	friend_name_label.text = ""
	friend_info_label.text = ""
	btn_chat.visible = false
	btn_unfriend.visible = false
	_refresh_list()


func close_menu() -> void:
	visible = false
	closed.emit()


func _gui_input(event: InputEvent) -> void:
	if not is_draggable:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = get_global_mouse_position() - global_position
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset


static func _get_atlas_loader() -> Node:
	if Engine.has_singleton("StarlingAtlasLoader"):
		return Engine.get_singleton("StarlingAtlasLoader")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("StarlingAtlasLoader"):
		return tree.root.get_node("StarlingAtlasLoader")
	return load("res://scripts/autoload/StarlingAtlasLoader.gd").new()
