extends Node2D

class_name FloatingItem

@export var movement_radius := 100.0
@export var movement_speed := 100.0
@export var float_amplitude := 10.0
@export var float_speed := 2.0

var origin: Vector2
var target: Vector2
var time := 0.0

@export var item_scene: PackedScene = null

func _ready():
	origin = global_position

	var item: Node = item_scene.instantiate()
	add_child(item)
	
	choose_target()

func _process(delta):
	time += delta

	global_position = global_position.move_toward(
		target,
		movement_speed * delta
	)

	if global_position.distance_to(target) < 5.0:
		choose_target()

	position.y += sin(time * float_speed) * float_amplitude * delta

func choose_target():
	target = origin + Vector2(
		randf_range(-movement_radius, movement_radius),
		randf_range(-movement_radius, movement_radius)
	)