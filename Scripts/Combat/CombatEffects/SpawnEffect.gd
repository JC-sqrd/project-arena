class_name SpawnEffect
extends Effect

enum SpawnOn{ACTOR, TARGET}

@export var spawn_scene : PackedScene
@export var source : Node
@export var spawn_on : SpawnOn = SpawnOn.TARGET
@export var spawn_direction : SpawnEffectDirection = SpawnEffectDirection.new()
@export var spawn_position_offset : Vector2 = Vector2.ZERO
@export var add_as_child : bool = false
@export var hit_listener : HitListener



func get_effect_key() -> Variant:
	return "spawn_effect"

func apply_effect(hit_data : Dictionary):
	var spawn_object = spawn_scene.instantiate()
	if spawn_object is Spawnable:
		spawn_object.collision_mask = (spawn_object.collision_mask - actor.collision_layer)
		spawn_object.on_hit.connect(_on_spawn_object_hit)
		if hit_listener != null:
			spawn_object.hit_data = hit_listener.generate_effect_data()
		if hit_data.has("stack"):
			spawn_object.stack = hit_data["stack"]
		if spawn_on == SpawnOn.ACTOR:
			spawn_object.source = source
			if add_as_child:
				hit_data["actor"].add_child(spawn_object,true)
			else:
				get_tree().root.add_child(spawn_object, true)
			spawn_object.global_position = hit_data["actor"].global_position + + (spawn_position_offset * (hit_data["target"].global_position - source.actor.global_position).normalized())
			spawn_object.rotation = (hit_data["target"].global_position - source.actor.global_position).normalized().angle()
			pass
		elif spawn_on == SpawnOn.TARGET:
			spawn_object.source = source
			if add_as_child:
				hit_data["target"].add_child(spawn_object,true)
			else:
				get_tree().root.add_child(spawn_object, true)
				pass
			spawn_object.global_position = hit_data["target"].global_position + (spawn_position_offset * (hit_data["target"].global_position - source.actor.global_position).normalized())
			spawn_object.rotation = spawn_direction.get_spawn_direction(hit_data).angle() #hit_data["source"].rotation
			#var space : PhysicsDirectSpaceState2D = get_viewport().world_2d.direct_space_state
			#var shape_query : PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
			#var circle : CircleShape2D = CircleShape2D.new()
			#circle.radius = 500
			#shape_query.collision_mask = 2
			#shape_query.shape = circle
			#shape_query.motion = hit_data["target"].global_position
			#
			#var results : Array[Dictionary] = space.intersect_shape(shape_query)
			#var nearest_target : Entity
			#
			#if results != null:
				#if results[0] != null:
					#nearest_target = results[0]["collider"]  
				#pass
				#
			#for result in results:
				#var nearest_distance : float = (nearest_target.global_position - hit_data["target"].global_position).length()
				#if result["collider"] == hit_data["target"]:
					#continue
				#elif nearest_distance > (result["collider"].global_position - hit_data["target"].global_position).length():
					#nearest_distance = (result["collider"].global_position - hit_data["target"].global_position).length()
					#nearest_target = result["collider"] 
				#pass
			##spawn_object.rotation = (nearest_target.global_position - hit_data["target"].global_position).normalized().angle() 
			#pass
	pass

func _on_spawn_object_hit(hit_data : Dictionary):
	if hit_listener != null:
		hit_listener.on_hit(hit_data)
	pass
