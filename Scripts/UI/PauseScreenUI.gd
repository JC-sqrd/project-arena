class_name PauseScreenUI
extends Control

@onready var resume_button: Button = %ResumeButton
@onready var character_select_button: Button = %CharacterSelectButton
@onready var quit_button: Button = %QuitButton

func _ready():
	visible = false
	resume_button.pressed.connect(_on_resume_button_pressed)
	character_select_button.pressed.connect(_on_character_select_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE and !event.is_echo():
			if !visible:
				visible = true
				PauseManager.pause_scene_tree()
			else:
				visible = false
				PauseManager.resume_scene_tree()
			pass
	pass

func _on_resume_button_pressed():
	visible = false
	PauseManager.resume_scene_tree()
	pass

func _on_character_select_button_pressed():
	visible = false
	Globals.clear_2D_nodes()
	get_tree().change_scene_to_file("res://Scenes/UI/Character Select/character_select_scene.tscn")
	PauseManager.resume_scene_tree()
	pass

func _on_quit_button_pressed():
	get_tree().quit()
	pass
