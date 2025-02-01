extends MultiplayerSpawner

const BALL_SCENE := preload("res://scenes/levels/ball/ball.tscn")

func _ready() -> void:
	spawn_function = spawn_object
	spawn(Vector3.ZERO)

func spawn_object(pos: Vector3) -> Node:
	var ball_instance : RigidBody3D = BALL_SCENE.instantiate()
	ball_instance.position = pos
	return ball_instance
