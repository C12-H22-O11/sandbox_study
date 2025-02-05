class_name InputSynchronizer extends MultiplayerSynchronizer

signal action_just_pressed(action: StringName)
signal action_just_released(action: StringName)

@export var pressed_actions := {}
@export var input_direction := Vector2()


func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	for action in InputMap.get_actions():
		if Input.is_action_just_pressed(action):
			request_just_pressed.rpc(action)
		if Input.is_action_just_released(action):
			request_just_released.rpc(action)
		pressed_actions[action] = Input.is_action_pressed(action)


func is_action_pressed(action: StringName) -> bool:
	return pressed_actions.get(action, false)


@rpc("authority", "call_local", "unreliable_ordered")
func request_just_pressed(action: String) -> void:
	action_just_pressed.emit(action)

@rpc("authority", "call_local", "unreliable_ordered")
func request_just_released(action: String) -> void:
	action_just_released.emit(action)
