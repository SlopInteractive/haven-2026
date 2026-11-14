
extends RigidBody2D

@export_group("Movement")
@export var move_speed := 300.0
@export var acceleration := 100.0
@export var air_control := 0.6

@export_group("Bounce")
@export var bounce_strength := 600.0
@export var bounce_delay := 0.2
@export var min_landing_speed := 50.0

var bounce_pending := false
var pending_normal := Vector2.UP

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 8

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("player1_left", "player2_right")

	var target_speed := direction * move_speed
	var force_x := (target_speed - linear_velocity.x) * acceleration

	apply_central_force(Vector2(force_x * mass, 0.0))

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if bounce_pending:
		return

	for i in state.get_contact_count():
		var normal := state.get_contact_local_normal(i)

		if normal.y < -0.7 and state.linear_velocity.dot(
			global_transform.basis_xform(normal).normalized()
		) < -min_landing_speed:
			pending_normal = global_transform.basis_xform(normal).normalized()
			bounce_pending = true
			_schedule_bounce()
			break


func _schedule_bounce() -> void:
	await get_tree().create_timer(bounce_delay).timeout

	if not is_inside_tree():
		return

	apply_central_impulse(pending_normal * bounce_strength)
	bounce_pending = false
