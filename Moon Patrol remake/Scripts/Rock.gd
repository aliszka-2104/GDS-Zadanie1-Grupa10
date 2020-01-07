extends Area2D

export (int)var hitPoints =100
export (int)var jumpOverPoints =80
onready var raycast = $RayCast2D
var canBeJumpedOver = true

const EXPLOSION = preload("res://Scenes/Prefabs/Explosions/BulletExplosion.tscn")

func _physics_process(delta):
	if raycast!=null and canBeJumpedOver and raycast.is_colliding():
		canBeJumpedOver = false
		Global.addPoints(jumpOverPoints)

func _on_Rock_area_entered(area):
	var layer = area.get_collision_layer()
	if(layer==1):
		canBeJumpedOver = false
		Global.player_death()
	elif(layer==8):
		area.queue_free()
		get_hit()
		
func get_hit():
	Global.drawExplosion(EXPLOSION,global_position)
	Global.addPoints(hitPoints)
	queue_free()
