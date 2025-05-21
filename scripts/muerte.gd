extends Node2D  # O CanvasLayer dependiendo de tu estructura

@onready var death_label = $DeathLabel  # Asegúrate de tener un Label en la escena
var death: AudioStreamPlayer
const Death = preload("res://audio/jumpscare.mp3")  # Precarga el sonido

func _ready():
	reset_all_ia_levels()
	death = AudioStreamPlayer.new()
	add_child(death)
	death.stream = Death
	death.play()
	# Añade un ColorRect que cubra toda la pantalla
	var flash = ColorRect.new()
	flash.color = Color.WHITE
	flash.size = get_viewport_rect().size
	add_child(flash)
	# Haz que desaparezca gradualmente
	create_tween().tween_property(flash, "color:a", 0.0, 0.5)
	
	# Mostrar qué enemigo mató al jugador
	match GlobalData.killer_enemy:
		"croc":
			death_label.text = "¡El cocodrilo te ha atrapado! Recuerda que después de que caigan dos rayos estará esperándote en la ventana, así que cierra la cortina para que se vaya"
		"snake":
			death_label.text = "¡La serpiente te envenenó! Si la serpiente hace ruido de respiración en la ventilación, ciérrale el paso y no enciendas la luz, ya que estará demasiado cerca"
		"iguana":
			death_label.text = "¡La iguana te encontró! Cuando se apaguen las luces escóndete antes de que te vea. Solo podrás salir cuando se haya ido"
		"komodo":
			death_label.text = "¡El dragón de Komodo te devoró! Cuando veas que el dragón de Komodo esté en alerta, en cualquier momento empezará a correr hacia ti, así que cierra la puerta antes de que llegue"
		_:
			death_label.text = "¡Has muerto!"
	var death_timer = Timer.new()
	death_timer.name = "DeathTimer"
	death_timer.wait_time = 5.0
	death_timer.timeout.connect(_return_to_title)
	add_child(death_timer)
	death_timer.start()
	GlobalData.killer_enemy = "none"

func reset_all_ia_levels():
	# Resetear todos los niveles de IA a 0
	GlobalGame.set_ia_level("snake", 0)
	GlobalGame.set_ia_level("croc", 0)
	GlobalGame.set_ia_level("komodo", 0)
	GlobalGame.set_ia_level("iguana", 0)


func _return_to_title():
	# Limpieza y cambio de escena
	if death.playing:
		death.stop()
	
	GlobalData.killer_enemy = "none"
	get_tree().change_scene_to_file("res://scenes/title.tscn")

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if death.playing:
			death.stop()
