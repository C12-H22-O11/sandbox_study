class_name InteractAreaComponent extends Area3D

signal interaction(from: Player)

@export var continuous: bool = true


func interact(from: Player) -> void:
	interaction.emit(from)
