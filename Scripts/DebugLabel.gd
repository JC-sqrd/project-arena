extends Control

@export var player_character : PlayerCharacter
@export var stats_manager : StatManager
@export var level_manager : LevelManager

var stat_uis : Array[StatUI]
@onready var stat_ui_container: VBoxContainer = $StatsMarginContainer2/PanelContainer/MarginContainer/StatUIContainer



func _ready():
	for child in stat_ui_container.get_children():
		if child is StatUI:
			stat_uis.append(child)
			(child as StatUI).initialize(player_character)
			pass
		pass
	if player_character != null:
		player_character.stat_manager.stat_manager_ready.connect(
			func(): 
				stats_manager = player_character.stat_manager
		)
	#stats_manager = player_character.stat_manager
	
	pass
 
func initialize_stat_uis(actor : Entity):
	for stat_ui in stat_uis:
		stat_ui.initialize(actor)
		pass
	pass




func get_actor():
	return player_character
