class_name Elevator_3D extends AnimatableBody3D

signal lifted(lift: bool)

@export var levers: Array[Lever3D]
@export var animation_duration: float = .2

@onready var start_position: Vector3 = position


var tween: Tween
var is_lifted: bool = false


func _ready() -> void:
	lifted.connect(_on_lifted)
	for lever in levers:
		lever.toggled.connect(_on_lever_toggled)
	
	
func lift() -> void: 
	is_lifted = !is_lifted
	lifted.emit(is_lifted)
	
	
func _on_lever_toggled(toggled: bool) -> void:
	lift()

func _on_lifted(lift: bool) -> void:
	if tween:
		if  tween.is_running(): 
			tween.stop()
	if lift:
		tween = create_tween()
		tween.tween_property(self, "position", start_position + Vector3(0, 5, 0), animation_duration)

	else:
		tween = create_tween()
		tween.tween_property(self, "position", start_position, animation_duration)
