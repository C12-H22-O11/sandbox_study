extends Node3D

@export var head: Node3D

@onready var previous_position := (owner as CharacterBody3D).position
@onready var previous_velocity := (owner as CharacterBody3D).velocity


func _ready() -> void:
	if is_multiplayer_authority() and owner.is_node_ready():
		send_visuals.rpc(head.rotation, rotation)

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
	
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	if event is InputEventMouseMotion:
		var mouse_input := -Vector2(deg_to_rad(event.relative.x), deg_to_rad(event.relative.y))
		mouse_input *= 0.2
		rotate_y(mouse_input.x)
		head.rotation.x = clampf(head.rotation.x+mouse_input.y, -TAU/4, TAU/4)
		
		send_visuals.rpc(head.rotation, rotation)


func _process(delta: float) -> void:
	if is_multiplayer_authority():
		send_visuals.rpc(head.rotation, rotation)
	
	if Engine.get_frames_per_second() > Engine.physics_ticks_per_second:
		if not top_level:
			top_level = true
		var interpolation_factor := Engine.get_physics_interpolation_fraction()
		var current_positiion := (owner as CharacterBody3D).position
		var current_velocity := (owner as CharacterBody3D).velocity
		var new_position := (previous_position + previous_velocity * delta).lerp((current_positiion + current_velocity * delta), interpolation_factor)
		position = new_position
		previous_position = current_positiion
		previous_velocity = current_velocity
	else:
		if top_level:
			top_level = false
			position = Vector3()

@rpc("authority", "call_remote", "unreliable_ordered")
func send_visuals(head_rotation: Vector3, visuals_rotation: Vector3) -> void:
	rotation.y = visuals_rotation.y
	head.rotation.x = head_rotation.x
	
