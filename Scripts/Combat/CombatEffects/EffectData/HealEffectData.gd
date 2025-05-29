class_name HealEffectData
extends EffectData

var source : Node
var heal_amount : float = 0

func _init(heal_amount : float):
	self.heal_amount = heal_amount

func apply_effect(hit_data : Dictionary):
	var actor = hit_data["actor"] as Entity
	actor.heal(_create_heal_data(hit_data))
	
func _create_heal_data(hit_data : Dictionary) -> HealEffectData:
	var heal_data : HealEffectData
	heal_data.heal_amount = heal_amount
	heal_data.source = hit_data["source"]
	return heal_data
