extends VBoxContainer

@export var member_container: Container


func _ready() -> void:
	Lobby.initialized.connect(_on_lobby_initialized)
	Lobby.closed.connect(_on_lobby_closed)
	Lobby.member_registered.connect(_on_member_registered)
	Lobby.member_unregistered.connect(_on_member_unregistered)


func fill() -> void:
	add_member(multiplayer.get_unique_id())
	for member_id in Lobby.member_data:
		pass

func clear() -> void:
	for child in member_container.get_children():
		member_container.remove_child(child)
		child.queue_free()


func add_member(member_id: int) -> void:
	var member_label := Label.new()
	var member_name := Lobby.get_member_data(member_id, Lobby.MemberDataType.NAME) as String
	member_label.text = "%s" % member_name
	member_container.add_child(member_label)

func remove_member(member_id: int) -> void:
	pass


#region Signal Functions

func _on_lobby_initialized() -> void:
	fill()

func _on_lobby_closed() -> void:
	clear()

func _on_member_registered(member_id: int) -> void:
	add_member(member_id)

func _on_member_unregistered(member_id: int) -> void:
	remove_member(member_id)

#endregion
