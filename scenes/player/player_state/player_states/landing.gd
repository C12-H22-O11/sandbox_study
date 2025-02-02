extends PlayerState

func physics_update(delta: float) -> void:
	if player.get_planar_velocity().is_zero_approx():
		state_machine.transition("Idle")
	else:
		state_machine.transition("Walking")
	player.move_and_slide()
