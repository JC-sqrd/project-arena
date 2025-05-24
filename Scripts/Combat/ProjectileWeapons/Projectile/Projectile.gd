class_name Projectile
extends Spawnable

@export var projectile_sprite : Sprite2D
@onready var sprite_2d = $Sprite2D

@export var speed : float = 600
@export var speed_curve : Curve = Curve.new()
@export var max_distance : float = 1000


var current_distance : float = 0
var motion : Vector2 = Vector2.ZERO

var initial_pos : Vector2 = Vector2.ZERO
var current_pos : Vector2 = Vector2.ZERO

signal max_distance_reached

func _ready():
	self.body_entered.connect(_on_body_hit)
	if projectile_sprite != null:
		sprite_2d = projectile_sprite
	#get_tree().create_timer(max_distance / speed, false, true, false).timeout.connect(_on_max_distance_reached)
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, true)
	initial_pos = global_position
	pass

func _process(delta):
	
	pass

func _physics_process(delta):
	if current_distance >= max_distance:
		max_distance_reached.emit()
		queue_free()
	
	initial_pos = global_position
	
	motion = global_transform.x * delta * (speed * speed_curve.sample(current_distance/max_distance))
	position += motion
	
	current_distance += global_position.distance_to(initial_pos)
	pass
	
func _on_max_distance_reached():
	max_distance_reached.emit()
	queue_free()
	pass

func _on_body_hit(body : Node2D):
	if is_valid(body):
		on_hit.emit(_create_hit_data(body))
		body.on_hit.emit(_create_hit_data(body))
	else:
		queue_free()
	pass

#func _create_hit_data(entity_hit : Entity) -> HitData:
	#var hit_data = HitData.create()
	#hit_data.data["target"] = entity_hit
	#hit_data.data["source"] = self
	#hit_data.data["actor"] = source.owner
	#return hit_data
	#pass

func is_valid(body : Node2D) -> bool:
	if body != null and body.is_in_group("Hittable"):
		return true
	return false

func _create_hit_data(entity_hit : Entity) -> Dictionary:
	var hit_data : Dictionary = self.hit_data.duplicate()
	hit_data["target"] = entity_hit
	hit_data["source"] = self
	hit_data["actor"] = actor
	return hit_data
