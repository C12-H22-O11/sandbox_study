class_name ElevatorFloor3D extends Node3D

signal called

@export var buttons: Array[Button3D]

func _ready() -> void:
	for button in buttons:
		button.just_pressed.connect(_on_button_just_pressed)

func _on_button_just_pressed() -> void:
	called.emit()
