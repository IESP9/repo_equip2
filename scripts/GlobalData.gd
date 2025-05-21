extends Node
var frame_to_set = 0  # Default frame
var active_goback = false
var current_room = "main"  # Tracks which scene we're in
var killer_enemy: String = "none"  # Almacena qué enemigo te mató

# Señal para muerte
signal player_died(killer)

# Función para registrar muerte
func register_death(enemy_type: String):
	killer_enemy = enemy_type
	emit_signal("player_died", enemy_type)
	get_tree().change_scene_to_file("res://scenes/muerte.tscn")

func set_current_room(room_name):
	current_room = room_name
