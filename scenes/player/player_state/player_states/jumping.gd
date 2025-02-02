extends State

@export var speed: float = 3.0
@export var acceleration: float = 5.0
@export var deceleration: float = 10.0

@onready var player: Player = owner

func enter(from: State = null) -> void:
	player.jump()

func physics_update(delta: float) -> void:
	player.apply_movement(speed, acceleration, deceleration, delta, true)
	player.apply_gravity(Vector3.DOWN * 9.81, delta)
	
	if player.velocity.y <= 0:
		if player.is_on_floor():
			state_machine.transition("Idle")
		state_machine.transition("Falling")
	
	player.move_and_slide()
