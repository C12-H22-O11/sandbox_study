class_name PlayerState extends State

@export var gravity := Vector3.DOWN * 9.81

@onready var player: Player = owner

func move_and_slide() -> void:
	player.move_and_slide()

func move_and_slide_snapped() -> void:
	player.apply_floor_snap()
	player.move_and_slide()
