class_name SkillshotSpawnable
extends AreaEnterHit


@export var move_speed : float = 300
var move_direction : Vector2 = Vector2.RIGHT

var _speed : float = 300
var _velocity : Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	move_direction = global_transform.x#Vector2.RIGHT.rotated(spawnable.rotation)
	_speed = (move_speed) 
	#motion = lerp(move_direction, move_direction * move_speed, spawnable.get_physics_process_delta_time()) * curve.sample(_lifetime_counter / spawnable.lifetime)
	_velocity = move_direction * _speed
	global_position += _velocity * delta
	#print("Spawnable direction: " + str(spawnable_velocity) + " degrees: " + str(spawnable.rotation_degrees))  
