extends PlayerState

@export var speed: float = 10.0
@export var acceleration: float = 30.0
@export var deceleration: float = 30.0

var previous_state: State = null
var flying := false

func _ready() -> void:
	player.input.action_just_pressed.connect(_on_action_just_pressed)

func enter(from: State = null) -> void:
	previous_state = from
	player.velocity = Vector3()
	flying = true
	player.move_and_slide()

func physics_update(delta: float) -> void:
	player.apply_movement(
		player.input.get_rotated_input(),
		speed, 
		acceleration,
		deceleration,
		delta
	)
	
	move_and_slide()
 
func exit() -> State:
	flying = false
	return self


func _on_action_just_pressed(action: StringName) -> void:
	if action == "no_clip":
		if not flying:
			request_transition("Flying")
		else:
			request_transition("Idle")
