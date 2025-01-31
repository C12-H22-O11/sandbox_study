extends PanelContainer

@export_category("Host")
@export var host_port_spin_box: SpinBox
@export var slots_spin_box: SpinBox
@export var host_button: Button
@export_category("Join")
@export var ip_adress_line_edit: LineEdit
@export var join_port_spin_box: SpinBox
@export var join_button: Button


func _ready() -> void:
	Lobby.created.connect(_on_lobby_created)
	Lobby.joined.connect(_on_lobby_joined)
	Lobby.closed.connect(_on_lobby_closed)
	host_button.pressed.connect(_on_host_pressed)
	join_button.pressed.connect(_on_join_pressed)


func _on_lobby_created() -> void: 
	hide()

func _on_lobby_joined() -> void: 
	hide()

func _on_lobby_closed() -> void:
	show()

func _on_host_pressed() -> void:
	var port := int(host_port_spin_box.value)
	var slots := int(slots_spin_box.value)
	ENetNetwork.host(port, slots)

func _on_join_pressed() -> void:
	var address := ip_adress_line_edit.text
	var port := int(join_port_spin_box.value)
	ENetNetwork.join(address, port)
