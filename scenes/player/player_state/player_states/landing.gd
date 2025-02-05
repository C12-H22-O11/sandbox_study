extends PlayerState

func physics_update(delta: float) -> void:
	if player.get_planar_velocity().is_zero_approx():
		state_machine.transition("Idle")
	elif player.input.is_action_pressed("jump"):
		state_machine.transition("Jumping")
	elif player.input.is_action_pressed("run"):
		state_machine.transition("Running")
	else:
		state_machine.transition("Walking")
	player.move_and_slide()
