class_name SpawnOnUtilCastArea
extends PassiveAbility

@export var spawn_scene : PackedScene
@export var area : Area2D
@export var hit_listener : HitListener

var hittable_entities : Array[Entity]

func enable_passive_ability(actor : Entity):
	super(actor)
	self.actor = actor
	(self.actor as PlayerCharacter).utility_ability.ability.ability_casted.connect(_on_util_casted)
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	var overlapping_bodies : Array[Node2D] = area.get_overlapping_bodies()
	for body in overlapping_bodies:
		area.body_entered.emit(body)
	pass

func disable_passive_ability():
	(self.actor as PlayerCharacter).utility_ability.ability.ability_casted.disconnect(_on_util_casted)
	super()
	hittable_entities.clear()
	pass


func _on_util_casted():
	if hittable_entities.size() > 0:
		print("PASSIVE UTIL CAST")
		var spawn = spawn_scene.instantiate() as Spawnable
		
		var spawn_rotation : float = 0
		
		spawn.source = self
		spawn.actor = actor
		spawn.on_hit.connect(_on_spawn_hit)
		spawn.inactive.connect(_on_spawn_inactive)
		spawn.collision_mask = (spawn.collision_mask - actor.collision_layer)
		if hit_listener != null:
			spawn.hit_data = hit_listener.generate_effect_data()
		
		#if !aim_at_mouse:
			#spawn_rotation = spawn_direction.angle()
		#else:
			#spawn_rotation = actor.global_position.direction_to(actor.get_global_mouse_position()).angle()
		#spawn_rotation = ability.global_position.direction_to(spawn_direction).angle()
		
		spawn.global_position = hittable_entities[0].global_position
		spawn.rotation = actor.global_position.direction_to(actor.get_global_mouse_position()).angle()
		#actor.get_tree().root.add_child(spawn)
		get_tree().root.add_child(spawn)
	pass

func _on_body_entered(body : Node2D):
	if body is Entity and body.is_in_group("Hittable") and body != actor:
		hittable_entities.append(body)
		hittable_entities.sort_custom(_sort_by_distance)
	pass

func _sort_by_distance(a : Entity, b : Entity) -> bool:
	return a.global_position.distance_squared_to(actor.global_position) < b.global_position.distance_squared_to(actor.global_position)

func _on_body_exited(body : Node2D):
	if hittable_entities.has(body):
		hittable_entities.erase(body)
		hittable_entities.sort_custom(_sort_by_distance)
	pass

func _on_spawn_hit():
	pass

func _on_spawn_inactive():
	pass
