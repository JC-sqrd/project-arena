class_name WeaponSocketable
extends Socketable

var effects : Array[WeaponSocketableEffect]

var weapon : Weapon

func _ready() -> void:
	for child in get_children():
		if child is WeaponSocketableEffect:
			effects.append(child)

func apply_effects_to_weapon(weapon : Weapon):
	for effect in effects:
		effect.apply_effect_to_weapon(weapon)
	pass

func remove_socketable_effect():
	for effect in effects:
		effect.remove_effect_from_weapon(weapon)
	pass
