class_name MemberLabel extends Label

var member_id: int


func _init(id: int) -> void:
	member_id = id

func _ready() -> void:
	var member_name := Lobby.get_member_data(member_id, Lobby.MemberDataType.NAME) as String
	text = "%s" % member_name
