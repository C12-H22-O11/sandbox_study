extends Node

signal created
signal joined
signal closed
signal member_registered(member_id: int)
signal member_unregistered(member_id: int)

var member_data: Dictionary = {}


func _ready() -> void:
	member_registered.connect(_on_member_registered)
	member_unregistered.connect(_on_member_unregistered)


func close() -> void:
	member_data = {}
	closed.emit()

func unregister(peer_id: int) -> void:
	member_data.erase(peer_id)
	member_unregistered.emit(peer_id)


#region RPCs

@rpc("any_peer", "call_remote")
func register(registration_data: Dictionary) -> void:
	var sender_id := multiplayer.get_remote_sender_id()
	member_data[sender_id] = registration_data
	member_registered.emit(sender_id)

#endregion


#region Signal Functions

func _on_member_registered(member_id: int) -> void:
	print("Lobby: member %s registered" % member_id)

func _on_member_unregistered(member_id: int) -> void:
	print("Lobby: member %s unregistered" % member_id)

#endregion
