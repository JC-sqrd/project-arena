class_name RemoveStatusEffect
extends Effect


@export var status_effect_scene : PackedScene
@export var stack : int = 1
var target_entity : Entity 

#func apply_effect(hit_data : Dictionary):
	#target_entity = hit_data["target"]
	#var status_effect = status_effect_scene.instantiate()
	#if status_effect is StatusEffect:
		#status_effect.actor = hit_data["actor"]
		#target_entity.status_effect_manager.add_status_effect(status_effect)
	#pass

func get_effect_key() -> Variant:
	return "remove_status_effect"

func get_effect_value() -> StatusEffectData:
	#status_effect : StatusEffect, stack : int, chance : float, tags : Array[StringName]
	return StatusEffectData.new(status_effect_scene, stack, 1)

#class StatusEffectData:
	#var status_effect_scene : PackedScene
	#var stack : int = 1
	#
	#func _init(status_effect_scene : PackedScene, stack : int):
		#self.status_effect_scene = status_effect_scene
		#self.stack = stack
