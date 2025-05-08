class_name RelativeMouseDirection
extends Node

@export var relative_from : Node2D

func get_mouse_direction():
	var mouse_direction : Vector2 = (relative_from.get_global_mouse_position() - relative_from.position).normalized()
	return  mouse_direction
