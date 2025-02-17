extends PanelContainer

@export var player: Player
@export var state_machine: StateMachine

@export var current_state_label: Label


func _ready() -> void:
	state_machine.transitioned.connect(_on_state_transitioned)

func _on_state_transitioned(from: State, to: State) -> void:
	current_state_label.text = "Current state: %s (prev: %s) " % [to.name, from.name]
