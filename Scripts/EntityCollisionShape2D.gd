class_name EntityCollisionShape2D
extends CollisionShape2D


var entity : Entity 


func _enter_tree() -> void:
	if owner is Entity:
		entity = owner
		entity.died.connect(_on_entity_die)

func _on_entity_die():
	disabled = true
	pass
