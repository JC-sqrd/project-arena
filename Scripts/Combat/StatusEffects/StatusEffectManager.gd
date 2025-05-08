class_name StatusEffectManager
extends Node

@export var entity : Entity = _get_entity_owner()

var status_effects : Array[StatusEffect]

func _ready():
	for child in get_children():
		if child is StatusEffect:
			status_effects.append(child)
			child.actor = entity
	owner.ready.connect(
		func():
			for status_effect in status_effects:
				status_effect.activate_status_effect(entity)
				pass
			pass
	)
	pass

func _get_entity_owner() -> Entity:
	if owner is Entity:
		return owner
	else:
		return null

func add_status_effect(status_effect : StatusEffect, stack : int):
	status_effect.target_entity = entity
	#If status effects is empty, add without checking for duplicates
	if get_children().size() == 0: 
		add_child(status_effect)
		status_effects.append(status_effect)
		status_effect.add_stack(stack)
		status_effect.activate_status_effect(entity)
	else:
		var duplicate = get_duplicate(status_effect)
		#Check if duplicate and if it is stackable
		if duplicate != null and duplicate.stackable:
			duplicate.add_stack(stack)
			status_effect.queue_free()
			pass
		#Check if duplicate and if it is not stackable
		elif duplicate != null and !duplicate.stackable:
			duplicate.restart_duration()
			status_effect.queue_free()
			pass
		else:
			add_child(status_effect)
			status_effects.append(status_effect)
			status_effect.add_stack(stack)
			status_effect.activate_status_effect(entity)
	pass

func remove_status_effect_by_id(id : String):
	for status_effect in status_effects:
		if status_effect.id == id:
			status_effects.erase(status_effect)
			status_effect.queue_free()
	pass

func has_status_effect_id(id : String) -> bool:
	for status_effect in status_effects:
		if status_effect.id == id:
			return true
	return false

func get_status_effect_by_id(id : String) -> StatusEffect:
	for status_effect in status_effects:
		if status_effect.id == id:
			return status_effect
	return null

func get_duplicate(status_effect : StatusEffect) -> StatusEffect:
	for child in get_children():
		if child is StatusEffect:
			if child.id == status_effect.id:
				return child
	return null
