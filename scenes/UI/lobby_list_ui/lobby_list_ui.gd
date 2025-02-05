extends PanelContainer

@export var member_count_label: Label
@export var member_container: Container


func _ready() -> void:
	Lobby.lobby_initialized.connect(_on_lobby_initialized)
	Lobby.lobby_registered.connect(_on_lobby_registered)
	Lobby.lobby_closed.connect(_on_lobby_closed)
	Lobby.member_registered.connect(_on_member_registered)
	Lobby.member_unregistered.connect(_on_member_unregistered)
	fill()
	update()


func update() -> void:
	update_member_count_label()
	member_count_label.visible = Lobby.in_lobby


func fill() -> void:
	for member_id: int in Lobby.member_data:
		add_member(multiplayer.get_unique_id())

func clear() -> void:
	for child in member_container.get_children():
		member_container.remove_child(child)
		child.queue_free()

func update_member_count_label() -> void:
	var member_count := multiplayer.get_peers().size()
	var member_limit := Lobby.lobby_data.get(Lobby.LobbyData.MEMBER_LIMIT, 4) as int
	var member_count_str := "%s/%s" % [member_count, member_limit]
	member_count_label.text = member_count_str

func add_member(member_id: int) -> void:
	member_container.add_child(MemberMenuButton.new(member_id))

func remove_member(member_id: int) -> void:
	for member_label: MemberMenuButton in member_container.get_children().filter(
		func(m: MemberMenuButton) -> bool: return m.member_id == member_id
		):
		member_container.remove_child(member_label)
		member_label.queue_free()


#region Signal Functions

func _on_lobby_initialized() -> void:
	clear()
	fill()
	update()

func _on_lobby_registered() -> void:
	update()

func _on_lobby_closed() -> void:
	clear()
	update()

func _on_member_registered(member_id: int) -> void:
	add_member(member_id)
	update_member_count_label()

func _on_member_unregistered(member_id: int) -> void:
	remove_member(member_id)
	update_member_count_label()

#endregion
