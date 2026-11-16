extends IItem

@export_group("Throw")
@export var throw_force: float = 1200.0
@export var throw_upward_force: float = 350.0

var activated := false
var timer := 0.0

func _ready() -> void:
	freeze = true

func _process(delta: float) -> void:
	handle_duration(delta)
	timer = max(timer - delta, 0.0)

func on_pickup(player: PlayerController) -> void:
	self.has_owner = true

func on_interact(player: PlayerController) -> void:
	# deparent from player
	player.unequip_item()
	freeze = false
	self.has_owner = false

	var direction := Vector2.LEFT if player.facing_left else Vector2.RIGHT

	# Apply throw impulse.
	apply_central_impulse(
		direction * throw_force +
			Vector2.UP * throw_upward_force
	)
	
	activated = true
	timer = 0.05

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !activated:
		return

	if timer > 0.0:
		return

	if body is PlayerController:
		body.apply_external_force(linear_velocity * throw_force)
		queue_free()
