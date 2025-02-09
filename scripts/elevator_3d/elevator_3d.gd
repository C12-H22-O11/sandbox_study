class_name Elevator_3D extends AnimatableBody3D

signal lifted(lift: bool)

@export var floors: Array[ElevatorFloor3D]
@export var animation_duration: float = .2


var tween: Tween
var is_lifted: bool = false


func _ready() -> void:
	for floor in floors:
		floor.called.connect(_on_floor_called.bind(floor))
	
	
func lift(floor: ElevatorFloor3D) -> void: 
	
	if tween:
		if  tween.is_running(): 
			tween.stop()
			
	tween = create_tween()
	tween.tween_property(self, "position", floor.position, animation_duration)
	lifted.emit(is_lifted)
	
	
func _on_floor_called(floor: ElevatorFloor3D) -> void:
	print(floor)
	lift(floor)
