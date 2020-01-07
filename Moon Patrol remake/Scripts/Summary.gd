extends Control

onready var your_time_label = $"MarginContainer2/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Time/Your time"
onready var average_time_label = $"MarginContainer2/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Time/Average time"
onready var top_time_label = $"MarginContainer2/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Time/Top record"
onready var top_label = $MarginContainer2/MarginContainer/VBoxContainer/Label
onready var bonus_label = $"MarginContainer2/MarginContainer/VBoxContainer/Bonus label"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Global_draw_summary(checkpoint):
	top_label.text = "TIME TO REACH POINT \""+checkpoint.letter+"\""
	your_time_label.text = str("%03d"%floor(Global.game_timer))
	average_time_label.text = str("%03d"%checkpoint.time_to_reach)
	var bonus =1000
	if checkpoint.time_to_reach>floor(Global.game_timer):
		bonus += (checkpoint.time_to_reach-floor(Global.game_timer))*100
	bonus_label.text = "BONUS POINTS: "+str(bonus)
	Global.addPoints(bonus)
	pass # Replace with function body.
