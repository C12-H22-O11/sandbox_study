extends PlayerState

@export var speed := 2.0
@export var acceleration := 15.0
@export var deceleration := 25.0


func enter(_from: State = null) -> void:
	player.input.action_just_pressed.connect(_on_action_just_pressed)

func physics_update(delta: float) -> void:
	player.apply_planar_movement(
		player.input.get_rotated_planar_input(Vector3.UP),
		speed, 
		acceleration,
		deceleration,
		delta,
		Vector3.UP
	)
	
	if player.is_on_floor():
		if player.input.is_action_pressed("jump"):
			state_machine.transition("Jumping")
			return
	else:
		state_machine.transition("Falling")
		return
	
	if player.get_planar_velocity().is_zero_approx():
		state_machine.transition("Idle")
		return
	
	if player.input.is_action_pressed("sprint"):
		state_machine.transition("Sprinting")
		return
	elif not player.input.is_action_pressed("walk"):
		state_machine.transition("Running")
		return
	
	player.move_and_slide()

func exit() -> State:
	if player.input.action_just_pressed.is_connected(_on_action_just_pressed):
		player.input.action_just_pressed.disconnect(_on_action_just_pressed)
	return self


func _on_action_just_pressed(action: StringName) -> void:
	match  action:
		"jump": state_machine.transition("Jumping")
