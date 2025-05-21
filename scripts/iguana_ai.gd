extends Node

# Iguana AI System
var iguana_ai_level = 0  # Default AI level (0-20)
var iguana_data = {
	"current_stage": 0,  # 0=inactiva, 1=apagón, 2=ataque
	"timer": 0,
	"move_interval": 10.0 + randf() * 10.0,
	"lights_out_timer": 0.0,
	"attack_timer": 0.0,
	"attack_duration": 0.0
}

# Audio
var audio_player: AudioStreamPlayer
var powerout_sound = preload("res://audio/powerout.mp3")
var static_sound = preload("res://audio/static.mp3")
var darkness_layer: ColorRect
var canvas_layer: CanvasLayer
const DARKNESS_COLOR = Color(0, 0, 0, 0.9)

func _ready():
	randomize()
	# Configurar el reproductor de audio
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	_setup_darkness_layer()
	
	# Conectar señales de GlobalGame
	GlobalGame.connect("ia_level_changed", Callable(self, "_on_ia_level_changed"))
	set_ai_level(GlobalGame.ia_levels["iguana"])

func _setup_darkness_layer():
	# Capa CanvasLayer para asegurar que esté encima de todo
	canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100  # Valor alto para prioridad
	get_tree().root.add_child(canvas_layer)
	
	# ColorRect que cubre toda la pantalla
	darkness_layer = ColorRect.new()
	darkness_layer.color = DARKNESS_COLOR
	darkness_layer.size = get_viewport().size
	darkness_layer.visible = false
	canvas_layer.add_child(darkness_layer)

func _on_ia_level_changed(enemy_type: String, level: int):
	if enemy_type == "iguana":
		set_ai_level(level)

func set_ai_level(level: int) -> void:
	iguana_ai_level = clamp(level, 0, 20)
	print("Iguana AI level set to: ", iguana_ai_level)

func _process(delta):
	_update_iguana(delta)
	if darkness_layer:
		darkness_layer.size = get_viewport().size

func _update_iguana(delta):
	iguana_data.timer += delta
	if darkness_layer:
		darkness_layer.size = get_viewport().size  # Ajustar tamaño continuamente
	
	# Activación
	if iguana_data.timer >= iguana_data.move_interval and iguana_data.current_stage == 0:
		iguana_data.timer = 0
		iguana_data.move_interval = 10.0 + randf() * 10.0
		
		if iguana_ai_level > 0:
			var roll = randi() % 20 + 1
			if roll <= iguana_ai_level:
				_activate_iguana()

	# Fase de apagón
	if iguana_data.current_stage == 1:
		iguana_data.lights_out_timer += delta
		
		if iguana_data.lights_out_timer >= 5.0:
			iguana_data.current_stage = 2
			iguana_data.attack_duration = 5.0 + min(randf() * 15.0, randf() * 10.0)
			_play_sound(static_sound)  # Sonido de estática al comenzar el ataque
			print("¡Fase de ataque! Tienes ", iguana_data.attack_duration, " segundos para llegar al closet.")

	# Fase de ataque
	if iguana_data.current_stage == 2:
		iguana_data.attack_timer += delta
		if iguana_data.attack_timer >= iguana_data.attack_duration:
			if GlobalData.current_room != "closet":
				_trigger_iguana_attack()
			else:
				_deactivate_iguana()

func _activate_iguana():
	iguana_data.current_stage = 1
	iguana_data.lights_out_timer = 0.0
	darkness_layer.visible = true  # Activar oscuridad
	_play_sound(powerout_sound)  # Sonido de apagón al activarse
	print("¡Apagón! La Iguana ha comenzado su evento.")

func _deactivate_iguana():
	iguana_data.current_stage = 0
	iguana_data.timer = 0
	darkness_layer.visible = false  # Restaurar luz
	audio_player.stop()  # Detener sonido al desactivarse
	print("¡Has sobrevivido al ataque de la Iguana!")

func _trigger_iguana_attack():
	GlobalData.register_death("iguana")
	iguana_data.current_stage = 0
	iguana_data.timer = 0
	darkness_layer.visible = false  # Restaurar luz al morir
	audio_player.stop()  # Detener sonido al morir
	print("¡Game Over! La Iguana te atrapó.")
	
	# get_tree().change_scene_to_file("res://game_over.tscn")

func _play_sound(sound: AudioStream):
	if audio_player.playing:
		audio_player.stop()
	audio_player.stream = sound
	audio_player.play()

func set_iguana_ai_level(level):
	iguana_ai_level = clamp(level, 0, 20)

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if canvas_layer and is_instance_valid(canvas_layer):
			canvas_layer.queue_free()
