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
@export var external_force_decay := 700.0

@onready var player_visual: PlayerVisual = $"PlayerVisual"
@onready var item_grabber: Area2D = $"ItemGrab"

@onready var attack_area: Area2D = $"AttackArea"

@export_group("Attack")
@export var attack_force := 1000.0

var bounce_timer := -1.0
var pending_normal := Vector2.UP
var item_in_hand: IItem = null

var facing_left := false

@export var DASH_COOLDOWN := 3.0
var dash_timer := 0.0

var has_jump := false

var item_cooldown := 0.0

var attack_cooldown := 0.0

func attack() -> void:
	if attack_cooldown > 0.0:
		return
	
	player_visual.trigger_attack_animation()
	for body in attack_area.get_overlapping_bodies():
		# print(body)
		if body is PlayerController and body != self:
			# print("Attacking player: ", body)
			var direction := (body.global_position - global_position).normalized()
			# print(direction)
			body.apply_external_force(direction * attack_force)

func equip_item(item: IItem) -> void:
	if item_cooldown > 0.0:
		return
	
	item.position = Vector2.ZERO
	item.rotation = 0.0
	
	item_in_hand = item
	item_in_hand.reparent($"PlayerVisual/ItemHold", false)
	item_in_hand.on_pickup(self)
	player_visual.start_holding()

func unequip_item() -> void:	
	if item_in_hand == null:
		return

	item_cooldown = 3.0
	
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

	item_grabber.body_entered.connect(Callable(self, "_on_item_grabber_body_entered"))

func _on_item_grabber_body_entered(body: Node) -> void:
	if item_cooldown > 0.0:
		return
	
	if item_in_hand != null:
		return

	if body is IItem:
		if body.has_owner:
			return
		equip_item(body)
	elif body is FloatingItem:
		var it: IItem = body.get_child(0) as IItem
		if it.has_owner:
			return
		equip_item(it)
		body.queue_free()

var external_velocity := Vector2.ZERO

func apply_external_force(impulse: Vector2) -> void:
	external_velocity += impulse / mass

func _translate_action(action: String) -> String:
	return "player" + str(player_id) + "_" + action

func _physics_process(delta: float) -> void:
	var direction := Input.get_action_strength(_translate_action("right")) - Input.get_action_strength(_translate_action("left"))

	dash_timer = max(dash_timer - delta, 0.0)
	item_cooldown = max(item_cooldown - delta, 0.0)
	attack_cooldown = max(attack_cooldown - delta, 0.0)

	if Input.is_action_just_pressed(_translate_action("interact")):
		if item_in_hand:
			item_in_hand.on_interact(self)
		else:
			attack()

	if Input.is_action_just_released(_translate_action("interact")) and item_in_hand == null:
		player_visual.stop_holding()

	if Input.is_action_just_pressed(_translate_action("dash")):
		if dash_timer <= 0.0:
			dash_timer = DASH_COOLDOWN
			
			var dash_direction := Vector2.RIGHT if direction > 0 else Vector2.LEFT
			if direction == 0:
				dash_direction = Vector2.LEFT if facing_left else Vector2.RIGHT
				
			apply_external_force(dash_direction * 1000.0)

	if Input.is_action_just_pressed(_translate_action("up")):
		if has_jump:
			apply_central_impulse(Vector2.UP * 700.0)
			has_jump = false

	if direction != 0:
		player_visual.trigger_midair_walk_animation()
		player_visual.update_facing(direction)
		facing_left = direction < 0
		
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
			has_jump = true

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
