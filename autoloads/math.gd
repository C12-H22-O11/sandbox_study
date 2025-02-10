extends Node
## Singleton used as a math library.

## Takes [param vector] and returns it normalized and scaled using the value of its "longest" axis. [br]
## Should primarily be used with orthonormed vectors whose component values are kept between [code]-1.0[/code] and [code]1.0[/code], 
## otherwise it might return unexpected values.
func get_scaled_normalized_vector3(vector: Vector3) -> Vector3:
	var vector_abs := vector.abs()
	var max_axis_index := vector_abs.max_axis_index()
	var max_axis_value := vector_abs[max_axis_index]
	return vector.normalized() * max_axis_value

## Takes [param vector] and nullifies its value along [param exclude_axis]
func get_planar_vector3(vector: Vector3, exclude_axis: Vector3) -> Vector3:
	assert(exclude_axis.is_normalized(), "Exclude axis should be normalized.")
	var exclude_axis_value := vector.dot(exclude_axis.normalized())
	return vector - (exclude_axis.normalized() * exclude_axis_value)
