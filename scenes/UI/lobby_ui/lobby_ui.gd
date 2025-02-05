extends Control


func _input(_event: InputEvent) -> void:
	visible = Input.is_action_pressed("overlay")
