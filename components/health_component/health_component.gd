class_name HealthComponent extends Node

signal changed(new_health: float)
signal healed(amount: float, overhead: float)
signal damaged(amount: float)

@export var max_health: float = 100.0
@export var current_health: float = 100.0


func heal(amount: float, limit_to_max_health := true) -> void:
	current_health += amount
	
	if limit_to_max_health:
		current_health = minf(max_health, current_health)
	healed.emit()

func damage(amount: float) -> void:
	current_health -= amount
	damaged.emit(amount)
	if current_health <= 0:
		current_health = 0
