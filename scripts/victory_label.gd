extends Control

func _ready() -> void:
	SignalBus.connect("player_win", _show_label)

func _show_label(index : int):
	print("Player ", index, " wins!")
	$"Label".text = "Player " + str(index) + " wins!"

	$"WinsLabel".text = ""
	for i in Globals.player_count:
		$"WinsLabel".text += "Player " + str(i+1) + ": " + str(Globals.player_wins[i+1]) + "\n"
	
	$"Label".visible = true
	$"Button2".visible = true
	$"Button".visible = true
	$"WinsLabel".visible = true

func _replay():
	get_tree().change_scene_to_file("res://scenes/maps/arena" + str(randi_range(1, 8))+".tscn")

func _quit_to_menu():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
