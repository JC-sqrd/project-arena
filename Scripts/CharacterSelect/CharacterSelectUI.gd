class_name CharacterSelectUI
extends Control


@export var level_scene : PackedScene
@onready var character_grid_container: GridContainer = $Panel/CharacterGridContainer
@onready var start_game_button: Button = $StartGameButton

var current_selected_icon : CharacterSelectIconUI
var current_stage : Stage
var current_character : PlayerCharacter

func _ready():
	Globals.character_select_screen = self
	current_stage = level_scene.instantiate() as Stage
	for child in character_grid_container.get_children():
		if child is CharacterSelectIconUI:
			child.selected.connect(_on_icon_selected)
	start_game_button.pressed.connect(_on_start_button_pressed)
	start_game_button.disabled = true
	visible = false
	visible = true
	pass


func _on_icon_selected(character_icon : CharacterSelectIconUI):
	current_selected_icon = character_icon
	if character_icon.character_data != null:
		print(character_icon.character_data.character_name)
	start_game_button.disabled = false
	pass


func _on_start_button_pressed():
	Globals.current_player_character_data = current_selected_icon.character_data
	Globals.current_stage = current_stage
	Globals.current_stage_scene = level_scene
	current_character = current_selected_icon.character_data.character_scene.instantiate() as PlayerCharacter
	Globals.player = current_character
	get_tree().root.add_child(current_stage)
	current_stage.add_child(current_character)
	current_character.global_position = current_stage.player_spawn_point.global_position
	visible = false
	#get_tree().change_scene_to_file("res://Scenes/Test/test_scene.tscn")
	#get_tree().change_scene_to_packed()
	#get_tree().root.add_child(current_stage)
	pass
