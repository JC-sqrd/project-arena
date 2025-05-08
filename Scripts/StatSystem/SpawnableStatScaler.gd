class_name SpawnableStatScaler
extends StatScaler


@export var spawnable : Spawnable
@export var stat_to_scale : String

func _ready():
	var actor = spawnable.source.owner
	if actor is Entity:
		if actor.stat_manager.stats.has(stat_to_scale):
			scale_with_stat = actor.stat_manager.stats[stat_to_scale] 
			scale_with_stat.stat_changed.connect(apply_scaled_value)
			stat.stat_changed.connect(_update_base_value)
			_original_base_value = stat.stat_value
			apply_scaled_value()
		else:
			printerr("spawnable actor does not contain the stat: " + stat_to_scale)
	else:
		printerr("spawnable actor is not an entity")
	pass
