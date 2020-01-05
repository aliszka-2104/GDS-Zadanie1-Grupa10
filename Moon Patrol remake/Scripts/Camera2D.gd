extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player
var offset_position
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../Player")
	offset_position= position.x-player.position.x

func _physics_process(delta):
	var relative_speed = Global.current_speed-Global.min_speed
	var speed_change = relative_speed/Global.speed_amplitude
	var speed_offset = get_viewport().size.x/2*speed_change
	position.x = player.position.x+offset_position