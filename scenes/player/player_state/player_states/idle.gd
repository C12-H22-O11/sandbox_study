extends PlayerState


func enter(_from: State = null) -> void:
	player.velocity = Vector3.ZERO


func physics_update(_delta: float) -> void:
	if player.is_on_floor():
		if player.input.is_action_pressed("jump"):
			state_machine.transition("Jumping")
	else:
		state_machine.transition("Falling")
	
	if not player.input.input_direction.is_zero_approx():
		if player.input.is_action_pressed("run"):
			state_machine.transition("Running")
		else:
			state_machine.transition("Walking")
	
	player.move_and_slide()

func exit() -> State:
	return self
