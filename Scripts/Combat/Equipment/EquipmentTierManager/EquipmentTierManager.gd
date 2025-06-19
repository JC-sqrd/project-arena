class_name EquipmentTierManager
extends Node

var equipment : Equipment
@export var next_tier_node : EquipmentTierNode

func _ready() -> void:
	if owner is Equipment:
		equipment = owner
	pass

#func get_next_level_equipment() -> Equipment:
	#return next_tier_data.equipment_scene.instantiate() as Equipment

func upgrade_to_next_tier():
	if next_tier_node != null:
		next_tier_node.upgrade_to_tier(equipment)
		if next_tier_node.next_tier_node != null:
			next_tier_node = next_tier_node.next_tier_node
		pass
	else:
		printerr("No next tier node.")
	pass
