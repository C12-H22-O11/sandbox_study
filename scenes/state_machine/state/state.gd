class_name State extends Node

signal transition_request(to: StringName)

var active := false


func enter(_from: State = null) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func exit() -> State:
	return self

func request_transition(to: NodePath):
	if active: 
		active = false
		transition_request.emit(to)
