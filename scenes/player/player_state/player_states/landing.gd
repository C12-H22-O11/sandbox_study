extends PlayerState

func physics_update(delta: float) -> void:
	if player.get_planar_velocity().is_zero_approx():
		state_machine.transition("Idle")
		return
	elif player.input.is_action_pressed("jump"):
		state_machine.transition("Jumping")
		return
	elif player.input.is_action_pressed("sprint"):
		state_machine.transition("Sprinting")
		return
	elif player.input.is_action_pressed("walk"):
		state_machine.transition("Walking")
		return
	else:
		state_machine.transition("Running")
		return
	player.move_and_slide()
