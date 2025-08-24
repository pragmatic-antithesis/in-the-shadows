extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_player: AudioStreamPlayer = $SoundEffectsPlayer

var audio_tween: Tween = null

var tracks: Dictionary = {
	"menu": load("res://assets/sounds/experimental-rift-wip-17676.mp3"),
	"selection": preload("res://assets/sounds/the-humming-song-22267.mp3"),
	"puzzle1": load("res://assets/sounds/old-vinyl-piano-song-14583.ogg"),
	"puzzle2": load("res://assets/sounds/african-percussion-297608.mp3"),
	"puzzle3": load("res://assets/sounds/Adventure.mp3"),
}

var sounds: Dictionary = {
	"puzzle1": load("res://assets/sounds/glass_004.ogg"),
	"puzzle2": load("res://assets/sounds/gajah-220044.mp3")
}

func play_music(music_theme: String, delay_start: float = 0.0, fade_time: float = 2.2):
	if not tracks.has(music_theme):
		return

	if audio_tween:
		audio_tween.kill()
		audio_tween = null

	if delay_start > 0:
		await get_tree().create_timer(delay_start / 2.0).timeout

	if music_player.playing:
		audio_tween = create_tween()
		audio_tween.tween_property(music_player, "volume_db", -80.0, fade_time)
		audio_tween.finished.connect(
			Callable(self, "_ready_to_play").bind(music_theme),
			Object.CONNECT_ONE_SHOT)
	else:
		_ready_to_play(music_theme)

func _ready_to_play(music_theme: String) -> void:
	music_player.stream = tracks[music_theme]
	music_player.volume_db = 0
	music_player.play()

func play_sfx(sound_effect: String) -> void:
	if sounds.has(sound_effect):
		sfx_player.stream = sounds[sound_effect]
		sfx_player.play()
