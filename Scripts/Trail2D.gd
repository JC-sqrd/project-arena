class_name Trail2D
extends Line2D

@export var max_points : int = 5
var point : Vector2

func _ready() -> void:
	show_behind_parent = true
	pass

func _process(delta : float):
	global_position = Vector2(0, 0)
	global_rotation = 0
	
	point = get_parent().global_position
	
	add_point(point)
	while get_point_count() > max_points:
		remove_point(0)
	
	pass
