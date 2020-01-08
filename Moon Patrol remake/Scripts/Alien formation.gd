extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal scene_entered
var player
var follow=false
var initial_position=Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Scene/Player")
	initial_position=global_position
	Global.connect("reload",self,"reload_formation")
	for child in get_children():
		connect("scene_entered",child,"on_scene_entered")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player!=null and follow:
		global_position.x = player.global_position.x
	pass
#	if !Global.game_started:
#		global_position=initial_position
#		follow=false

func reload_formation():
	global_position=initial_position
	follow=false

func _on_VisibilityNotifier2D_screen_entered():
	follow=true
	emit_signal("scene_entered")