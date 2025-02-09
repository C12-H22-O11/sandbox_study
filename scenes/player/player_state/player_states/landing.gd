extends PlayerState

func enter(_from: State = null) -> void:
	if player.input.is_action_pressed("jump"):
		request_transition("Jumping")
		return
	
	if Math.get_planar_vector3(player.velocity, Vector3.UP).is_zero_approx():
		request_transition("Idle")
		return
	
	if player.input.is_action_pressed("sprint"):
		request_transition("Sprinting")
		return
		
	if player.input.is_action_pressed("walk"):
		request_transition("Walking")
		return
	else:
		request_transition("Running")
		return
	
