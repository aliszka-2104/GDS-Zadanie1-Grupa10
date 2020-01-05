extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal scene_entered
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		connect("scene_entered",child,"on_scene_entered")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VisibilityNotifier2D_screen_entered():
	emit_signal("scene_entered")