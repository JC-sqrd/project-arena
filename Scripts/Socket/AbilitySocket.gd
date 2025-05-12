class_name AbilitySocket
extends Socket


@export var socketable : AbilitySocketable : set = set_socketable 

var ability : Ability

func set_socket_ability(ability : Ability):
	self.ability = ability
	pass

func activate_socketable():
	socketable.apply_effects_to_ability(ability)

func set_socketable(new_socketable : AbilitySocketable):
	if new_socketable != null:
		if socketable != null:
			socketable.remove_socketable_effect()
		socketable = new_socketable
		socketable.apply_effects_to_ability(ability)
	pass
