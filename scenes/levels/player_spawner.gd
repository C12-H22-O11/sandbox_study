class_name PlayerSpawner
extends MultiplayerSpawner

const PLAYER_SCENE := preload("res://scenes/player/player.tscn")

func _ready() -> void:
	spawn_function = spawn_player
	
func spawn_player(data: Dictionary) -> Node:
	var player_instance: Player = PLAYER_SCENE.instantiate()
	player_instance.setup_multiplayer.call_deferred(data['id'])
	return player_instance
	
@rpc("any_peer", "call_local", "reliable")
func request_spawn(data: Dictionary) -> void:
	var sender_id := multiplayer.get_remote_sender_id()
	data['id'] = sender_id 
	spawn(data)
	
	
