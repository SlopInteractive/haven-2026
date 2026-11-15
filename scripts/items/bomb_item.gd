extends IItem

@onready var tex: Sprite2D = $"HoldItem"
@onready var label: Label = $"Label"
@onready var boom_anim: AnimatedSprite2D = $"BoomAnim"

@onready var explosion_shape: CollisionShape2D = $"ExplosionShape"
@export var explosion_force: float = 5000.0

@export_group("Throw")
@export var throw_force: float = 1200.0
@export var throw_upward_force: float = 350.0

# secs
const TIME := 4
var activated := false

var time_left := 0.0

func _ready() -> void:
	freeze = true
	boom_anim.animation_finished.connect(_on_boom_anim_animation_finished)

func _on_boom_anim_animation_finished():
	boom_anim.hide()
	queue_free()

func detonate() -> void:
	label.hide()
	tex.hide()
	freeze = true
	boom_anim.show()
	boom_anim.play("default")
	SignalBus.audio_play.emit("boom")
	explode()

func explode():
	var shape := explosion_shape.shape as CircleShape2D

	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = explosion_shape.global_transform
	query.collision_mask = 1 << 1
	query.collide_with_bodies = true

	var space := get_world_2d().direct_space_state
	var results := space.intersect_shape(query, 32)

	for result in results:
		var body := result.collider as PlayerController

		if body == null:
			continue

		var offset := body.global_position - explosion_shape.global_position

		if offset.length_squared() < 0.001:
			continue

		var direction := offset.normalized()
		
		var distance_falloff := 1.0 - clampf(
			offset.length() / shape.radius, 0.0, 1.0
		)
		
		body.unequip_item()
		var impulse := direction * explosion_force * distance_falloff
		body.apply_external_force(impulse)

func _process(delta: float):
	if time_left > 0.0:
		time_left -= delta
		
		var in_secs := int(time_left)
		label.text = str(in_secs+1)
		
		if time_left <= 0.0:
			detonate()

func on_pickup(player: PlayerController) -> void:
	freeze = true
	if activated:
		return
	activated = true
	self.has_owner = true
	
	label.show()
	time_left = TIME

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
	
