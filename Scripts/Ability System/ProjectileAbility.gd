class_name ProjectileAbility
extends ActiveAbility


@export var max_range : float = 200
@export var spawn : PackedScene
@export var aim_at_mouse : bool = true
@export var direction : Vector2
var cast_position : Vector2

func _ready():
	#actor = owner
	super()
	ability_start.connect(_spawn_start)
	ability_canceled.connect(_cancel_spawn)

func invoke_ability():
	listen_for_cast = true
	ability_invoked.emit()
	pass

func _process(delta):
	if listen_for_cast:
		if actor is PlayerCharacter:
			actor.can_attack = false
			actor.can_cast = false
		actor.queue_redraw()
		cast_data = await get_cast_data()
	pass

func _spawn_start():
	listen_for_cast = false
	if actor is PlayerCharacter:
		get_tree().create_timer(0.1, false, false, false).timeout.connect(func (): actor.can_attack = true)
		if (actor.get_global_mouse_position() - actor.position).length() >= (max_range):
			cast_position = actor.position + (actor.get_global_mouse_position() - actor.global_position).normalized() * max_range
		else:
			cast_position = actor.get_global_mouse_position()
	else:
		cast_position = actor.global_position
	
	var spawn_rotation : float = 0
	#if !aim_at_mouse:
		#spawn_rotation = direction.angle()
		#spawn_rotation = actor.global_position.direction_to(cast_data["target_position"]).angle()
	#else:
		##spawn_rotation = (cast_data["target_position"] - actor.global_position).normalized().angle()
		#spawn_rotation = actor.global_position.direction_to(actor.get_global_mouse_position()).angle()
	
	spawn_rotation = cast_position.angle()
#
	#if spawn != null:
		#var spawn_object = new_spawnable(spawn)
		#spawn_object.position = cast_position
		#spawn_object.rotation = spawn_rotation
		#get_tree().root.add_child(spawn_object)
		#spawn_object.rotation = spawn_rotation
	#else:
		#printerr("No spawnable attached to " + name)
		
	#spawn_behavior.spawn_finished.connect(
	#	func():
	#		actor.can_cast = true
	#)
	#spawn_behavior.hit_listener = hit_listener
	#var spawn_obj : Spawnable = await spawn_behavior.spawn(self, actor, cast_position, cast_data["target_position"] as Vector2, spawn) as Spawnable
	
	#######################
	
	var spawnable : Spawnable = spawn.instantiate() as Projectile
	
	
	spawnable.source = self
	spawnable.actor = actor
	spawnable.on_hit.connect(_on_ability_hit)
	spawnable.inactive.connect(_spawn_end)
	spawnable.collision_mask = (spawnable.collision_mask - actor.collision_layer)
	if hit_listener != null:
		spawnable.hit_data = hit_listener.generate_effect_data()
	
	#if !aim_at_mouse:
		#spawn_rotation = spawn_direction.angle()
	#else:
		#spawn_rotation = actor.global_position.direction_to(actor.get_global_mouse_position()).angle()
	#spawn_rotation = ability.global_position.direction_to(spawn_direction).angle()
	
	spawnable.global_position = actor.global_position
	spawnable.rotation = actor.global_position.direction_to(get_global_mouse_position()).angle()#spawn_rotation
	actor.get_tree().root.add_child(spawnable)
	spawnable.collision_mask = (spawnable.collision_mask - actor.collision_layer)
	actor.can_cast = true
	pass

func _cancel_spawn():
	if actor is PlayerCharacter:
		actor.can_attack = true
		actor.can_cast = true
		listen_for_cast = false
	pass

func new_spawnable(spawnable_scene : PackedScene) -> Spawnable:
	var spawn_object = spawnable_scene.instantiate()
	if spawn_object is Spawnable:
			spawn_object.source = self
			spawn_object.actor = actor
			spawn_object.on_hit.connect(_on_ability_hit)
			spawn_object.on_destroy.connect(_spawn_end)
			spawn_object.collision_mask = (spawn_object.collision_mask - actor.original_coll_layer)
			if hit_listener != null:
				spawn_object.hit_data = hit_listener.generate_effect_data()
	return spawn_object

func _spawn_end():
	actor.can_attack = true
	actor.can_cast = true
	ability_end.emit()
	pass

#func _on_ability_hit(hit_data : HitData):
	#if hit_listener != null:
		#ability_hit.emit(hit_data)
		#hit_listener.on_hit(hit_data)
	#pass
	
func _on_ability_hit(hit_data : Dictionary):
	#if hit_listener != null:
		#ability_hit.emit(hit_data)
		#hit_listener.on_hit(hit_data)
	pass
