class_name HomingSpawnAbility
extends SpawnAbility

@export var max_targets : int = 5
@export var homing_area : Area2D

var targets : Array[Entity]

func _ready():
	super()
	homing_area.body_entered.connect(_on_target_enter)
	homing_area.body_exited.connect(_on_target_exit)

func _spawn_start():
	get_cast_position = false
	if actor is PlayerCharacter:
		get_tree().create_timer(0.1, false, false, false).timeout.connect(func (): actor.can_attack = true)
		if (actor.get_global_mouse_position() - actor.position).length() >= (max_range):
			cast_position = actor.position + (actor.get_global_mouse_position() - actor.global_position).normalized() * max_range
		else:
			cast_position = actor.get_global_mouse_position()
	else:
		cast_position = actor.global_position
	
	#spawn_behavior.spawn_finished.connect(
		#func():
			#actor.can_cast = true
	#)
	
	targets.sort_custom(
		func(a : Entity, b : Entity):
			var mouse_pos : Vector2 = get_global_mouse_position()
			return a.global_position.distance_squared_to(mouse_pos) < b.global_position.distance_squared_to(mouse_pos)
	)
	
	print(str(targets))
	
	for i in targets.size():
		if i >= max_targets:
			break
		var homing_spawn : HomingHitSpawnable = spawn.instantiate() as HomingHitSpawnable
		homing_spawn.source = self
		homing_spawn.actor = actor
		homing_spawn.on_hit.connect(_on_ability_hit)
		homing_spawn.collision_mask = (homing_spawn.collision_mask - actor.collision_layer)
		if hit_listener != null:
			homing_spawn.hit_data = hit_listener.generate_effect_data()
		homing_spawn.target = targets[i]
		homing_spawn.global_position = cast_position
		homing_spawn.rotation = homing_spawn.global_position.direction_to(targets[i].global_position).angle()
		get_tree().root.add_child(homing_spawn)
		pass
	_spawn_end()
	#spawn_behavior.hit_listener = hit_listener
	#var spawn_obj : Spawnable = await spawn_behavior.spawn(self, actor, cast_position, cast_data["target_position"] as Vector2, spawn) as Spawnable
	pass

func _on_target_enter(body : Node2D):
	if body.is_in_group("Hittable") and body != actor:
		targets.append(body)
		targets.sort_custom(
		func(a : Entity, b : Entity):
			var mouse_pos : Vector2 = get_global_mouse_position()
			a.global_position.distance_to(get_viewport().get_mouse_position()) < b.global_position.distance_to(get_viewport().get_mouse_position())
	)
	pass

func _on_target_exit(body : Node2D):
	if targets.has(body):
		targets.erase(body)
	pass
