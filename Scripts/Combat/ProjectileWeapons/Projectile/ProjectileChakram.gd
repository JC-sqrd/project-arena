class_name ProjectileChakram
extends Projectile


@export var return_speed : float = 600
@export var return_curve : Curve


var return_hit_data : Dictionary
var returning : bool = false

signal returned_to_actor()

func _physics_process(delta):
	if current_distance >= max_distance and !returning:
		print("BOOMERANG RETURN")
		returning = true
		current_distance = 0
		max_distance_reached.emit()
	
	initial_pos = global_position
	
	if !returning:
		motion = global_transform.x * delta * (speed * speed_curve.sample(current_distance/max_distance))
		position += motion
	else:
		motion = global_position.direction_to(actor.global_position) * delta * (return_speed * return_curve.sample(current_distance/max_distance))
		position += motion
		print("Current boomerang distance to actor: " + str(global_position.distance_to(actor.global_position)))
	
	if global_position.distance_to(actor.global_position) <= 10 and returning:
		returned_to_actor.emit()
		queue_free()
		pass
	
	current_distance += global_position.distance_to(initial_pos)
	pass

func _on_body_hit(body : Node2D):
	if is_valid(body) and !returning:
		on_hit.emit(_create_hit_data(body))
		body.on_hit.emit(_create_hit_data(body))
	elif is_valid(body):
		on_hit.emit(_create_return_hit_data(body))
		body.on_hit.emit(_create_return_hit_data(body))
	else:
		queue_free()
	pass

func _on_max_distance_reached():
	max_distance_reached.emit()
	returning = true
	current_distance = 0
	pass

func _create_return_hit_data(entity_hit : Entity) -> Dictionary:
	var hit_data : Dictionary = self.return_hit_data.duplicate()
	hit_data["target"] = entity_hit
	hit_data["source"] = self
	hit_data["actor"] = source.owner
	return hit_data
