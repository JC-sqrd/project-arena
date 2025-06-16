class_name EquipmentLevelManager
extends Node

@export var previous_tier_data : EquipmentLevelData
@export var next_tier_data : EquipmentLevelData


func get_next_level_equipment() -> Equipment:
	return next_tier_data.equipment_scene.instantiate() as Equipment
