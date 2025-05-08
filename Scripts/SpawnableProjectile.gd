class_name SpawnableProjectile
extends Spawnable

@export var projectile : Projectile
@export var projectile_speed : float = 600
@export var projectile_max_distance : float = 500
var projectile_direction : Vector2
@onready var actor_stats : StatManager = get_actor_stats()
var area_size_mult : float = 1

var move_behavior : SpawnableMoveBehavior

func _ready():
	get_tree().create_timer(lifetime, false, true, false).timeout.connect(func() : queue_free())
	#var mouse_pos : Vector2 = source.actor.get_global_mouse_position()
	#projectile_direction = (mouse_pos - source.actor.global_position).normalized()
	#if actor_stats.stats.has("area_size"):
		#area_size_mult = actor_stats.stats["area_size"].stat_derived_value
	#scale *= area_size_mult
	#projectile.source = source
	#projectile.direction = Vector2.RIGHT
	##projectile.look_at(mouse_pos.normalized())
	#projectile.piercing = true
	#projectile.set_collision_mask_value(source.actor.collision_layer, false)
	#projectile.speed = projectile_speed
	#projectile.max_distance = projectile_max_distance
	#projectile.on_hit.connect(func(hit_data : Dictionary) : 
		#on_hit.emit(hit_data)
		#)
	#projectile.max_distance_reached.connect(func() : 
		#queue_free()
		#)
	#var mouse_pos : Vector2 = source.actor.get_global_mouse_position()
	#move_behavior = SpawnableMoveBehavior.new()
	#move_behavior.move_direction = (mouse_pos - source.actor.global_position).normalized()
	#move_behavior.spawnable = self
	#add_child(move_behavior)
	pass
	
func _physics_process(delta):
	#move_behavior.apply_behavior()
	pass

func _on_body_entered(body : Node2D):
	if body is Entity and body != source.actor:
		entities_in_area.append(body)
	pass

func get_actor_stats() -> StatManager:
	if source != null and source.actor is Entity:
		return source.actor.stat_manager
	else:
		return null
	pass
