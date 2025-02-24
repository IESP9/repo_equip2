extends Node

var noche_actual = 1  # Valor predeterminado si no hay progreso guardado

func guardar_progreso(noche):
	var archivo = FileAccess.open("user://progreso.save", FileAccess.WRITE)
	archivo.store_var(noche)
	archivo.close()
	noche_actual = noche

func cargar_progreso():
	if FileAccess.file_exists("user://progreso.save"):
		var archivo = FileAccess.open("user://progreso.save", FileAccess.READ)
		noche_actual = archivo.get_var()
		archivo.close()
	return noche_actual
