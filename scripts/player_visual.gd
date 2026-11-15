extends Node

class_name PlayerVisual

@export_category("Textures")
@export var torso_tex_id := 1
@export var hair_tex_id := 1
@export var eyes_tex_id := 1

@onready var arms_animator: AnimationPlayer = $"Arms"
@onready var legs_animator: AnimationPlayer = $"Legs"

@onready var arm_anim_tree: AnimationTree = $"ArmAnimTree"
@onready var arm_playback: AnimationNodeStateMachinePlayback = arm_anim_tree.get("parameters/playback")

@onready var leg_anim_tree: AnimationTree = $"LegAnimTree"
@onready var leg_playback: AnimationNodeStateMachinePlayback = leg_anim_tree.get("parameters/playback")

var is_holding := false

func change_shirt(index: int):
	$"FrontArm".texture = load( "res://assets/sprites/arms/arm_0" + str(index) + ".tres")
	$"BackArm".texture = load( "res://assets/sprites/arms/arm_0" + str(index) + ".tres")
	$"Torso".texture = load( "res://assets/sprites/torsos/torso_0" + str(index) + ".tres")
	
func change_hair(index: int):
	$"Head2/Hair".texture = load( "res://assets/sprites/hair/hair_0" + str(index) + ".tres")
	
func change_eyes(index: int):
	$"Head2/Eyes".texture = load( "res://assets/sprites/eyes/eyes_0" + str(index) + ".tres")

func _ready():
	apply_textures()
	arm_anim_tree.active = true
	arm_playback.travel("idle")

func apply_textures():
	change_shirt(torso_tex_id)
	change_hair(hair_tex_id)
	change_eyes(eyes_tex_id)

func play_state(playback: AnimationNodeStateMachinePlayback, state: StringName):
	if playback.get_current_node() == state:
		if playback.get_current_play_position() < playback.get_current_length():
			return

		playback.start(state)
		return

	playback.travel(state)

func trigger_midair_animation():
	if !is_holding:
		play_state(arm_playback, &"in_air")
	play_state(leg_playback, &"in_air")

func trigger_midair_walk_animation():
	if !is_holding:
		play_state(arm_playback, &"walk")
	play_state(leg_playback, &"walk")

func start_holding():
	is_holding = true
	play_state(arm_playback, &"grab")

func stop_holding():
	is_holding = false
	play_state(arm_playback, &"idle")

func update_facing(direction: float):
	self.scale.x = -1 if direction < 0 else 1
