class_name MemberLabel extends Label

var member_id: int


func _init(member_id: int) -> void:
	self.member_id = member_id

func _ready() -> void:
	var self_marker := "" if multiplayer.get_unique_id() != member_id else " (Self)"
	var member_name := Lobby.get_member_data(member_id, Lobby.MemberDataType.NAME) as String
	var member_color := Lobby.get_member_data(member_id, Lobby.MemberDataType.COLOR) as Color
	text = "%s" % member_name + self_marker
	modulate = member_color
	Lobby.member_data_changed.connect(_on_member_data_changed)
	
func _on_member_data_changed(member_id: int, data_type: Lobby.MemberDataType, value: Variant) -> void:
	if self.member_id == member_id:
		if data_type == Lobby.MemberDataType.NAME:
			var self_marker := "" if multiplayer.get_unique_id() != member_id else " (Self)"
			text = "%s" % value + self_marker
		if data_type == Lobby.MemberDataType.COLOR:
			modulate = value 
