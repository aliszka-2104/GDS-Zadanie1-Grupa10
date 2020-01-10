extends Node2D

class_name Alien

export var hitPoints = 100
const BULLET = preload("res://Scenes/Prefabs/AlienBullet.tscn")
const EXPLODING_BULLET = preload("res://Scenes/Prefabs/AlienExplodingBullet.tscn")
const EXPLOSION = preload("res://Scenes/Prefabs/Explosions/AlienExplosion.tscn")
var timer = Timer.new()
var alien_bullet_delay = 2
var canShoot = false
var shouldMove = false
var player
var initial_position=Vector2()
var move_to_position=false
var new_position=Vector2()

enum EnemyType{
	PLATE,
	CUROSANT,
	MULTIPLA
}
export (EnemyType)var enemy_type

func set_new_position(pos):
	new_position=pos
	get_node("Body").calculate_curve()

func _move():
	position=new_position

func is_multipla():
	if enemy_type==EnemyType.MULTIPLA:
		return true
	return false

func _ready():
	Global.connect("reload",self,"on_level_reload")
	add_child(timer)
	timer.connect("timeout",self,"_on_timer_timeout")
	alien_bullet_delay = Global.alienBulletDelayInSeconds
	player = get_node("//root/Scene/Player")
	initial_position=position
	get_parent().connect("shoot_exploding",self,"on_shoot_exploding")
	
func _physics_process(delta):
	if !Global.game_started:
		return
		
	if move_to_position:
		_move()
		move_to_position=false
	_shoot()
	
func _shoot():
	if !canShoot:
		 return
	
	var bullet
	if enemy_type==EnemyType.MULTIPLA:
		bullet=EXPLODING_BULLET.instance()
	else:
		bullet = BULLET.instance()
	bullet.position=$Body/Position2D.global_position
	get_node("/root/Scene/Bullets").add_child(bullet)
	canShoot=false
	timer.start(alien_bullet_delay)
	
func _on_timer_timeout():
	if enemy_type==EnemyType.MULTIPLA:
		return
	canShoot=true

func on_scene_entered():
	print("start")
#	position=Global.camera.position+Vector2(500,0)
	shouldMove = true
	canShoot=true

func on_shoot_exploding():
	canShoot=true

func _on_Body_area_entered(area):
	var layer = area.get_collision_layer()
	if(layer==8):
		area.queue_free()
		get_hit()
		
func get_hit():
#	var explosion = EXPLOSION.instance()
#	explosion.global_position=global_position
#	get_tree().root.add_child(explosion)
	if enemy_type==EnemyType.MULTIPLA:
		var i = get_parent().multiplas.find(self)
		get_parent().multiplas.remove(i)
	else:
		var i = get_parent().others.find(self)
		get_parent().others.remove(i)
	Global.free_position(position)
	Global.addPoints(hitPoints)
	Global.drawExplosion(EXPLOSION,get_child(0).global_position)
	queue_free()
	
func on_level_reload():
	Global.free_position(position)
	position=initial_position
	get_node("Body").position=get_node("Body").pos