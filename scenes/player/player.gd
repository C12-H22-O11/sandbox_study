class_name Player extends CharacterBody3D

const JUMP_VELOCITY := 5.0

var owner_id: int = 1

@export var input: InputSynchronizer

@export var visuals: Node3D
@export var label: Label3D
@export var head: Node3D 
@export var camera: Camera3D 
@export var velo: Vector3: 

	set(value):
		velocity = value
	get:
		return velocity


func setup_multiplayer(id: int) -> void:
	owner_id = id
	
	input.set_multiplayer_authority(owner_id)
	visuals.set_multiplayer_authority(owner_id)
	
	label.text = Lobby.get_member_data(owner_id, Lobby.MemberData.NAME)
	label.modulate = Lobby.get_member_data(owner_id, Lobby.MemberData.COLOR)
	
	var local_id := multiplayer.get_unique_id()
	if local_id == id:
		camera.make_current()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func apply_movement(input: Vector3, speed: float, accel: float, decel: float, delta: float) -> void:
	var current_velocity := velocity
	var target_velocity := input * speed
	var acceleration_factor := (signf(current_velocity.dot(target_velocity)) + 1) / 2.0
	var target_acceleration := lerpf(decel, accel, acceleration_factor)
	velocity =  current_velocity.move_toward(target_velocity, target_acceleration * delta)
	
func apply_planar_movement(input: Vector3, speed: float, accel: float, decel: float, delta: float, exclude_axis := Vector3(),  airborne := false) -> void:
	assert(exclude_axis.is_normalized(), "Exclude axis should be normalized")
	
	var exclude_axis_value := velocity.dot(exclude_axis.normalized())
	var exclude_axis_vector := exclude_axis.normalized() * exclude_axis_value
	
	var planar_velocity := velocity - exclude_axis_vector
	var target_velocity := input * speed
	var acceleration_factor := (signf(planar_velocity.dot(target_velocity)) + 1) / 2.0
	var target_acceleration := lerpf(decel, accel, acceleration_factor)
	
	if airborne:
		var held_speed := maxf(input.normalized().dot(planar_velocity), 0.0)
		target_velocity = input * maxf(held_speed, speed)
	
	velocity = planar_velocity.move_toward(target_velocity, target_acceleration * delta) + exclude_axis_vector


func get_planar_velocity() -> Vector2:
	return Vector2(velocity.x, velocity.z)

func apply_gravity(gravity: Vector3, delta: float) -> void:
	if not is_on_floor():
		velocity += gravity * delta

func jump(jump_force: Vector3) -> void:
	velocity += jump_force
