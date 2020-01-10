extends Node2D

var speed = 250
var CircularMovement = Curve2D.new()
var r = 400
var r2 = 100
var pos = Vector2(200,200)
var bppos = 0

func _ready():
	
	CircularMovement.add_point(pos+Vector2(r,0),Vector2(0,-r))
	CircularMovement.add_point(pos+Vector2(0,r2),Vector2(r,0))
	CircularMovement.add_point(pos+Vector2(-r,0),Vector2(0,r2))
	CircularMovement.add_point(pos+Vector2(0,-r2),Vector2(-r,0))
	CircularMovement.add_point(pos+Vector2(r,0),Vector2(0,-r2))
	CircularMovement.set_bake_interval(1)
	

func _physics_process(delta):
	if bppos + delta*speed >= CircularMovement.get_baked_points().size():
		bppos += delta*speed - CircularMovement.get_baked_points().size()
	else:
		position = CircularMovement.get_baked_points()[round(bppos)]
		bppos += delta*speed