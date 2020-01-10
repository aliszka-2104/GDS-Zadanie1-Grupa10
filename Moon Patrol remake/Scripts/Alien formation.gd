extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal scene_entered
signal shoot_exploding
var shoot_timer=0
var shoot_delay=6
var player
var alienPositions
var alienBoundaryLeft
var alienBoundaryRight
var alienBoundaries
var follow=false
var initial_position=Vector2()
var multiplas=[]
var others=[]
var offset=Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	offset.x=get_viewport().size.x/2*2.4
	offset.y=get_viewport().size.y
	player = get_node("/root/Scene/Player/Camera2D")
	alienPositions = get_node("/root/Scene/Player/Camera2D/AlienPositions")
	alienBoundaryLeft = get_node("/root/Scene/Player/Camera2D/AlienBoundary/Left").position.x
	alienBoundaryRight = get_node("/root/Scene/Player/Camera2D/AlienBoundary/Right").position.x
	initial_position=global_position
	Global.connect("reload",self,"reload_formation")
	for child in get_children():
		if child.is_class("Position2D") or child.is_class("VisibilityNotifier2D") or child.is_class("Sprite"):
			continue
		if child.is_multipla():
			multiplas.push_front(child)
		else:
			others.push_front(child)
		connect("scene_entered",child,"on_scene_entered")
	global_position.y=player.global_position.y-offset.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player==null or !follow:
		return
	global_position.x = player.global_position.x-offset.x
	
	if multiplas.empty():
		return
	shoot_timer+=delta
	if shoot_timer>shoot_delay:
		shoot_timer=0
		var i=rand_range(0,multiplas.size())
		multiplas[i].canShoot=true
#	if !Global.game_started:
#		global_position=initial_position
#		follow=false

func reload_formation():
	global_position=initial_position
	global_position.y=player.global_position.y-offset.y
	follow=false
	shoot_timer=0

func _on_VisibilityNotifier2D_screen_entered():
	follow=true
	emit_signal("scene_entered")
	for child in others:
		var pos = Global.get_free_position()
		child.set_new_position(pos)
		child._move()
		child.move_to_position=true
	for child in multiplas:
		var pos = Global.get_free_position()
		child.set_new_position(pos)
		child._move()
		child.move_to_position=true