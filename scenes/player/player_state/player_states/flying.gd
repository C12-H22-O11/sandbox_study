extends PlayerState

@export var speed: float
@export var acceleration: float
@export var deceleration: float

var previous_state: State = null

func enter(from: State = null) -> void:
	previous_state = from

func physics_update(delta: float) -> void:
	player.apply_movement(
		player.input.get_planar_input(Vector3.UP),
		speed, 
		acceleration,
		deceleration,
		delta
	)
