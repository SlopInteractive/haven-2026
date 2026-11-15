extends Control

func _ready() -> void:
	if Globals.player_count >= 3:
		$"Player3".visible = true
	if Globals.player_count >= 4:
		$"Player4".visible = true
