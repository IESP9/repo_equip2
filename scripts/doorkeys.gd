extends AnimatedSprite2D

func _ready():
	set_frame(0)  # Default frame

func _process(delta):
	if Input.is_key_pressed(KEY_CTRL):
		set_frame(1)
	elif Input.is_key_pressed(KEY_SPACE):
		set_frame(2)
	else:
		set_frame(0)  # Revert to frame 1 when no key is pressed
