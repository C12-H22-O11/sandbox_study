class_name StateMachine extends Node

@export var current_state: State
@export var state_label: Label

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
	current_state = target_state
	target_state.enter(previous_state)
	state_label.text = current_state.name
