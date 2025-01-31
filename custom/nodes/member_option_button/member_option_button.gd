class_name MemberMenuButton extends MenuButton

enum MemberActions {
	KICK
}

var member_id: int


func _init(_member_id: int) -> void:
	member_id = _member_id

func _ready() -> void:
	setup()
	Lobby.member_data_changed.connect(_on_member_data_changed)
	get_popup().id_pressed.connect(_on_id_pressed)


func setup() -> void:
	var self_marker := "" if multiplayer.get_unique_id() != member_id else " (Self)"
	var member_name := Lobby.get_member_data(member_id, Lobby.MemberData.NAME) as String
	var member_color := Lobby.get_member_data(member_id, Lobby.MemberData.COLOR) as Color
	text = "%s" % member_name + self_marker
	modulate = member_color
	if Lobby.is_owner and multiplayer.get_unique_id() != member_id :
		get_popup().add_item("Kick", MemberActions.KICK)
	else:
		disabled = true 


func _on_member_data_changed(_member_id: int, data: Lobby.MemberData, value: Variant) -> void:
	if self.member_id != _member_id:
		return
	
	match data:
		Lobby.MemberData.NAME:
			var self_marker := "" if multiplayer.get_unique_id() != member_id else " (Self)"
			text = "%s" % value + self_marker
		Lobby.MemberData.COLOR:
			modulate = value 

func _on_id_pressed(id: int) -> void:
	match id as MemberActions:
		MemberActions.KICK:
			Lobby.kick(member_id)
