extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player
var offsetPosition
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../Player")
	offsetPosition= position-player.position

func _physics_process(delta):
	position = player.position+offsetPosition