class_name EquipmentTierManager
extends Node

@export var previous_tier_data : EquipmentTierData
@export var next_tier_data : EquipmentTierData


func get_next_level_equipment() -> Equipment:
	return next_tier_data.equipment_scene.instantiate() as Equipment
