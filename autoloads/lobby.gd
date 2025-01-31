extends Node

signal lobby_initialized
signal lobby_registered
#signal lobby_data_updated
signal lobby_closed

signal member_connected(member_id: int)
signal member_disconnected(member_id: int)

signal member_registered(member_id: int)
signal member_unregistered(member_id: int)

signal member_data_changed(member_id: int, data: MemberData, value: Variant)

signal message_received(member_id: int, message: String)


enum LobbyData {
	MEMBER_LIMIT
}

enum MemberData {
	NAME,
	COLOR
}

var lobby_data := Dictionary()
var member_data := Dictionary()
var is_owner := false
var in_lobby := false


func _ready() -> void:
	member_connected.connect(_on_member_connected)
	member_disconnected.connect(_on_member_disconnected)
	member_registered.connect(_on_member_registered)
	member_unregistered.connect(_on_member_unregistered)
	Globals.user_data.changed.connect(_on_user_data_changed)


func get_local_member_data() -> Dictionary:
	var data := Dictionary()
	data[MemberData.NAME] = Globals.user_data.name
	data[MemberData.COLOR] = Globals.user_data.color
	return data

func update_member_data() -> void:
	var current_data := member_data[multiplayer.get_unique_id()] as Dictionary
	var new_data := get_local_member_data()
	
	for data: MemberData in MemberData.values():
		var current_value: Variant = current_data[data]
		var new_value: Variant = new_data[data]
		if current_value != new_value:
			set_member_data.rpc(data, new_value)

func get_member_data(member_id: int, data: MemberData) -> Variant:
	return member_data[member_id][data]

func host(member_limit: int) -> void:
	lobby_data[LobbyData.MEMBER_LIMIT] = member_limit
	is_owner = true
	initialize()

func join() -> void:
	initialize()

func initialize() -> void:
	member_data[multiplayer.get_unique_id()] = get_local_member_data()
	in_lobby = true
	lobby_initialized.emit()

func close() -> void:
	member_data = {}
	in_lobby = false
	is_owner = false
	lobby_closed.emit()

func unregister_member(member_id: int) -> void:
	member_data.erase(member_id)
	member_unregistered.emit(member_id)

func kick(member_id: int) -> void:
	multiplayer.multiplayer_peer.disconnect_peer(member_id)


#region RPCs

@rpc("any_peer", "call_remote", "reliable")
func register_member(registration_data: Dictionary) -> void:
	var sender_id := multiplayer.get_remote_sender_id()
	member_data[sender_id] = registration_data
	member_registered.emit(sender_id)

@rpc("authority", "call_remote", "reliable")
func register_lobby(registration_data: Dictionary) -> void:
	lobby_data = registration_data
	lobby_registered.emit()

@rpc("any_peer", "call_local", "reliable")
func set_member_data(data: MemberData, value: Variant) -> void:
	var sender_id := multiplayer.get_remote_sender_id()
	member_data[sender_id][data] = value
	member_data_changed.emit(sender_id, data, value)

@rpc("any_peer", "call_local", "unreliable_ordered")
func send_message(message: String) -> void:
	var sender_id := multiplayer.get_remote_sender_id()
	message_received.emit(sender_id, message)

#endregion


#region Signal Functions

func _on_member_connected(member_id: int) -> void:
	register_member.rpc_id(member_id, get_local_member_data())
	if is_owner:
		register_lobby.rpc_id(member_id, lobby_data)

func _on_member_disconnected(member_id: int) -> void:
	unregister_member(member_id)

func _on_member_registered(member_id: int) -> void:
	print("Lobby: Member %s registered" % member_id)

func _on_member_unregistered(member_id: int) -> void:
	print("Lobby: Member %s unregistered" % member_id)

func _on_user_data_changed() -> void:
	if in_lobby:
		update_member_data()

#endregion
