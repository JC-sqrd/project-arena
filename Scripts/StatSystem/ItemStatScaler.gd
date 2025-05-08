class_name ItemStatScaler
extends StatScaler

@export var item : Item
#@export var stat : Stat
@export var stat_to_scale : String
#@export var scale_ratio : float = 0
#@export var scale_base_value : bool = false

#var scale_with_stat : Stat
#var _old_scaled_value : float = 0
#var _original_base_value : float = 0

func _ready():
	item.ready.connect(initialize_stat_scaler)
	item.ready.connect(_on_item_ready)
	pass

func initialize_stat_scaler():
	item.actor.ready.connect(_on_actor_ready)
	pass

func _on_actor_ready():
	var actor = item.actor
	if actor is Entity:
		if actor.stat_manager.stats != null and actor.stat_manager.stats.has(stat_to_scale) :
			scale_with_stat = actor.stat_manager.stats[stat_to_scale] 
			scale_with_stat.stat_changed.connect(apply_scaled_value)
			scale_with_stat.stat_updated.connect(apply_scaled_value)
			stat.stat_changed.connect(_update_base_value)
			_original_base_value = stat.stat_value
			apply_scaled_value()
		else:
			printerr(owner.name + " Item actor does not contain the stat: " + stat_to_scale)
	else:
		printerr("Ability actor is not an entity")
	pass

func _on_item_ready():
	var actor = item.actor
	if actor is Entity:
		if actor.stat_manager.stats != null and actor.stat_manager.stats.has(stat_to_scale):
			scale_with_stat = actor.stat_manager.stats[stat_to_scale] 
			scale_with_stat.stat_changed.connect(apply_scaled_value)
			stat.stat_changed.connect(_update_base_value)
			_original_base_value = stat.stat_value
			apply_scaled_value()
		else:
			printerr("Item actor stats empty")
	else:
		printerr("Ability actor is not an entity")
	pass
