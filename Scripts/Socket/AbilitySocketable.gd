class_name AbilitySocketable
extends Socketable

var effects : Array[AbilitySocketableEffect]

var ability

func _ready() -> void:
	for child in get_children():
		if child is AbilitySocketableEffect:
			effects.append(child)

func apply_effects_to_ability(ability : Ability):
	for effect in effects:
		effect.apply_effect_to_ability(ability)
	pass

func remove_socketable_effect():
	for effect in effects:
		effect.remove_effect_from_ability(ability)
	pass
