class_name GroupSpawnable
extends Spawnable

@export var pass_rotation_to_child : bool = true

func _ready():
	for child in get_children():
		if child is Spawnable:
			child.source = source
			child.hit_data = hit_data
			child.stack = stack
	get_tree().create_timer(time_active, false, false, false).timeout.connect(func (): 
		inactive.emit()
		)
	get_tree().create_timer(lifetime, false, true, false).timeout.connect(
		func():
			inactive.emit()
			on_destroy.emit()
			queue_free()
	)

func _enter_tree() -> void:
	child_entered_tree.connect(_on_child_entered_tree)

func _on_child_entered_tree(node):
	if node is Spawnable:
		#node.rotate(rotation)
		node.source = source
		node.actor = actor
		node.collision_mask = collision_mask
	pass # Replace with function body.
