class_name ModifyEquipmentGetActorStatMult
extends EquipmentTierModification

@export var actor_stat_mult : GetActorStatMult
@export var new_ratio : float = 0
@export var new_stat_id : String

var old_ratio : float = 0
var old_stat_id : String 

func apply_modification(equipment : Equipment):
	actor_stat_mult.ratio = new_ratio
	old_ratio = new_ratio
	if new_stat_id != null or new_stat_id != "":
		actor_stat_mult.scale_with_stat_id = new_stat_id
		old_stat_id = new_stat_id
		pass
	pass

func remove_modification(equipment : Equipment):
	actor_stat_mult.ratio = old_ratio
	if new_stat_id != null or new_stat_id != "":
		actor_stat_mult.scale_with_stat_id = old_stat_id
	pass
