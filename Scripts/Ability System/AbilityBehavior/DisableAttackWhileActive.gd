class_name DisableAttackWhileActive
extends AbilityBehavior

var ability_active : bool = false

func _ready() -> void:
	super()
	ability.ability_casted.connect(_on_ability_casted)
	ability.ability_end.connect(_on_ability_end)
	#ability.ability_end.connect(on_ability_end)



func _process(delta: float) -> void:
	if ability_active:
		ability.actor.can_attack = false
	pass


func _on_ability_casted():
	ability_active = true
	pass


func _on_ability_end():
	ability_active = false
	ability.actor.can_attack = true
	pass
