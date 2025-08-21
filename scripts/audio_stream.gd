extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_player: AudioStreamPlayer = $SoundEffectsPlayer

var tracks: Dictionary = {
	"menu": preload("res://assets/sounds/experimental-rift-wip-17676.mp3"),
}

var sounds: Dictionary = {
	"puzzle1": load("res://assets/sounds/glass_004.ogg"),
	"puzzle2": load("res://assets/sounds/gajah-220044.mp3")
}

func play_music(music_theme: String, delay_start: float = 0.0, fade_time: float = 1.0):
	if not tracks.has(music_theme):
		return

	if delay_start > 0:
		await get_tree().create_timer(delay_start / 2.0).timeout

	if music_player.playing:
		var old_player := music_player
		var new_player := AudioStreamPlayer.new()
		new_player.bus = "Music"
		new_player.stream = tracks[music_theme]
		add_child(new_player)
		
		# Start new one at -80 dB (muted)
		new_player.volume_db = -80
		new_player.play()
		
		# Crossfade
		var t := create_tween()
		t.tween_property(old_player, "volume_db", -80.0, fade_time)
		t.tween_property(new_player, "volume_db", 0.0, fade_time)
		t.finished.connect(func():
			old_player.stop()
			old_player.queue_free()
			music_player = new_player
		)
	else:
		music_player.stream = tracks[music_theme]
		music_player.volume_db = 0
		music_player.play()
		if delay_start > 0:
			music_player.volume_db = -20.0
			var t := create_tween()
			t.tween_property(music_player, "volume_db", 0.0, delay_start / 2.0)


func play_sfx(sound_effect: String):
	if sounds.has(sound_effect):
		sfx_player.stream = sounds[sound_effect]
		sfx_player.play()
