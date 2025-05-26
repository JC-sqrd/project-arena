class_name Equipment
extends Node2D

enum EquipmentType {WEAPON, HEADGEAR, TORSO, ARMGEAR, SHOES}
enum EquipmentTier {ONE, TWO, THREE}

@onready var actor : Entity = owner
@export var equipment_name : String
@export var type : EquipmentType = EquipmentType.WEAPON
@export var tier : EquipmentTier = EquipmentTier.ONE
@export var string_id : String
@export_multiline var equipment_description : String
@export_multiline var equipment_details : String
@export var equipment_icon : Texture2D
@export var buy_cost : float
@export var sell_value : float 
var is_equipped : bool = false

signal equipped (actor : Entity)
signal unequipped ()
signal upgrade (equipment : Equipment)

func equip(actor : Entity):
	self.actor = actor
	is_equipped = true
	equipped.emit(actor)
	pass

func unequip():
	is_equipped = false
	unequipped.emit()
	actor = null
	pass

func get_actor() -> Entity:
	return actor

func on_equipped(actor : Entity):
	ready.emit()
	pass
