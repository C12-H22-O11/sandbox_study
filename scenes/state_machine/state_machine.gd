class_name StateMachine extends Node
## State machine.


## Emitted when entered in [param state]
signal state_entered(state: State)
## Emitted when exited from [param state].
signal state_exited(state: State)
## Emitted when transitioned from a state to another.
signal transitioned(from: State, to: State)

## State used as the start-up point for the state machine.
@export var start_state: State
var _current_state: State = null
var _previous_state: State = null


func _ready() -> void:
	assert(start_state != null, "State machine does not have a start state")
	_current_state = start_state
	
	for state in get_states():
		state.transition_request.connect(_on_transition_request.bind(state))
	
	_transition(_current_state, _previous_state)

func _process(delta: float) -> void:
	if _current_state.is_active():
		_current_state.update(delta)

func _physics_process(delta: float) -> void:
	if _current_state.is_active():
		_current_state.physics_update(delta)


## Gathers and returns all states found in the state machines' children into an array.
func get_states() -> Array[State]:
	var states: Array[State] = []
	for child in get_children():
		if child is State:
			states.append(child)
	return  states

# Transitions from a state to another.
func _transition(to_state: State, from_state: State) -> void:
	_previous_state = from_state
	
	if _previous_state == null:
		if _previous_state != _current_state:
			_previous_state = _current_state
			
	else:
		_previous_state.exit()
	
	state_exited.emit(_previous_state)
	
	_current_state = to_state
	_current_state._active = true
	_current_state.enter(_previous_state)
	state_entered.emit(_current_state)
	
	transitioned.emit(_previous_state, _current_state)


func _on_transition_request(to_path: NodePath, from: State) -> void:
	_transition(get_node(to_path), _previous_state if from == null else from)
