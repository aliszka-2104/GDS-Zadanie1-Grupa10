extends Area2D

export var distance = 10
export var speed = .01

var positionLeft
var positionRight

var movingLeft = true
var moving = false
var t=0
var newpos
var offset=0

func _ready():
	positionLeft = get_parent().get_node("PositionLeft")
	positionRight = get_parent().get_node("PositionRight")
	newpos=position
	offset = get_parent().position.x-position.x
	
#func _physics_process(delta):
##	if !Global.game_started or !get_parent().shouldMove:
##		return
#
#	if abs(position.x-newpos.x)<distance:
#		var pos = rand_range(-5,5)*1000
#		pos = clamp(pos,0-offset,get_viewport_rect().size.x-offset)
#		pos*=2.4
#		newpos = Vector2(pos,position.y)
#		t=0
#
#	_move(delta,newpos)
		
#	if movingLeft and abs(position.x-positionLeft.position.x)<distance:
#		movingLeft = false
#	elif !movingLeft and abs(position.x-positionRight.position.x)<distance:
#		movingLeft = true
#
#	if movingLeft:
#		position=position.linear_interpolate(positionLeft.position,delta*speed)
#	else:
#		position=position.linear_interpolate(positionRight.position,delta*speed)

func _move(delta,newpos):
	t+=delta*speed
#	translate(newpos)
	position = position.linear_interpolate(newpos,t)
	
func _physics_process(delta):
	t+=delta*speed
	 position = curve.interpolate_baked(t * curve.get_baked_length(), true)
	