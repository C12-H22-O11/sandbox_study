extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ACCELERATION = 15
const DECELERATION = 20
@export var head: Node3D 


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_input := -Vector2(deg_to_rad(event.relative.x), deg_to_rad(event.relative.y))
		mouse_input *= 0.3
		rotate_y(mouse_input.x)
		head.rotation.x = clampf(head.rotation.x+mouse_input.y, -TAU/4, TAU/4)

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta )
		velocity.z = move_toward(velocity.z, 0, DECELERATION * delta)

	move_and_slide()
