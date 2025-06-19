class_name ModifyEquipmentGetActorStatAdder
extends EquipmentTierModification

@export var actor_stat_adder : GetActorStatAdder
@export var new_ratio : float = 0
@export var new_stat_id : String

var old_ratio : float = 0
var old_stat_id : String 

func apply_modification(equipment : Equipment):
	actor_stat_adder.ratio = new_ratio
	old_ratio = new_ratio
	if new_stat_id != "":
		actor_stat_adder.scale_with_stat_id = new_stat_id
		old_stat_id = new_stat_id
		pass
	actor_stat_adder.apply_scaled_value()
	pass

func remove_modification(equipment : Equipment):
	actor_stat_adder.ratio = old_ratio
	if new_stat_id != "":
		actor_stat_adder.scale_with_stat_id = old_stat_id
	actor_stat_adder.apply_scaled_value()
	pass
