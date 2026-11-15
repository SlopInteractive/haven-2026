extends Control

func _ready() -> void:
	if Globals.player_count >= 3:
		$"Player3".visible = true
	if Globals.player_count >= 4:
		$"Player4".visible = true

func start_game(): 
	for i in range(1,5):
		Globals.player_skins[i] =  get_node("Player" + str(i) +"/PlayerCustomization").indexes
	
	var rand := randi_range(1, 8)
	get_tree().change_scene_to_file("res://scenes/maps/arena" + str(rand) + ".tscn")
	
