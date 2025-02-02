class_name InputSynchronizer extends MultiplayerSynchronizer

signal just_pressed(action: String)

@export var input_direction := Vector2()


func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if Input.is_action_just_pressed("jump"):
		request_jump.rpc()


@rpc("authority", "call_local", "unreliable_ordered")
func request_jump() -> void:
	just_pressed.emit("jump")
