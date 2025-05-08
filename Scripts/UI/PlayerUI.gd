class_name PlayerUI
extends Control

@export var player_character : PlayerCharacter
@export var player_skills : Array[AbilityIconUI]
@export var level_bar : TextureProgressBar
@export var level_label : Label
@export var abilities_action_bar : HBoxContainer

var level_manager : LevelManager 
var stat_manager : StatManager
var tween : Tween

func _ready():
	level_manager = player_character.level_manager
	stat_manager = player_character.stat_manager
	
	level_bar.value = 0
	level_bar.max_value = level_manager.exp_to_level
	
	level_manager.exp_evaluated.connect(_level_bar_exp_gained)
	level_manager.leveled_up.connect(_level_bar_level_up)
	
	
	
	player_character.ready.connect(
		func():
			for ability in player_character.abilities:
				if ability.ability_icon != null:
					var icon = ability.ability_icon.instantiate()
					if icon is AbilityIconUI:
						icon.ability_container = ability
						abilities_action_bar.add_child(icon)
					else:
						icon.queue_free()
					pass
			level_label.text = str(level_manager.current_level)
	)
	
	pass

func _level_bar_exp_gained():
	#level_bar.value = lerp(level_bar.value, level_manager.current_exp, 0.1)
	tween = create_tween()
	tween.tween_property(level_bar, "value", level_manager.current_exp, 0.25)
	pass

func _level_bar_level_up():
	#tween.tween_property(level_bar, "value", 0, 0.25)
	level_bar.value = 0
	level_bar.max_value = level_manager.exp_to_level
	level_label.text = str(level_manager.current_level)
	pass

func get_player() -> PlayerCharacter:
	return player_character
