extends Control

@export var resume_button: Button
@export var quit_button: Button


func _ready() -> void:
	resume_button.pressed.connect(_on_resume_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		toggle_menu()

func toggle_menu() -> void:
	visible =!visible 
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
func _on_resume_pressed() -> void:
	toggle_menu()
			
func _on_quit_pressed() -> void:
	get_tree().quit()
