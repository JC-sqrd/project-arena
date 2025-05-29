class_name TriggerSpawnable
extends Spawnable

@export var spawnable : PackedScene
@export var trigger_listener : SpawnableTriggerListener

signal on_trigger(hit_data : Dictionary)

func _ready():
	if spawnable != null:
		var spawn_obj = spawnable.instantiate()
		if spawn_obj is Spawnable:
			spawn_obj.source = source
			get_tree().root.add_child(spawn_obj)
			spawn_obj.global_position = global_position
			spawn_obj.owner = get_tree().root
		pass
	get_tree().create_timer(time_active, false, false, false).timeout.connect(func (): 
		inactive.emit()
		)
	get_tree().create_timer(lifetime, false, true, false).timeout.connect(func(): queue_free())
	on_trigger.connect(_on_triggered)
	pass

func _on_triggered(hit_data : Dictionary):
	if trigger_listener != null:
		trigger_listener.apply_trigger_effects(hit_data)
		pass
	pass
