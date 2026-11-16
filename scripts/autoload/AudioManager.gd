extends Node
## AudioManager — Менеджер фоновой музыки и многоканальных звуковых эффектов (порт com.sound.SoundManager и SoundLibrary).
## Загружает и кеширует MP3 из res://assets/client_data/SFX_and_music/, поддерживает позиционное затухание по расстоянию.

const AUDIO_DIR: String = "res://assets/client_data/SFX_and_music"
const SFX_POOL_SIZE: int = 16
const MAX_HEARING_DISTANCE: float = 1200.0

## Громкость каналов (0.0 .. 1.0) — по умолчанию 20% при старте игры
var music_volume: float = 0.2:
	set(value):
		music_volume = clampf(value, 0.0, 1.0)
		music_muted = (music_volume <= 0.001)
		_update_music_player_volume()
		if not music_muted and _music_player != null and not _music_player.playing and not _current_music_name.is_empty() and _music_player.stream != null:
			_music_player.play()

var sfx_volume: float = 0.2:
	set(value):
		sfx_volume = clampf(value, 0.0, 1.0)
		sfx_muted = (sfx_volume <= 0.001)
		_update_sfx_players_volume()

var music_muted: bool = false:
	set(value):
		music_muted = value
		_update_music_player_volume()

var sfx_muted: bool = false:
	set(value):
		sfx_muted = value
		_update_sfx_players_volume()

## Кеш загруженных аудиопотоков: sound_name -> AudioStream
var _stream_cache: Dictionary = {}

## Плеер фоновой музыки
var _music_player: AudioStreamPlayer = null
var _current_music_name: String = ""

## Пул плееров для многоканальных SFX
var _sfx_pool: Array[AudioStreamPlayer] = []
var _sfx_pool_cursor: int = 0

## Таблица алиасов из SoundLibrary.as (короткое имя в коде -> имя файла без .mp3)
const SOUND_ALIASES: Dictionary = {
	"main menu music": "Glory_Glory_full_mix",
	"main_menu_music": "Glory_Glory_full_mix",
	"theme_1": "helmet_heroes_theme_1",
	"town_1": "town_music_1",
	"town_2": "town_music_2",
	"battle_1": "battle_music_1",
	"cave_1": "cave_music_1",
	"forest_1": "forest_music_1",
	"desert_1": "desert_music_1",
	"snow_1": "snow_music_1",
	"lava_1": "lava_music_1",
	"space_1": "space_music_1",
	"boss_1": "boss_music_1",
	"slash": "sword swoosh 1",
	"slash 2": "sword swoosh 2",
	"slash 3": "sword swoosh 3",
	"bow fire": "bow_fire",
	"magic swing": "magic swing",
	"hit": "quick hit",
	"item bought": "cash register",
	"cash register": "cash register",
	"stick break": "stick break",
	"sciFiExplosion": "Sci Fi Ring Explosion",
	"lightBeam": "light beam",
	"thunder": "Thunder_Booming_SE",
	"electric": "electric zap"
}


func _ready() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.name = "MusicPlayer"
	_music_player.bus = "Master"
	add_child(_music_player)

	for i: int in range(SFX_POOL_SIZE):
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		player.name = "SFXPlayer_%d" % i
		player.bus = "Master"
		add_child(player)
		_sfx_pool.append(player)

	_update_music_player_volume()


## Воспроизводит фоновую музыку (с зацикливанием).
func play_music(music_name: String, force_restart: bool = false, volume_scale: float = 1.0) -> void:
	if music_name.is_empty():
		stop_music()
		return

	var resolved_name: String = _resolve_sound_name(music_name)
	if _current_music_name == resolved_name and _music_player.playing and not force_restart:
		return

	var stream: AudioStream = get_audio_stream(resolved_name, true)
	if stream == null:
		return

	_current_music_name = resolved_name
	_music_player.stream = stream
	_music_player.set_meta("track_scale", clampf(volume_scale, 0.0, 2.0))
	_update_music_player_volume()
	if not music_muted:
		_music_player.play()


func stop_music() -> void:
	_current_music_name = ""
	if _music_player != null and _music_player.playing:
		_music_player.stop()


