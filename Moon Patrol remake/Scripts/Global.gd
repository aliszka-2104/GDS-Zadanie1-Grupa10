extends Node2D

const verticalBulletSpeed = 3000
const horizontalBulletSpeed = 1500
const alienBulletSpeed = 1000
const alienBulletDelayInSeconds = 5

const base_speed = 1000
const speed_change_step = 10
const speed_up_value = 500
const slow_down_value = 500
const jump_speed = 500
const gravity = 1000

const camera_speed=10

const max_speed = base_speed+speed_up_value
const min_speed = base_speed-slow_down_value
const speed_amplitude = max_speed-min_speed
var current_speed=1000

var game_started = false
var can_move = true

var totalPoints=0
var lives = 5
var current_checkpoint = ""
var current_checkpoint_position

signal score_changed
signal lives_changed
signal checkpoint_changed
signal draw_summary
signal reload
var reload_game_timer = Timer.new()
var summary_timer = Timer.new()
var game_timer = 0
var paused = false

const EXPLOSION_TESLA = preload("res://Scenes/Prefabs/Explosions/TeslaExplosion.tscn")
var camera
var player
var player_start_pos=Vector2()
var alienPositionsNode
var alienPositions=[]
var alienPositionsIsFree=[]

onready var summary = $"CanvasLayer/Summary"
onready var game_over_label = $"CanvasLayer/Game over"

var placeholdersDictionary = {}


func _ready():
	randomize()
##	placeholdersDictionary["hole"] = preload("res://Scenes/Prefabs/Hole.tscn")
##	placeholdersDictionary["hole1"] = preload("res://Scenes/Prefabs/Hole1.tscn")
#	placeholdersDictionary["rock1"] = preload("res://Scenes/Prefabs/Rock1.tscn")
##	placeholdersDictionary["rock2"] = preload("res://Scenes/Prefabs/Rock2.tscn")
##	placeholdersDictionary["rock3"] = preload("res://Scenes/Prefabs/Rock3.tscn")
#	placeholdersDictionary["aliens"] = preload("res://Scenes/Prefabs/Alien.tscn")
#	placeholdersDictionary["mine"] = preload("res://Scenes/Prefabs/Mine.tscn")
	placeholdersDictionary["ground1024"] = preload("res://Scenes/Prefabs/Ground.tscn")
	placeholdersDictionary["ground1_1024"] = preload("res://Scenes/Prefabs/Ground2.tscn")
	player = get_node("/root/Scene/Player")
	camera = get_node("/root/Scene/Player/Camera2D")
	if(player):
		current_checkpoint_position=player.global_position.x
	add_child(reload_game_timer)
	add_child(summary_timer)
	reload_game_timer.connect("timeout",self,"reload_game")
	summary_timer.connect("timeout",self,"hide_summary")
	emit_signal("score_changed")
	emit_signal("lives_changed")
	if(player):
		player_start_pos.y=player.global_position.y
	
	alienPositionsNode=  get_node("/root/Scene/Player/Camera2D/AlienPositions").get_children()
	for i in range(0,alienPositionsNode.size()):
		alienPositions.append(alienPositionsNode[i].position)
		alienPositionsIsFree.append(true)

func get_free_position():
	var i = alienPositionsIsFree.find(true)
	alienPositionsIsFree[i]=false
	return alienPositions[i]

func free_position(pos):
	var i = alienPositions.find(pos)
	alienPositionsIsFree[i]=true

func _physics_process(delta):
	if !paused and Input.is_action_just_pressed("ui_right"):
		game_started=true
	if game_started:
		game_timer+=delta

func player_death():
	if !can_move:
		return
	game_started=false
	paused=true
	can_move=false
	lives-=1
	emit_signal("lives_changed")
	player = get_node("/root/Scene/Player")
	drawExplosion(EXPLOSION_TESLA,player.global_position)
	player.visible=false
	reload_game_timer.start(2)
	pass

func reload_checkpoint():
	print("reloading")
	player.visible=true
	can_move=true
	game_started=true
	paused=false
	player_start_pos.x=current_checkpoint_position
	player.position=player_start_pos
	for child in get_node("/root/Scene/Temporary holes").get_children():
		child.queue_free()
	emit_signal("reload")
	pass
	
func game_over():
	game_over_label.visible=true
	pass

func reload_game():
	reload_game_timer.stop()
	if lives>0:
		reload_checkpoint()
	else:
		game_over()
	pass
	
func addPoints(points):
	totalPoints+=points
	emit_signal("score_changed")
	
func drawExplosion(explosionType,targetPosition):
	var explosion = explosionType.instance()
	explosion.global_position=targetPosition
	get_tree().root.add_child(explosion)
	
func checkpoint_passed(checkpoint):
	if current_checkpoint==checkpoint.letter:
		return
	current_checkpoint=checkpoint.letter
	current_checkpoint_position=checkpoint.global_position.x
	emit_signal("checkpoint_changed")
	if checkpoint.is_summary:
		emit_signal("draw_summary",checkpoint)
		summary()
		
func summary():
	summary.visible=true
	game_started=false
	paused=true
	summary_timer.start(3)

func hide_summary():
	summary_timer.stop()
	game_timer=0
	print("hiding")
	summary.visible=false
	paused=false
	game_started=true
	
	
