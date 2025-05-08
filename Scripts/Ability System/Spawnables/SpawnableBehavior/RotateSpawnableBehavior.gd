class_name RotateSpawnableBehavior
extends SpawnableBehavior

@export var degree : float = 0
@export var curve : Curve

var rotation_degrees : float = 0
var _lifetime_counter : float = 0
var desired_rotation_degrees : float = 0

func _ready() -> void:
	desired_rotation_degrees = spawnable.global_rotation_degrees + (degree)

func _on_spawnable_ready():
	pass

func apply_behavior():
	rotation_degrees = (desired_rotation_degrees * curve.sample(_lifetime_counter / spawnable.lifetime))
	spawnable.global_rotation_degrees = rotation_degrees
	pass

func _physics_process(delta):
	_lifetime_counter += delta
	_lifetime_counter = clamp(_lifetime_counter + delta, 0, spawnable.lifetime)
	apply_behavior()
