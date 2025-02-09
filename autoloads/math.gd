extends Node


func get_scaled_normalized_vector3(vector: Vector3) -> Vector3:
	var vector_abs := vector.abs()
	var max_axis_index := vector_abs.max_axis_index()
	var max_axis_value := vector_abs[max_axis_index]
	return vector.normalized() * max_axis_value

func get_planar_vector3(vector: Vector3, exclude_axis: Vector3) -> Vector3:
	var exclude_axis_value := vector.dot(exclude_axis.normalized())
	return vector - (exclude_axis.normalized() * exclude_axis_value)
