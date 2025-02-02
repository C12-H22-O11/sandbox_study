extends StaticBody3D
@export var player_spawner : PlayerSpawner

var just_pressed := false

func _ready() -> void:
	input_event.connect(_on_input_event)
	
func _on_input_event(_camera: Node, _event: InputEvent, event_position: Vector3, normal: Vector3, _shape_idx: int) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not just_pressed: 
		just_pressed = true
		var data := {
			'position' : event_position,
			'normal' : normal 
		}
		player_spawner.request_spawn.rpc_id(1, data)
	
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and just_pressed: 
		just_pressed = false
