class_name MemberLabel extends Label

var member_id: int


func _init(member_id: int) -> void:
	self.member_id = member_id

func _ready() -> void:
	var member_name := Lobby.get_member_data(member_id, Lobby.MemberDataType.NAME) as String
	text = "%s" % member_name
	Lobby.member_data_changed.connect(_on_member_data_changed)
	
func _on_member_data_changed(member_id: int, data_type: Lobby.MemberDataType, value: Variant) -> void:
	if self.member_id == member_id and data_type == Lobby.MemberDataType.NAME:
		text = "%s" % value 
