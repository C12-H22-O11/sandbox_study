extends PlayerState

@export var speed := 4.0
@export var acceleration := 20.0
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
	
	if not player.is_on_floor():
		if player.is_falling(gravity):
			request_transition("Falling")
			return
		player.apply_gravity(gravity, delta)
	
	if Math.get_planar_vector3(player.velocity, Vector3.UP).is_zero_approx():
		request_transition("Idle")
		return
	
	if player.input.is_action_pressed("sprint"):
		request_transition("Sprinting")
		return
	elif player.input.is_action_pressed("walk"):
		request_transition("Walking")
		return
	
	move_and_slide_snapped()


func exit() -> State:
	if player.input.action_just_pressed.is_connected(_on_action_just_pressed):
		player.input.action_just_pressed.disconnect(_on_action_just_pressed)
	return self


func _on_action_just_pressed(action: StringName) -> void:
	match  action:
		"jump": 
			if player.is_on_floor():
				request_transition("Jumping")
