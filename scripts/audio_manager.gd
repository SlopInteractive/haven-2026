extends Node

@onready var player := AudioStreamPlayer.new()

func _ready() -> void:
	add_child(player)
	player.max_polyphony = 32
	SignalBus.connect("audio_play", _play_sound)
	
func _play_sound(track : String):
	player.stream = load("res://assets/" + track + ".mp3")
	player.play();
