extends KinematicBody2D

var velocity = Vector2()
var jumping = false
var shooted=false
var horBullet
const BULLET = preload("res://Scenes/Prefabs/Bullet.tscn")
const HORIZONTAL_BULLET = preload("res://Scenes/Prefabs/HorizontalBullet.tscn")
var bullets

func _ready():
	bullets = get_parent().get_node("HorizontalBullets")

func get_input():
	velocity.x = Global.base_speed
	var speed_up = Input.is_action_pressed('ui_right')
	var slow_down = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_up')
	var shoot = Input.is_action_just_pressed('ui_select')

	if jump and is_on_floor():
		jumping = true
		velocity.y = -Global.jump_speed
	if speed_up:
		velocity.x += Global.speed_up_value
	if slow_down:
		velocity.x -= Global.slow_down_value
	if shoot:
		_shoot()

func _physics_process(delta):
	get_input()
	velocity.y += Global.gravity * delta
	if jumping and is_on_floor():
		jumping = false
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
func _shoot():
	var bullet = BULLET.instance()
	bullet.position=$VerticalBulletPosition2D.global_position
	get_parent().add_child(bullet)
	
	if bullets.get_child_count()>0:
		return
	horBullet = HORIZONTAL_BULLET.instance()
	horBullet.position=$HorizontalBulletPosition2D.global_position
	bullets.add_child(horBullet)
	
	

func _on_Area2D_area_entered(area):
	var layer = area.get_collision_layer()
	if(layer==2):
		print("dziura")
	elif(layer==32):
		print("pprzeszkadzajka")
