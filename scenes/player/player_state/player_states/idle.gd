extends PlayerState


func enter(_from: State = null) -> void:
	player.input.action_just_pressed.connect(_on_action_just_pressed)

func physics_update(delta: float) -> void:
	if player.is_on_floor():
		if player.input.is_action_pressed("jump"):
			request_transition("Jumping")
			return
	else:
		if player.is_falling(gravity):
			request_transition("Falling")
			return
		player.apply_gravity(gravity, delta)
	
	if player.input.is_attempting_to_move_planar(gravity.normalized()):
		if player.input.is_action_pressed("sprint"):
			request_transition("Sprinting")
			return
		elif player.input.is_action_pressed("walk"):
			request_transition("Walking")
			return
		else:
			request_transition("Running")
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
