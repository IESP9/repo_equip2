extends Node2D

@onready var timer: Timer = $Timer
@onready var bed: AnimatedSprite2D = $bed  # Correct path for AnimatedSprite2D

var current_frame: int = 0

func _ready() -> void:
	if bed == null:
		print("Error: bed is null!")
		return

	current_frame = 0  # Set the initial frame to 0 or 1 as needed
	bed.frame = current_frame
	timer.start()  # Start the timer

func _on_timer_timeout() -> void:
	current_frame = 1 - current_frame  # Toggle between 0 and 1
	bed.frame = current_frame
