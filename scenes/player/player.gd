class_name Player
extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ACCELERATION = 15
const DECELERATION = 20

@export var head: Node3D 
@export var camera: Camera3D 
@export var velo: Vector3: 
	set(value):
		velocity = value
	get:
		return velocity

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): 
		return
	if event is InputEventMouseMotion:
		var mouse_input := -Vector2(deg_to_rad(event.relative.x), deg_to_rad(event.relative.y))
		mouse_input *= 0.3
		rotate_y(mouse_input.x)
		head.rotation.x = clampf(head.rotation.x+mouse_input.y, -TAU/4, TAU/4)

func setup_multiplayer(id: int) -> void:
	set_multiplayer_authority(id)
	var local_id := multiplayer.get_unique_id()
	if local_id == id:
		camera.make_current()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): 
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var direction := input_dir.rotated(-rotation.y)
	
	var planar_velocity := Vector2(velocity.x, velocity.z)
	
	if direction:
		planar_velocity =  planar_velocity.move_toward(direction* SPEED, ACCELERATION * delta)
	else:
		planar_velocity =  planar_velocity.move_toward(Vector2.ZERO, DECELERATION * delta)
	
	velocity.x = planar_velocity.x
	velocity.z = planar_velocity.y
	
	move_and_slide()
