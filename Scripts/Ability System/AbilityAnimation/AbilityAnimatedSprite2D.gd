class_name AbilityAnimatedSprite2D
extends AnimatedSprite2D

var ability : Ability

func _ready():
	if owner is Ability:
		ability = owner
	ability.ability_casted.connect(on_ability_start)


func on_ability_start():
	play("ability_windup")
	pass
