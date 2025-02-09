extends PlayerState

@export var speed := 3.0
@export var acceleration := 5.0
@export var deceleration := 10.0


func enter(_from: State = null) -> void:
	player.jump(5.0 * -gravity.normalized())
	print("ty")

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		if player.is_falling(gravity):
			request_transition("Falling")
			return
		player.apply_gravity(gravity, delta)
	
	player.apply_planar_movement(
		player.input.get_rotated_planar_input(gravity),
		speed, 
		acceleration,
		deceleration,
		delta,
		gravity.normalized(),
		true
	)
	
	move_and_slide()



func exit() -> State:
	return self
