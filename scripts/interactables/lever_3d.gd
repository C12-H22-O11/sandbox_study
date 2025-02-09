class_name Lever3D extends Node3D

signal toggled(toggle: bool)

@export var interact_area_component: InteractAreaComponent
@export var rotation_point: Node3D

var tween: Tween = null
var is_toggle: bool = false


func _ready() -> void:
	interact_area_component.interaction.connect(_on_interaction)
	toggled.connect(_on_toggled)


func toggle(): 
	is_toggle = !is_toggle
	toggled.emit(is_toggle)
	
	

func _on_interaction(_from: Player) -> void:
	toggle()
	


func _on_toggled(toggle: bool) -> void:
	if tween != null:
		tween.stop()
	else:
		tween = create_tween()
		
	print(toggle)
	if toggle:
		tween.tween_property(rotation_point, "rotation", Vector3(0,0,TAU/8), 1)
	else:
		tween.tween_property(rotation_point, "rotation", Vector3(0,0,-TAU/8), 1) 
