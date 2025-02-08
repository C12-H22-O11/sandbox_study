class_name Door3D extends AnimatableBody3D

@export var buttons: Array[Button3D]
@export var time: float = 2
@export var travel := Vector3.UP
@onready var start_position := self.position 

var opened := false
var tween: Tween = null

func _ready() -> void:
	if not multiplayer.is_server(): 
		request_door_state.rpc_id(1) 
	for button in buttons:
		button.just_pressed.connect(_on_button_just_pressed)

func _on_button_just_pressed() -> void:
	if not multiplayer.is_server():
		request_door_state_toggle.rpc_id(1)
	else:
		request_door_state_toggle()	

func tween_position() -> void:
	if tween and tween.is_running():
		tween.stop()
	tween = create_tween()
	if opened:
		tween.tween_property(self, "position", start_position + travel, time * (1-get_factor()))\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	else:
		tween.tween_property(self, "position", start_position, time * get_factor())\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		
func get_factor() -> float:
	return inverse_lerp(start_position.x, (travel + start_position).x, position.x)

# Request door state
@rpc("any_peer", "reliable")
func request_door_state() -> void:
	send_door.rpc(opened)
	
# Server sends door state
@rpc("call_local", "authority", "reliable")
func send_door(door_state: bool) -> void:
	opened = door_state
	tween_position()

# Request door open/close
@rpc("any_peer")
func request_door_state_toggle() -> void:
	opened = !opened
	send_door.rpc(opened)

	
