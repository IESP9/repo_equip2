extends Area2D

# Señal visual cuando el ratón entra/sale (opcional)
func _on_mouse_entered():
	scale = Vector2(1.1, 1.1)
	modulate = Color(1.2, 1.2, 1.2)

func _on_mouse_exited():
	scale = Vector2(1.0, 1.0)
	modulate = Color.WHITE

# Detección de clic
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			
			# Efecto visual (opcional)
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.1)
			tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
			
			# Acción principal
			_iniciar_juego()

func _iniciar_juego():
	get_tree().change_scene_to_file("res://scenes/config_menu.tscn")
