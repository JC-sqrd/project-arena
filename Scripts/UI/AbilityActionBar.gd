class_name AbilityActionBar
extends Control


var player : PlayerCharacter
var abilties : Array[AbilityContainer]
@export var ability_icon_ui_scene : PackedScene

@onready var innate_active_bar: MarginContainer = $InnateActivePanel/InnateActiveBar
@onready var innate_utility_bar: MarginContainer = $InnateUtilityPanel/InnateUtilityBar
@onready var weapon_ability_bar: MarginContainer = $WeaponAbilityPanel/WeaponAbilityBar



var primary_ability_container : AbilityContainer
var utility_abiltiy_container : AbilityContainer


func _ready():
	if owner is PlayerCharacter:
		player = owner
	elif owner.has_method("get_player"):
		player = owner.get_actor()
	
	player.ready.connect(_on_player_ready)
	
	pass


func _on_player_ready():
	var innate_ability_icon : AbilityIconUI = ability_icon_ui_scene.instantiate() as AbilityIconUI
	innate_active_bar.add_child(innate_ability_icon)
	innate_ability_icon.initialize_ability_icon(player.innate_active_ability)
	
	var utility_ability_icon : AbilityIconUI = ability_icon_ui_scene.instantiate() as AbilityIconUI
	innate_utility_bar.add_child(utility_ability_icon)
	utility_ability_icon.initialize_ability_icon(player.utility_ability)
	#for ability in player.ability_containers:
		#var icon : AbilityIconUI = ability_icon_ui_scene.instantiate() as AbilityIconUI
		#icon.ability_container = ability
		#icon.ability_icon_texture = ability.ability_icon
		#action_bar.add_child(icon)
		#pass
	#
	#var innate_ability_icon : AbilityIconUI = ability_icon_ui_scene.instantiate() as AbilityIconUI
	#innate_ability_icon.ability_container = player.innate_active_ability
	#innate_ability_icon.ability_icon_texture = player.innate_active_ability.ability_icon
	#innate_active_bar.add_child(innate_ability_icon)
	
	#var innate_utility_icon : AbilityIconUI = ability_icon_ui_scene.instantiate() as AbilityIconUI
	#innate_utility_icon.ability_container = player.innate_utility_ability
	#innate_utility_icon.ability_icon_texture = player.innate_utility_ability.ability_icon
	#innate_utility_bar.add_child(innate_utility_icon)
	pass
