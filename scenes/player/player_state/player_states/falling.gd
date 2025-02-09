extends PlayerState

@export var speed := 3.0
@export var acceleration := 5.0
@export var deceleration := 10.0


func enter(from: State = null) -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	player.apply_planar_movement(
		player.input.get_rotated_planar_input(gravity),
		speed, 
		acceleration,
		deceleration,
		delta,
		gravity.normalized(),
		true
	)
	
	if player.is_on_floor():
		transition_request.emit("Landing")
		return
	else:
		player.apply_gravity(gravity, delta)
	
	move_and_slide()

func exit() -> State:
	return self
