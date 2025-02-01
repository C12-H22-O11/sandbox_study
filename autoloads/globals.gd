extends Node

var e_net_settings := ENetSettings.load_or_create()
var user_data := UserData.load_or_create()


func _ready() -> void:
	e_net_settings.changed.connect(_on_e_net_settings_changed)
	user_data.changed.connect(_on_user_data_changed)


func _on_e_net_settings_changed() -> void:
	e_net_settings.save()

func _on_user_data_changed() -> void:
	user_data.save()
