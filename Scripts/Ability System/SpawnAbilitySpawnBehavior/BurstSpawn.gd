class_name BurstSpawn
extends SpawnBehavior

@export var burst_count : int = 1
@export var burst_delay : float = 0.1
@export var relative_to_actor : bool = true
@export var look_at_mouse : bool = false

var delay_counter : float = 0
var burst_counter : int = 0

func spawn(ability : Ability, actor: Entity, spawn_position : Vector2, spawn_direction : Vector2, spawn_scene : PackedScene):
	burst_counter = burst_count
	while burst_counter >= 1:
		spawn_spawnable(ability, actor, spawn_position, spawn_direction, spawn_scene)
		await actor.get_tree().create_timer(burst_delay, false, true, false).timeout
		burst_counter -= 1

	spawn_finished.emit()
	
	print("Spawn finished")
	pass

func spawn_spawnable(ability : Ability, actor: Entity, spawn_position : Vector2, spawn_direction : Vector2, spawn_scene : PackedScene):
	var spawn = spawn_scene.instantiate() as Spawnable
	
	var spawn_rotation : float = 0
	
	spawn.source = ability
	spawn.actor = actor
	spawn.on_hit.connect(ability._on_ability_hit)
	spawn.on_destroy.connect(ability._spawn_end)
	spawn.collision_mask = (spawn.collision_mask - actor.collision_layer)
	if hit_listener != null:
		spawn.hit_data = hit_listener.generate_effect_data()
	
	if !look_at_mouse:
		spawn_rotation = actor.global_position.direction_to(spawn_direction).angle()
	else:
		spawn_rotation = actor.global_position.direction_to(actor.get_global_mouse_position()).angle()
	
	if relative_to_actor:
		spawn_position = spawn_position + (actor.global_position - spawn_position)
	
	spawn.global_position = spawn_position
	spawn.rotation = spawn_rotation
	actor.get_tree().root.add_child(spawn)
	pass
