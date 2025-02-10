extends Node
## Network-independent abstraction singleton handling and providing lobby signals and functions. 
## Its functions are used in network-specific scripts to handle lobby logic.

## Emitted when a lobby is initialized, or more precisely when the lobbys' [member member_data], 
## [member lobby_data], ownership and state are initialized.
signal lobby_initialized 

## Emitted when the remote lobby registered its [member lobby_data] on local instance.
signal lobby_registered
#signal lobby_data_updated
## Emitted either when the lobby was closed using [method close] or when the currently used network closed connection.
signal lobby_closed

## Emitted when a member (or peer) has connected to the server (used to propagate the information to the lobby). 
## Holds the [param member_id] of the connected member.
signal member_connected(member_id: int)
## Emitted when a member (or peer) has disconnected from the server (used to propagate the information to the lobby).
## Holds the [param member_id] of the disconnected member.
signal member_disconnected(member_id: int)

## Emitted after a member has connected and registered its data in the local [member member_data].
## Holds the [param member_id] of the registered member.
signal member_registered(member_id: int)
## Emitted after a member has disconnected and after the local instance unregistered it from its [member member_data].
## Holds the [param member_id] of the unregistered member.
signal member_unregistered(member_id: int)

## Emitted when a member a value of its data in [member member_data]
## Holds the [param member_id] of the member whose data changed, the [param data] key and its [param value]
signal member_data_changed(member_id: int, data: MemberData, value: Variant)

## Emitted when a member sent message was received.
## Holds the [param member_id] of the member who sent it and its [param message] string.
signal message_received(member_id: int, message: String)


## Enum used to as keys to get lobby-specific values in [member lobby_data].
enum LobbyData {
	MEMBER_LIMIT ## Points to the member limit of the lobby.
}

## Enum used to as keys to get member-specific values in [member lobby_data] using [method get_member_data].
enum MemberData {
	NAME, ## Points a member name.
	COLOR ## Points a member color.
}

var lobby_data := Dictionary() ## Holds lobby-specific data.
var member_data := Dictionary() ## Holds all member-specific data.
var _is_owner := false
var _in_lobby := false


func _ready() -> void:
	member_connected.connect(_on_member_connected)
	member_disconnected.connect(_on_member_disconnected)
	member_registered.connect(_on_member_registered)
	member_unregistered.connect(_on_member_unregistered)
	Globals.user_data.changed.connect(_on_user_data_changed)

## Gathers local member into a returned dictionary.
func get_local_member_data() -> Dictionary:
	var data := Dictionary()
	data[MemberData.NAME] = Globals.user_data.name
	data[MemberData.COLOR] = Globals.user_data.color
	return data

## Returns a member data value using, a [param member_id] and a [enum MemberData] [param data] enum key.
func get_member_data(member_id: int, data: MemberData) -> Variant:
	return member_data[member_id][data]

## Initializes a lobby as host, takes in a [param member_limit] to hold in [member lobby_data].
func host(member_limit: int) -> void:
	lobby_data[LobbyData.MEMBER_LIMIT] = member_limit
	_is_owner = true
	_initialize()

## Initializes a joined lobby as member.
func join() -> void:
	_initialize()

## Closes the lobby.
func close() -> void:
	lobby_data = {}
	member_data = {}
	_in_lobby = false
	_is_owner = false
	lobby_closed.emit()

## Returns lobby ownership.
func is_owner() -> bool:
	return _is_owner

## Returns lobby state.
func in_lobby() -> bool:
	return _in_lobby

## Closes connection of member using [param member_id]
func kick(member_id: int) -> void:
	multiplayer.multiplayer_peer.disconnect_peer(member_id)


#region Private functions

# Initializes the lobby.
func _initialize() -> void:
	member_data = {multiplayer.get_unique_id(): get_local_member_data()}
	_in_lobby = true
	lobby_initialized.emit()

# Unregisters member from [member member_data] using the [param member_id].
func _unregister_member(member_id: int) -> void:
	#member_data.erase(member_id)
	member_unregistered.emit(member_id)

# Should only be called on the server to propage data on the [member member_data] changes
func _update_member_data() -> void:
	var current_data := member_data[multiplayer.get_unique_id()] as Dictionary
	var new_data := get_local_member_data()
	
	for data: MemberData in MemberData.values():
		var current_value: Variant = current_data[data]
		var new_value: Variant = new_data[data]
		if current_value != new_value:
			set_member_data.rpc(data, new_value)

#endregion


#region RPCs

# Registers member on remote instances.
@rpc("any_peer", "call_remote", "reliable")
func _register_member(registration_data: Dictionary) -> void:
	var sender_id := multiplayer.get_remote_sender_id()
	member_data[sender_id] = registration_data
	member_registered.emit(sender_id)

# Registers lobby on remote instances.
@rpc("authority", "call_remote", "reliable")
func _register_lobby(registration_data: Dictionary) -> void:
	lobby_data = registration_data
	lobby_registered.emit()

## [annotation @rpc] Propagates member data change on other instances.
@rpc("any_peer", "call_local", "reliable")
func set_member_data(data: MemberData, value: Variant) -> void:
	var sender_id := multiplayer.get_remote_sender_id()
	member_data[sender_id][data] = value
	member_data_changed.emit(sender_id, data, value)

## [annotation @rpc] Sends message to all instances.
@rpc("any_peer", "call_local", "unreliable_ordered")
func send_message(message: String) -> void:
	var sender_id := multiplayer.get_remote_sender_id()
	message_received.emit(sender_id, message)

#endregion


#region Signal Functions

func _on_member_connected(member_id: int) -> void:
	_register_member.rpc_id(member_id, get_local_member_data())
	if _is_owner:
		_register_lobby.rpc_id(member_id, lobby_data)

func _on_member_disconnected(member_id: int) -> void:
	_unregister_member(member_id)

func _on_member_registered(member_id: int) -> void:
	print("Lobby: Member %s registered" % member_id)

func _on_member_unregistered(member_id: int) -> void:
	print("Lobby: Member %s unregistered" % member_id)

func _on_user_data_changed() -> void:
	if in_lobby():
		_update_member_data()

#endregion
