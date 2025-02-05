class_name State extends Node

@onready var state_machine: StateMachine = get_parent()


func enter(_from: State = null) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func exit() -> State:
	return self
