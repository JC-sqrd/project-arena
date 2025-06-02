class_name AreaHit
extends Spawnable

@export var windup_time : float = 1
@export var free_on_lifetime_end : bool = true
var area_size_mult : float = 1
@onready var actor_stats : StatManager = source.actor.stat_manager


func _ready():
	if actor_stats.stats.has("area_size"):
		area_size_mult = actor_stats.stats["area_size"].stat_derived_value
	self.scale *= area_size_mult
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	self.area_entered.connect(_on_area_entered)
	windup_start.emit()
	get_tree().create_timer(windup_time, false, false, false).timeout.connect(_on_windup_end)

func _on_timer_timeout():
	get_tree().create_timer(time_active, false, false, false).timeout.connect(func (): 
		inactive.emit()
		is_inactive = true
		)
	get_tree().create_timer(lifetime, false, false, false).timeout.connect(func (): 
		if !is_inactive:
			inactive.emit()
		on_destroy.emit()
		if free_on_lifetime_end:
			queue_free()
		)
	pass

func area_hit():
	if entities_in_area.size() != 0:
		for entity in entities_in_area:
			if filter.is_valid(self, entity, entities_in_area):
				var data : Dictionary = _create_hit_data(entity)
				entity.on_hit.emit(data)
				on_hit.emit(data)
				if hit_listener != null:
					hit_listener.on_hit(data)
	pass

func _on_windup_end():
	windup_end.emit()
	spawnable_start.emit()
	area_hit()
	_on_timer_timeout()
	pass

#func _create_hit_data(entity_hit : Entity) -> HitData:
	#var hit_data = HitData.create()
	#hit_data.data["target"] = entity_hit
	#hit_data.data["source"] = self
	#hit_data.data["actor"] = source.owner
	#return hit_data

func _create_hit_data(entity_hit : Entity) -> Dictionary:
	var data_dict : Dictionary = hit_data.duplicate(true)
	data_dict["target"] = entity_hit
	data_dict["source"] = self
	data_dict["actor"] = actor
	return data_dict


func _on_body_entered(body : Node2D):
	entities_in_area.append(body)
	pass

func _on_area_entered(area : Area2D):
	var area_object = area
	if area_object is TriggerSpawnable:
		area_object.on_trigger.emit(_create_hit_data(null))
		pass
	pass

func _on_body_exited(body : Node2D):
	if entities_in_area.has(body):
		entities_in_area.erase(body)
	pass
