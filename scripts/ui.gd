extends Control

# Rutas de las escenas
const SCENE_PLAY = "res://scenes/warning.tscn"
const SCENE_CONTINUE_GAME = "res://scenes/continue_game.tscn"
const SCENE_SETTINGS = "res://scenes/settings.tscn"
const SCENE_EXTRAS = "res://scenes/extras.tscn"

@onready var play_button: Button = $play
@onready var continue_game_button: Button = $continue_game
@onready var settings_button: Button = $settings
@onready var extras_button: Button = $extras


func _ready():

	play_button.pressed.connect(_on_play_pressed)
	continue_game_button.pressed.connect(_on_continue_game_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	extras_button.pressed.connect(_on_extras_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file(SCENE_PLAY)

func _on_continue_game_pressed():
	get_tree().change_scene_to_file(SCENE_CONTINUE_GAME)  # Aquí luego se puede cargar el nivel guardado

func _on_settings_pressed():
	get_tree().change_scene_to_file(SCENE_SETTINGS)

func _on_extras_pressed():
	get_tree().change_scene_to_file(SCENE_EXTRAS)
