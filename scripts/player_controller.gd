extends RigidBody2D

class_name PlayerController

@export_group("Movement")
@export var move_speed := 300.0
@export var acceleration := 100.0

@export_group("Bounce")
@export var bounce_strength := 600.0
@export var bounce_delay := 0.2

@export_group("PlayerID")
@export var player_id := 1

@export var starting_item: PackedScene

@export_group("External Forces")
@export var external_force_decay := 300.0

@onready var player_visual: PlayerVisual = $"PlayerVisual"

var bounce_timer := -1.0
var pending_normal := Vector2.UP

var item_in_hand: IItem = null

func equip_item(item: IItem) -> void:
	item.position = Vector2.ZERO
	item.rotation = 0.0
	
	item_in_hand = item
	item_in_hand.reparent($"PlayerVisual/ItemHold", false)
	player_visual.start_holding()
	
func unequip_item() -> void:
	if item_in_hand == null:
		return
	
	item_in_hand.reparent(get_tree().root, true)
	item_in_hand = null
	player_visual.stop_holding()


func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 8
	
	if starting_item != null:
		var it: IItem = starting_item.instantiate()
		get_tree().root.add_child.call_deferred(it)
		equip_item.call_deferred(it)

var external_velocity := Vector2.ZERO

func apply_external_force(impulse: Vector2) -> void:
	external_velocity += impulse / mass

func _translate_action(action: String) -> String:
	return "player" + str(player_id) + "_" + action

func _physics_process(delta: float) -> void:
	var direction := Input.get_action_strength(_translate_action("right")) - Input.get_action_strength(_translate_action("left"))

	if Input.is_action_just_pressed(_translate_action("interact")):
		if item_in_hand:
			item_in_hand.on_interact(self)
		else:
			player_visual.start_holding()

	if Input.is_action_just_released(_translate_action("interact")) and item_in_hand == null:
		player_visual.stop_holding()

	if direction != 0:
		player_visual.trigger_midair_walk_animation()
		player_visual.update_facing(direction)
		
	var target_speed := direction * move_speed
	var force_x := (target_speed - linear_velocity.x + external_velocity.x) * acceleration

	apply_central_force(Vector2(force_x * mass, 0.0))

	external_velocity = external_velocity.move_toward(
		Vector2.ZERO,
		external_force_decay * delta
	)
	

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if bounce_timer >= 0.0:
		bounce_timer -= state.step

		if bounce_timer <= 0.0:
			player_visual.trigger_midair_animation()
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
