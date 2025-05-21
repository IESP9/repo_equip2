extends Node2D  # O CanvasLayer dependiendo de tu estructura

var death: AudioStreamPlayer
const Death = preload("res://audio/alarma.mp3")  # Precarga el sonido

func _ready():
	reset_all_ia_levels()
	death = AudioStreamPlayer.new()
	add_child(death)
	death.stream = Death
	death.play()
	# Añade un ColorRect que cubra toda la pantalla
	var flash = ColorRect.new()
	flash.color = Color.WHITE
	flash.size = get_viewport_rect().size
	add_child(flash)
	# Haz que desaparezca gradualmente
	create_tween().tween_property(flash, "color:a", 0.0, 0.5)
	var death_timer = Timer.new()
	death_timer.name = "DeathTimer"
	death_timer.wait_time = 5.0
	death_timer.timeout.connect(_return_to_title)
	add_child(death_timer)
	death_timer.start()
	GlobalData.killer_enemy = "none"

func reset_all_ia_levels():
	# Resetear todos los niveles de IA a 0
	GlobalGame.set_ia_level("snake", 0)
	GlobalGame.set_ia_level("croc", 0)
	GlobalGame.set_ia_level("komodo", 0)
	GlobalGame.set_ia_level("iguana", 0)


func _return_to_title():
	# Limpieza y cambio de escena
	if death.playing:
		death.stop()
	
	GlobalData.killer_enemy = "none"
	get_tree().change_scene_to_file("res://scenes/title.tscn")

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if death.playing:
			death.stop()
