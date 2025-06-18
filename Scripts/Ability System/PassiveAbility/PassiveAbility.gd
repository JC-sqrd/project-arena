class_name PassiveAbility
extends Ability



func enable_ability(actor : Entity):
	if actor != null:
		self.actor = actor
		if actor.stat_manager != null:
			_cdr = actor.stat_manager.get_stat("cooldown_reduction")
	enabled = true
	pass

func disable_ability():
	actor = null
	enabled = false
	pass

func on_cooldown_timer_timeout():
	cooldown_end.emit()
	cooling_down = false
	can_cast = true
	pass

func start_cooldown():
	var cooldown_time : float = cooldown * (1 - (_cdr.stat_derived_value / 100))
	get_tree().create_timer(cooldown_time, false, false, false).timeout.connect(on_cooldown_timer_timeout)
	#cooldown_timer.start(cooldown_time)
	cooling_down = true
	can_cast = false
	cooldown_start.emit(cooldown_time)
	print(ability_name + " Start cooldown")
	pass
