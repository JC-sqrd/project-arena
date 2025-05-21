class_name StatusEffect
extends Node

enum Type{NEGATIVE, POSITIVE}

var actor : Entity
@export var icon : Texture
@export var duration : float = 0
@export var stackable : bool = false
@export var timer : Timer
@export var stack_stat : Stat
@export var max_stack : int = 999
@export var restart_on_stack_add : bool = false
@export var id : String = "status_effect"
@export var type : Type 
@export var is_permanent : bool = false
var stack : int = 0 : set = _set_stack
var active : bool = false

var target_entity : Entity

signal duration_end()


func activate_status_effect(target : Entity):
	target_entity = target
	timer.wait_time = duration
	timer.one_shot = true
	active = true
	timer.timeout.connect(
		func():
			duration_end.emit()
			active = false
			queue_free()
	)
	timer.start()
	pass

func add_stack(amount : int):
	stack += amount
	if restart_on_stack_add:
		restart_duration()
	pass

func restart_duration():
	timer.start()
	pass

func _set_stack(new_value : int):
	stack = min(new_value, max_stack)
	pass

func get_actor() -> Entity:
	return actor

func get_target() -> Entity:
	return target_entity
