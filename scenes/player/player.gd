class_name Player
extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ACCELERATION = 15
const DECELERATION = 20

@export var input: InputSynchronizer

@export var visuals: Node3D
@export var head: Node3D 
@export var camera: Camera3D 
@export var velo: Vector3: 
	set(value):
		velocity = value
	get:
		return velocity


func _ready() -> void:
	input.just_pressed.connect(_on_input_just_pressed)


func setup_multiplayer(id: int) -> void:
	input.set_multiplayer_authority(id)
	visuals.set_multiplayer_authority((id))
	var local_id := multiplayer.get_unique_id()
	if local_id == id:
		camera.make_current()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): 
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta


	var input_dir := input.input_direction
	var direction := input_dir.rotated(-visuals.rotation.y)
	
	var planar_velocity := Vector2(velocity.x, velocity.z)
	
	if direction:
		planar_velocity =  planar_velocity.move_toward(direction* SPEED, ACCELERATION * delta)
	else:
		planar_velocity =  planar_velocity.move_toward(Vector2.ZERO, DECELERATION * delta)
	
	velocity.x = planar_velocity.x
	velocity.z = planar_velocity.y
	
	move_and_slide()


func _on_input_just_pressed(action: String) -> void:
	match  action:
		"jump":
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
