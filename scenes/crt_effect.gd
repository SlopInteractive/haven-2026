extends CanvasLayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_crt"):
		Globals.crt_enabled = not Globals.crt_enabled
	
	if Globals.crt_enabled:
		visible = true
	else:
		visible = false
