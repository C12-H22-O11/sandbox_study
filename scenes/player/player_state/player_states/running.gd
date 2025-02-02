extends PlayerState

@export var speed := 7.5
@export var acceleration := 25.0
@export var deceleration := 25.0

func physics_update(delta: float) -> void:
	player.apply_movement(speed, acceleration, deceleration, delta)
	
	if player.is_on_floor():
		if player.input.pressing_jump:
			state_machine.transition("Jumping")
	else:
		state_machine.transition("Falling")
	
	if player.get_planar_velocity().is_zero_approx():
		state_machine.transition("Idle")
	
	if not player.input.pressing_run:
		state_machine.transition("Walking")
	
	player.move_and_slide()
