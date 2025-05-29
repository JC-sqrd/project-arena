class_name PointSpawn
extends SpawnBehavior



func spawn(ability : Ability, actor: Entity, spawn_position : Vector2, spawn_direction : Vector2, spawn_scene : PackedScene) -> Node2D:
	var spawn = spawn_scene.instantiate() as Spawnable
	
	var spawn_rotation : float = 0
	
	spawn.source = ability
	spawn.actor = actor
	spawn.on_hit.connect(ability._on_ability_hit)
	spawn.inactive.connect(ability._spawn_end)
	spawn.collision_mask = (spawn.collision_mask - actor.collision_layer)
	if hit_listener != null:
		spawn.hit_data = hit_listener.generate_effect_data()
	
	#if !aim_at_mouse:
		#spawn_rotation = spawn_direction.angle()
	#else:
		#spawn_rotation = actor.global_position.direction_to(actor.get_global_mouse_position()).angle()
	spawn_rotation = ability.global_position.direction_to(actor.get_global_mouse_position()).angle()
	
	spawn.global_position = spawn_position
	spawn.rotation = spawn_rotation
	actor.get_tree().root.add_child(spawn)
	
	spawn_finished.emit()
	return spawn
