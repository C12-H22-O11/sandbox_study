class_name UserData extends Resource
## Saving-to-system resource that stores ENet networking settings.

## Resource system path.
const PATH := "user://user_data.tres"


@export var name: String = "Player": ## User name.
	set(value):
		if name != value:
			name = value
			emit_changed()
@export var color: Color = Color.AQUA: ## User color.
	set(value):
		if color != value:
			color = value
			emit_changed()

## Saves the resource on system using [member PATH]
func save() -> void:
	ResourceSaver.save(self, PATH)

## Tries to load resource from system and to return it. Returns new resource if none is found.
static func load_or_create() -> UserData:
	if ResourceLoader.exists(PATH ):
		return ResourceLoader.load(PATH)
	return UserData.new()
