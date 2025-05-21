class_name ApplyStatusEffect
extends Effect

@export var status_effect_scene : PackedScene
@export var stack : int = 1
@export var chance : float = 1
var target_entity : Entity 

#func apply_effect(hit_data : Dictionary):
	#target_entity = hit_data["target"]
	#var status_effect = status_effect_scene.instantiate()
	#if status_effect is StatusEffect:
		#status_effect.actor = hit_data["actor"]
		#target_entity.status_effect_manager.add_status_effect(status_effect)
	#pass

func get_effect_key() -> Variant:
	return "apply_status_effect"

func get_effect_value() -> StatusEffectData: 
	return StatusEffectData.new(status_effect_scene, stack, chance)

#class StatusEffectData:
	#var status_effect : StatusEffect
	#var stack : int = 1
	#var chance : float = 1
	#
	#var tags : Array[StringName]
	#
	#func _init(status_effect : StatusEffect, stack : int, chance : float, tags : Array[StringName]):
		#self.status_effect = status_effect
		#self.stack = stack
		#self.chance = chance
		#self.tags = tags
