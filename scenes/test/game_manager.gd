extends Node2D

func _ready() -> void:
	for i in range(1,5):
		var player : PlayerController = load("res://prefabs/player.tscn").instantiate() 
		player.player_id = i
		player.move_speed = 300
		player.acceleration = 100
		player.bounce_delay = 0.2
		player.bounce_strength = 600
		player.position = find_child("player" + str(i) + "_marker").position
		player.external_force_decay = 300
		player.player_visual.shirt_tex_id = Globals.player_skins[i][Globals.SHIRT]
		player.player_visual.eyes_tex_id = Globals.player_skins[i][Globals.EYES]
		player.player_visual.hair_tex_id = Globals.player_skins[i][Globals.HAIR]
		player.player_visual.apply_textures()
		add_child.call_deferred(player)
