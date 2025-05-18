class_name KnockbackReceiver
extends EffectReceiver


func receive_effect(hit_data : Dictionary):
	if hit_data.has("knockback_effect"):
		var knockback_data : KnockbackEffectData = hit_data["knockback_effect"]
		var target = hit_data["target"]
		var strength : float = knockback_data.knockback_strength
		var direction : Vector2 = (target.global_position - hit_data.get("source").global_position).normalized()
		
		for check in knockback_data.checks:
			if check is BonusValueCondition:
				if check.condition_met(hit_data):
					knockback_data.knockback_strength += check.get_bonus_value()
					pass
		pass
		
		if target is Entity:
			target.can_move = false
		var knockback_time = 0.1
		get_tree().create_timer(knockback_time, false, false, false).timeout.connect(
			func():
				if target != null:
					target.can_move = true
		)
		target.velocity += direction * strength
	pass
