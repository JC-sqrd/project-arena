class_name AbilityOnHitASE
extends AbilitySocketableEffect


@export var trigger_chance : float = 0

var on_hit_effect : OnHitEffect

func _ready() -> void:
	on_hit_effect = OnHitEffect.new()
	on_hit_effect.on_hit_chance = trigger_chance

func apply_effect_to_ability(ability : Ability):
	on_hit_effect.actor = ability.actor
	ability.hit_listener.add_child(on_hit_effect, false)
	pass

func remove_effect_from_ability(ability : Ability):
	ability.hit_listener.remove_child(on_hit_effect)
	pass
