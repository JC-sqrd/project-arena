class_name LookAtMouseLerp
extends SpawnableBehavior



@export var weight : float = 1


func _process(delta: float) -> void:
	spawnable.rotation = lerp_angle(spawnable.rotation,(spawnable.get_global_mouse_position() - spawnable.global_position).normalized().angle(), weight * delta)
