extends PlayerState

func physics_update(delta: float) -> void:
	if player.get_planar_velocity().is_zero_approx():
		state_machine.transition("Idle")
	elif player.input.pressing_jump:
		state_machine.transition("Jumping")
	elif player.input.pressing_run:
		state_machine.transition("Running")
	else:
		state_machine.transition("Walking")
	player.move_and_slide()
