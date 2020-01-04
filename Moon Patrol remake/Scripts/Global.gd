extends Node2D

const verticalBulletSpeed = 3000
const horizontalBulletSpeed = 1000
const alienBulletSpeed = 3000
const alienBulletDelayInSeconds = 2

const base_speed = 500
const speed_up_value = 100
const slow_down_value = 100
const jump_speed = 500
const gravity = 1000

var game_started = false

var totalPoints=0
var lives = 2

signal score_changed
signal lives_changed

const EXPLOSION = preload("res://Scenes/Prefabs/Explosion.tscn")

var placeholdersDictionary = {}

func _ready():
	placeholdersDictionary["hole"] = preload("res://Scenes/Prefabs/Hole.tscn")
	placeholdersDictionary["hole1"] = preload("res://Scenes/Prefabs/Hole1.tscn")
	placeholdersDictionary["rock1"] = preload("res://Scenes/Prefabs/Rock1.tscn")
	placeholdersDictionary["rock2"] = preload("res://Scenes/Prefabs/Rock2.tscn")
	placeholdersDictionary["rock3"] = preload("res://Scenes/Prefabs/Rock3.tscn")
	placeholdersDictionary["aliens"] = preload("res://Scenes/Prefabs/Alien.tscn")
	placeholdersDictionary["mine"] = preload("res://Scenes/Prefabs/Mine.tscn")
	emit_signal("score_changed")
	emit_signal("lives_changed")

func _physics_process(delta):
	if !game_started and Input.is_action_just_pressed("ui_right"):
		game_started=true

func player_death():
	game_started=false
	lives-=1
	get_tree().reload_current_scene()
	emit_signal("lives_changed")
	pass
	
func addPoints(points):
	totalPoints+=points
	emit_signal("score_changed")
	
func drawExplosion(targetPosition):
	var explosion = EXPLOSION.instance()
	explosion.position=targetPosition
	get_tree().root.add_child(explosion)