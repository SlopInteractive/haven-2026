extends RigidBody2D

@export_group("Movement")
@export var move_speed := 300.0
@export var acceleration := 100.0

@export_group("Bounce")
@export var bounce_strength := 600.0
@export var bounce_delay := 0.2
@export var wall_bounce_strength := 1000.0

var bounce_timer := -1.0
var pending_normal := Vector2.UP
var touching_wall := false

var wall_normal := Vector2.ZERO

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 8

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("player1_left", "player2_right")

	# Block movement into the wall, but allow movement away.
	if wall_normal != Vector2.ZERO and direction * wall_normal.x < 0.0:
		direction = 0.0

	var target_speed := direction * move_speed
	var force_x := (target_speed - linear_velocity.x) * acceleration

	apply_central_force(Vector2(force_x * mass, 0.0))

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	wall_normal = Vector2.ZERO

	if bounce_timer >= 0.0:
		bounce_timer -= state.step

		if bounce_timer <= 0.0:
			state.apply_central_impulse(pending_normal * bounce_strength)
			bounce_timer = -1.0

		return

	for i in state.get_contact_count():
		var normal := global_transform.basis_xform(
			state.get_contact_local_normal(i)
		).normalized()

		if absf(normal.x) > 0.9:
			wall_normal = normal

		if normal.y < -0.7 and bounce_timer <= 0.0:
			pending_normal = normal
			bounce_timer = bounce_delay
			break
