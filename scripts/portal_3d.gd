class_name Portal3D extends Node3D

@export var camera: Camera3D
@export var viewport_texture: ViewportTexture
@export var portal_mesh: MeshInstance3D
@export var target_portal: Portal3D

func _ready() -> void:
	(portal_mesh.get_surface_override_material(0) as StandardMaterial3D).albedo_texture = target_portal.viewport_texture

func _process(delta: float) -> void:
	var current_camera := get_viewport().get_camera_3d()
	
	var relative_pos := global_position - current_camera.global_position
	var relative_rot := global_rotation - current_camera.global_rotation
	camera.position = target_portal.global_position + relative_pos
	camera.global_rotation = target_portal.global_rotation

	prints(relative_pos, relative_rot)
