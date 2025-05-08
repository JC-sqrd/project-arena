class_name LookAtMouse
extends SpawnableBehavior






func _process(delta: float) -> void:
	spawnable.rotation = (spawnable.get_global_mouse_position() - spawnable.global_position).normalized().angle()
