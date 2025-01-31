extends PanelContainer

@export var member_container: Container
@export var close_button: Button


func _ready() -> void:
	Lobby.initialized.connect(_on_lobby_initialized)
	Lobby.closed.connect(_on_lobby_closed)
	Lobby.member_registered.connect(_on_member_registered)
	Lobby.member_unregistered.connect(_on_member_unregistered)
	close_button.pressed.connect(_on_close_button_pressed)


func fill() -> void:
	add_member(multiplayer.get_unique_id())
	for member_id: int in Lobby.member_data:
		pass

func clear() -> void:
	for child in member_container.get_children():
		member_container.remove_child(child)
		child.queue_free()


func add_member(member_id: int) -> void:
	member_container.add_child(MemberLabel.new(member_id))

func remove_member(member_id: int) -> void:
	for member_label: MemberLabel in member_container.get_children().filter(
		func(m: MemberLabel): return m.member_id == member_id
		):
		member_container.remove_child(member_label)
		member_label.queue_free()


#region Signal Functions

func _on_lobby_initialized() -> void:
	fill()
	close_button.disabled = false

func _on_lobby_closed() -> void:
	clear()
	close_button.disabled = true

func _on_member_registered(member_id: int) -> void:
	add_member(member_id)

func _on_member_unregistered(member_id: int) -> void:
	remove_member(member_id)

func _on_close_button_pressed() -> void:
	Lobby.close()

#endregion
