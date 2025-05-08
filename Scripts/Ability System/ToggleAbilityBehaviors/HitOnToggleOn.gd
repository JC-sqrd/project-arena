class_name HitOnToggleOn
extends ToggleAbilityBehavior


var toggled : bool = false
@export var hit_listener : HitListener

func _ready() -> void:
	if owner is ToggleAbility:
		toggle_ability = owner
		toggle_ability.ability_toggled_off.connect(on_ability_toggled_off)
		toggle_ability.ability_toggled_on.connect(on_ability_toggled_on)

func on_ability_toggled_on():
	toggled = true
	var hit_data : Dictionary = _create_hit_data()
	toggle_ability.actor.on_hit.emit(hit_data)
	if hit_listener != null:
		hit_listener.on_hit(hit_data)
	pass

func on_ability_toggled_off():
	toggled = false
	pass

func on_hit_timer_timeout():
	
	pass

func _create_hit_data() -> Dictionary:
	var hit_data : Dictionary = HitDataHelper.create_hit_data(toggle_ability.actor, toggle_ability.actor, toggle_ability.actor)
	if hit_listener != null:
		hit_data = hit_listener.append_effect_data(hit_data)
	return hit_data
