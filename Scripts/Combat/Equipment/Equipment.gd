class_name Equipment
extends Node2D

enum EquipmentType {WEAPON, HEADGEAR, TORSO, ARMGEAR, SHOES}

@onready var actor : Entity = owner
@export var equipment_name : String
@export var type : EquipmentType = EquipmentType.WEAPON
@export_multiline var equipment_description : String
@export_multiline var equipment_details : String
@export var equipment_icon : Texture2D
@export var buy_data : ShopBuyData
@export var sell_data : ShopSellData
var is_equipped : bool = false

signal equipped (actor : Entity)
signal unequipped ()

func equip(actor : Entity):
	self.actor = actor
	is_equipped = true
	equipped.emit(actor)
	pass

func unequip():
	is_equipped = false
	actor = null
	unequipped.emit()
	pass

func get_actor() -> Entity:
	return actor
