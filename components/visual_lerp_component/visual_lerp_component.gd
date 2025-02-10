class_name VisualLerpComponent extends Node3D
## Interpolates the position of this component relative to its parent.


@onready var _parent := get_parent() as Node3D
@onready var _previous_velocity := Vector3()
@onready var _previous_position := _parent.global_position


func _process(delta: float) -> void:
	var current_position := _parent.global_position
	var current_velocity := _get_velocity()
	if _previous_position == current_position and _previous_velocity == current_velocity:
		return
	
	if Engine.get_frames_per_second() > Engine.physics_ticks_per_second:
		if not top_level:
			top_level = true
		var interpolation_factor := Engine.get_physics_interpolation_fraction()
		
		
		var new_position := (_previous_position + _previous_velocity * delta).lerp((current_position + current_velocity * delta), interpolation_factor)
		position = new_position
		_previous_position = current_position
		_previous_velocity = current_velocity
	else:
		if top_level:
			top_level = false
			position = Vector3()


func _get_velocity() -> Vector3:
	return _parent.global_position - _previous_position
