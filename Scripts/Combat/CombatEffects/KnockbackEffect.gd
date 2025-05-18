class_name Knockback
extends Effect

@export var force : float = 300
var bonus_value_checks : Array[EffectCheck]
var condition_checks : Array[BonusValueCondition]

var bonus_value : float

func _ready():
	for child in get_children():
		if child is EffectCheck:
			bonus_value_checks.append(child)
			condition_checks.append(child.generate_bonus_value_condition())
	pass

func get_effect_key() -> Variant:
	return "knockback_effect"


func get_effect_value() -> KnockbackEffectData:
	return KnockbackEffectData.new(force, condition_checks)

#class KnockbackData:
	#var knockback_strength : float = 0
	#var checks : Array[BonusValueCondition] 
	#func _init(strength : float, checks : Array[BonusValueCondition]):
		#knockback_strength = strength
		#self.checks = checks
		#pass
