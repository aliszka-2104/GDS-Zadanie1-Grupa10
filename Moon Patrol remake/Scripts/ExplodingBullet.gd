extends Area2D

enum BulletType{
	ENEMY,
	EXPLODING,
	VERTICAL,
	HORIZONTAL
}

export (BulletType) var bulletType
var  speed = 100
var velocity = Vector2()
var canHit=true
const ALIEN_BULLET_HOLE = preload("res://Scenes/Prefabs/Explosions/AlienBulletMakesHole.tscn")
const HOLE = preload("res://Scenes/Prefabs/Level design/Obstacles/HoleExplosion.tscn")
var holePosition
var myPos=0

func _ready():
#	velocity.y = Global.alienBulletSpeed
	holePosition=get_node("/root/Scene/Player/Camera2D/HolePosition")
	velocity=holePosition.global_position-global_position
	velocity.x+=Global.current_speed
	
func _physics_process(delta):
#	myPos += delta*speed
#	global_position = global_position.linear_interpolate(holePosition.position,myPos)
	translate(velocity*delta)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_body_entered(body):
	var layer = body.get_collision_layer()
	
	if(canHit and layer==64):
		canHit=false
		Global.drawExplosion(ALIEN_BULLET_HOLE,global_position)
		var hole = HOLE.instance()
		hole.global_position=global_position
		get_node("/root/Scene/Temporary holes").add_child(hole)
		queue_free()
