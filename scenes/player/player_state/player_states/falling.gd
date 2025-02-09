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
		player.input.get_rotated_planar_input(Vector3.UP),
		speed, 
		acceleration,
		deceleration,
		delta,
		Vector3.UP,
		true
	)
	player.apply_gravity(Vector3.DOWN * 9.81, delta)
	
	
	if player.is_on_floor():
			requested_transition.emit("Landing")
			return
	
	player.move_and_slide()

func exit() -> State:
	return self
