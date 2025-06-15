class_name EquipmentSlot
extends Node2D

@export var actor : Entity
@export var equipment : Equipment : set = set_equipment
@export  var action_trigger : String

signal equipment_equipped(equipment : Equipment)
signal equipment_unequipped(equipment : Equipment)

func _ready() -> void:
	if owner is Entity:
		actor = owner
	if equipment != null:
		await actor.ready
		equip(equipment)
	pass

func equip(equipment : Equipment):
	equipment.equip(actor)
	equipment_equipped.emit(equipment)
	
	equipment.reparent(actor)
	equipment.global_position = Vector2.ZERO
	equipment.rotation = 0
	equipment.position = Vector2.ZERO
	#equipment.action_trigger = action_trigger
	equipment.equip(actor)
	equipment.visible = true
	equipment_equipped.emit(equipment)
	pass

func unequip(equipment : Equipment):
	equipment.unequip()
	equipment_unequipped.emit(equipment)
	pass

func set_equipment(new_equipment : Equipment):
	if equipment != null:
		equipment.visible = false
		unequip(equipment)
		equipment = null
	if new_equipment != null:
		equipment = new_equipment
		equipment.visible = true
		equip(new_equipment)
	else:
		equipment = null
	pass 
