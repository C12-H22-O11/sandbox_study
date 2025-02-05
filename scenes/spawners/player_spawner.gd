class_name PlayerSpawner extends MultiplayerSpawner

const PLAYER_SCENE := preload("res://scenes/player/player.tscn")

var spawned_players := {}


func _ready() -> void:
	Lobby.member_unregistered.connect(_on_member_unregistered)
	spawn_function = spawn_player


func spawn_player(data: Dictionary) -> Node:
	var player_instance: Player = PLAYER_SCENE.instantiate()
	var player_id: int = data['id']
	var player_position: Vector3 = data['position']
	var player_normal: Vector3 = data['normal']
	
	player_instance.owner_id = player_id
	player_instance.setup_multiplayer.call_deferred(player_id)
	player_instance.set_position.call_deferred(player_position)
	
	spawned_players[player_id] = player_instance
	
	return player_instance


@rpc("any_peer", "call_local", "reliable")
func request_spawn(data: Dictionary) -> void:
	var sender_id := multiplayer.get_remote_sender_id()
	if not spawned_players.has(sender_id):
		data['id'] = sender_id 
		spawn(data)


func _on_member_unregistered(member_id: int) -> void:
	spawned_players[member_id].queue_free()
	spawned_players.erase(member_id)
	
	#for child in get_node(spawn_path).get_children():
		#if child is Player:
			#if child.owner_id == member_id:
				#child.queue_free()
