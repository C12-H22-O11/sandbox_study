class_name ENetSettings extends Resource
## Saving-to-system resource that stores ENet networking settings.

## Resource system path.
const PATH := "user://e_net_settings.tres"

@export_category("Host")
@export var host_slots: int = 2: ## ENet slot limit.
	set(value):
		if host_slots != value:
			host_slots = value
			emit_changed()
@export var host_port: int = 25565: ## ENet host port.
	set(value):
		if host_port != value:
			host_port = value
			emit_changed()

@export_category("Join")
@export var join_ip: String = "localhost": ## ENet join ip address.
	set(value):
		if join_ip != value:
			join_ip = value
			emit_changed()
@export var join_port: int = 25565: ## ENet join port.
	set(value):
		if join_port != value:
			join_port = value
			emit_changed()

## Saves the resource on system using [member PATH]
func save() -> void:
	ResourceSaver.save(self, PATH)

## Tries to load resource from system and to return it. Returns new resource if none is found.
static func load_or_create() -> ENetSettings:
	if ResourceLoader.exists(PATH ):
		return ResourceLoader.load(PATH)
	return ENetSettings.new()
