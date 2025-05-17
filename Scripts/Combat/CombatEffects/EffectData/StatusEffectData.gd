class_name StatusEffectData
extends RefCounted



var status_effect : StatusEffect
var stack : int = 1
var chance : float = 1

var tags : Array[StringName]

func _init(status_effect : StatusEffect, stack : int, chance : float, tags : Array[StringName]):
	self.status_effect = status_effect
	self.stack = stack
	self.chance = chance
	self.tags = tags
