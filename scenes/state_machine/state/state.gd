class_name State extends Node

@onready var state_machine: StateMachine = get_parent()


func enter(from: State = null) -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass

func exit() -> State:
	return self
