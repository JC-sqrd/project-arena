class_name Pickupable
extends Node2D

@export var pickup_sound : AudioStream
var move_to : Entity
var _move_to_entity : bool = false

signal picked_up

var _lerp_weight : float = -0.5
@onready var _lerp_weight_counter : float = _lerp_weight 

func move_to_pickup(pickup_pos : Vector2):
	var lerped_pos : Vector2 = lerp(global_position, pickup_pos, _lerp_weight_counter)
	global_position = lerp(global_position, lerped_pos, 0.1)
	_lerp_weight_counter += 0.05
	pass
	
func move_to_entity(entity : Entity):
	move_to = entity
	_move_to_entity = true
	pass

func _physics_process(delta):
	if _move_to_entity and move_to != null:
		move_to_pickup(move_to.global_position)
		pass
	pass

func pickup(entity : Entity):
	picked_up.emit()
	_lerp_weight_counter = _lerp_weight
	queue_free()
	pass
