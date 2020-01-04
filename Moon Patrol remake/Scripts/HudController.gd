extends Control

onready var current_score_label = $MarginContainer/HBoxContainer/Scores/Current/Value
onready var lives_label = $MarginContainer/HBoxContainer/Lives/Value
onready var death_popup = $Death

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Global_score_changed():
	current_score_label.text = "1P - " + str("%06d" %Global.totalPoints)
	pass # Replace with function body.


func _on_Global_lives_changed():
	lives_label.text = str(Global.lives)
	pass # Replace with function body.
