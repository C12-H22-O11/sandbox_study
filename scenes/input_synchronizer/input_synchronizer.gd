class_name InputSynchronizer extends MultiplayerSynchronizer
## Multiplayer Synchonizer used exclusively to synchronize all user inputs over the network. 

## Emitted on all instances when user just pressed an [param action].
signal action_just_pressed(action: StringName)
## Emitted on all instances when user just released an [param action].
signal action_just_released(action: StringName)

## Node used for [method get_rotated_input] and [method get_rotated_planar_input]
@export var input_rotation_point: Node3D
@export var _raw_input := Vector3()
@export var _pressed_actions := {}


func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	var lateral_input := Input.get_axis("move_left", "move_right")
	var vertical_input := Input.get_axis("crouch", "jump")
	var longitudinal_input := Input.get_axis("move_forward", "move_backward")
	
	_raw_input = Vector3(lateral_input, vertical_input, longitudinal_input)
	
	for action in InputMap.get_actions():
		if Input.is_action_just_pressed(action):
			_request_just_pressed_emission.rpc(action)
		if Input.is_action_just_released(action):
			_request_just_released_emission.rpc(action)
		_pressed_actions[action] = Input.is_action_pressed(action)

## Return action press state.
func is_action_pressed(action: StringName) -> bool:
	return _pressed_actions.get(action, false)

## Returns if the user is inputing movement.
func is_attempting_to_move() -> bool:
	return not _raw_input.is_zero_approx()

## Returns if the user is inputing planar movement.
func is_attempting_to_move_planar(exclude_axis: Vector3) -> bool:
	return not get_raw_planar_input(exclude_axis).is_zero_approx()

## Returns raw input.
func get_raw_input() -> Vector3:
	return _raw_input

## Returns input.
func get_input() -> Vector3:
	return Math.get_scaled_normalized_vector3(_raw_input)

## Returns input rotated using the [method Quaternion.inverse] of the [member input_rotation_point] basis rotation quaternion.
func get_rotated_input() -> Vector3:
	return get_input() * input_rotation_point.basis.get_rotation_quaternion().inverse()

## Returns raw planar input nullifying the value of [param exclude_axis].
func get_raw_planar_input(exclude_axis: Vector3) -> Vector3:
	var length := _raw_input.dot(exclude_axis.normalized())
	var raw_planar_input := _raw_input - (exclude_axis.normalized() * length)
	return raw_planar_input

## Returns planar input nullifying the value of [param exclude_axis].
func get_planar_input(exclude_axis: Vector3) -> Vector3:
	var raw_planar_input := get_raw_planar_input(exclude_axis)
	return Math.get_scaled_normalized_vector3(raw_planar_input)

## Returns planar input nullifying the value of [param exclude_axis]
## rotated using the [method Quaternion.inverse] of the [member input_rotation_point] basis rotation quaternion.
func get_rotated_planar_input(exclude_axis: Vector3) -> Vector3:
	return get_planar_input(exclude_axis) * input_rotation_point.basis.get_rotation_quaternion().inverse()


# Propagates the [signal action_just_pressed] signal on other instances.
@rpc("authority", "call_local", "unreliable_ordered")
func _request_just_pressed_emission(action: String) -> void:
	action_just_pressed.emit(action)

# Propagates the [signal action_just_released] signal on other instances.
@rpc("authority", "call_local", "unreliable_ordered")
func _request_just_released_emission(action: String) -> void:
	action_just_released.emit(action)
