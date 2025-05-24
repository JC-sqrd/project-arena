class_name UpgradeTier
extends Node

@export var tier : Equipment.EquipmentTier
@export var next_tier : UpgradeTier
var upgrades : Array[EquipmentUpgrade]


func _ready():
	for child in get_children():
		if child is EquipmentUpgrade:
			upgrades.append(child)
	pass

func apply_upgrade(equipment : Equipment):
	for upgrade in upgrades:
		upgrade.apply_upgrade(equipment)
	pass
