class_name AddDamageWSE
extends WeaponSocketableEffect


@export var damage_add : float = 0


func apply_effect_to_weapon(weapon : Weapon):
	var weapon_hit_listener : HitListener = weapon.hit_listener
	for effect in weapon_hit_listener.effects:
		if weapon_hit_listener.effects[effect] is DamageEffect:
			var damage_effect : DamageEffect = weapon_hit_listener.effects[effect]
			if damage_effect.damage_stat != null:
				damage_effect.damage_stat.bonus_value += damage_add
				damage_effect.damage_stat.update_stat()
			pass
	pass

func remove_effect_from_weapon(weapon : Weapon):
	var weapon_hit_listener : HitListener = weapon.hit_listener
	for effect in weapon_hit_listener.effects:
		if weapon_hit_listener.effects[effect] is DamageEffect:
			var damage_effect : DamageEffect = weapon_hit_listener.effects[effect]
			if damage_effect.damage_stat != null:
				damage_effect.damage_stat.bonus_value -= damage_add
				damage_effect.damage_stat.update_stat()
	pass
