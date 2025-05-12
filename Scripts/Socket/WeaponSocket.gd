class_name WeaponSocket
extends Socket



@export var socketable : WeaponSocketable : set = set_socketable 

var weapon : Weapon

func set_socket_weapon(weapon : Weapon):
	self.weapon = weapon
	pass

func activate_socketable():
	socketable.apply_effects_to_weapon(weapon)

func set_socketable(new_socketable : WeaponSocketable):
	if new_socketable != null:
		if socketable != null:
			socketable.remove_socketable_effect()
		socketable = new_socketable
		socketable.apply_effects_to_weapon(weapon)
	pass
