class_name WeaponDamageUpgrade
extends EquipmentUpgrade


func apply_upgrade(equipment : Equipment):
	if equipment is Weapon:
		equipment = equipment as Weapon
		if equipment.hit_listener.effects.has("damage_effect"):
			var damage_effect : DamageEffect = equipment.hit_listener.effects.get()
			pass
		pass
	pass
