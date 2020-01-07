extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal scene_entered
var player
var follow=false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Scene/Player")
	for child in get_children():
		connect("scene_entered",child,"on_scene_entered")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player!=null and follow:
		global_position.x = player.global_position.x
	pass


func _on_VisibilityNotifier2D_screen_entered():
	follow=true
	emit_signal("scene_entered")