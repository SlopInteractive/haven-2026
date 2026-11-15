extends Control

func _ready() -> void:
	SignalBus.connect("player_win", _show_label)

func _show_label(index : int):
	print("Player ", index, " wins!")
	$"Label".text = "Player " + str(index) + " wins!"
	$"Label".visible = true
	$"Button".visible = true

func _replay():
		get_tree().change_scene_to_file("res://scenes/maps/arena1.tscn")
