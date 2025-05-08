class_name AllowCastWhileActive
extends AbilityBehavior


func _ready() -> void:
	super()
	ability.ability_casted.connect(on_ability_casted)
	#ability.ability_end.connect(on_ability_end)



func on_ability_casted():
	ability.actor.can_cast = true
	pass
