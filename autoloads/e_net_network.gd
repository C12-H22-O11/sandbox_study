extends Node

signal server_created(slot_count: int)


func _ready() -> void:
	server_created.connect(_on_server_created)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	Lobby.lobby_closed.connect(_on_lobby_closed)


func host() -> void:
	var port: int = Globals.e_net_settings.host_port
	var slots: int = Globals.e_net_settings.host_slots
	var enet_peer := ENetMultiplayerPeer.new()
	var error := enet_peer.create_server(port, slots)
	assert(error == OK, "Could not host ENet lobby")
	multiplayer.multiplayer_peer = enet_peer
	print("ENetNetwork (%s): Server created" % multiplayer.get_unique_id())
	server_created.emit(slots)

func join() -> void:
	var ip: String = Globals.e_net_settings.join_ip
	var port: int = Globals.e_net_settings.join_port
	var enet_peer := ENetMultiplayerPeer.new()
	var error := enet_peer.create_client(ip, port)
	assert(error == OK, "Could not create ENet client")
	multiplayer.multiplayer_peer = enet_peer
	print("ENetNetwork (%s): Client created" % multiplayer.get_unique_id())


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
