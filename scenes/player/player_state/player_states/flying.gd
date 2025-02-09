extends PlayerState

@export var speed: float
@export var acceleration: float
@export var deceleration: float


func enter(from: State = null) -> void:
	pass

func physics_update(delta: float) -> void:
	player.apply_movement(
		player.input.get_rotated_planar_input(Vector3.UP),
		speed, 
		acceleration,
		deceleration,
		delta
	)
