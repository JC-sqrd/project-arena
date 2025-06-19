extends Node

var current_player_character_data : CharacterSelectData
var current_stage_scene : PackedScene
var current_stage : Stage
var character_select_screen : CharacterSelectUI
var player : PlayerCharacter


var wave_spawner : WaveSpawner : set = _set_wave_spawner

signal wave_spawner_set(wave_spawner : WaveSpawner)


var common_item_pool : Array[PackedScene] = [
	preload("res://Scenes/Items/gain_move_speed/item_move_speed.tscn"),
	preload("res://Scenes/Items/gain_attack_speed/item_attack_speed.tscn"),
	preload("res://Scenes/Items/item_magic.tscn"),
	preload("res://Scenes/Items/item_strength.tscn"),
	preload("res://Scenes/Items/item_vitality.tscn"),
	preload("res://Scenes/Items/block_damage/item_chance_block_damage.tscn")
]

var common_item_data_pool : Array[ItemData] = [
	preload("res://Scripts/Resources/ItemData/item_data_move_speed.tres"),
	preload("res://Scripts/Resources/ItemData/item_data_attack_speed.tres"),
	preload("res://Scripts/Resources/ItemData/item_data_magic.tres"),
	preload("res://Scripts/Resources/ItemData/item_data_strength.tres"),
	preload("res://Scripts/Resources/ItemData/item_data_vitality.tres"),
	preload("res://Scripts/Resources/ItemData/item_data_chance_block_damage.tres"),
	preload("res://Scripts/Resources/ItemData/item_data_focus.tres")
]

var rare_item_data_pool : Array[ItemData] = [
	preload("res://Scripts/Resources/ItemData/item_data_chain_lightning.tres"),
	preload("res://Scripts/Resources/ItemData/item_data_flying_dagger.tres"),
	preload("res://Scripts/Resources/ItemData/item_data_burst_damage.tres"),
	preload("res://Scripts/Resources/ItemData/item_data_charge_move_speed.tres"),
	preload("res://Scripts/Resources/ItemData/item_data_mana_on_kill.tres")
]

var rare_item_pool : Array[PackedScene] = [
	preload("res://Scenes/Items/chain_lightning/item_chain_lightning.tscn"),
	preload("res://Scenes/Items/flying_dagger/item_flying_dagger.tscn"),
	preload("res://Scenes/Items/burst_damage/item_burst_damage.tscn"),
	preload("res://Scenes/Items/charge_move_speed/item_charge_move_speed.tscn"),
	preload("res://Scenes/Items/mana_on_kill/item_mana_on_kill.tscn")
]

var common_equipment_data_pool : Array[EquipmentData] = [
	preload("res://Scripts/Resources/EquipmentData/equipment_data_iron_gauntlets.tres"),
	preload("res://Scripts/Resources/EquipmentData/equipment_data_speed_gloves.tres"),
	preload("res://Scripts/Resources/EquipmentData/equipment_data_iron_helmet.tres"),
	preload("res://Scripts/Resources/EquipmentData/equipment_data_iron_boots.tres"),
	preload("res://Scripts/Resources/EquipmentData/equipment_data_iron_chestplate.tres"),
	preload("res://Scripts/Resources/EquipmentData/equipment_data_bow.tres"),
	preload("res://Scripts/Resources/EquipmentData/equipment_data_chakram.tres"),
	preload("res://Scripts/Resources/EquipmentData/equipment_data_fire_grimoire.tres"),
	preload("res://Scripts/Resources/EquipmentData/equipment_data_hammer.tres"),
	preload("res://Scripts/Resources/EquipmentData/equipment_data_magic_gun.tres"),
	preload("res://Scripts/Resources/EquipmentData/equipment_data_shuriken.tres"),
	preload("res://Scripts/Resources/EquipmentData/equipment_data_swift_sword.tres"),
	preload("res://Scripts/Resources/EquipmentData/equipment_data_wooden_magic_staff.tres"),
	preload("res://Scripts/Resources/EquipmentData/equipment_data_long_sword.tres"),
]

var common_equipment_pool : Array[PackedScene] = [
	preload("res://Scenes/Equipments/Armgear/armgear_iron_gauntlets.tscn"),
	preload("res://Scenes/Equipments/Armgear/armgear_speed_gloves.tscn"),
	preload("res://Scenes/Equipments/Head Gears/Iron Helmet/headgear_iron_helmet.tscn"),
	preload("res://Scenes/Equipments/Shoes/shoes_iron_boots.tscn"),
	preload("res://Scenes/Equipments/Torso/Iron Chestplate/torso_iron_chestplate.tscn"),
	preload("res://Scenes/Weapons/Bow/weapon_bow.tscn"),
	preload("res://Scenes/Weapons/Chakram/weapon_chakram.tscn"),
	preload("res://Scenes/Weapons/Fire Grimoire/Tier1/weapon_fire_grimoire.tscn"),
	preload("res://Scenes/Weapons/Hammer/weapon_hammer.tscn"),
	preload("res://Scenes/Weapons/Magic Gun/weapon_magic_gun.tscn"),
	preload("res://Scenes/Weapons/Shuriken/weapon_shuriken.tscn"),
	preload("res://Scenes/Weapons/Swift Sword/Level1/weapon_swift_sword.tscn"),
]

var player_modifiers : Dictionary = {
	
}

var item_modifiers : Dictionary = {
	"cooldown":1.0
}

func restart_current_stage():
	for child in get_tree().root.get_children():
		if child is Node2D:
			child.queue_free()
	#current_stage.queue_free()
	current_stage = current_stage_scene.instantiate() as Stage
	player = current_player_character_data.character_scene.instantiate()
	get_tree().root.add_child(current_stage)
	current_stage.add_child(player)
	player.global_position = current_stage.player_spawn_point.global_position
	character_select_screen.visible = false
	pass

func clear_2D_nodes():
	for child in get_tree().root.get_children():
		if child is Node2D:
			child.queue_free()
	pass

func _set_wave_spawner(new_wave_spawner : WaveSpawner):
	wave_spawner = new_wave_spawner
	wave_spawner_set.emit(new_wave_spawner)
	pass
