class_name GameOverUI
extends Control

@export var try_again_button : Button
@onready var character_select_button: Button = $MarginContainer/VBoxContainer/CharacterSelectButtonContainer/CharacterSelectButton

func _ready() -> void:
	try_again_button.pressed.connect(on_try_again_pressed)
	character_select_button.pressed.connect(_on_character_select_button_pressed)
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
	pass

func _on_character_select_button_pressed():
	#Globals.clear_2D_nodes()
	#Globals.character_select_screen.visible = true
	#Globals.character_select_screen._ready()
	#get_tree().change_scene_to_packed(character_select_scene)
	Globals.clear_2D_nodes()
	get_tree().change_scene_to_file("res://Scenes/Character Selection Scene/character_select_scene.tscn")
	pass
