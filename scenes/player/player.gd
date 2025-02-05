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


func apply_movement(speed: float, accel: float, decel: float, delta: float, airborne := false) -> void:
	var input_dir := input.input_direction
	var direction := input_dir.rotated(-visuals.rotation.y)
	
	var planar_velocity := get_planar_velocity()
	var target_velocity := direction * speed
	var acceleration_factor := (signf(planar_velocity.dot(target_velocity)) + 1) / 2.0
	var target_acceleration := lerpf(decel, accel, acceleration_factor)
	
	if airborne:
		var held_speed := maxf(direction.normalized().dot(planar_velocity), 0.0)
		target_velocity = direction * maxf(held_speed, speed)
	
	planar_velocity =  planar_velocity.move_toward(target_velocity, target_acceleration * delta)
	
	velocity.x = planar_velocity.x
	velocity.z = planar_velocity.y

func get_planar_velocity() -> Vector2:
	return Vector2(velocity.x, velocity.z)

func apply_gravity(gravity: Vector3, delta: float) -> void:
	if not is_on_floor():
		velocity += gravity * delta

func jump(jump_velocity: float) -> void:
		velocity.y += jump_velocity
