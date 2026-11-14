extends RigidBody2D

@export_group("Movement")
@export var move_speed := 300.0
@export var acceleration := 100.0

@export_group("Bounce")
@export var bounce_strength := 600.0
@export var bounce_delay := 0.2

var bounce_timer := -1.0
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
	if bounce_timer >= 0.0:
		bounce_timer -= state.step

		if bounce_timer <= 0.0:
			state.apply_central_impulse(pending_normal * bounce_strength)
			bounce_timer = -1.0

		return

	for i in state.get_contact_count():
		var normal := (
			global_transform.basis_xform(
				state.get_contact_local_normal(i)
			).normalized()
		)

		if normal.y < -0.7:
			pending_normal = normal
			bounce_timer = bounce_delay
			break