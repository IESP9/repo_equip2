extends Node2D

#var control
var left:bool = false
var right:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movcamera(left,right)
	pass


func movcamera(left:bool, right:bool):
	if left && $camera.position.x < 0:
		$camera.position.x -= 20
	if right && $camera.position.x < 283:
		$camera.position.x += 20

func _on_left_mouse_entered() -> void:
	left = true
	pass


func _on_left_mouse_exited() -> void:
	left = false
	pass 




func _on_right_mouse_entered() -> void:
	right  = true
	pass


func _on_right_mouse_exited() -> void:
	right  = false
	pass
