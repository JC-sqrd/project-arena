extends Line2D


var old_position : Vector2 = global_position
@export var segments : float = 5


func _ready():
	old_position = global_position
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			var mouse_pos : Vector2 = get_global_mouse_position()
			var relative_mouse_pos : Vector2 = ((mouse_pos - old_position))
			var point_vector : Vector2 = ((relative_mouse_pos - points[points.size() - 1]) + points[points.size() - 1])
			#var segmented_point : Vector2 =  (((relative_mouse_pos - points[points.size() - 1]) / segments) + points[points.size() - 1])
			for i in range(1, segments + 1):
				var segmented_point : Vector2 =  (((relative_mouse_pos - points[points.size() - 1]) / segments) + points[points.size() - 1])
				add_point(segmented_point)
			#add_point(point_vector)
			old_position = old_position
