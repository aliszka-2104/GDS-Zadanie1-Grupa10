extends Node2D

var speed = 250
var CircularMovement = Curve2D.new()
var r = 400
var r2 = 100
var pos
var bppos = 0

var started=false

var alienBoundaryLeft
var alienBoundaryRight

func _ready():
	alienBoundaryLeft = get_node("/root/Scene/Player/Camera2D/AlienBoundary/Left").position.x
	alienBoundaryRight = get_node("/root/Scene/Player/Camera2D/AlienBoundary/Right").position.x
	pos=position
	

func calculate_curve():
	if started:
		return
	started=true
	pos=position
	r=min(abs(alienBoundaryRight-get_parent().new_position.x),abs(alienBoundaryLeft-get_parent().new_position.x))
	print(r)
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