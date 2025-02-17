extends MultiplayerSpawner

const SANDBOX_LEVEL := preload("res://scenes/levels/sandbox_level/sandbox_level.tscn")


func _ready() -> void:
	spawn_function = spawn_level
	Lobby.lobby_initialized.connect(_on_lobby_initialized)


func spawn_level(_data = null) -> Node:
	return SANDBOX_LEVEL.instantiate()


func _on_lobby_initialized() -> void:
	if Lobby.is_owner:
		spawn()

func _on_lobby_closed() -> void:
	for child in get_node(spawn_path).get_children():
		child.queue_free()
