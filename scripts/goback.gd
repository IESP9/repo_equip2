extends Area2D

func _ready():
	connect("mouse_entered", _on_mouse_entered)

func _on_mouse_entered():
	get_tree().change_scene_to_file("res://scenes/room.tscn")  # Replace with your scene path
	print("adios")
