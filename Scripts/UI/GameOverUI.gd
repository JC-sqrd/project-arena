class_name GameOverUI
extends Control

@onready var try_again_button: Button = %TryAgainButton
@onready var character_select_button: Button = %CharacterSelectButton
@onready var quit_button: Button = %QuitButton

#const CHARACTER_SELECT_SCENE = preload("res://Scenes/Character Selection Scene/character_select_scene.tscn")

func _ready() -> void:
	try_again_button.pressed.connect(on_try_again_pressed)
	character_select_button.pressed.connect(_on_character_select_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	visible = false
	if owner is Stage:
		owner.game_over.connect(on_game_over)
		pass


func on_game_over(stage : Stage):
	visible = true
	pass

func on_try_again_pressed():
	#get_tree().reload_current_scene()
	Globals.restart_current_stage()
	PauseManager.resume_scene_tree()
	GameState.reset_game_timer()
	print("Restaring current stage...")
	pass

func _on_character_select_button_pressed():
	print("Go to character select scene")
	Globals.clear_2D_nodes()
	get_tree().change_scene_to_file("res://Scenes/UI/Character Select/character_select_scene.tscn")
	PauseManager.resume_scene_tree()
	pass

func _on_quit_button_pressed():
	get_tree().quit(0)
	pass
