class_name StateMachine extends Node

signal state_exited(state: State)
signal state_entered(state: State)
signal transitioned(from: State, to: State)

@export var current_state: State


func _ready() -> void:
	assert(current_state != null, "State does not have current node")
	
	for state in get_states():
		state.requested_transition.connect(_on_requested_transition.bind(state))
	
	transition(current_state, null)


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
	if from_state: 
		from_state.exit()
	state_exited.emit(from_state)
	
	current_state = to_state
	await to_state.enter(from_state)
	state_entered.emit(to_state)
	
	transitioned.emit(from_state, current_state)

func _on_requested_transition(to_path: NodePath, from: State) -> void:
	transition(get_node(to_path), from)
