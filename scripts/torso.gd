extends RigidBody2D

#func _physics_process(delta: float) -> void:
	#if abs(rotation) > 10:
		#rotation  *= 0.9 * delta
