extends Control

func _ready():
	# Configuraciones iniciales (opcional)
	pass



func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/room.tscn")
