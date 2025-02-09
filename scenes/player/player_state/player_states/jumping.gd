extends PlayerState

@export var speed := 3.0
@export var acceleration := 5.0
@export var deceleration := 10.0


func enter(_from: State = null) -> void:
	player.jump(5.0 * Vector3.UP)

func physics_update(delta: float) -> void:
	player.apply_gravity(Vector3.DOWN * 9.81, delta)
	
	player.apply_planar_movement(
		player.input.get_rotated_planar_input(Vector3.UP),
		speed, 
		acceleration,
		deceleration,
		delta,
		Vector3.UP,
		true
	)
	
	if player.is_falling(Vector3.DOWN * 9.81):
		if player.is_on_floor():
			requested_transition.emit("Idle")
			return
		requested_transition.emit("Falling")
		return
	
	player.move_and_slide()

func exit() -> State:
	return self
