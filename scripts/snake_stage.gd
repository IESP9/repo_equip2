extends AnimatedSprite2D

func _ready():
	SnakeAi.register_snake_node(self)

func _exit_tree():
	SnakeAi.unregister_snake_node()
