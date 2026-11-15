extends Node2D

func change_shirt(index : int):
	$"BackArm".texture = load("res://assets/sprites/arms/arm_0" + str(index) + ".tres")
	$"FrontArm".texture = load("res://assets/sprites/arms/arm_0" + str(index) + ".tres")
	$"Torso".texture = load("res://assets/sprites/torsos/torso_0" + str(index) + ".tres")
func change_hair(index : int):
	$"Head2/Hair".texture = load("res://assets/sprites/hair/hair_0" + str(index) + ".tres")
func change_eyes(index : int):
	$"Head2/Eyes".texture = load("res://assets/sprites/eyes/eyes_0" + str(index) + ".tres")
func change_shoes(index : int):
	$"BackLeg/BackShoe".texture = load("res://assets/sprites/shoes/shoes_0" + str(index) + ".tres")
	$"FrontLeg/FrontShoe".texture = load("res://assets/sprites/shoes/shoes_0" + str(index) + ".tres")

func _ready() -> void:
	pass
