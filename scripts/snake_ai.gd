extends Node

# AI levels for each enemy (0-20)
var snake_ai_level = 0


# Enemy states and tracking
var enemy_data = {
	"snake": {
		"current_stage": 1,
		"target_scene": "vent",
		"timer": 0,
		"move_interval": 4.0 + randf(),
		"animation_frame": 0,
		"should_be_visible": false,
		"flashlight_timer": 0.0,
		"door_timer": 0.0
	}
	# Add other enemies...
}

# Reference to the current snake node
var snake_node: AnimatedSprite2D = null
var breath_player: AudioStreamPlayer
const BREATH_SOUND = preload("res://audio/breath.mp3")

func _ready():
	randomize()
	breath_player = AudioStreamPlayer.new()
	add_child(breath_player)
	breath_player.stream = BREATH_SOUND
	# Configurar el loop en el stream, no en el player
	breath_player.stream.loop = true
	# Conectarse al singleton GlobalGame para detectar cambios
	GlobalGame.connect("ia_level_changed", Callable(self, "_on_ia_level_changed"))
	set_ai_level(GlobalGame.ia_levels["snake"])

func _on_ia_level_changed(enemy_type: String, level: int):
	if enemy_type == "snake":
		set_ai_level(level)

func set_ai_level(level: int) -> void:
	snake_ai_level = clamp(level, 0, 20)
	print("Croc AI level set to: ", snake_ai_level)

func _process(delta):
	_update_snake(delta)
	
	# Verificar si estamos en vent y snake está en stage 5
	if GlobalData.current_room == "vent":
		_handle_flashlight(delta)
		_handle_door(delta)
		
		# Update visibility based on flashlight
		if snake_node:
			var flashlight_on = Input.is_key_pressed(KEY_CTRL)
			snake_node.visible = enemy_data.snake.should_be_visible and flashlight_on
			
			if enemy_data.snake.current_stage == 5 and flashlight_on:
				_trigger_game_over()
		
		# Esta es la parte nueva que soluciona el problema
		if enemy_data.snake.current_stage == 5:
			_play_breath_sound()  # Intenta reproducir cada frame mientras estemos en vent
	else:
		_stop_breath_sound()  # Detener si salimos de vent

func _update_snake(delta):
	# This runs globally regardless of current scene
	var snake = enemy_data.snake
	snake.timer += delta
	
	if snake.timer >= snake.move_interval:
		snake.timer = 0
		snake.move_interval = 4.0 + randf()
		
		if snake_ai_level > 0:
			var roll = randi() % 20 + 1
			if roll <= snake_ai_level:
				_move_snake()

func _move_snake():
	var snake = enemy_data.snake
	if snake.current_stage < 6:
		snake.current_stage += 1
		_update_snake_state()
		print("Snake advanced to stage ", snake.current_stage)
		
		if snake.current_stage == 6:
			_trigger_game_over()

func _handle_flashlight(delta):
	if GlobalData.current_room != "vent":
		return
	
	var snake = enemy_data.snake
	var flashlight_on = Input.is_key_pressed(KEY_CTRL)
	
	if flashlight_on and snake.current_stage >= 2 and snake.current_stage <= 4:
		snake.flashlight_timer += delta
		if snake.flashlight_timer >= 4.0:
			snake.current_stage = max(2, snake.current_stage - 1)
			snake.flashlight_timer = 0.0
			_update_snake_state()
			print("Snake pushed back to stage ", snake.current_stage)
	else:
		snake.flashlight_timer = 0.0

func _handle_door(delta):
	if GlobalData.current_room != "vent":
		return
	
	var snake = enemy_data.snake
	# Only allow door closing when snake is at stage 5
	if snake.current_stage != 5:
		snake.door_timer = 0.0  # Reset timer if not at stage 5
		return
	
	var door_closed = Input.is_key_pressed(KEY_SPACE)
	
	if door_closed:
		snake.door_timer += delta
		if snake.door_timer >= 3.0 + randf() * 2.0:  # 3-5 seconds
			snake.current_stage = 1
			snake.door_timer = 0.0
			_update_snake_state()
			print("Door closed! Snake reset to stage 1")
	else:
		snake.door_timer = 0.0

func _update_snake_state():
	var snake = enemy_data.snake
	
	match snake.current_stage:
		1:  # Not active
			snake.should_be_visible = false
			snake.animation_frame = 0
			_stop_breath_sound()
		2:  # Active but hidden
			snake.should_be_visible = false
			snake.animation_frame = 0
			_stop_breath_sound()
		3:  # Visible frame 0
			snake.should_be_visible = true
			snake.animation_frame = 0
			_stop_breath_sound()
		4:  # Visible frame 1
			snake.should_be_visible = true
			snake.animation_frame = 1
			_stop_breath_sound()
		5:  # Attack position
			snake.should_be_visible = true
			snake.animation_frame = 1
			_play_breath_sound()
	
	if snake_node:
		snake_node.frame = snake.animation_frame

func _play_breath_sound():
	if not breath_player.playing and breath_player.stream != null:
		breath_player.play()
		print("Reproduciendo sonido de respiración")  # Debug

func _stop_breath_sound():
	if breath_player.playing:
		breath_player.stop()

func register_snake_node(node: AnimatedSprite2D):
	snake_node = node
	_update_snake_state()

func unregister_snake_node():
	snake_node = null

func _trigger_game_over():
	_stop_breath_sound()
	print("Game Over - Snake got you!")
	GlobalData.register_death("snake")
	# get_tree().change_scene("res://game_over.tscn")
