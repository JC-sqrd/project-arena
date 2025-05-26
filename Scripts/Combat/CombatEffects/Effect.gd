class_name Effect
extends Node

var actor : Entity 

signal effect_data_generated(effect_data : EffectData)

func _ready() -> void:
	if owner != null:
		owner.ready.connect(_on_owner_ready)
	else:
		print("EFFECT OWNER IS NULL :" + str(name))
	
	if owner is Entity:
		actor = owner
	elif owner != null and owner.has_method("get_actor"):
		actor = owner.get_actor()


#func _enter_tree():
	#if owner is Entity:
		#actor = owner
	##elif owner != null and owner.has_method("get_actor"):
		##actor = owner.get_actor()
	#elif owner != null:
		#if owner.has_method("get_actor"):
			#actor = owner.get_actor()
		#print("EFFECT OWNER IS NOT NULL: " + str(name))
		#print("EFFECT OWNER: " + str(owner.name))
		#print("EFFECT ACTOR: " + str(actor))
	#pass

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
