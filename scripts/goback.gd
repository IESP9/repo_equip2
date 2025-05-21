extends Area2D

func _ready():
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

func _on_mouse_entered():
	if not GlobalData.active_goback:
		GlobalData.active_goback = true
		print("Changing scene...")
		get_tree().change_scene_to_file("res://scenes/room.tscn")

func _on_mouse_exited():
	print("Mouse exited, reset active_goback")
	GlobalData.active_goback = false
