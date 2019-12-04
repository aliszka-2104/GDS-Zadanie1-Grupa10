extends KinematicBody2D

var velocity=Vector2(1,0);
export var speed = 250;
export var slowDownSpeed = 100;
export var speedUpSpeed =300;

func get_input():
	if Input.is_action_pressed("speed_up"):
		speed=speedUpSpeed
	if Input.is_action_pressed("slow_down"):
		speed=slowDownSpeed
	velocity=velocity.normalized()*speed;

func _physics_process(delta):
	get_input()
	move_and_collide(velocity*delta)
	
	