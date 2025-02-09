extends PlayerState


func enter(_from: State = null) -> void:
	player.input.action_just_pressed.connect(_on_action_just_pressed)
	player.velocity = Vector3.ZERO

func physics_update(_delta: float) -> void:
	if player.is_on_floor():
		if player.input.is_action_pressed("jump"):
			state_machine.transition("Jumping")
			return
	else:
		state_machine.transition("Falling")
		return
	
	if player.input.is_attempting_to_move_planar(Vector3.UP):
		if player.input.is_action_pressed("sprint"):
			state_machine.transition("Sprinting")
			return
		elif player.input.is_action_pressed("walk"):
			state_machine.transition("Walking")
			return
		else:
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
