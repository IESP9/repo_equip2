extends Node2D

# Referencias a los elementos de UI
@onready var snake_level_label = $CanvasLayer/GridContainer/SnakeContainer/HBoxContainer/Label
@onready var croc_level_label = $CanvasLayer/GridContainer/CrocContainer/HBoxContainer/Label
@onready var komodo_level_label = $CanvasLayer/GridContainer/KomodoContainer/HBoxContainer/Label
@onready var iguana_level_label = $CanvasLayer/GridContainer/IguanaContainer/HBoxContainer/Label

# Niveles actuales
var current_levels = {
	"snake": 0,
	"croc": 0,
	"komodo": 0,
	"iguana": 0
}

func _ready():
	# Conectar botones
	$CanvasLayer/GridContainer/SnakeContainer/HBoxContainer/Button.pressed.connect(_on_snake_down)
	$CanvasLayer/GridContainer/SnakeContainer/HBoxContainer/Button2.pressed.connect(_on_snake_up)
	# Conectar los demás botones de manera similar...
	$CanvasLayer/GridContainer/CrocContainer/HBoxContainer/Button.pressed.connect(_on_croc_down)
	$CanvasLayer/GridContainer/CrocContainer/HBoxContainer/Button2.pressed.connect(_on_croc_up)

	$CanvasLayer/GridContainer/KomodoContainer/HBoxContainer/Button.pressed.connect(_on_komodo_down)
	$CanvasLayer/GridContainer/KomodoContainer/HBoxContainer/Button2.pressed.connect(_on_komodo_up)

	$CanvasLayer/GridContainer/IguanaContainer/HBoxContainer/Button.pressed.connect(_on_iguana_down)
	$CanvasLayer/GridContainer/IguanaContainer/HBoxContainer/Button2.pressed.connect(_on_iguana_up)
	
	$CanvasLayer/Play.pressed.connect(_on_start_game)
	
	# Actualizar labels iniciales
	_update_labels()

func _update_labels():
	snake_level_label.text = str(current_levels["snake"])
	croc_level_label.text = str(current_levels["croc"])
	komodo_level_label.text = str(current_levels["komodo"])
	iguana_level_label.text = str(current_levels["iguana"])

func _on_snake_down():
	current_levels["snake"] = max(0, current_levels["snake"] - 1)
	_update_labels()

func _on_snake_up():
	current_levels["snake"] = min(20, current_levels["snake"] + 1)
	_update_labels()

# Añadir funciones similares para los otros enemigos...

func _on_croc_down():
	current_levels["croc"] = max(0, current_levels["croc"] - 1)
	_update_labels()

func _on_croc_up():
	current_levels["croc"] = min(20, current_levels["croc"] + 1)
	_update_labels()


func _on_komodo_down():
	current_levels["komodo"] = max(0, current_levels["komodo"] - 1)
	_update_labels()

func _on_komodo_up():
	current_levels["komodo"] = min(20, current_levels["komodo"] + 1)
	_update_labels()


func _on_iguana_down():
	current_levels["iguana"] = max(0, current_levels["iguana"] - 1)
	_update_labels()

func _on_iguana_up():
	current_levels["iguana"] = min(20, current_levels["iguana"] + 1)
	_update_labels()

func _on_start_game():
	# Asigna los niveles usando el método set_ia_level
	GlobalGame.set_ia_level("snake", current_levels["snake"])
	GlobalGame.set_ia_level("croc", current_levels["croc"])
	GlobalGame.set_ia_level("komodo", current_levels["komodo"])
	GlobalGame.set_ia_level("iguana", current_levels["iguana"])
	
	# Guarda los niveles en una variable global accesible
	GlobalGame.ia_levels = current_levels.duplicate()  # Esto asegura una copia independiente
	
	# Configuración inicial del juego
	GlobalGame.game_settings["ias_activas"] = true
	GlobalGame.game_settings["hora_actual"] = 22.0
	
	# Cambio de escena
	get_tree().change_scene_to_file("res://scenes/room.tscn")
