extends Node2D

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

enum EnemyType{
	PLATE,
	CUROSANT,
	MULTIPLA
}
export (EnemyType)var enemy_type

func _ready():
	Global.connect("reload",self,"on_level_reload")
	add_child(timer)
	timer.connect("timeout",self,"_on_timer_timeout")
	alien_bullet_delay = Global.alienBulletDelayInSeconds
	player = get_node("//root/Scene/Player")
	initial_position=position
	
func _physics_process(delta):
	if !Global.game_started:
		return
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
	get_tree().root.add_child(bullet)
	canShoot=false
	timer.start(alien_bullet_delay)
	
func _on_timer_timeout():
	canShoot=true

func on_scene_entered():
	print("start")
	position=Global.camera.position+Vector2(500,0)
	shouldMove = true
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
	Global.addPoints(hitPoints)
	Global.drawExplosion(EXPLOSION,global_position)
	queue_free()
	
func on_level_reload():
	position=initial_position