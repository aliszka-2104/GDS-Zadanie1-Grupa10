extends KinematicBody2D

var velocity=Vector2(1,0);
var speed = 250;

func get_input():
	if Input.is_action_pressed("speed_up"):
		speed=300
	if Input.is_action_pressed("slow_down"):
		speed=100
	velocity=velocity.normalized()*speed;

func _physics_process(delta):
	get_input()
	move_and_collide(velocity*delta)
	
	