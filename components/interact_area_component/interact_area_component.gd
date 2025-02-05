class_name InteractAreaComponent extends Area3D

signal interaction(from: Player)


func interact(from: Player) -> void:
	interaction.emit(from)
