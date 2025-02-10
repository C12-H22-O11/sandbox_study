extends Node
## Singleton handling ENet client and server creation and propagation of network signals to the Lobby singleton.


## Emitted when an ENet server is created with [param slot_count] representing available slots.
signal server_created(slot_count: int)


func _ready() -> void:
	server_created.connect(_on_server_created)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	Lobby.lobby_closed.connect(_on_lobby_closed)

## Creates ENet server using saved settings in [member Globals.e_net_settings].
func host() -> Error:
	var port: int = Globals.e_net_settings.host_port
	var slots: int = Globals.e_net_settings.host_slots
	var enet_peer := ENetMultiplayerPeer.new()
	print("ENetNetwork: Attempting to create %s slot(s) server using port %s" % [slots, port])
	var error := enet_peer.create_server(port, slots)
	if error != OK:
		assert(error == OK, "ENetNetwork: Failed to create %s slot(s) server using port %s with code: %s" % [slots, port, error])
		return error
	multiplayer.multiplayer_peer = enet_peer
	print("ENetNetwork (%s): Successfully created %s slot(s) server using port %s" % [multiplayer.get_unique_id(), slots, port])
	server_created.emit(slots)
	return OK

## Creates ENet client using saved settings in [member Globals.e_net_settings]
func join() -> Error:
	var ip: String = Globals.e_net_settings.join_ip
	var port: int = Globals.e_net_settings.join_port
	print("ENetNetwork: Attempting to create client using %s:%s" % [ip, port])
	var enet_peer := ENetMultiplayerPeer.new()
	var error := enet_peer.create_client(ip, port)
	if error != OK:
		assert(error == OK, "ENetNetwork: Failed to create client using %s:%s with code: %s" % [ip, port, error])
		return error
	multiplayer.multiplayer_peer = enet_peer
	print("ENetNetwork (%s): Successfully created client using %s:%s" % [multiplayer.get_unique_id(), ip, port])
	return OK


#region Signal Functions

func _on_server_created(slot_count: int) -> void:
	Lobby.host(slot_count)

func _on_connected_to_server() -> void:
	print("ENetNetwork (%s): Connected to server" % multiplayer.get_unique_id())
	Lobby.join()

func _on_peer_connected(peer_id: int) -> void:
	print("ENetNetwork (%s): peer %s connected" % [multiplayer.get_unique_id(), peer_id])
	Lobby.member_connected.emit(peer_id)

func _on_peer_disconnected(peer_id: int) -> void:
	print("ENetNetwork (%s): peer %s disconnected" % [multiplayer.get_unique_id(), peer_id])
	Lobby.member_disconnected.emit(peer_id)

func _on_server_disconnected() -> void:
	print("ENetNetwork: Server disconnected")
	Lobby.close()

func _on_lobby_closed() -> void:
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()

#endregion
