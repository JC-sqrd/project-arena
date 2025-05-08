class_name SpawnableHitCounterBehavior
extends SpawnableBehavior


@export var hit_times : Stat 
var _hit_counter : float = 0

func _ready():
	spawnable.on_hit.connect(_on_spawnable_hit)


func _on_spawnable_hit(data : Dictionary):
	_hit_counter += 1
	if _hit_counter == hit_times.stat_derived_value:
		spawnable.queue_free()
	pass
