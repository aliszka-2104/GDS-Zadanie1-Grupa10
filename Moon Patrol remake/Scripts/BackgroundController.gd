extends Node2D

export (NodePath) var visibilityNotifierPath
onready var visibilityNotifier = get_node(visibilityNotifierPath)



func _on_VisibilityNotifier2D_screen_exited():
	print("exited")
	position = Vector2(position.x+ 3*get_viewport().size.x,position.y)
