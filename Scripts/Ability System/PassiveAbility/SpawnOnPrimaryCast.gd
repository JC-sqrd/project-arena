class_name SpawnOnPrimaryCast
extends PassiveAbility

@export var spawn_scene : PackedScene
@export var hit_listener : HitListener


func enable_passive_ability(actor : Entity):
	super(actor)
	self.actor = actor as PlayerCharacter
	(self.actor as PlayerCharacter).innate_active_ability.ability_casted.connect(_on_util_casted)
	pass

func disable_passive_ability():
	super()
	(self.actor as PlayerCharacter).utility_ability.ability.ability_casted.disconnect(_on_util_casted)
	pass


func _on_util_casted():
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
	
	spawn.global_position = actor.global_position
	spawn.rotation = actor.global_position.direction_to(actor.get_global_mouse_position()).angle()
	actor.get_tree().root.add_child(spawn)
	pass

func _on_spawn_hit():
	pass

func _on_spawn_inactive():
	pass
