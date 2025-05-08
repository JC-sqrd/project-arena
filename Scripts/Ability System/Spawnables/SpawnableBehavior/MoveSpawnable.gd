class_name SpawnableMoveBehavior
extends SpawnableBehavior

@export var move_speed : float = 100 
@export var curve : Curve
var move_direction : Vector2 = Vector2.RIGHT
var speed : float 
var spawnable_velocity : Vector2


var _lifetime_counter : float = 0

func _ready():
	spawnable = owner
	pass

func apply_behavior():
	move_direction = spawnable.global_transform.x#Vector2.RIGHT.rotated(spawnable.rotation)
	speed = (move_speed * curve.sample(_lifetime_counter / spawnable.lifetime)) * spawnable.get_physics_process_delta_time()
	#motion = lerp(move_direction, move_direction * move_speed, spawnable.get_physics_process_delta_time()) * curve.sample(_lifetime_counter / spawnable.lifetime)
	spawnable_velocity = move_direction * speed
	spawnable.global_position += spawnable_velocity
	#print("Spawnable direction: " + str(spawnable_velocity) + " degrees: " + str(spawnable.rotation_degrees))  
	pass

func _physics_process(delta):
	_lifetime_counter += delta
	_lifetime_counter = clamp(_lifetime_counter + delta, 0, spawnable.lifetime)
	apply_behavior()
	pass
	
