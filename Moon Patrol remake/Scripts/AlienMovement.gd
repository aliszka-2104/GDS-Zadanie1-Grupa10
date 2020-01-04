extends Area2D

export var distance = 1
export var speed = 1

var positionLeft
var positionRight

var movingLeft = true

func _ready():
	positionLeft = get_parent().get_node("PositionLeft")
	positionRight = get_parent().get_node("PositionRight")
	
func _physics_process(delta):
	if movingLeft and abs(position.x-positionLeft.position.x)<distance:
		movingLeft = false
	elif !movingLeft and abs(position.x-positionRight.position.x)<distance:
		movingLeft = true
	
	if movingLeft:
		position=position.linear_interpolate(positionLeft.position,delta*speed)
	else:
		position=position.linear_interpolate(positionRight.position,delta*speed)
	