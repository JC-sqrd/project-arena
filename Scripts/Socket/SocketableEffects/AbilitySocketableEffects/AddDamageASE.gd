class_name AddDamageASE
extends AbilitySocketableEffect


@export var damage_add : float = 0


func apply_effect_to_ability(ability : Ability):
	var ability_hit_listener : HitListener = ability.hit_listener
	for effect in ability_hit_listener.effects:
		if effect is DamageEffect:
			if effect.damage_stat != null:
				effect.damage_stat.bonus_value += damage_add
				effect.damage_stat.update_stat()
			pass
	pass

func remove_effect_from_ability(ability : Ability):
	var ability_hit_listener : HitListener = ability.hit_listener
	for effect in ability_hit_listener.effects:
		if effect is DamageEffect:
			if effect.damage_stat != null:
				effect.damage_stat.bonus_value -= damage_add
				effect.damage_stat.update_stat()
	pass
