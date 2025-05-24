class_name HitListener
extends Node

@export var listener_id : String
var effects : Dictionary[String, Effect]
var hit_data_arr : Array[HitData]

func _ready():
	#child_entered_tree.connect(_on_child_entered_tree)
	for child in get_children():
		if child is Effect:
			effects[child.get_effect_key()] = child

#func on_hit(hit_data : HitData):
	#if !effects.is_empty():
		#for effect in effects.size():
			#await effects[effect].apply_effect(hit_data)
			#if effect == effects.size() - 1:
				#hit_data.queue_free() 
			##effect.apply_effect(hit_data)
	#pass
	
func on_hit(hit_data : Dictionary):
	if !effects.is_empty():
		for effect in effects:
			await effects[effect].apply_effect(hit_data)
			#effect.apply_effect(hit_data)
	pass

func generate_effect_data() -> Dictionary:
	var effect_data : Dictionary
	for effect in effects:
		effect_data[effect] = effects[effect].get_effect_value()
	return effect_data

func append_effect_data(data : Dictionary) -> Dictionary:
	for effect in effects:
		data[effect] = effects[effect]
	return data
	pass

func _on_free_hit_data(hit_data : HitData):
	hit_data.queue_free()
	pass

#func _on_child_entered_tree(node : Node):
	#if node is Effect:
		#effects.append(node)
	#pass
