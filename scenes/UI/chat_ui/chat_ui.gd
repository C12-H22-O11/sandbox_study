extends PanelContainer

@export var chat_rich_text_label: RichTextLabel
@export var chat_message_line_edit: LineEdit

var chat_messages: Array[ChatMessage] = []

func _ready() -> void:
	Lobby.lobby_initialized.connect(_on_lobby_initialized)
	Lobby.lobby_closed.connect(_on_lobby_closed)
	Lobby.member_data_changed.connect(_on_member_data_changed)
	Lobby.message_received.connect(_on_message_received)
	
	chat_message_line_edit.text_submitted.connect(_on_chat_message_submitted)


func reset() -> void:
	chat_messages.clear()
	chat_rich_text_label.text = ""

func add_message(chat_message: ChatMessage) -> void:
	var member_id := chat_message.member_id
	var message := chat_message.message
	var member_name := Lobby.get_member_data(member_id, Lobby.MemberData.NAME) as String
	var member_color := Lobby.get_member_data(member_id, Lobby.MemberData.COLOR) as Color
	chat_rich_text_label.push_color(member_color)
	chat_rich_text_label.append_text("%s: " % member_name)
	chat_rich_text_label.pop()
	chat_rich_text_label.append_text("%s\n" % message)

func update() -> void:
	chat_rich_text_label.text = ""
	for chat_message in chat_messages:
		add_message(chat_message)


func _on_lobby_initialized() -> void:
	reset()
	chat_message_line_edit.editable = true

func _on_lobby_closed() -> void:
	reset()
	chat_message_line_edit.editable = false

func _on_message_received(member_id: int, message: String) -> void:
	var chat_message := ChatMessage.new(member_id, message)
	chat_messages.append(chat_message)
	add_message(chat_message)

func _on_member_data_changed(_member_id: int, data: Lobby.MemberData, _value: Variant) -> void:
	if data == Lobby.MemberData.NAME or data == Lobby.MemberData.COLOR:
		update()

func _on_chat_message_submitted(message: String) -> void:
	if not message.is_empty():
		chat_message_line_edit.text = ""
		Lobby.send_message.rpc(message)


class ChatMessage:
	var member_id: int
	var message: String
	
	func _init(_member_id: int, _message: String) -> void:
		member_id = _member_id
		message = _message
