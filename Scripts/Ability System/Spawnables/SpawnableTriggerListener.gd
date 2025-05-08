class_name SpawnableTriggerListener
extends Node

var spawnable_trigger_effects : Array[SpawnableTriggerEffect]

func _ready():
	for child in get_children():
		if child is SpawnableTriggerEffect:
			spawnable_trigger_effects.append(child)
	pass

func apply_trigger_effects(hit_data : Dictionary):
	for effect in spawnable_trigger_effects:
		effect.trigger_effect(hit_data)
	pass
