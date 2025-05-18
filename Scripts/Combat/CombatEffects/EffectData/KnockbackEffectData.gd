class_name KnockbackEffectData
extends RefCounted



var knockback_strength : float = 0
var checks : Array[BonusValueCondition] 

func _init(strength : float, checks : Array[BonusValueCondition]):
	knockback_strength = strength
	self.checks = checks
	pass
