class_name ModifyWeaponHitListener
extends EquipmentTierModification

@export var new_hit_listener : HitListener
var old_hit_listener : HitListener

func apply_modification(equipment : Equipment):
	equipment = equipment as Weapon
	old_hit_listener = equipment.hit_listener
	equipment.hit_listener = new_hit_listener
	pass

func remove_modification(equipment : Equipment):
	equipment.hit_listener = old_hit_listener
	pass