## Воспроизводит звуковой эффект (непозиционный или с вычисленным коэффициентом громкости).
func play_sfx(sfx_name: String, volume_scale: float = 1.0, pitch_scale: float = 1.0) -> void:
	if sfx_muted or sfx_volume <= 0.001 or sfx_name.is_empty():
		return

	var resolved_name: String = _resolve_sound_name(sfx_name)
	var stream: AudioStream = get_audio_stream(resolved_name, false)
	if stream == null:
		return

	var player: AudioStreamPlayer = _acquire_sfx_player()
	var effective_linear: float = clampf(sfx_volume * volume_scale, 0.0, 2.0)
	player.stream = stream
	player.set_meta("volume_scale", volume_scale)
	player.volume_db = linear_to_db(maxf(0.0001, effective_linear))
	player.pitch_scale = maxf(0.1, pitch_scale)
	player.play()


## Воспроизводит позиционный SFX относительно координат камеры/игрока (как в SoundManager.playPositionalSound).
func play_positional_sfx(sfx_name: String, source_pos: Vector2, listener_pos: Vector2, base_volume: float = 1.0, pitch_scale: float = 1.0) -> void:
	if sfx_muted or sfx_volume <= 0.001:
		return
	var dist: float = source_pos.distance_to(listener_pos)
	if dist >= MAX_HEARING_DISTANCE:
		return
	var attenuation: float = 1.0 - (dist / MAX_HEARING_DISTANCE)
	play_sfx(sfx_name, base_volume * attenuation, pitch_scale)


## Загружает MP3-файл из SFX_and_music/ (работает как с импортированными ресурсами, так и напрямую с байтами MP3).
func get_audio_stream(sound_name: String, loop: bool = false) -> AudioStream:
	var cache_key: String = "%s::%s" % [sound_name, "loop" if loop else "once"]
	if _stream_cache.has(cache_key):
		return _stream_cache[cache_key]

	var filename: String = sound_name if sound_name.to_lower().ends_with(".mp3") else "%s.mp3" % sound_name
	var search_subdirs: Array[String] = ["", "SFX", "gun sounds", "SFX/gun sounds", "SFX/enemy sounds"]
	for subdir: String in search_subdirs:
		var res_path: String = "%s/%s" % [AUDIO_DIR, filename] if subdir.is_empty() else "%s/%s/%s" % [AUDIO_DIR, subdir, filename]
		var global_path: String = ProjectSettings.globalize_path(res_path)

		if FileAccess.file_exists(global_path):
			var bytes: PackedByteArray = FileAccess.get_file_as_bytes(global_path)
			if not bytes.is_empty():
				var mp3: AudioStreamMP3 = AudioStreamMP3.new()
				mp3.data = bytes
				mp3.loop = loop
				_stream_cache[cache_key] = mp3
				return mp3

		if ResourceLoader.exists(res_path):
			var res: Resource = ResourceLoader.load(res_path)
			if res is AudioStreamMP3:
				var dup: AudioStreamMP3 = res.duplicate()
				dup.loop = loop
				_stream_cache[cache_key] = dup
				return dup
			elif res is AudioStream:
				_stream_cache[cache_key] = res
				return res

	push_warning("[AudioManager] Audio file not found: %s/%s" % [AUDIO_DIR, filename])
	return null


func _acquire_sfx_player() -> AudioStreamPlayer:
	for p: AudioStreamPlayer in _sfx_pool:
		if not p.playing:
			return p
	var chosen: AudioStreamPlayer = _sfx_pool[_sfx_pool_cursor]
	_sfx_pool_cursor = (_sfx_pool_cursor + 1) % _sfx_pool.size()
	return chosen


func _resolve_sound_name(raw_name: String) -> String:
	var clean: String = raw_name.strip_edges()
	if clean.to_lower().ends_with(".mp3"):
		clean = clean.substr(0, clean.length() - 4)
	if SOUND_ALIASES.has(clean):
		return SOUND_ALIASES[clean]
	return clean


func set_music_volume(value: float) -> void:
	music_volume = value


func set_sfx_volume(value: float) -> void:
	sfx_volume = value


func _update_music_player_volume() -> void:
	if _music_player == null:
		return
	if music_muted or music_volume <= 0.001:
		_music_player.volume_db = -80.0
	else:
		var track_scale: float = float(_music_player.get_meta("track_scale", 1.0))
		_music_player.volume_db = linear_to_db(maxf(0.0001, music_volume * track_scale))


func _update_sfx_players_volume() -> void:
	for p: AudioStreamPlayer in _sfx_pool:
		if not is_instance_valid(p):
			continue
		if sfx_muted or sfx_volume <= 0.001:
			p.volume_db = -80.0
		else:
			var v_scale: float = float(p.get_meta("volume_scale", 1.0))
			p.volume_db = linear_to_db(maxf(0.0001, clampf(sfx_volume * v_scale, 0.0, 2.0)))
