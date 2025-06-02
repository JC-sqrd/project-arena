class_name HomingHitSpawnable
extends AreaHit

@export var speed : float = 400
var target : Entity

var motion : Vector2

signal target_hit()

func _physics_process(delta: float) -> void:
	if target != null:
		motion = global_position.direction_to(target.global_position) * speed * delta
		global_position += motion
		rotation = global_position.direction_to(target.global_position).angle()
		pass
	else:
		queue_free()
	pass

func _on_body_entered(body : Node2D):
	if body == target:
		var data : Dictionary = _create_hit_data(body)
		body.on_hit.emit(data)
		on_hit.emit(data)
		if hit_listener != null:
			hit_listener.on_hit(data)
		if !is_inactive:
			inactive.emit()
		target_hit.emit()
		queue_free()
		
	pass


func _hit_target(target : Entity):
	if filter.is_valid(self, target, entities_in_area):
		var data : Dictionary = _create_hit_data(target)
		target.on_hit.emit(data)
		on_hit.emit(data)
		if hit_listener != null:
			hit_listener.on_hit(data)
	pass
