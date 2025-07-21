class_name SpawnableHelper
extends RefCounted


static func initialize_spawnable(spawnable_scene : PackedScene,actor : Entity, source : Node2D, hit_listener : HitListener) -> Spawnable:
	var spawnable : Spawnable = spawnable_scene.instantiate() as Spawnable
	spawnable.actor = actor
	spawnable.source = source
	if hit_listener == null:
		return spawnable
	spawnable.hit_data = hit_listener.generate_effect_data()
	return spawnable

static func spawn_spawnable():
	pass
