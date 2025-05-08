class_name SpawnOnWindup
extends SpawnableBehavior


@export var spawnable_scene : PackedScene
@export var hit_listener : HitListener
@export var direction : Vector2 = Vector2(1,0)

func _ready():
	spawnable = owner
	if spawnable.has_signal("windup_end"):
		spawnable.windup_end.connect(_on_windup_end)
	pass


func _on_windup_end():
	if spawnable_scene != null:
		var spawnable_obj : Spawnable = spawnable_scene.instantiate() as Spawnable
		spawnable_obj.actor = spawnable.actor
		spawnable_obj.source = spawnable.source
		if hit_listener != null:
			spawnable_obj.hit_data = hit_listener.generate_effect_data()
		else:
			spawnable_obj.hit_data = spawnable.hit_data.duplicate(true)
		spawnable_obj.collision_mask = spawnable.collision_mask
		spawnable_obj.position = spawnable.position
		spawnable_obj.rotation = direction.angle()
		get_tree().root.add_child(spawnable_obj, true)
	pass
