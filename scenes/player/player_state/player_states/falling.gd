extends PlayerState

@export var speed: float = 2.0
@export var acceleration: float = 5.0
@export var deceleration: float = 10.0


func enter(from: State = null) -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	player.apply_gravity(Vector3.DOWN * 9.81, delta)
	player.apply_movement(speed, acceleration, deceleration, delta, true)
	
	if player.is_on_floor():
			state_machine.transition("Landing")
	
	player.move_and_slide()

func exit() -> State:
	return self
