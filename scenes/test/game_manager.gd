extends Node2D

func _ready() -> void:
	for i in range(1,Globals.player_count + 1):
		var player : PlayerController = load("res://prefabs/player.tscn").instantiate() 
		add_child(player)
		player.player_id = i
		player.move_speed = 300
		player.acceleration = 100
		player.bounce_delay = 0.2
		player.bounce_strength = 600
		player.position = find_child("player" + str(i) + "_marker").position
		player.external_force_decay = 300
		player.get_node("PlayerVisual").torso_tex_id = Globals.player_skins[i][Globals.SHIRT]
		player.get_node("PlayerVisual").eyes_tex_id = Globals.player_skins[i][Globals.EYES]
		player.get_node("PlayerVisual").hair_tex_id = Globals.player_skins[i][Globals.HAIR]
		player.player_visual.apply_textures()
