class_name ItemPassiveEffectManager
extends Node


var item_passive_effects : Array[ItemPassiveEffect]


func _ready():
	for child in get_children():
		if child is ItemPassiveEffect:
			item_passive_effects.append(child)

func apply_passive_effects(actor : Entity):
	for passive_effect in item_passive_effects:
		passive_effect.apply_passive_effect(actor)
	pass
