class_name Button3D extends Node3D

signal just_pressed
signal just_released

@export var interact_area_component: InteractAreaComponent
@export var timer: Timer
@export var button_mesh: MeshInstance3D


var pressed := false
var tween: Tween

func _ready() -> void:
	interact_area_component.interaction.connect(_on_interaction)
	timer.timeout.connect(_on_timeout)
	just_pressed.connect(_on_just_pressed)
	just_released.connect(_on_just_released)


func press() -> void:
	if not pressed:
		pressed = true
		just_pressed.emit()
	timer.start()


func _on_interaction(from: Player) -> void:
	press()

func _on_timeout() -> void:
	pressed = false
	just_released.emit()

func _on_just_pressed() -> void:
	if tween and tween.is_running():
		tween.stop()
	tween = create_tween()
	tween.tween_property(button_mesh, "position", Vector3.UP * .025, 0.05).set_ease(Tween.EASE_IN_OUT)

func _on_just_released() -> void:
	if tween and tween.is_running():
		tween.stop()
	tween = create_tween()
	tween.tween_property(button_mesh, "position", Vector3.UP * .05, 0.05).set_ease(Tween.EASE_IN_OUT)
