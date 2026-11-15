extends Node2D

func _ready() -> void:
	for i in range(1,Globals.player_count + 1):
		var player : PlayerController = load("res://prefabs/player.tscn").instantiate() 
		add_child(player)
		player.player_id = i
		player.move_speed = 400
		player.acceleration = 100
		player.bounce_delay = 0.0
		player.bounce_strength = 700
		player.position = find_child("player" + str(i) + "_marker").position
		player.external_force_decay = 700
		player.get_node("PlayerVisual").torso_tex_id = Globals.player_skins[i][Globals.SHIRT]
		player.get_node("PlayerVisual").eyes_tex_id = Globals.player_skins[i][Globals.EYES]
		player.get_node("PlayerVisual").hair_tex_id = Globals.player_skins[i][Globals.HAIR]
		player.get_node("PlayerVisual").shoes_tex_id = Globals.player_skins[i][Globals.SHOES]
		
		player.player_visual.apply_textures()

var knocked_players := []

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/test/character_select.tscn")
	
	# Check for any player that has fallen below the screen and reset their position
	for player in get_children():
		if player is PlayerController:
			if player.global_position.y > 1000:
				knocked_players.append(player.player_id)
	
	if len(knocked_players) == Globals.player_count - 1:
		for player in get_children():
			if player is PlayerController and player.player_id not in knocked_players:
				print("Player ", player.player_id, " wins!")
