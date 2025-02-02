extends PlayerState


func enter(from: State = null) -> void:
	player.velocity = Vector3.ZERO


func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	if player.is_on_floor():
		if player.input.pressing_jump:
			state_machine.transition("Jumping")
	else:
		state_machine.transition("Falling")
	
	if not player.input.input_direction.is_zero_approx():
		if Input.is_action_pressed("run"):
			state_machine.transition("Running")
		else:
			state_machine.transition("Walking")
	
	player.move_and_slide()

func exit() -> State:
	return self
