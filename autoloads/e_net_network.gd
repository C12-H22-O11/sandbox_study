extends Node


func _ready() -> void:
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func host(port: int, slots: int) -> void:
	var enet_peer := ENetMultiplayerPeer.new()
	var error := enet_peer.create_server(port, slots)
	assert(error == OK, "Could not host ENet lobby")
	multiplayer.multiplayer_peer = enet_peer
	print("ENetNetwork (%s): Server created" % multiplayer.get_unique_id())
	Lobby.created.emit()

func join(address: String, port: int) -> void:
	var enet_peer := ENetMultiplayerPeer.new()
	var error := enet_peer.create_client(address, port)
	assert(error == OK, "Could not create ENet client")
	multiplayer.multiplayer_peer = enet_peer
	print("ENetNetwork (%s): Client created" % multiplayer.get_unique_id())


func _on_connected_to_server() -> void:
	print("ENetNetwork (%s): Connected to server" % multiplayer.get_unique_id())
	Lobby.joined.emit()

func _on_peer_connected(peer_id: int) -> void:
	print("ENetNetwork (%s): peer %s connected" % [multiplayer.get_unique_id(), peer_id])
	Lobby.register.rpc_id(peer_id, {"id": multiplayer.get_unique_id()})

func _on_peer_disconnected(peer_id: int) -> void:
	print("ENetNetwork (%s): peer %s disconnected" % [multiplayer.get_unique_id(), peer_id])
	Lobby.unregister(peer_id)

func _on_server_disconnected() -> void:
	print("ENetNetwork (%s): Server disconnected" % multiplayer.get_unique_id())
	Lobby.close()
