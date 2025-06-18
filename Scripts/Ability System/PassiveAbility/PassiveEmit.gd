class_name PassiveEmit
extends PassiveAbility

@export var spawnable_scene : PackedScene
@export var hit_listener : HitListener

func enable_ability(actor : Entity):
	super(actor)
	cooldown_timer.autostart = false
	_cdr = actor.stat_manager.get_stat("cooldown_reduction")
	cooldown_timer.wait_time = cooldown - (cooldown * _cdr.stat_derived_value)
	cooldown_timer.timeout.connect(_emit_spawnable)
	cooldown_timer.start()
	print("PASSIVE EMIT ABILITY ENABLED: " + str(cooldown))
	pass

func disable_ability():
	super()
	print("PASSIVE EMIT ABILITY DISABLED: " + str(cooldown))
	cooldown_timer.stop()
	pass


func _emit_spawnable():
	if spawnable_scene != null and enabled:
		print("PASSIVE EMIT ABILITY EMITTED")
		var spawn : Spawnable = spawnable_scene.instantiate() as Spawnable
		spawn.source = self
		spawn.on_hit.connect(_on_emit_hit)
		spawn.inactive.connect(_end_emit)
		spawn.collision_mask = (spawn.collision_mask - actor.original_coll_layer)
		if hit_listener != null:
			spawn.hit_data = hit_listener.generate_effect_data()
		actor.add_child(spawn)
		spawn.rotation = actor.global_position.direction_to(actor.get_global_mouse_position()).angle()
	pass

func _on_emit_hit():
	
	pass

func _end_emit():
	if enabled:
		cooldown_timer.start(cooldown - (cooldown * _cdr.stat_derived_value))
	pass
