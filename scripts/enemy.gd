extends Node2D

@onready var enemy: Sprite2D = $"."  # Referencia al sprite del enemigo

# Posiciones donde puede aparecer el enemigo
var positions := [Vector2(10, 20), Vector2(30, 15), Vector2(50, 20)]

func _ready():
	enemy.visible = false  # El enemigo empieza invisible
	randomize()
	_schedule_next_appearance()

func _schedule_next_appearance():
	var wait_time = randf_range(0, 10)  # Espera entre 0 y 10 segundos
	await get_tree().create_timer(wait_time).timeout
	_show_enemy()

func _show_enemy():
	enemy.position = positions[randi() % positions.size()]  # Selecciona una posición aleatoria
	enemy.visible = true
	await get_tree().create_timer(0.3).timeout  # Espera 0.3 segundos
	enemy.visible = false
	_schedule_next_appearance()  # Programa la siguiente aparición
