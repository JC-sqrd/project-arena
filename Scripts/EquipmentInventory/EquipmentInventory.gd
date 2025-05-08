class_name EquipmentInventory
extends Node


var max_size : int = 6
var inventory : Array[Equipment] = [null, null, null, null, null, null]

@export var weapon_slot : WeaponSlot
@export var headgear_slot : EquipmentSlot
@export var torso_slot : EquipmentSlot
@export var armgear_slot : EquipmentSlot
@export var shoes_slot : EquipmentSlot


var equipped_weapon : Weapon
var equipped_headgear : Equipment
var equipped_torso : Equipment
var equipped_armgear : Equipment
var equipped_shoes : Equipment



func _ready() -> void:
	var children : Array[Node] = get_children()
	var inventory_index : int = 0
	for i in range(children.size()):
		print("CHILDREN INDEX : " + str(i))
		if i < max_size and children[i] is Equipment:
			inventory[i] = children[i]
			print("INVENTORY INDEX : " + str(inventory_index))
			inventory_index += 1
			pass
		pass


func add_equipment(equipment : Equipment):
	pass

func remove_equipment(equipment : Equipment):
	inventory.erase(equipment)
	pass
