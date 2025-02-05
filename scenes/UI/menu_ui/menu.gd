extends Control


func _ready() -> void:
	Lobby.lobby_initialized.connect(_on_lobby_initialized)
	Lobby.lobby_closed.connect(_on_lobby_closed)


func _on_lobby_initialized() -> void:
	hide()

func _on_lobby_closed() -> void:
	show()
