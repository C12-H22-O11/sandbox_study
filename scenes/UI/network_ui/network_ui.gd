extends PanelContainer

@export_category("Host")
@export var host_port_spin_box: SpinBox
@export var host_slots_spin_box: SpinBox
@export var host_button: Button
@export_category("Join")
@export var join_ip_line_edit: LineEdit
@export var join_port_spin_box: SpinBox
@export var join_button: Button


func _ready() -> void:
	setup()


func setup() -> void:
	host_port_spin_box.set_value_no_signal(Globals.e_net_settings.host_port)
	host_port_spin_box.value_changed.connect(func(new_port: float) -> void: Globals.e_net_settings.host_port = int(new_port))
	
	host_slots_spin_box.set_value_no_signal(Globals.e_net_settings.host_slots)
	host_slots_spin_box.value_changed.connect(func(new_slots: float) -> void: Globals.e_net_settings.host_slots = int(new_slots))
	
	
	join_ip_line_edit.text = Globals.e_net_settings.join_ip
	join_ip_line_edit.text_changed.connect(func(new_ip: String) ->void: Globals.e_net_settings.join_ip = new_ip)
	
	join_port_spin_box.set_value_no_signal(Globals.e_net_settings.join_port)
	join_port_spin_box.value_changed.connect(func(new_port: float) -> void: Globals.e_net_settings.join_port = int(new_port))
	
	host_button.pressed.connect(_on_host_pressed)
	join_button.pressed.connect(_on_join_pressed)


#region Signal Functions

func _on_host_pressed() -> void:
	ENetNetwork.host()

func _on_join_pressed() -> void:
	ENetNetwork.join()

#endregion
