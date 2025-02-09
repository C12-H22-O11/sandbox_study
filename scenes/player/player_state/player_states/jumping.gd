extends PlayerState

@export var speed := 3.0
@export var acceleration := 5.0
@export var deceleration := 10.0


func enter(_from: State = null) -> void:
	player.jump(5.0)

func physics_update(delta: float) -> void:
	player.apply_movement(player.input.get_planar_input(Vector3.UP), speed, acceleration, 	deceleration, delta, true)
	player.apply_gravity(Vector3.DOWN * 9.81, delta)
	
	if player.velocity.y <= 0:
		if player.is_on_floor():
			state_machine.transition("Idle")
		state_machine.transition("Falling")
	
	player.move_and_slide()
