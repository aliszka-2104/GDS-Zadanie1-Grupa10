extends Area2D

export (int)var jumpOverPoints =80
onready var raycast = $RayCast2D
var canBeJumpedOver = true

func _physics_process(delta):
	if raycast!=null and canBeJumpedOver and raycast.is_colliding():
		canBeJumpedOver = false
		Global.addPoints(jumpOverPoints)

func _on_Hole_area_entered(area):
	var layer = area.get_collision_layer()
	if(layer==1):
		canBeJumpedOver = false
		Global.player_death()
		