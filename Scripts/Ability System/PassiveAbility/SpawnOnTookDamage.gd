class_name SpawnOnTookDamage
extends PassiveAbility

@export var spawnable_scene : PackedScene
@export var hit_listener : HitListener

func enable_passive_ability(actor : Entity):
	super(actor)
	actor.took_damage.connect(_on_actor_took_damage)
	print("TOOK DAMAGE SIGNAL CONNECTED")
	pass

func disable_passive_ability():
	actor.took_damage.disconnect(_on_actor_took_damage)
	pass


func _on_actor_took_damage(damage : float):
	var spawn : Spawnable = spawnable_scene.instantiate() as Spawnable
	spawn.source = self
	spawn.actor = actor
	spawn.on_hit.connect(_on_spawnable_hit)
	print("TOOK DAMAGE ACTOR: " + str(actor.name))
	#spawn.inactive.connect(ability._spawn_end)
	spawn.collision_mask = (spawn.collision_mask - actor.collision_layer)
	if hit_listener != null:
		spawn.hit_data = hit_listener.generate_effect_data()
	
	spawn.global_position = actor.global_position
	#spawn.rotation = actor.global_position.direction_to(spawn_direction).angle()
	actor.get_tree().root.add_child(spawn)
	print("SPAWN ON TOOK DAMAGE")
	pass

func _on_spawnable_hit(hit_data : Dictionary):
	if hit_listener != null:
		ability_hit.emit(hit_data)
		hit_listener.on_hit(hit_data)
	pass
