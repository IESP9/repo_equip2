extends Node

# Configuración del juego
var game_settings = {
	"ias_activas": false,
	"hora_actual": 0.0,  # 0-24 horas
	"duracion_noche": 12.0,  # 12 minutos reales = 6 horas de juego (22:00 a 6:00)
	"velocidad_tiempo": 1.0  # Ajustable para testing
}

# Niveles de IA para cada enemigo (configurables en menú)
var ia_levels = {
	"snake": 0,
	"croc": 0,
	"komodo": 0,
	"iguana": 0,
}

func _ready():
	randomize()
	process_mode = Node.PROCESS_MODE_ALWAYS  # Persistencia entre escenas

func _process(delta):
	if game_settings["ias_activas"]:
		_avanzar_tiempo(delta)
		_verificar_victoria()

func _avanzar_tiempo(delta):
	# Avanza el tiempo (12 minutos reales = 6 horas de juego)
	game_settings["hora_actual"] += delta * (6.0 / (12.0 * 60.0)) * game_settings["velocidad_tiempo"]
	
	# Reiniciar el ciclo de 24 horas
	if game_settings["hora_actual"] >= 24.0:
		game_settings["hora_actual"] = 0.0

func _verificar_victoria():
	# Verifica si ha llegado a las 6:00 AM (hora_actual >= 6.0 y estaba antes de 6:00)
	if game_settings["hora_actual"] >= 6.0 and game_settings["hora_actual"] - get_process_delta_time() < 6.0:
		_ganar_juego()

func _ganar_juego():
	print("¡Has sobrevivido la noche! Victoria")
	get_tree().change_scene_to_file("res://scenes/victoria.tscn")  # Asegúrate de crear esta escena
	game_settings["ias_activas"] = false  # Detener el juego

signal ia_level_changed(enemy_type: String, level: int)

func set_ia_level(enemy: String, level: int):
	if ia_levels.has(enemy):
		var clamped_level = clamp(level, 0, 20)
		if ia_levels[enemy] != clamped_level:
			ia_levels[enemy] = clamped_level
			emit_signal("ia_level_changed", enemy, clamped_level)

# Función para iniciar la noche
func comenzar_noche():
	game_settings["hora_actual"] = 22.0  # Comienza a las 10 PM
	game_settings["ias_activas"] = true
