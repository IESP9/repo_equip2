extends Node

# Komodo AI System
var komodo_ai_level = 0   # Default AI level (0-20)
var komodo_data = {
	"current_stage": 0,  # Stages 0-2
	"timer": 0,
	"move_interval": 5.0 + randf(),
	"animation_frame": 0,
	"should_be_visible": false,
	"attack_timer": 0.0,
	"defense_window": 0.0,
	"in_defense_window": false,
	"warning_played": false,
	"knock_played": false  # Nuevo campo para controlar el sonido de golpes
}

# Audio system
var audio_player: AudioStreamPlayer
var knock_player: AudioStreamPlayer  # Reproductor adicional para los golpes
const FOOTSTEPS_SOUND = preload("res://audio/pasos.mp3")
const KNOCK_SOUND = preload("res://audio/knock.mp3")  # Precarga el sonido


# Reference to the current komodo node
var komodo_node: AnimatedSprite2D = null

func _ready():
	randomize()
	# Initialize audio player
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = FOOTSTEPS_SOUND
	 # Initialize knock player
	knock_player = AudioStreamPlayer.new()
	add_child(knock_player)
	knock_player.stream = KNOCK_SOUND
	# Conectarse al singleton GlobalGame para detectar cambios
	GlobalGame.connect("ia_level_changed", Callable(self, "_on_ia_level_changed"))
	set_ai_level(GlobalGame.ia_levels["komodo"])

func _on_ia_level_changed(enemy_type: String, level: int):
	if enemy_type == "komodo":
		set_ai_level(level)

func set_ai_level(level: int) -> void:
	komodo_ai_level = clamp(level, 0, 20)
	print("Croc AI level set to: ", komodo_ai_level)

func _process(delta):
	_update_komodo(delta)
	
	# Only process if we're in the door scene
	if GlobalData.current_room == "door":
		_handle_komodo_flashlight(delta)
		_handle_komodo_defense(delta)
		
		# Update visibility based on flashlight
		if komodo_node:
			var flashlight_on = Input.is_key_pressed(KEY_CTRL)
			komodo_node.visible = komodo_data.should_be_visible and flashlight_on
			komodo_node.frame = komodo_data.animation_frame

func _update_komodo(delta):
	# This runs globally regardless of current scene
	komodo_data.timer += delta
	
	if komodo_data.timer >= komodo_data.move_interval:
		komodo_data.timer = 0
		komodo_data.move_interval = 5.0 + randf()
		
		if komodo_ai_level > 0:
			var roll = randi() % 20 + 1
			if roll <= komodo_ai_level:
				_move_komodo()

func _move_komodo():
	if komodo_data.current_stage < 2:  # Stages 0-2
		komodo_data.current_stage += 1
		_update_komodo_state()
		print("Komodo advanced to stage ", komodo_data.current_stage)
		
		if komodo_data.current_stage == 2:  # Start attack sequence
			komodo_data.attack_timer = 0.0
			komodo_data.defense_window = 0.0
			komodo_data.in_defense_window = false
			komodo_data.warning_played = false

func _handle_komodo_flashlight(_delta):
	if GlobalData.current_room != "door":
		return
	
	# No special flashlight behavior except visibility
	pass

func _handle_komodo_defense(delta):
	if GlobalData.current_room != "door" or komodo_data.current_stage != 2:
		return
	
	# Attack sequence has two phases:
	# 1. 4 second warning phase
	# 2. 5 second defense window (aumentado de 3 a 5 segundos)
	
	if not komodo_data.in_defense_window:
		komodo_data.attack_timer += delta
		
		# Reproducir sonido de pasos cuando quedan 5 segundos
		if komodo_data.attack_timer >= 1.0 and not komodo_data.warning_played:
			audio_player.play()
			komodo_data.warning_played = true
			print("DEFEND SOON! Pasos.mp3 playing...")
		
		if komodo_data.attack_timer >= 4.0:
			komodo_data.in_defense_window = true
			komodo_data.defense_window = 0.0
			komodo_data.knock_played = false  # Resetear estado de golpes
			print("DEFEND NOW! Hold SPACE for 5 seconds!")
	else:
		komodo_data.defense_window += delta
		var defending = Input.is_key_pressed(KEY_SPACE)
		
		 # Reproducir sonido de golpes cuando se está defendiendo
		if defending and not komodo_data.knock_played:
			knock_player.play()
			komodo_data.knock_played = true
			print("Knock sound playing - door being attacked!")
		
		if komodo_data.defense_window >= 5.0:  # Cambiado a 5 segundos
			if defending:
				# Successful defense
				komodo_data.current_stage = 0
				_update_komodo_state()
				audio_player.stop()
				knock_player.stop()
				print("Door defended! Komodo reset")
			else:
				# Failed defense
				_trigger_komodo_attack()
		elif not defending:
			# Released SPACE too early
			knock_player.stop()
			_trigger_komodo_attack()

func _update_komodo_state():
	match komodo_data.current_stage:
		0:  # Inactive but visible
			komodo_data.should_be_visible = true
			komodo_data.animation_frame = 0
		1:  # Active
			komodo_data.should_be_visible = true
			komodo_data.animation_frame = 1
		2:  # Attack sequence
			komodo_data.should_be_visible = true
			komodo_data.animation_frame = 1
	
	if komodo_node:
		komodo_node.frame = komodo_data.animation_frame

func _trigger_komodo_attack():
	audio_player.stop()
	knock_player.stop()
	print("Game Over - Komodo got you!")
	GlobalData.register_death("komodo")
	# get_tree().change_scene("res://game_over.tscn")

func register_komodo_node(node: AnimatedSprite2D):
	komodo_node = node
	_update_komodo_state()

func unregister_komodo_node():
	komodo_node = null

func set_komodo_ai_level(level):
	komodo_ai_level = clamp(level, 0, 20)
