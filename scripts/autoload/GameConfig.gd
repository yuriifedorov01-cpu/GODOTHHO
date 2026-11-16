extends Node

# =============================================================================
# GameConfig.gd — Global constants for Helmet Heroes (MyGame.swf v9.50)
# =============================================================================

# --- PlayerIO & Network Constants ---
const GAME_ID: String = "hho-ygpra4ftumusohpifpdug"
const CLIENT_VERSION: String = "9.50"
const CLIENT_API: String = "as3"
const USE_SECURE_API_REQUESTS: bool = true
const API_ENDPOINT: String = "https://api.playerio.com/api"
const GAMEFS_BASE_URL: String = "https://yuriifedorov01-cpu.github.io/hht-client"
const GAMEFS_LEGACY_URL: String = "http://r.playerio.com/r/"

# --- BigDB & Room Constants ---
const DB_CACHE_VERSION: int = 110
const DB_CACHE_FILE_PATH: String = "user://db_items_cache.json"
const HELMET_SAVE_FILE_PATH: String = "user://helmet_save.json"
const MULTIPLAYER_ROOM_TYPE: String = "MyCode"
const DEFAULT_SERVER_NAME: String = "Pve Server"
const PVP_SERVER_NAME: String = "PvP Server"
const PUBLIC_CONNECTION_ID: String = "public"
const SIMPLE_CONNECTION_ID: String = "simpleconnection"
const KONGREGATE_CONNECTION_ID: String = "kongregateconnection"
const STEAM_CONNECTION_ID: String = "steamconnection"
const PUBLISHING_NETWORK_CONNECTION_ID: String = "publishingnetwork"
const PUBLIC_BOOTSTRAP_USER_ID: String = "adsfjhakf"

# --- Stage & Viewport Constants ---
const VIEWPORT_WIDTH: int = 950
const VIEWPORT_HEIGHT: int = 700
const TARGET_FPS: int = 30
const CAMERA_FOCUS_X: float = 475.0
const CAMERA_FOCUS_Y: float = 449.0
const SCROLL_X_MODIFIER: float = 2.5
const SCROLL_Y_MODIFIER: float = 6.0

# --- World & Physics Constants (30 Hz tick rate) ---
const TILE_SIZE: int = 165
const MAP_COLS: int = 35
const MAP_ROWS: int = 22
const GRAVITY: float = 1.1
const GROUND_FRICTION: float = 0.83
const AIR_FRICTION: float = 0.96
const MAX_FALL_SPEED: float = 25.0
const MAX_GAP: float = 20.0
const BASE_MOVE_SPEED: float = 7.0
const DEX_SPEED_DIVISOR: float = 176.0
const BASE_JUMP_POWER: float = 20.0
const JUMP_SKILL_MULTIPLIER: float = 0.3

# --- Inventory & Gameplay Constants ---
const DEFAULT_MAX_ITEMS: int = 20
const MORE_ITEMS_MAX: int = 30
const MORE_MORE_ITEMS_MAX: int = 40
const MAX_BANK_ITEMS: int = 13
const MAX_PETS_OWNED: int = 8
const MAX_VENDOR_ITEMS: int = 8
const TOTAL_MAP_COUNT: int = 145
const REDIRECTED_STAGE_FROM: int = 51
const REDIRECTED_STAGE_TO: int = 46

# --- Local Asset Paths ---
const CLIENT_DATA_ROOT: String = "res://assets/client_data"
const DATA_DIR: String = "res://assets/client_data/data"
const DYNAMIC_CONTENT_DIR: String = "res://assets/client_data/dynamic_content"
const SPRITE_SHEETS_DIR: String = "res://assets/client_data/dynamic_content/sprite_sheets"
const BACKGROUNDS_DIR: String = "res://assets/client_data/dynamic_content/backgrounds"
const MISC_DIR: String = "res://assets/client_data/dynamic_content/misc"
const AUDIO_DIR: String = "res://assets/client_data/SFX_and_music"
const INCLUDES_DIR: String = "res://assets/client_data/includes"

# --- Flash Keyboard ActionScript KeyCodes (used in "kd" / "ku" network packets) ---
const AS3_KEY_LEFT: int = 37
const AS3_KEY_UP: int = 38
const AS3_KEY_RIGHT: int = 39
const AS3_KEY_DOWN: int = 40
const AS3_KEY_SPACE: int = 32
const AS3_KEY_A: int = 65
const AS3_KEY_B: int = 66
const AS3_KEY_C: int = 67
const AS3_KEY_D: int = 68
const AS3_KEY_E: int = 69
const AS3_KEY_G: int = 71
const AS3_KEY_H: int = 72
const AS3_KEY_K: int = 75
const AS3_KEY_L: int = 76
const AS3_KEY_M: int = 77
const AS3_KEY_N: int = 78
const AS3_KEY_O: int = 79
const AS3_KEY_Q: int = 81
const AS3_KEY_R: int = 82
const AS3_KEY_S: int = 83
const AS3_KEY_T: int = 84
const AS3_KEY_V: int = 86
const AS3_KEY_W: int = 87
const AS3_KEY_Y: int = 89
const AS3_KEY_Z: int = 90


static func build_room_id(level: int, server_name: String = DEFAULT_SERVER_NAME, version: String = CLIENT_VERSION) -> String:
	return "%s-r%d_%s" % [version, level, server_name]


static func calc_move_speed(dex: int) -> float:
	return BASE_MOVE_SPEED + float(dex) / DEX_SPEED_DIVISOR


static func calc_jump_power(jump_skill_lvl: int) -> float:
	return BASE_JUMP_POWER + float(jump_skill_lvl) * JUMP_SKILL_MULTIPLIER


static func is_pvp_area(level: int, server_name: String) -> bool:
	return server_name == PVP_SERVER_NAME or level == 112 or level == 113 or level == 114


static func resolve_gamefs_url(relative_path: String) -> String:
	var clean_path: String = relative_path.strip_edges()
	if clean_path.begins_with("http://") or clean_path.begins_with("https://"):
		return clean_path
	if not clean_path.begins_with("/"):
		clean_path = "/" + clean_path
	return GAMEFS_BASE_URL + clean_path


static func get_gamefs_url(relative_path: String) -> String:
	return resolve_gamefs_url(relative_path)


static func resolve_local_asset_path(url_or_path: String) -> String:
	var clean: String = url_or_path.strip_edges()
	if clean.begins_with(GAMEFS_BASE_URL):
		clean = clean.substr(GAMEFS_BASE_URL.length())
	if clean.begins_with("/"):
		clean = clean.substr(1)
	if clean.begins_with("res://") or clean.begins_with("user://"):
		return clean
	return CLIENT_DATA_ROOT + "/" + clean
