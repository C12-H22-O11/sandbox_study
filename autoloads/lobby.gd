extends Node

signal initialized
signal closed
signal member_connected(member_id: int)
signal member_disconnected(member_id: int)
signal member_registered(member_id: int)
signal member_unregistered(member_id: int)

enum MemberData {
	NAME,
}

var member_data: Dictionary = {}

var in_lobby := false


func _ready() -> void:
	member_connected.connect(_on_member_connected)
	member_disconnected.connect(_on_member_disconnected)
	member_registered.connect(_on_member_registered)
	member_unregistered.connect(_on_member_unregistered)


func initialize() -> void:
	initialized.emit()

func close() -> void:
	member_data = {}
	closed.emit()

func unregister(peer_id: int) -> void:
	member_data.erase(peer_id)
	member_unregistered.emit(peer_id)


#region RPCs

@rpc("any_peer", "call_remote", "reliable")
func register(registration_data: Dictionary) -> void:
	var sender_id := multiplayer.get_remote_sender_id()
	member_data[sender_id] = registration_data
	member_registered.emit(sender_id)

#endregion


#region Signal Functions

func _on_member_connected(member_id: int) -> void:
	register.rpc_id(member_id, {"id": multiplayer.get_unique_id()})

func _on_member_disconnected(member_id: int) -> void:
	unregister(member_id)

func _on_member_registered(member_id: int) -> void:
	print("Lobby: member %s registered" % member_id)

func _on_member_unregistered(member_id: int) -> void:
	print("Lobby: member %s unregistered" % member_id)

#endregion
