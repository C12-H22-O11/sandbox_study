class_name PlayerSpawner
extends MultiplayerSpawner

const PLAYER_SCENE := preload("res://scenes/player/player.tscn")


func _ready() -> void:
	spawn_function = spawn_player
	
func spawn_player(data: Dictionary) -> Node:
	var player_instance: Player = PLAYER_SCENE.instantiate()
	var player_id: int = data['id']
	var player_position: Vector3 = data['position']
	var player_normal: Vector3 = data['normal']
	
	player_instance.setup_multiplayer.call_deferred(data['id'])
	player_instance.set_position.call_deferred(player_position)
	return player_instance
	
@rpc("any_peer", "call_local", "reliable")
func request_spawn(data: Dictionary) -> void:
	var sender_id := multiplayer.get_remote_sender_id()
	data['id'] = sender_id 
	spawn(data)
	
	
