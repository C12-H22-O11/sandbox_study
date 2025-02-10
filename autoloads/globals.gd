extends Node
## Singleton used for storing and keeping accessible general use variables.


var e_net_settings := ENetSettings.load_or_create() ## Auto-saving resource holding ENet networking settings.
var user_data := UserData.load_or_create() ## Auto-saving resource holding the user data.


func _ready() -> void:
	e_net_settings.changed.connect(_on_e_net_settings_changed)
	user_data.changed.connect(_on_user_data_changed)


func _on_e_net_settings_changed() -> void:
	e_net_settings.save()

func _on_user_data_changed() -> void:
	user_data.save()
