extends Node2D

export var hitPoints = 100
const BULLET = preload("res://Scenes/Prefabs/AlienBullet.tscn")
var timer = Timer.new()
var alien_bullet_delay = 2
var canShoot = true
var shouldMove = false
var player

func _ready():
	add_child(timer)
	timer.connect("timeout",self,"_on_timer_timeout")
	alien_bullet_delay = Global.alienBulletDelayInSeconds
	player = get_node("/root/Scene/Player")
	
func _physics_process(delta):
	if !Global.game_started:
		return
	_shoot()
	if shouldMove and player!=null:
		_move()

func _move():
	global_position.x = player.global_position.x
	
#	var distance = global_position.x - player.global_position.x
#	global_position.x = player.global_position.x+distance

func _shoot():
	if !canShoot:
		 return
	
	var bullet = BULLET.instance()
	bullet.position=$Body/Position2D.global_position
	get_tree().root.add_child(bullet)
	canShoot=false
	timer.start(alien_bullet_delay)
	
func _on_timer_timeout():
	canShoot=true

func _on_VisibilityNotifier2D_screen_entered():
	shouldMove = true


func _on_Body_area_entered(area):
	var layer = area.get_collision_layer()
	if(layer==8):
		area.queue_free()
		get_hit()
		
func get_hit():
	Global.addPoints(hitPoints)
	Global.drawExplosion(position)
	queue_free()
