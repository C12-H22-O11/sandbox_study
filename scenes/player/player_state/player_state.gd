class_name PlayerState extends State
## Player-specific state, to be used as child of a [StateMachine].

## [annotation @export] State defined gravity to apply to the player.
@export var gravity := Vector3.DOWN * 9.81

## [annotation @onready] Owner [Player] reference.
@onready var player: Player = owner

## State helper function that does [method CharacterBody3D.move_and_slide]
func move_and_slide() -> bool:
	return player.move_and_slide()

## State helper function that does [method CharacterBody3D.apply_floor_snap] and [method CharacterBody3D.move_and_slide]
func move_and_slide_snapped() -> bool:
	player.apply_floor_snap()
	return player.move_and_slide()
