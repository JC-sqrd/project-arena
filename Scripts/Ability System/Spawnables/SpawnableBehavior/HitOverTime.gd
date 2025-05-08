class_name HitOverTime
extends SpawnableBehavior

@export var hit_speed : Stat
@export var hit_listener : HitListener
var hit_timer : Timer

func _ready() -> void:
	hit_timer = Timer.new()
	hit_timer.autostart = false
	hit_timer.one_shot = false
	hit_timer.wait_time = 1 / hit_speed.stat_derived_value
	hit_timer.timeout.connect(_on_hit_timer_timout)
	add_child(hit_timer, true)
	if owner is Spawnable:
		spawnable = owner
		spawnable.spawnable_start.connect(_on_spawnable_start)


func _on_spawnable_start():
	hit_timer.start()
	pass

func _on_hit_timer_timout():
	for entity in spawnable.entities_in_area:
		entity.on_hit.emit(_create_hit_data(entity))
	pass

func _create_hit_data(entity_hit : Entity) -> Dictionary:
	var data : Dictionary
	if hit_listener != null:
		data = hit_listener.generate_effect_data()
	data["target"] = entity_hit
	data["source"] = spawnable
	data["actor"] = spawnable.actor
	return data
