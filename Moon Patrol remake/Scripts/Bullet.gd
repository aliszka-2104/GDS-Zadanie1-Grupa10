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
const ALIEN_BULLET_EXPLOSION = preload("res://Scenes/Prefabs/Explosions/AlienBulletExplodesOnGround.tscn")
const ALIEN_BULLET_HOLE = preload("res://Scenes/Prefabs/Explosions/AlienBulletMakesHole.tscn")
const BULLET_EXPLOSION = preload("res://Scenes/Prefabs/Explosions/BulletExplosion.tscn")
const HOLE = preload("res://Scenes/Prefabs/Level design/Obstacles/Hole.tscn")

func _ready():
	match bulletType:
		BulletType.ENEMY:
			velocity.y = Global.alienBulletSpeed
			randomize()
			velocity.x=rand_range(1,3)*1000
		BulletType.EXPLODING:
			velocity.y = Global.alienBulletSpeed
		BulletType.HORIZONTAL:
			velocity.x = Global.base_speed+Global.horizontalBulletSpeed
		BulletType.VERTICAL:
			velocity.y = -Global.verticalBulletSpeed
			velocity.x= Global.current_speed
	
	
func _process(delta):
	translate(velocity*delta)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_body_entered(body):
	var layer = body.get_collision_layer()
	if(canHit and bulletType==BulletType.ENEMY and layer==64):
		canHit=false
		Global.drawExplosion(ALIEN_BULLET_EXPLOSION,global_position)
		queue_free()
	if(canHit and bulletType==BulletType.EXPLODING and layer==64):
		canHit=false
		Global.drawExplosion(ALIEN_BULLET_HOLE,global_position)
		var hole = HOLE.instance()
		hole.global_position=global_position
		get_node("/root/Scene/Temporary holes").add_child(hole)
		queue_free()
