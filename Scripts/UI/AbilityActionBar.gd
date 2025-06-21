class_name AbilityActionBar
extends Control


var player : PlayerCharacter
var abilties : Array[AbilityContainer]
var player_weapon_manager : WeaponManager
@export var ability_icon_ui_scene : PackedScene

@onready var innate_active_bar: MarginContainer = %InnateActiveBar#$InnateActivePanel/InnateActiveBar
@onready var innate_utility_bar: MarginContainer = %InnateUtilityBar#$InnateUtilityPanel/InnateUtilityBar
@onready var weapon_ability_bar: MarginContainer = %WeaponAbilityBar#$WeaponAbilityPanel/WeaponAbilityBar
@onready var offhand_weapon_ability_bar: MarginContainer = %OffhandWeaponAbilityBar



var primary_ability_container : AbilityContainer
var utility_abiltiy_container : AbilityContainer

var innate_ability_icon : AbilityIconUI
var utility_ability_icon : AbilityIconUI
var main_weapon_ability_icon : AbilityIconUI
var off_weapon_ability_icon : AbilityIconUI

var current_main_weapon : Weapon
var current_off_weapon : Weapon

var main_weapon_slot : WeaponSlot
var off_weapon_slot : OffhandWeaponSlot

func _ready():
	if owner is PlayerCharacter:
		player = owner
	elif owner.has_method("get_player"):
		player = owner.get_actor()
	
	player.ready.connect(_on_player_ready)
	pass


func _on_player_ready():
	#Create primary ability icon
	player_weapon_manager = player.weapon_manager
	innate_ability_icon = ability_icon_ui_scene.instantiate() as AbilityIconUI
	innate_active_bar.add_child(innate_ability_icon)
	innate_ability_icon.initialize_ability_icon_with_container(player.innate_active_ability)
	
	#Create utility ability icon
	utility_ability_icon = ability_icon_ui_scene.instantiate() as AbilityIconUI
	innate_utility_bar.add_child(utility_ability_icon)
	utility_ability_icon.initialize_ability_icon_with_container(player.utility_ability)
	
	#Create main weapon ability icon
	if player.weapon_manager.main_weapon_slot.weapon != null:
		main_weapon_ability_icon  = ability_icon_ui_scene.instantiate() as AbilityIconUI
		weapon_ability_bar.add_child(main_weapon_ability_icon)
		main_weapon_ability_icon.initialize_ability_icon(player.weapon_manager.current_weapon_slot.weapon.weapon_ability, player.weapon_manager.current_weapon_slot.action_trigger)
	
	#Create offhand weapon ability icon
	if player.weapon_manager.offhand_weapon_slot.weapon != null:
		off_weapon_ability_icon = ability_icon_ui_scene.instantiate() as AbilityIconUI
		offhand_weapon_ability_bar.add_child(off_weapon_ability_icon)
		off_weapon_ability_icon.initialize_ability_icon(player.weapon_manager.offhand_weapon_slot.weapon.weapon_ability, player.weapon_manager.offhand_weapon_slot.action_trigger)
	
	if player.weapon_manager.current_weapon_slot.weapon != null:
		current_main_weapon = player.weapon_manager.current_weapon_slot.weapon
	if player.weapon_manager.offhand_weapon_slot.weapon != null:
		current_off_weapon = player.weapon_manager.offhand_weapon_slot.weapon
		#Create offhand weapon ability icon and make it invisible
		off_weapon_ability_icon  = ability_icon_ui_scene.instantiate() as AbilityIconUI
		weapon_ability_bar.add_child(off_weapon_ability_icon)
		off_weapon_ability_icon.initialize_ability_icon(player.weapon_manager.current_weapon_slot.weapon.weapon_ability, player.weapon_manager.current_weapon_slot.action_trigger)
		off_weapon_ability_icon.visible = false
	if player_weapon_manager.main_weapon_slot != null:
		main_weapon_slot = player.weapon_manager.current_weapon_slot
	if player_weapon_manager.offhand_weapon_slot != null:
		off_weapon_slot = player.weapon_manager.offhand_weapon_slot
	
	#player.weapon_manager.weapon_switched.connect(_on_current_weapon_slot_switched)
	player.weapon_manager.main_weapon_slot.equipment_slotted.connect(_on_main_weapon_slotted)
	player.weapon_manager.main_weapon_slot.equipment_unslotted.connect(_on_main_weapon_unslotted)
	player.weapon_manager.offhand_weapon_slot.equipment_slotted.connect(_on_off_weapon_slotted)
	player.weapon_manager.offhand_weapon_slot.equipment_unslotted.connect(_on_off_weapon_unslotted)
	pass

func _on_current_weapon_slot_switched(weapon_slot : WeaponSlot):
	if weapon_slot == main_weapon_slot:
		main_weapon_ability_icon.visible = true
		off_weapon_ability_icon.visible = false
		#main_weapon_ability_icon.modulate.a = 1
		#off_weapon_ability_icon.modulate.a = 0
		print("MAIN HAND ICON VISIBLE")
	elif weapon_slot == off_weapon_slot:
		main_weapon_ability_icon.visible = false
		off_weapon_ability_icon.visible = true
		#main_weapon_ability_icon.modulate.a = 0
		#off_weapon_ability_icon.modulate.a = 1
		print("OFF HAND ICON VISIBLE")
	pass

func _on_main_weapon_slotted(weapon : Equipment):
	print("MAIN HAND WEAPON EQUIPPED")
	if main_weapon_ability_icon != null:
		main_weapon_ability_icon.queue_free()
	main_weapon_ability_icon  = ability_icon_ui_scene.instantiate() as AbilityIconUI
	weapon_ability_bar.add_child(main_weapon_ability_icon)
	main_weapon_ability_icon.initialize_ability_icon((weapon as Weapon).weapon_ability, main_weapon_slot.action_trigger)
	pass

func _on_main_weapon_unslotted(weapon : Equipment):
	if main_weapon_ability_icon != null:
		main_weapon_ability_icon.queue_free()
	pass

func _on_off_weapon_slotted(weapon : Equipment):
	print("OFF HAND WEAPON EQUIPPED")
	if off_weapon_ability_icon != null:
		off_weapon_ability_icon.queue_free()
	off_weapon_ability_icon  = ability_icon_ui_scene.instantiate() as AbilityIconUI
	offhand_weapon_ability_bar.add_child(off_weapon_ability_icon)
	off_weapon_ability_icon.initialize_ability_icon((weapon as Weapon).weapon_ability, main_weapon_slot.action_trigger)
	#if player_weapon_manager.current_weapon_slot == player_weapon_manager.offhand_weapon_slot:
		#off_weapon_ability_icon.visible = true
	#else:
		#off_weapon_ability_icon.visible = false
	pass

func _on_off_weapon_unslotted(weapon : Equipment):
	if off_weapon_ability_icon != null:
		off_weapon_ability_icon.queue_free()
	pass
