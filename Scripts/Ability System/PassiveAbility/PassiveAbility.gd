class_name PassiveAbility
extends Ability


var enabled : bool = false


func enable_passive_ability(actor : Entity):
	if actor != null:
		self.actor
	enabled = true
	pass

func disable_passive_ability():
	actor = null
	enabled = false
	pass
