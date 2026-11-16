extends RigidBody2D

class_name IItem

var has_owner := false
@export var item_duration : float = 21

func _ready() -> void:
	pass

func handle_duration(delta:float):
	if !has_owner:
		item_duration = max(item_duration - delta, 0.0)
	if item_duration == 0:
		queue_free()
func on_pickup(_player: PlayerController) -> void:
	pass

func on_interact(_player: PlayerController) -> void:
	pass
