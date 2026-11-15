
@tool
extends SoftBody2D

@export_group("Anchoring")
@export var anchor_radius := 40.0
@export var anchor_zone: Area2D

const COLORS: Array[Variant] = [
	Color(1, 0, 0),
	Color(0, 1, 0),
	Color(0, 0, 1),
	Color(0.5882353, 0.3254902, 0.93333334),
	Color(0.6313726, 0.19215687, 0.5529412),
	Color(0.77254903, 0.12156863, 0.18431373),
]

func _ready() -> void:
	color = COLORS[randi() % COLORS.size()]
	# if not is_connected("baked", _on_baked):
	# 	connect("baked", _on_baked)

	# Handle softbodies already generated in the editor.
	_anchor_bottom.call_deferred()


func _on_baked(_body_count: int) -> void:
	_anchor_bottom.call_deferred()


func _anchor_bottom() -> void:
	var bodies := get_rigid_bodies()

	if bodies.is_empty():
		return

	var center := Vector2.ZERO
	var count := 0

	# Calculate center of the softbody.
	for child in bodies:
		var body := child.rigidbody as RigidBody2D

		if body == null:
			continue

		center += body.global_position
		count += 1

	if count == 0:
		return

	center /= count

	var anchored_count := 0

	# Anchor
	for child in bodies:
		var body := child.rigidbody as RigidBody2D

		if body == null:
			continue

		var should_anchor := false

		if anchor_zone != null:
			var collision_shape := anchor_zone.get_node_or_null("CollisionShape2D") as CollisionShape2D

			if collision_shape != null and collision_shape.shape != null:
				var local_pos := collision_shape.to_local(body.global_position)
				var shape := collision_shape.shape
				var half_size : Vector2 = shape.size / 2.0
				should_anchor = absf(local_pos.x) <= half_size.x and absf(local_pos.y) <= half_size.y
		else:
			should_anchor = body.global_position.distance_to(center) <= anchor_radius
		
		if should_anchor:
			body.freeze = true
			body.freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
			anchored_count += 1

	print("Anchored bodies: ", anchored_count)
