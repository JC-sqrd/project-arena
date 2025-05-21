class_name AreaEnterHit
extends AreaHit

func _on_timer_timeout():
	get_tree().create_timer(0.1, false, false, false).timeout.connect(func (): 
		get_tree().create_timer(lifetime, false, true, false).timeout.connect(func():
			on_destroy.emit()
			if free_on_lifetime_end:
				queue_free()
			)
		)
	pass

#func area_hit():
	#if entities_in_area.size() != 0:
		#for entity in entities_in_area:
			#on_hit.emit(_create_hit_data(entity))
	#pass

#func _create_hit_data(entity_hit : Entity) -> HitData:
	#var hit_data = HitData.create()
	#hit_data.data["target"] = entity_hit
	#hit_data.data["source"] = self
	#hit_data.data["actor"] = source.owner
	#return hit_data

func _create_hit_data(entity_hit : Entity) -> Dictionary:
	var data = hit_data.duplicate(true)
	data["target"] = entity_hit
	data["source"] = self
	data["actor"] = actor
	return data
	pass

func _on_body_entered(body : Node2D):
	entities_in_area.append(body)
	hit_body(body)
	pass

func _on_area_entered(area : Area2D):
	var area_object = area
	if area_object is TriggerSpawnable:
		area_object.on_trigger.emit(_create_hit_data(null))
		pass
	pass

func _on_body_exited(body : Node2D):
	entities_in_area.erase(body)
	pass

func hit_body(target : Entity):
	var is_valid : bool = filter.is_valid(self, target, entities_in_area)
	if is_valid:
		var data : Dictionary = _create_hit_data(target)
		target.on_hit.emit(data)
		on_hit.emit(data)
		if hit_listener != null:
			hit_listener.on_hit(data)
