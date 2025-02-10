class_name State extends Node
## State, to be used as child of a [StateMachine].

## Emitted when the node requests to the state machine to transition to another state
signal transition_request(to: StringName)

# Defines if the node is active.
var _active := false

## Called when entering the state, takes [param from] as the previous state.
func enter(_from: State = null) -> void:
	pass

## Called every frame when the state is active.
func update(_delta: float) -> void:
	pass

## Called every tick when the state is active.
func physics_update(_delta: float) -> void:
	pass

## Called when exiting the state, returns itself.
func exit() -> State:
	return self

## Returns state activation state.
func is_active() -> bool:
	return _active

## Deactivates the state and requests for transition with [param to].
func request_transition(to: NodePath):
	if _active: 
		_active = false
		transition_request.emit(to)
