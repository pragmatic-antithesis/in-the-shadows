extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_player: AudioStreamPlayer = $SoundEffectsPlayer

var audio_tween: Tween = null

var tracks: Dictionary = {
	"menu": load("res://assets/sounds/experimental-rift-wip-17676.mp3"),
	"selection": preload("res://assets/sounds/the-humming-song-22267.mp3"),
	"puzzle1": load("res://assets/sounds/old-vinyl-piano-song-14583.ogg"),
	"puzzle2": load("res://assets/sounds/african-percussion-297608.mp3")
}

var sounds: Dictionary = {
	"puzzle1": load("res://assets/sounds/glass_004.ogg"),
	"puzzle2": load("res://assets/sounds/gajah-220044.mp3")
}

func play_music(music_theme: String, delay_start: float = 0.0, fade_time: float = 1.8):
	if not tracks.has(music_theme):
		return

	if audio_tween:
		audio_tween.kill()
		audio_tween = null

	if delay_start > 0:
		await get_tree().create_timer(delay_start / 2.0).timeout

	if music_player.playing:
		var old_player := music_player
		var new_player := AudioStreamPlayer.new()
		new_player.bus = "Music"
		new_player.stream = tracks[music_theme]
		new_player.stream.loop = true
		add_child(new_player)

		new_player.volume_db = -80.0

		audio_tween = create_tween()
		audio_tween.tween_property(old_player, "volume_db", -80.0, fade_time)
		new_player.play()
		audio_tween.tween_property(new_player, "volume_db", 0.0, fade_time / 2.0)
		audio_tween.finished.connect(
			Callable(self, "_on_crossfade_finished").bind(old_player, new_player),
			Object.CONNECT_ONE_SHOT
		)
	else:
		music_player.stream = tracks[music_theme]
		music_player.stream.loop = true
		music_player.volume_db = 0
		music_player.play()
		if delay_start > 0:
			music_player.volume_db = -10.0
			audio_tween = create_tween()
			audio_tween.tween_property(music_player, "volume_db", 0.0, delay_start / 2.0)

func _on_crossfade_finished(old_player, new_player):
	if old_player:
		old_player.stop()
		old_player.queue_free()
		music_player = new_player
	else:
		push_error("tried calling crossfade finished on not player")


func play_sfx(sound_effect: String):
	if sounds.has(sound_effect):
		sfx_player.stream = sounds[sound_effect]
		sfx_player.play()
