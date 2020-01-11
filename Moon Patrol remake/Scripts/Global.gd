extends Node2D

const verticalBulletSpeed = 3000
const horizontalBulletSpeed = 1500
const alienBulletSpeed = 400
const alienBulletDelayInSeconds = 5

const base_speed = 1000
const speed_change_step = 10
const speed_up_value = 500
const slow_down_value = 100
const jump_speed = 600
const gravity = 1000

const camera_speed=10

const LIVES = 3

const max_speed = base_speed+speed_up_value
const min_speed = base_speed-slow_down_value
const speed_amplitude = max_speed-min_speed
var current_speed = base_speed

var game_started = false
var can_move = true

var totalPoints
var lives
var current_checkpoint
var current_checkpoint_position

signal score_changed
signal lives_changed
signal checkpoint_changed
signal draw_summary
signal reload
var reload_game_timer = Timer.new()
var summary_timer = Timer.new()
var back_to_menu_timer = Timer.new()
var game_timer=0
var paused = true
var game_won = false

const EXPLOSION_TESLA = preload("res://Scenes/Prefabs/Explosions/TeslaExplosion.tscn")
const MAIN = preload("res://Scenes/Main.tscn")
var camera
var player
var bullets
var player_start_pos=Vector2()
var alienPositionsNode
var alienPositions=[]
var alienPositionsIsFree=[]

onready var summary = $"CanvasLayer/Summary"
onready var game_over_label = $"CanvasLayer/Game over"
onready var you_win_label = $"CanvasLayer/You win!"

var placeholdersDictionary = {}


func _ready():
	randomize()
	placeholdersDictionary["ground1024"] = preload("res://Scenes/Prefabs/Ground.tscn")
	placeholdersDictionary["ground1_1024"] = preload("res://Scenes/Prefabs/Ground2.tscn")
	
	player = get_node("/root/Scene/Player")
	camera = get_node("/root/Scene/Player/Camera2D")
	bullets = get_node("/root/Scene/Bullets")
	alienPositionsNode=  get_node("/root/Scene/Player/Camera2D/AlienPositions").get_children()
	
	if(player):
		current_checkpoint_position=player.global_position.x
	
	add_child(reload_game_timer)
	add_child(summary_timer)
	add_child(back_to_menu_timer)
	reload_game_timer.connect("timeout",self,"reload_game")
	summary_timer.connect("timeout",self,"hide_summary")
	back_to_menu_timer.connect("timeout",self,"back_to_menu")
	
	if(player):
		player_start_pos.y=player.global_position.y
	
	set_parameters()

func new_game():
	paused=true
	get_node("CanvasLayer/Menu").visible=true
	game_over_label.visible=false
	you_win_label.visible=false
	get_tree().reload_current_scene()
	set_parameters()

func set_parameters():
	
	lives=LIVES
	current_checkpoint=""
	game_started = false
	can_move = true
	game_won=false
	game_timer=0
	totalPoints=0
	current_speed=base_speed
	bullets = get_node("/root/Scene/Bullets")
	
	alienPositions.clear()
	alienPositionsIsFree.clear()
	
	for i in range(0,get_node("/root/Scene/Player/Camera2D/AlienPositions").get_children().size()):
		alienPositions.append(get_node("/root/Scene/Player/Camera2D/AlienPositions").get_children()[i].position)
		alienPositionsIsFree.append(true)
	
	emit_signal("score_changed")
	emit_signal("lives_changed")
	emit_signal("checkpoint_changed")
	
	pass

func get_free_position():
	var i = alienPositionsIsFree.find(true)
	alienPositionsIsFree[i]=false
	return alienPositions[i]

func free_position(pos):
	var i = alienPositions.find(pos)
#	if i<0:
#		return
	alienPositionsIsFree[i]=true

func _physics_process(delta):
	if Input.is_action_just_pressed("help"):
		help()
	if !paused and Input.is_action_just_pressed("ui_right"):
		game_started=true
	if game_started:
		game_timer+=delta

func help():
	lives+=1
	emit_signal("lives_changed")

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
	get_node("/root/Scene/Temporary holes").get_children().clear()
	get_node("/root/Scene/Bullets").get_children().clear()
	
	emit_signal("reload")
	pass
	
func game_over():
	game_over_label.visible=true
	back_to_menu_timer.start(3)

func back_to_menu():
	back_to_menu_timer.stop()
	new_game()

func victory():
	game_started=false
	paused=true
	can_move=false
	back_to_menu_timer.start(3)
	you_win_label.visible=true

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
		if checkpoint.end_game:
			game_won=true
		
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
	if game_won:
		victory()
	
	
