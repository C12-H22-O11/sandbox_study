extends MultiplayerSpawner

const BALL_SCENE := preload("res://scenes/ball/ball.tscn")

func _ready() -> void:
	spawn_function = spawn_object

func spawn_object(data := {}) -> Node:
	var position: Vector3 = data['position']
	var normal: Vector3 = data['normal']
	var ball_instance : RigidBody3D = BALL_SCENE.instantiate()
	var ball_bounds := AABB()
	
	for child in ball_instance.get_children():
		if child is VisualInstance3D:
			ball_bounds = ball_bounds.merge(child.get_aabb())
	
	var ball_center :=  ball_bounds.position + ball_bounds.size
	
	print("Spawning %s at %s" % [ball_instance.name, position])
	ball_instance.position = position
	return ball_instance

@rpc("any_peer", "call_local", "reliable")
func request_spawn(data: Dictionary) -> void:
	spawn(data)
