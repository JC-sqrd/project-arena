class_name StatUpgradeUI
extends Control

var player_character : PlayerCharacter
@export var stat_upgrades : Array[StatUpgradeControl]
var stat_point : int = 0

func _ready():
	if owner is PlayerCharacter:
		player_character = owner
	elif owner.has_method("get_player"):
		player_character = owner.get_player()
		pass
	player_character.level_manager.leveled_up.connect(_on_player_level_up)
	
	for upgrades in stat_upgrades:
		if upgrades != null:
			upgrades.stat_upgraded.connect(_on_stat_upgrade)
		pass
	visible =  false
	pass

func _on_player_level_up():
	stat_point += 1
	visible = true
	pass

func _on_stat_upgrade():
	stat_point -= 1
	if stat_point <= 0:
		visible = false
	pass

func get_player():
	return player_character
