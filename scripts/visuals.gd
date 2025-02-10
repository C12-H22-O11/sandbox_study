extends Node3D

@onready var parent := get_parent() as Node3D
@onready var previous_velocity := Vector3()
@onready var previous_position := parent.global_position


func _process(delta: float) -> void:
	if Engine.get_frames_per_second() > Engine.physics_ticks_per_second:
		if not top_level:
			top_level = true
		var interpolation_factor := Engine.get_physics_interpolation_fraction()
		var current_position := parent.global_position
		var current_velocity := current_position - previous_position
		var new_position := (previous_position + previous_velocity * delta).lerp((current_position + current_velocity * delta), interpolation_factor)
		position = new_position
		previous_position = current_position
		previous_velocity = current_velocity
	else:
		if top_level:
			top_level = false
			position = Vector3()
