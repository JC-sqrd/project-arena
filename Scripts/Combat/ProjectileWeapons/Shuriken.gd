extends ProjectileWeapon

@export var throw_count : int = 1
@export var throw_delay : float = 0.1
@export var shuriken_sprite : Node2D
var throw_counter : float = 0

func _spawn_projectile():
	throw_counter = throw_count + int(actor.stat_manager.get_stat("projectile_count").stat_derived_value)
	while throw_counter >= 1:
		if shuriken_sprite != null:
			shuriken_sprite.visible = false
		spawn_shuriken()
		print("SHURIKEN DELAY: " + str(minf(0, throw_delay * attack_speed_stat.stat_derived_value)))
		await get_tree().create_timer(throw_delay, false, true, false).timeout
		if shuriken_sprite != null:
			shuriken_sprite.visible = true
		throw_counter -= 1
		actor.basic_attack.emit(self)
		end_attack()
	pass

func spawn_shuriken():
	if projectile != null:
		var new_projectile = projectile.instantiate()
		if new_projectile is Projectile:
			new_projectile.on_hit.connect(_on_attack_hit)
			if hit_listener != null:
				new_projectile.hit_data = hit_listener.generate_effect_data()
			new_projectile.max_distance_reached.connect(func() : attack_end.emit())
			new_projectile.source = self
			new_projectile.max_distance = max_distance
			new_projectile.speed = speed
			get_tree().root.add_child(new_projectile)
			new_projectile.set_collision_mask_value(actor.original_coll_layer, false)
			if spawn_node != null:
				new_projectile.position = spawn_node.global_position
			else:
				new_projectile.position = global_position
			#new_projectile.direction = ((get_global_mouse_position() + position) - position).normalized()
			new_projectile.rotation = global_position.direction_to(get_global_mouse_position()).angle()
			attack_active.emit()
			#end_attack()
	else:
		printerr("No projectile to spawn")
	pass
