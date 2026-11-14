extends Node2D

func die():
	for child in get_children():
		if child is PinJoint2D:
			child.node_a = NodePath("")
			child.node_b = NodePath("")
		
func _ready() -> void:
	#die()
	pass
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("player1_left"):
		$"Torso".position.x -= 200 * delta;
	if Input.is_action_pressed("player2_right"):
		$"Torso".position.x += 200 * delta;
