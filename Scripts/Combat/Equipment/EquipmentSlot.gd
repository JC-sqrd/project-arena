class_name EquipmentSlot
extends Node2D

@export var actor : Entity
@export var equipment : Equipment : set = set_equipment
@export  var action_trigger : String



func _ready() -> void:
	if owner is Entity:
		actor = owner
	if equipment != null:
		await actor.ready
		equip(equipment)
	pass

func equip(equipment : Equipment):
	equipment.equip(actor)
	pass

func unequip(equipment : Equipment):
	equipment.unequip()
	equipment = null
	pass

func set_equipment(new_equipment : Equipment):
	if equipment != null:
		equipment.visible = false
		unequip(equipment)
	if new_equipment != null:
		equipment = new_equipment
		equipment.visible = true
		equip(new_equipment)
	else:
		equipment = null
	pass 
