extends PlayerState


func enter(_from: State = null) -> void:
	player.input.action_just_pressed.connect(_on_action_just_pressed)
	player.velocity = Vector3.ZERO

func physics_update(_delta: float) -> void:
	if player.is_on_floor():
		if player.input.is_action_pressed("jump"):
			requested_transition.emit("Jumping")
			return
	else:
		if player.is_falling(Vector3.DOWN * 9.81):
			requested_transition.emit("Falling")
			return
	
	if player.input.is_attempting_to_move_planar(Vector3.UP):
		if player.input.is_action_pressed("sprint"):
			requested_transition.emit("Sprinting")
			return
		elif player.input.is_action_pressed("walk"):
			requested_transition.emit("Walking")
			return
		else:
			requested_transition.emit("Running")
			return
	
	player.velocity
	
	player.move_and_slide()

func exit() -> State:
	if player.input.action_just_pressed.is_connected(_on_action_just_pressed):
		player.input.action_just_pressed.disconnect(_on_action_just_pressed)
	return self


func _on_action_just_pressed(action: StringName) -> void:
	match  action:
		"jump": 
			if player.is_on_floor():
				requested_transition.emit("Jumping")
