extends Control

func _choose_two_players(): 
	Globals.player_count = 2
	get_tree().change_scene_to_file("res://scenes/character_select.tscn")
func _choose_three_players(): 
	Globals.player_count = 3
	get_tree().change_scene_to_file("res://scenes/character_select.tscn")
func _choose_four_players(): 
	Globals.player_count = 4
	get_tree().change_scene_to_file("res://scenes/character_select.tscn")
