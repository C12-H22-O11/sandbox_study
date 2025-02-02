class_name StateMachine extends Node

signal state_exited(state: State)
signal state_entered(state: State)
signal transitioned(from: State, to: State)

@export var current_state: State


func _ready() -> void:
	assert(current_state != null, "State does not have current node")
	
	transition(self.get_path_to(current_state))


func _process(delta: float) -> void:
	current_state.update(delta)

func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)


func transition(to: NodePath) -> void:
	var previous_state := 	await current_state.exit()
	var target_state := get_node(to) as State
	state_exited.emit(previous_state)
	
	current_state = target_state
	await target_state.enter(previous_state)
	state_entered.emit(target_state)
	transitioned.emit(previous_state, current_state)
