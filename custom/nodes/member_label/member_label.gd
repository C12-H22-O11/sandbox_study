class_name MemberLabel extends Label

var member_id: int


func _init(_member_id: int) -> void:
	self.member_id = _member_id

func _ready() -> void:
	var self_marker := "" if multiplayer.get_unique_id() != member_id else " (Self)"
	var member_name := Lobby.get_member_data(member_id, Lobby.MemberData.NAME) as String
	var member_color := Lobby.get_member_data(member_id, Lobby.MemberData.COLOR) as Color
	text = "%s" % member_name + self_marker
	modulate = member_color
	Lobby.member_data_changed.connect(_on_member_data_changed)
	
func _on_member_data_changed(_member_id: int, data: Lobby.MemberData, value: Variant) -> void:
	if self.member_id == _member_id:
		if data == Lobby.MemberData.NAME:
			var self_marker := "" if multiplayer.get_unique_id() != member_id else " (Self)"
			text = "%s" % value + self_marker
		if data == Lobby.MemberData.COLOR:
			modulate = value 
