class_name SelfTargetAbility
extends Ability

@export var hit_listener : HitListener
var ability_count : int = 1

func _ready() -> void:
	super()

func invoke_ability():
	ability_invoked.emit()
	actor.stat_manager.stats[required_stat.stat_name].stat_derived_value -= required_stat.required_value
	ability_casted.emit()
	ability_start.emit()
	ability_active.emit()
	if hit_listener != null:
		actor.on_hit.emit(_create_hit_data())
	ability_end.emit()
	pass

func start_cooldown():
	var cooldown_time : float = cooldown * (1 - (_cdr.stat_derived_value / 100))
	get_tree().create_timer(cooldown_time, false, false, false).timeout.connect(on_cooldown_timer_timeout)
	ability_count -= 1
	if ability_count == 0:
		#cooldown_timer.start()
		cooling_down = true
		can_cast = false
	cooldown_start.emit(cooldown_time)
	pass

func on_cooldown_timer_timeout():
	ability_count += 1
	cooldown_end.emit()
	cooling_down = false
	can_cast = true
	pass

func _create_hit_data() -> Dictionary:
	var hit_data : Dictionary
	if hit_listener != null:
		hit_data = hit_listener.generate_effect_data()
	hit_data["target"] = actor
	hit_data["source"] = self
	hit_data["actor"] = actor
	return hit_data
