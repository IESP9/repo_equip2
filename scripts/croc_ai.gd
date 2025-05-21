extends Node

# Croc AI System
var croc_ai_level = 0  # Default AI level (0-20)
var croc_data = {
	"current_stage": 0,  # Stages 0-3 (0 is inactive)
	"timer": 0,
	"move_interval": 5.0 + randf(),
	"animation_frame": 0,
	"should_be_visible": false,
	"flashlight_timer": 0.0,
	"door_timer": 0.0
}

# Reference to the current croc node
var croc_node: AnimatedSprite2D = null

var audio_player: AudioStreamPlayer
const LIGHTNING_SOUND = preload("res://audio/lightning.mp3")

func _ready():
	randomize()
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = LIGHTNING_SOUND
	
	# Conectarse al singleton GlobalGame para detectar cambios
	GlobalGame.connect("ia_level_changed", Callable(self, "_on_ia_level_changed"))
	set_ai_level(GlobalGame.ia_levels["croc"])

func _on_ia_level_changed(enemy_type: String, level: int):
	if enemy_type == "croc":
		set_ai_level(level)

func set_ai_level(level: int) -> void:
	croc_ai_level = clamp(level, 0, 20)
	print("Croc AI level set to: ", croc_ai_level)

func _process(delta):
	_update_croc(delta)
	
	# Only process inputs if we're in the window scene
	if GlobalData.current_room == "window":
		_handle_croc_flashlight(delta)
		_handle_croc_door(delta)
		
		# Update visibility based on flashlight
		if croc_node:
			var flashlight_on = Input.is_key_pressed(KEY_CTRL)
			croc_node.visible = croc_data.should_be_visible and flashlight_on
			
			# Immediate game over if flashlight is on during stage 3 (attack)
			if croc_data.current_stage == 3 and flashlight_on:
				_trigger_croc_attack()

func _play_stage_sound():
	if audio_player.playing:
		audio_player.stop()
	audio_player.play()

func _update_croc(delta):
	# This runs globally regardless of current scene
	croc_data.timer += delta
	
	if croc_data.timer >= croc_data.move_interval:
		croc_data.timer = 0
		croc_data.move_interval = 5.0 + randf()
		
		if croc_ai_level > 0:
			var roll = randi() % 20 + 1
			if roll <= croc_ai_level:
				_move_croc()

func _move_croc():
	if croc_data.current_stage < 3:  # Stages 0-3
		var previous_stage = croc_data.current_stage
		croc_data.current_stage += 1
		
		# Play sound only when advancing to a new stage (not when regressing)
		if croc_data.current_stage > previous_stage:
			_play_stage_sound()
		
		_update_croc_state()
		print("Croc advanced to stage ", croc_data.current_stage)
		
		if croc_data.current_stage == 3:  # Stage 3 is attack
			_trigger_croc_attack()

func _handle_croc_flashlight(delta):
	if GlobalData.current_room != "window":
		return
	
	var flashlight_on = Input.is_key_pressed(KEY_CTRL)
	
	# Only affects stage 2 (visible)
	if flashlight_on and croc_data.current_stage == 2:
		croc_data.flashlight_timer += delta
		if croc_data.flashlight_timer >= 4.0:
			croc_data.current_stage = max(1, croc_data.current_stage - 1)  # Can't go below stage 1
			croc_data.flashlight_timer = 0.0
	else:
		croc_data.flashlight_timer = 0.0

func _handle_croc_door(delta):
	if GlobalData.current_room != "window":
		return
	
	# Only allow window closing when croc is at stage 2 (visible)
	if croc_data.current_stage != 2:
		croc_data.door_timer = 0.0
		return
	
	var window_closed = Input.is_key_pressed(KEY_SPACE)
	
	if window_closed:
		croc_data.door_timer += delta
		if croc_data.door_timer >= 4.0:  # 4 seconds to close window
			croc_data.current_stage = 0  # Reset to inactive
			croc_data.door_timer = 0.0
			_update_croc_state()
			print("Window secured! Croc reset to stage 0")
	else:
		croc_data.door_timer = 0.0

func _update_croc_state():
	match croc_data.current_stage:
		0:  # Inactive
			croc_data.should_be_visible = false
			croc_data.animation_frame = 0
		1:  # Moving but invisible
			croc_data.should_be_visible = false
			croc_data.animation_frame = 0
		2:  # Visible at window
			croc_data.should_be_visible = true
			croc_data.animation_frame = 0
		3:  # Attack position
			croc_data.should_be_visible = true
			croc_data.animation_frame = 1
	
	if croc_node:
		croc_node.frame = croc_data.animation_frame
		croc_node.visible = croc_data.should_be_visible and Input.is_key_pressed(KEY_CTRL)

func _trigger_croc_attack():
	print("Game Over - Croc got you!")
	GlobalData.register_death("croc")
	# get_tree().change_scene("res://game_over.tscn")

func register_croc_node(node: AnimatedSprite2D):
	croc_node = node
	_update_croc_state()

func unregister_croc_node():
	croc_node = null

func set_croc_ai_level(level):
	croc_ai_level = clamp(level, 0, 20)
