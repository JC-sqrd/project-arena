class_name Item
extends Node

var actor : Entity = get_item_actor()
@onready var source : Node = get_item_actor()
@export var item_name : String
@export var item_icon : Texture2D
@export var item_id : int
@export var string_id : String
@export var stack : int = 1 : set = _set_item_stack
@export_multiline var item_description : String
@export_multiline var item_detail : String 
var equipped : bool = false

signal item_ready()
signal stack_changed()
signal item_stack_changed (item : Item)
signal item_equipped ()
signal item_unequipped ()

func _enter_tree():
	if owner != null:
		actor = get_item_actor()
		#item_ready.emit()
	pass

func _ready():
	#if owner != null:
		#actor = get_item_actor()
		##item_ready.emit()
	#else:
	pass

func equip_item(entity : Entity):
	actor = entity
	source = entity
	equipped = true
	item_equipped.emit()
	pass

func unequip_item():
	actor = null
	source = null
	equipped = false
	item_unequipped.emit()
	pass


func get_item_actor() -> Entity:
	if owner is Entity:
		return owner
	else:
		return null

func get_actor() -> Entity:
	return actor

func _set_item_stack(new_value : int):
	if new_value <= 0:
		stack = 1
	else:
		stack = new_value
	stack_changed.emit()
	item_stack_changed.emit(self)
	pass
