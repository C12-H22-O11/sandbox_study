class_name ENetSettings extends Resource

const PATH := "user://e_net_settings.tres"

@export_category("Host")
@export var host_slots: int = 2:
	set(value):
		if host_slots != value:
			host_slots = value
			emit_changed()
@export var host_port: int = 25565:
	set(value):
		if host_port != value:
			join_port = value
			emit_changed()

@export_category("Join")
@export var join_ip: String = "localhost":
	set(value):
		if join_ip != value:
			join_ip = value
			emit_changed()
@export var join_port: int = 25565:
	set(value):
		if join_port != value:
			join_port = value
			emit_changed()


func save() -> void:
	ResourceSaver.save(self, PATH)


static func load_or_create() -> ENetSettings:
	if ResourceLoader.exists(PATH ):
		return ResourceLoader.load(PATH)
	return ENetSettings.new()
