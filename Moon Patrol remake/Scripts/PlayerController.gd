extends KinematicBody2D

export (int) var base_speed = 500
export (int) var speed_up_value = 100
export (int) var slow_down_value = 100
export (int) var jump_speed = 500
export (int) var gravity = 1000

var velocity = Vector2()
var jumping = false

func get_input():
    velocity.x = base_speed
    var speed_up = Input.is_action_pressed('speed_up')
    var slow_down = Input.is_action_pressed('slow_down')
    var jump = Input.is_action_just_pressed('ui_select')

    if jump and is_on_floor():
        jumping = true
        velocity.y = -jump_speed
    if speed_up:
        velocity.x += speed_up_value
    if slow_down:
        velocity.x -= slow_down_value

func _physics_process(delta):
    get_input()
    velocity.y += gravity * delta
    if jumping and is_on_floor():
        jumping = false
    velocity = move_and_slide(velocity, Vector2(0, -1))
	
	