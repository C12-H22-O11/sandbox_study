class_name InputSynchronizer extends MultiplayerSynchronizer

signal action_just_pressed(action: String)

@export var pressing_run := false
@export var pressing_jump := false
@export var input_direction := Vector2()


func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	if Input.is_action_just_pressed("jump"):
		request_just_pressed.rpc("jump")
	pressing_jump = Input.is_action_pressed("jump")
	
	if Input.is_action_just_pressed("run"):
		request_just_pressed.rpc("run")
	pressing_run = Input.is_action_pressed("run")


@rpc("authority", "call_local", "unreliable_ordered")
func request_just_pressed(action: String) -> void:
	action_just_pressed.emit(action)
