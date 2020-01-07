extends Area2D

class_name Checkpoint

export var letter = "A"
export (bool)var is_summary = false
export (int)var time_to_reach=0

func _ready():
	$Label.text=letter
	pass


func _on_Checkpoint_body_exited(body):
	var layer = body.get_collision_layer()
	if(layer==1):
		Global.checkpoint_passed(self)
#		Global.checkpoint_passed(letter,global_position.x,is_summary,time_to_reach)
		
