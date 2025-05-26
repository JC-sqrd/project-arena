class_name Effect
extends Node

var actor : Entity 

signal effect_data_generated(effect_data : EffectData)

func _ready() -> void:
	owner.ready.connect(_on_owner_ready)

func _enter_tree():
	if owner is Entity:
		actor = owner
	elif owner != null and owner.has_method("get_actor"):
		actor = owner.get_actor()
	pass

func _on_owner_ready():
	if owner is Entity:
		actor = owner
	elif owner != null and owner.has_method("get_actor"):
		actor = owner.get_actor()
	pass

#func apply_effect(hit_data : HitData):
	#pass
	
func apply_effect(hit_data : Dictionary):
	pass

func get_effect_key() -> Variant:
	return null

func get_effect_value() -> Variant:
	return null
