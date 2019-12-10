extends Area2D

export (int)var  speed = 100
var velocity = Vector2()

func _ready():
	speed = Global.horizontalBulletSpeed
	
func _process(delta):
	velocity.x=speed
	translate(velocity*delta)
	


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()