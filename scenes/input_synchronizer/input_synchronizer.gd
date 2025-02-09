class_name InputSynchronizer extends MultiplayerSynchronizer

signal action_just_pressed(action: StringName)
signal action_just_released(action: StringName)

@export var pressed_actions := {}
@export var raw_input := Vector3()
@export var input_rotation_point: Node3D


func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	var lateral_input := Input.get_axis("move_left", "move_right")
	var vertical_input := Input.get_axis("jump", "crouch")
	var longitudinal_input := Input.get_axis("move_forward", "move_backward")
	
	raw_input = Vector3(lateral_input, vertical_input, longitudinal_input)
	
	for action in InputMap.get_actions():
		if Input.is_action_just_pressed(action):
			request_just_pressed.rpc(action)
		if Input.is_action_just_released(action):
			request_just_released.rpc(action)
		pressed_actions[action] = Input.is_action_pressed(action)


func is_action_pressed(action: StringName) -> bool:
	return pressed_actions.get(action, false)

func is_attempting_to_move() -> bool:
	return not raw_input.is_zero_approx()

func is_attempting_to_move_planar(exclude_axis: Vector3) -> bool:
	return not get_raw_planar_input(exclude_axis).is_zero_approx()


func get_raw_input() -> Vector3:
	return raw_input

func get_input() -> Vector3:
	return Math.get_scaled_normalized_vector3(raw_input)


func get_raw_planar_input(exclude_axis: Vector3) -> Vector3:
	var length := raw_input.dot(exclude_axis.normalized())
	var raw_planar_input := raw_input - (exclude_axis.normalized() * length)
	return raw_planar_input

func get_planar_input(exclude_axis: Vector3) -> Vector3:
	var raw_planar_input := get_raw_planar_input(exclude_axis)
	return Math.get_scaled_normalized_vector3(raw_planar_input)


func get_rotated_raw_planar_input(exclude_axis: Vector3) -> Vector3:
	return get_raw_planar_input(exclude_axis) * input_rotation_point.basis.get_rotation_quaternion().inverse()


func get_rotated_planar_input(exclude_axis: Vector3) -> Vector3:
	return get_planar_input(exclude_axis) * input_rotation_point.basis.get_rotation_quaternion().inverse()





@rpc("authority", "call_local", "unreliable_ordered")
func request_just_pressed(action: String) -> void:
	action_just_pressed.emit(action)

@rpc("authority", "call_local", "unreliable_ordered")
func request_just_released(action: String) -> void:
	action_just_released.emit(action)
