class_name StateMachine extends Node

signal state_exited(state: State)
signal state_entered(state: State)
signal transitioned(from: State, to: State)

@export var current_state: State

var previous_state: State = null


func _ready() -> void:
	assert(current_state != null, "State does not have current node")
	
	for state in get_states():
		state.transition_request.connect(_on_transition_request.bind(state))
	
	transition(current_state, previous_state)


func _process(delta: float) -> void:
	current_state.update(delta)

func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)


func get_states() -> Array[State]:
	var states: Array[State] = []
	for child in get_children():
		if child is State:
			states.append(child)
	return  states

func transition(to_state: State, from_state: State) -> void:
	previous_state = from_state
	
	if previous_state == null:
		if previous_state != current_state:
			previous_state = current_state
			
	else:
		previous_state.exit()
	
	state_exited.emit(previous_state)
	
	current_state = to_state
	current_state.active = true
	current_state.enter(previous_state)
	state_entered.emit(current_state)
	
	transitioned.emit(previous_state, current_state)


func _on_transition_request(to_path: NodePath, from: State) -> void:
	transition(get_node(to_path), previous_state if from == null else from)
