extends Area2D

func _ready():
	# Conectar la señal de input_event
	self.connect("input_event", _on_input_event)
	
	# Configurar estado inicial
	get_node("../Ayuda").visible = false
	get_node("../background").visible = true

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Alternar visibilidad de Ayuda
		var ayuda = get_node("../Ayuda")
		ayuda.visible = not ayuda.visible
		
		# Alternar visibilidad de background (opuesto a Ayuda)
		var background = get_node("../background")
		background.visible = not ayuda.visible
