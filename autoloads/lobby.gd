extends Node

signal created
signal joined
signal closed
signal member_registered(member_id: int)
signal member_unregistered(member_id: int)

var member_data: Dictionary = {}

func close() -> void:
	member_data = {}
	closed.emit()


func unregister(peer_id: int) -> void:
	member_data.erase(peer_id)
	member_unregistered.emit(peer_id)

@rpc("any_peer", "call_remote")
func register(local_data: Dictionary) -> void:
	var sender_id := multiplayer.get_remote_sender_id()
	member_data[sender_id] = local_data
	member_registered.emit(sender_id)


func _on_e_net_peer_connected(peer_id: int) -> void:
	register.rpc_id(peer_id, {"id": multiplayer.get_unique_id()})

func _on_e_net_peer_disconnected(peer_id: int) -> void:
	unregister(peer_id)
