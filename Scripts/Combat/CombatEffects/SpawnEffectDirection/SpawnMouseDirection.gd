class_name SpawnMouseDirection
extends SpawnEffectDirection

enum RELATIVE_FROM {ACTOR, TARGET}

@export var relative_from : RELATIVE_FROM = RELATIVE_FROM.ACTOR

func get_spawn_direction(hit_data : Dictionary) -> Vector2:
	var subject : Entity
	if relative_from == RELATIVE_FROM.ACTOR:
		subject = hit_data["actor"] as Entity
		return (subject.get_global_mouse_position() - subject.global_position)
	elif relative_from == RELATIVE_FROM.TARGET:
		subject = hit_data["target"] as Entity
		return (subject.get_global_mouse_position() - subject.global_position)
	return Vector2.ZERO
