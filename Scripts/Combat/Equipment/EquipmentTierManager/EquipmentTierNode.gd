class_name EquipmentTierNode
extends Node

@export var tier : Equipment.EquipmentTier = Equipment.EquipmentTier.TWO
@export var next_tier_node : EquipmentTierNode


func upgrade_to_tier(equipment : Equipment):
	equipment.tier = tier
	for child in get_children():
		if child is EquipmentTierModification:
			child.apply_modification(equipment)
			pass
		pass
	pass
