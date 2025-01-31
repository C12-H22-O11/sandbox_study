class_name UserData extends Resource

const PATH := "user://user_data.tres"


@export var name: String = "Player":
	set(value):
		name = value
		emit_changed()
@export var color: Color = Color.AQUA:
	set(value):
		color = value
		emit_changed()


func save() -> void:
	ResourceSaver.save(self, PATH)


static func load_or_create() -> UserData:
	if ResourceLoader.exists(PATH, "UserData"):
		return ResourceLoader.load(PATH, "UserData")
	return UserData.new()
