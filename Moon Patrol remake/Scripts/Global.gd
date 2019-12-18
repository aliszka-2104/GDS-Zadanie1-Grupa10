extends Node2D

var verticalBulletSpeed = 1000
var horizontalBulletSpeed = 1000
var base_speed = 500
var speed_up_value = 100
var slow_down_value = 100
var jump_speed = 500
var gravity = 1000

var placeholdersDictionary = {}

func _ready():
	placeholdersDictionary["hole"] = preload("res://Scenes/Prefabs/Hole.tscn")
	placeholdersDictionary["hole1"] = preload("res://Scenes/Prefabs/Hole1.tscn")