@tool
class_name Portal3D extends Node3D

@export var camera: Camera3D
@export var viewport: SubViewport
@export var portal_mesh: MeshInstance3D
@export var target_portal: Portal3D

var camera_feed: CameraFeed


func _ready() -> void:
	var viewport_texture := ViewportTexture.new()
	viewport_texture.viewport_path = viewport.get_path()
	(portal_mesh.get_surface_override_material(0) as StandardMaterial3D).albedo_texture = viewport_texture
	
