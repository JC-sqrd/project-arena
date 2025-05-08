class_name Spawnable
extends Area2D

@export var lifetime : float = 1
@export var filter : SpawnableEnterFilter = SpawnableEnterFilter.new()
@export var hit_listener : HitListener
var entities_in_area : Array[Entity]
var hit_data : Dictionary
var source : Node
var stack : int = 1

@onready var actor : Entity = _get_actor_from_source()

signal on_destroy
signal on_hit(hit_data : Dictionary)
signal windup_start()
signal windup_end()
signal spawnable_start()

func _create_hit_data(entity_hit : Entity) -> Dictionary:
	var data : Dictionary = hit_data.duplicate(true)
	data["target"] = entity_hit
	data["source"] = self
	data["actor"] = actor
	return data

func _on_body_entered(body : Node2D):
	if body.is_in_group("Hittable") and body != actor:
		entities_in_area.append(body)
	pass

func _on_body_exited(body : Node2D):
	entities_in_area.erase(body)
	pass

func _get_actor_from_source() -> Entity:
	return source.actor
	pass

func get_actor() -> Entity:
	return actor

func get_stack() -> int:
	return stack
