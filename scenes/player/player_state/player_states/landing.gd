extends PlayerState

func physics_update(delta: float) -> void:
	if player.get_planar_velocity().is_zero_approx():
		state_machine.transition("Idle")
	elif player.input.is_action_pressed("jump"):
		state_machine.transition("Jumping")
	elif player.input.is_action_pressed("sprint"):
		state_machine.transition("Sprinting")
	elif player.input.is_action_pressed("walk"):
		state_machine.transition("Walking")
	else:
		state_machine.transition("Running")
	player.move_and_slide()
