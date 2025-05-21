extends AnimatedSprite2D

func _ready():
	KomodoAi.register_komodo_node(self)

func _exit_tree():
	KomodoAi.unregister_komodo_node()
