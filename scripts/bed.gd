extends Area2D

@onready var vent = $vent

const TARGET_SCENE = "res://scenes/bed.tscn"

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		print('------ room._on_input_event')
		var target_frame = 2  # Define the frame to pass
		#var packed_data = {"frame": target_frame}  # Store data in a dictionary
		

		# Change to the new scene and pass the data
		get_tree().change_scene_to_file(TARGET_SCENE)

		# Store data in an autoload (singleton) or use a global variable
		GlobalData.frame_to_set = target_frame  # Requires a GlobalData autoload
		
			
	pass # Replace with function body.
