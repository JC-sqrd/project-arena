class_name ItemPassiveEffect
extends Node

var effects : Array[Effect]
var item : Item

func _ready():
	for child in get_children():
		if child is Effect:
			effects.append(child)
	if owner is Item:
		item = owner
	pass

func apply_passive_effect(actor : Entity):
	pass
