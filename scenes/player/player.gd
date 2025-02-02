class_name Player
extends CharacterBody3D

const JUMP_VELOCITY := 5.0

@export var input: InputSynchronizer

@export var visuals: Node3D
@export var head: Node3D 
@export var camera: Camera3D 
@export var velo: Vector3: 
	set(value):
		velocity = value
	get:
		return velocity


func setup_multiplayer(id: int) -> void:
	input.set_multiplayer_authority(id)
	visuals.set_multiplayer_authority((id))
	var local_id := multiplayer.get_unique_id()
	if local_id == id:
		camera.make_current()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED



func apply_movement(speed: float, acceleration: float, deceleration: float, delta: float, floating := false) -> void:
	var input_dir := input.input_direction
	var direction := input_dir.rotated(-visuals.rotation.y)
	var planar_velocity := get_planar_velocity()
	var target_velocity := direction * speed
	var attempting_to_move := not input_dir.is_zero_approx()
	
	if floating:
		var f := target_velocity.normalized().dot(planar_velocity.normalized())
		target_velocity = direction * maxf(lerp(speed, planar_velocity.length(), f), speed)
	
	if attempting_to_move:
		planar_velocity =  planar_velocity.move_toward(target_velocity, acceleration * delta)
	else:
		planar_velocity =  planar_velocity.move_toward(target_velocity, deceleration * delta)
	
	velocity.x = planar_velocity.x
	velocity.z = planar_velocity.y

func get_planar_velocity() -> Vector2:
	return Vector2(velocity.x, velocity.z)



func apply_gravity(gravity: Vector3, delta: float) -> void:
	if not is_on_floor():
		velocity += gravity * delta


func jump() -> void:
		velocity.y = JUMP_VELOCITY
