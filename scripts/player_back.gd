extends Node2D

@onready var bed: AnimatedSprite2D = $"../../bed"  # Reference to AnimatedSprite2D
@onready var timer: Timer = $"../../Timer"  # Reference to main Timer
@onready var toggle_timer: Timer = Timer.new()  # Create a new Timer node for toggling

var is_interacting: bool = false  # Track if the player is interacting
var current_frame: int = 2  # Start with frame 4

func _ready():
	add_child(toggle_timer)  # Add the new Timer to the scene
	toggle_timer.wait_time = 0.5  # Adjust speed of toggling
	toggle_timer.timeout.connect(_on_toggle_timer_timeout)

# Start toggling between frames 4 and 5
func start_frame_2_3():
	if bed != null:
		timer.stop()  # Stop main timer to prevent switching back to 0-1
		is_interacting = true  # Set interaction flag
		toggle_timer.start()  # Start new timer for toggling frames
		bed.frame = current_frame
	else:
		print("Error: bed is null!")

# Stop toggling and keep the last frame
func stop_frame_2_3():
	if bed != null:
		is_interacting = false  # Reset interaction flag
		toggle_timer.stop()  # Stop the toggling timer
	else:
		print("Error: bed is null!")

# Function that toggles between 4 and 5
func _on_toggle_timer_timeout():
	if is_interacting and bed != null:
		current_frame = 3 if current_frame == 2 else 2  # Toggle frames
		bed.frame = current_frame

@onready var root_node: Node2D = get_parent()

func _input_event(viewport, event, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			start_frame_2_3()  # Start toggling frames 4 and 5
		else:
			stop_frame_2_3()  # Stop toggling
