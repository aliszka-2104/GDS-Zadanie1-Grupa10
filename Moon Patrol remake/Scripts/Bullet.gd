extends Area2D

enum BulletType{
	ENEMY,
	VERTICAL,
	HORIZONTAL
}

export (BulletType) var bulletType
var  speed = 100
var velocity = Vector2()
var canHit=true

func _ready():
	match bulletType:
		BulletType.ENEMY:
			velocity.y = Global.alienBulletSpeed
		BulletType.HORIZONTAL:
			velocity.x = Global.horizontalBulletSpeed
		BulletType.VERTICAL:
			velocity.y = -Global.verticalBulletSpeed
	
	
func _process(delta):
	translate(velocity*delta)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

#func _on_Bullet_body_entered(body):
#	var layer = body.get_collision_layer()
#	if(canHit and bulletType==BulletType.ENEMY and layer==1):
#		canHit=false
#		Global.player_death()
#		print(body)
#		queue_free()
