class_name EquipmentUpgradeManager
extends Node


var equipment : Equipment

var upgrades : Array[EquipmentUpgrade]
var current_tier : int = 1

func _ready() -> void:
	if owner is Equipment:
		equipment = owner
		equipment.upgrade.connect(on_equipment_upgrade)
	for child in get_children():
		if child is UpgradeTier:
			child = child as UpgradeTier
			if child.tier == equipment.tier:
				child.apply_upgrade(equipment)
				pass
			pass
		pass

func on_equipment_upgrade(equipment : Equipment):
	
	pass
