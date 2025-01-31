extends Node

signal initialized
signal closed
signal member_connected(member_id: int)
signal member_disconnected(member_id: int)
signal member_registered(member_id: int)
signal member_unregistered(member_id: int)
signal member_data_changed(member_id: int, data_type: MemberDataType, value: Variant)

enum MemberDataType {
	NAME,
	COLOR
}

var member_data := Dictionary()
var in_lobby := false


func _ready() -> void:
	member_connected.connect(_on_member_connected)
	member_disconnected.connect(_on_member_disconnected)
	member_registered.connect(_on_member_registered)
	member_unregistered.connect(_on_member_unregistered)
	Globals.user_data.changed.connect(_on_user_data_changed)


func get_local_data() -> Dictionary:
	var data := Dictionary()
	data[MemberDataType.NAME] = Globals.user_data.name
	data[MemberDataType.COLOR] = Globals.user_data.color
	return data

func update_member_data() -> void:
	var current_data := member_data[multiplayer.get_unique_id()] as Dictionary
	var new_data := get_local_data()
	
	for data_type in MemberDataType.values():
		var current_value: Variant = current_data[data_type]
		var new_value: Variant = new_data[data_type]
		if current_value != new_value:
			set_member_data.rpc(data_type, new_value)

func get_member_data(member_id: int, data_type: MemberDataType) -> Variant:
	return member_data[member_id][data_type]

func initialize() -> void:
	member_data[multiplayer.get_unique_id()] = get_local_data()
	in_lobby = true
	initialized.emit()

func close() -> void:
	member_data = {}
	in_lobby = false
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

@rpc("any_peer", "call_local", "reliable")
func set_member_data(data_type: MemberDataType, value: Variant) -> void:
	var sender_id := multiplayer.get_remote_sender_id()
	member_data[sender_id][data_type] = value
	member_data_changed.emit(sender_id, data_type, value)

#endregion


#region Signal Functions

func _on_member_connected(member_id: int) -> void:
	register.rpc_id(member_id, get_local_data())

func _on_member_disconnected(member_id: int) -> void:
	unregister(member_id)

func _on_member_registered(member_id: int) -> void:
	print("Lobby: member %s registered" % member_id)

func _on_member_unregistered(member_id: int) -> void:
	print("Lobby: member %s unregistered" % member_id)

func _on_user_data_changed() -> void:
	if in_lobby:
		update_member_data()

#endregion
