class_name GroupSpawnable
extends Spawnable

@export var pass_rotation_to_child : bool = true

func _ready():
	for child in get_children():
		if child is Spawnable:
			child.source = source
			child.hit_data = hit_data
			child.stack = stack
	
	get_tree().create_timer(lifetime, false, true, false).timeout.connect(
		func():
			queue_free()
	)




func _on_child_entered_tree(node):
	if node is Spawnable:
		#node.rotate(rotation)
		node.source = source
		node.collision_mask = collision_mask
	pass # Replace with function body.
