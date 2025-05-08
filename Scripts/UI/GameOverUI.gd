class_name GameOverUI
extends Control

@export var try_again_button : Button

func _ready() -> void:
	try_again_button.pressed.connect(on_try_again_pressed)
	visible = false
	if owner is Stage:
		owner.game_over.connect(on_game_over)
		pass


func on_game_over(stage : Stage):
	visible = true
	pass

func on_try_again_pressed():
	get_tree().reload_current_scene()
	PauseManager.resume_scene_tree()
	GameState.reset_game_timer()
	print("Reset stage")
	pass
