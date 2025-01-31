extends Node

signal server_created
signal server_joined
signal peer_connected(peer_id: int)
signal peer_disconnected(peer_id: int)

func _ready() -> void:
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.peer_connected.connect(_on_peer_connected)


func host(port: int, slots: int) -> void:
	var enet_peer := ENetMultiplayerPeer.new()
	var error := enet_peer.create_server(port, slots)
	assert(error == OK, "Could not host ENet lobby")
	multiplayer.multiplayer_peer = enet_peer
	server_created.emit()

func join(address: String, port: int) -> void:
	var enet_peer := ENetMultiplayerPeer.new()
	var error := enet_peer.create_client(address, port)
	assert(error == OK, "Could not create ENet client")
	multiplayer.multiplayer_peer = enet_peer


func _on_connected_to_server() -> void:
	server_joined.emit()


func _on_peer_connected(peer_id: int) -> void:
	pass
