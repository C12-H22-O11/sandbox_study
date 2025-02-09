extends PlayerState

func enter(_from: State = null) -> void:
	player.move_and_slide()
	
	if player.input.is_action_pressed("jump"):
		requested_transition.emit("Jumping")
		return
	
	if Math.get_planar_vector3(player.velocity, Vector3.UP).is_zero_approx():
		requested_transition.emit("Idle")
		return
	
	if player.input.is_action_pressed("sprint"):
		requested_transition.emit("Sprinting")
		return
		
	if player.input.is_action_pressed("walk"):
		requested_transition.emit("Walking")
		return
	else:
		requested_transition.emit("Running")
		return
	
