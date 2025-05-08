class_name AbilityStatScaler
extends StatScaler

@export var ability : Ability
#@export var stat : Stat
@export var stat_to_scale : String
#@export var scale_ratio : float = 0
#@export var scale_base_value : bool = false

#var scale_with_stat : Stat
#var _old_scaled_value : float = 0
#var _original_base_value : float = 0

func _ready():
	print("Owner: " + str(owner.name))
	ability.owner.ready.connect(initialize_stat_scaler)
	pass

func initialize_stat_scaler():
	var actor = ability.actor
	if actor is Entity:
		print("Actor stats: " + str(actor.stat_manager.stats.has(stat_to_scale)))
		if actor.stat_manager.stats.has(stat_to_scale):
			scale_with_stat = actor.stat_manager.stats[stat_to_scale] 
			scale_with_stat.stat_changed.connect(apply_scaled_value)
			scale_with_stat.stat_updated.connect(apply_scaled_value)
			stat.stat_changed.connect(_update_base_value)
			_original_base_value = stat.stat_value
			apply_scaled_value()
		else:
			printerr(owner.name + " Ability actor " + str(actor) + " does not contain the stat: " + stat_to_scale)
	else:
		printerr("Ability actor is not an entity")
	pass

#func apply_scaled_value():
	#if scale_base_value:
		#stat.stat_value -= _old_scaled_value
		#var new_scaled_value = scale_with_stat.stat_derived_value * scale_ratio
		#stat.stat_value += new_scaled_value
		#_old_scaled_value = new_scaled_value
		#stat.update_stat()
	#else:	
		#stat.bonus_value -= _old_scaled_value
		#var new_scaled_value = scale_with_stat.stat_derived_value * scale_ratio
		#stat.bonus_value += new_scaled_value
		#_old_scaled_value = new_scaled_value
		#stat.update_stat()
	#pass

func _update_base_value():
	pass
