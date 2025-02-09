extends PanelContainer

@export var player: Player
@export var state_machine: StateMachine

@export var current_state_label: Label


func _ready() -> void:
	if player.owner_id != multiplayer.get_unique_id():
		self.queue_free()
		
	state_machine.transitioned.connect(_on_state_transitioned)

func _on_state_transitioned(from: State, to: State) -> void:
	var to_str: String = "Current state: %s" % to.name if to else ""
	var from_str: String = " - (prev: %s)" % from.name if from else ""
	current_state_label.text = "%s%s " % [to_str, from_str]
