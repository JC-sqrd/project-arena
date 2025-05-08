extends Node2D

var time : float = 0

func _process(delta: float) -> void:
	time += delta
	global_position += (Vector2.UP * cos(time) * 5 * delta) + Vector2.RIGHT * sin(time) * 5 * delta
