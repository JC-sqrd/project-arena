class_name STriggerSpawnEffect
extends SpawnableTriggerEffect

@export var spawn_scene : PackedScene

var _spawnable_hit_listener : HitListener

func _ready():
	for child in get_children():
		if child is HitListener:
			_spawnable_hit_listener = child
		pass

func trigger_effect(hit_data : Dictionary):
	var spawn_obj = spawn_scene.instantiate()
	if spawn_obj is Spawnable:
		spawn_obj.source = owner.source
		get_tree().root.add_child(spawn_obj)
		_spawnable_hit_listener.reparent(spawn_obj)
		spawn_obj.on_hit.connect(_spawnable_hit_listener.on_hit)
		spawn_obj.global_position = owner.global_position
		
		pass
	pass
