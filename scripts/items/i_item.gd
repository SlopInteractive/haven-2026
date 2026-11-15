extends RigidBody2D

class_name IItem

var has_owner := false

func _ready() -> void:
	pass

func on_pickup(player: PlayerController) -> void:
	pass

func on_interact(player: PlayerController) -> void:
	pass