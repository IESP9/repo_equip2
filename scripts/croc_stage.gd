extends AnimatedSprite2D

func _ready():
	CrocAi.register_croc_node(self)

func _exit_tree():
	CrocAi.unregister_croc_node()
