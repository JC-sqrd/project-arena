class_name HitOverTimeToggle
extends ToggleAbilityBehavior


@export var hit_rate : Stat 

var toggled : bool = false
var hit_timer : Timer = Timer.new()

func _ready() -> void:
	if owner is ToggleAbility:
		toggle_ability = owner
		toggle_ability.ability_toggled_off.connect(on_ability_toggled_off)
		toggle_ability.ability_toggled_on.connect(on_ability_toggled_on)
	hit_timer.wait_time = hit_rate.stat_derived_value
	hit_timer.one_shot = false
	hit_timer.timeout.connect(on_hit_timer_timeout)
	add_child(hit_timer)

func on_ability_toggled_on():
	toggled = true
	hit_timer.start()
	pass

func on_ability_toggled_off():
	toggled = false
	hit_timer.stop()
	pass

func on_hit_timer_timeout():
	var hit_data : Dictionary = _create_hit_data()
	toggle_ability.actor.on_hit.emit(hit_data)
	toggle_ability.hit_listener.on_hit(hit_data)
	pass

func _create_hit_data() -> Dictionary:
	var hit_data : Dictionary = HitDataHelper.create_hit_data(toggle_ability.actor, toggle_ability.actor, toggle_ability.actor)
	if toggle_ability.hit_listener != null:
		hit_data = toggle_ability.hit_listener.append_effect_data(hit_data)
	return hit_data
	
