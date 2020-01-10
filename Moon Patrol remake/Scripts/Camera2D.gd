extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player
var offset_position
var prev_speed_offset=0
var camera_speed=10
var pos_y
var t=0
# Called when the node enters the scene tree for the first time.
#func _ready():
#	player = get_node("../Player")
#	offset_position= position.x-player.position.x
#
#func _physics_process(delta):
#	var relative_speed = Global.current_speed-Global.min_speed
#	var speed_change = relative_speed/Global.speed_amplitude
#	var speed_offset = get_viewport().size.x/2*speed_change
#	var speed_offset_change = prev_speed_offset-speed_offset
#	prev_speed_offset=speed_offset
##	print(speed_offset_change)
#	camera_speed=10
#	if speed_offset_change>0:
#		speed_offset=0
#		camera_speed=0.1
##	var newpos = Vector2(player.position.x+offset_position-speed_offset,position.y)
#	var newpos = Vector2(player.position.x+offset_position,position.y)
##	position = position.linear_interpolate(newpos,delta*camera_speed)
#	position = position.linear_interpolate(newpos,delta*10)

func _ready():
	player = get_parent()
	offset_position= position.x-player.position.x
	pos_y=global_position.y

func _physics_process(delta):
	var relative_speed = Global.current_speed-Global.min_speed
	var speed_change = relative_speed/Global.speed_amplitude
	var speed_offset = get_viewport().size.x/2*speed_change
	var speed_offset_change = prev_speed_offset-speed_offset
	prev_speed_offset=speed_offset
#	print(speed_offset_change)
	camera_speed=50
	var pos=offset_position-speed_offset
	t=0
	_move(delta,pos)
	
func _move(delta,pos):
	t+=delta*Global.camera_speed
#	if speed_offset_change>0:
#		speed_offset=0
#		camera_speed=0.1
#	var newpos = Vector2(player.position.x+offset_position-speed_offset,position.y)
	var newpos = Vector2(pos,position.y)
#	position = position.linear_interpolate(newpos,delta*camera_speed)
#	if newpos.x<position.x:
#		camera_speed=50
	position = position.linear_interpolate(newpos,delta*camera_speed)
#	position = position.linear_interpolate(newpos,t)
	global_position.y=pos_y
	