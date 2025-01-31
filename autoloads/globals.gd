extends Node

@onready var user_data := UserData.load_or_create()


func _ready() -> void:
	user_data.changed.connect(_on_user_data_changed)


func _on_user_data_changed() -> void:
	user_data.save()
