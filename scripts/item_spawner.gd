extends Node2D

@export var item_scene: PackedScene
@export var spawn_interval: float = 15.0

const ITEMS: Array[Variant] = [
	"res://prefabs/items/bomb_item.tscn",
	"res://prefabs/items/grenade.tscn",
	"res://prefabs/items/stick_item.tscn",
]

func _ready() -> void:
	var timer := Timer.new()
	timer.wait_time = spawn_interval
	timer.timeout.connect(_spawn_item)
	timer.autostart = true
	add_child.call_deferred(timer)
	_spawn_item()

func _spawn_item() -> void:
	var item := item_scene.instantiate() as FloatingItem
	item.item_scene = load(ITEMS[randi() % ITEMS.size()])
	get_tree().current_scene.add_child(item)
	item.global_position = global_position