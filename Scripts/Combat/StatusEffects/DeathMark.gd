extends StatusEffect

@export var damage_multiplier : float = 0.25

var target : Entity

func activate_status_effect(target : Entity):
	print("DEATH MARK STATUS EFFECT ACTIVATE")
	await get_tree().create_timer(0.2, false, false, false).timeout
	target.damage_listener.incoming_damage.connect(on_target_incoming_damage)
	self.target = target
	pass

func on_target_incoming_damage(damage_data : DamageEffectData):
	damage_data.damage += damage_data.damage * damage_multiplier * stack
	queue_free()
	pass
