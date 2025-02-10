class_name InteractAreaComponent extends Area3D
## Component that handles player interactions.


## Emitted when a player uses interacts with the component the [method interact] method.
signal interaction(from: Player)

## When [code]true[/code], the player will be able to interact with the component every physic tick.
## When [code]false[/code], the player will only be able to interact with the component once or until they release the interact action
@export var continuous: bool = true

## Used to emit [signal interaction], primarily when a [Player] calls [method interact] with its interaction ray cast.
func interact(from: Player) -> void:
	interaction.emit(from)
