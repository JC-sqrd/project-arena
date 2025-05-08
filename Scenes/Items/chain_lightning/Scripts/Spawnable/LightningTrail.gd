extends Line2D

@export var max_points : float = 2000
var old_position : Vector2

func _ready():
	old_position = global_position

func _process(delta):
	var dir_to_new_pos : Vector2 = (old_position - global_position).normalized()
	var dir_vector : Vector2 = (old_position - global_position) + old_position
	add_point(get_parent().global_position)
	if points.size() >= max_points:
		remove_point(0)
	pass
