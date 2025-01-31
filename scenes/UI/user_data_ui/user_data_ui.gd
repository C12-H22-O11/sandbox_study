extends HBoxContainer

@export var user_name_line_edit: LineEdit
@export var user_color_picker_button: ColorPickerButton


func _ready() -> void:
	user_name_line_edit.text = Globals.user_data.name
	user_name_line_edit.text_submitted.connect(_on_user_name_submitted)
	
	user_color_picker_button.color = Globals.user_data.color
	user_color_picker_button.color_changed.connect(_on_user_color_changed)


func _on_user_name_submitted(new_name: String) -> void:
	Globals.user_data.name = new_name

func _on_user_color_changed(new_color) -> void:
	Globals.user_data.color = new_color
