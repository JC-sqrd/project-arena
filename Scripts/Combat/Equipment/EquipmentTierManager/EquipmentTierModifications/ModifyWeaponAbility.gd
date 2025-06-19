class_name ModifyWeaponAbility
extends EquipmentTierModification

@export var new_ability_scene : PackedScene
var new_ability : ActiveAbility
var old_ability : ActiveAbility

func apply_modification(equipment : Equipment):
	equipment = equipment as Weapon
	old_ability = equipment.weapon_ability
	equipment.weapon_ability = new_ability_scene.instantiate() as ActiveAbility
	equipment.weapon_ability.actor = equipment.actor
	equipment.add_child(equipment.weapon_ability)
	equipment.weapon_ability.owner = equipment
	new_ability = equipment.weapon_ability
	pass
	

func remove_modification(equipment : Equipment):
	equipment.weapon_ability = old_ability
	pass
