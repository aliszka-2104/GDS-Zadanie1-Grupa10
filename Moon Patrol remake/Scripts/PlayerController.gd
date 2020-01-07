extends KinematicBody2D

var velocity = Vector2()
var jumping = false
var horBullet
const BULLET = preload("res://Scenes/Prefabs/Bullet.tscn")
const HORIZONTAL_BULLET = preload("res://Scenes/Prefabs/HorizontalBullet.tscn")
var bullets
var speedUp = false
var slowDown=false

func _ready():
	bullets = get_parent().get_node("HorizontalBullets")
	velocity.x=Global.base_speed

func get_input():
	
	var speed_up = Input.is_action_pressed('ui_right')
	var slow_down = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_up')
	var shoot = Input.is_action_just_pressed('ui_select')

	if jump and is_on_floor():
		jumping = true
		velocity.y = -Global.jump_speed
	if speed_up:
		speed_up()
	if slow_down:
		slow_down()
	if shoot:
		_shoot()

func speed_up():
	velocity.x += Global.speed_change_step
	velocity.x=clamp(velocity.x,Global.min_speed,Global.max_speed)

func slow_down():
	velocity.x -= Global.speed_change_step
	velocity.x=clamp(velocity.x,Global.min_speed,Global.max_speed)

func _physics_process(delta):
	if !Global.game_started or !Global.can_move:
		velocity.x=Global.base_speed
		velocity.y=0
		return
	get_input()
#
	velocity.y += Global.gravity * delta
	Global.current_speed=velocity.x
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
	if(layer==2):		#hole
		pass
	elif(layer==32):	#obstacle
		pass
	elif(layer==16):	#enemy projectile
		area.queue_free()
		death()

func death():
	
	Global.player_death()
	
	
	
	
	