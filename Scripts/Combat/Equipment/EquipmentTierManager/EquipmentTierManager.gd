class_name EquipmentTierManager
extends Node

var equipment : Equipment
var current_tier : Equipment.EquipmentTier = Equipment.EquipmentTier.ONE
@export var next_tier_node : EquipmentTierNode

func _ready() -> void:
	if owner is Equipment:
		equipment = owner
	owner.ready.connect(_on_onwer_ready)
	pass

#func get_next_level_equipment() -> Equipment:
	#return next_tier_data.equipment_scene.instantiate() as Equipment

func upgrade_to_next_tier():
	if next_tier_node != null:
		next_tier_node.upgrade_to_tier(equipment)
		current_tier = next_tier_node.tier
		if next_tier_node.next_tier_node != null:
			next_tier_node = next_tier_node.next_tier_node
		pass
	else:
		printerr("No next tier node.")
	pass


func _on_onwer_ready():
	if owner is Equipment:
		var tier_difference : int = owner.tier - current_tier
		if tier_difference <= 0:
			return
		
		while tier_difference > 0:
			if next_tier_node != null:
				next_tier_node.upgrade_to_tier(equipment)
				current_tier = next_tier_node.tier
				if next_tier_node.next_tier_node != null:
					next_tier_node = next_tier_node.next_tier_node
				tier_difference -= 1
			pass
		pass
	pass
