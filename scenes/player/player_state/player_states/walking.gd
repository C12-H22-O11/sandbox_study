extends PlayerState

@export var speed := 2.0
@export var acceleration := 15.0
@export var deceleration := 25.0


func physics_update(delta: float) -> void:
	player.apply_movement(player.input.get_rotated_planar_input(Vector3.UP), speed, acceleration, 	deceleration, delta)
	
	if player.is_on_floor():
		if player.input.is_action_pressed("jump"):
			state_machine.transition("Jumping")
	else:
		state_machine.transition("Falling")
	
	if player.get_planar_velocity().is_zero_approx():
		state_machine.transition("Idle")
	
	if player.input.is_action_pressed("sprint"):
		state_machine.transition("Sprinting")
	elif not player.input.is_action_pressed("walk"):
		state_machine.transition("Running")
	
	player.move_and_slide()

func get_animation_scaling() -> float:
	return  player.get_planar_velocity().length() / speed
