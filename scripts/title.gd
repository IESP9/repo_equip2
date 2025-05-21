extends Node
# MusicManager.gd - Sistema mejorado de música de menú

var music_player: AudioStreamPlayer
var menu_music = preload("res://audio/menu.mp3")

func _ready():
	# Configurar el reproductor
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	# Configurar loop (para WAV/OGG)
	if menu_music is AudioStreamWAV or menu_music is AudioStreamOggVorbis:
		menu_music.loop = true
		
	music_player.stream = menu_music
	music_player.bus = "Music"
		
	# Conectar señales
	GlobalData.set_current_room("title")
		
	# Iniciar música si estamos en title
	if GlobalData.current_room == "title":
		_play_music()

func _play_music():
	if not music_player.playing:
		music_player.play()

func _stop_music():
	if music_player.playing:
		music_player.stop()

func _on_room_changed(new_room):
	match new_room:
		"title":
			_play_music()
		"main":
			_stop_music()
		_:
			_play_music()

func _notification(what):
	if what == NOTIFICATION_PREDELETE and is_instance_valid(music_player):
		music_player.queue_free()
