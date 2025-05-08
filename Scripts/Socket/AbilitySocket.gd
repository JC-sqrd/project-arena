class_name AbilitySocket
extends Socket


@export var socketable : AbilitySocketable


func activate_socketable(ability : Ability):
	socketable.apply_effects_to_ability(ability)
