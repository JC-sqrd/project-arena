class_name SpawnableAccelerateBehavior
extends SpawnableBehavior


@export var move_speed : float = 100 
@export var acceleration : float = 10
var move_direction : Vector2 = Vector2.RIGHT
var motion : Vector2 
@export var lifetime : float = 1
@export var curve : Curve
var _lifetime_counter : float = 0
var _motion_acceleration = 0

var _current_speed : float = 0

func _ready():
	spawnable = owner
	pass

func apply_behavior():
	move_direction = spawnable.transform.x
	motion = move_direction * (_current_speed) * spawnable.get_physics_process_delta_time()
	spawnable.global_position += motion
	_motion_acceleration += acceleration * curve.sample(_lifetime_counter / lifetime) * get_physics_process_delta_time()
	_current_speed += _motion_acceleration
	_current_speed = clamp(_current_speed, -INF, move_speed)
	_current_speed = clamp(_current_speed, -INF, 5000)
	pass

func _physics_process(delta):
	_lifetime_counter += delta
	_lifetime_counter = clamp(_lifetime_counter + delta, 0, lifetime)
	apply_behavior()
	pass
