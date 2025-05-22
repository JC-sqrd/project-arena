class_name EquipmentInventory
extends Node


@export var max_size : int = 6
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


signal equipment_added(equipment : Equipment, slot_index : int)

func _ready() -> void:
	var children : Array[Node] = get_children()
	#for i in range(children.size()):
		#print("CHILDREN INDEX : " + str(i))
		#if i < max_size and children[i] is Equipment:
			#inventory[i] = children[i]
			#pass
	inventory.resize(max_size)
	inventory.fill(null)
	for i in range(children.size()):
		if children[i] is Equipment:
			inventory[i] = children[i]
			#inventory.append(equipment)
		pass


func add_equipment(equipment : Equipment) -> bool:
	for i in inventory.size():
		if inventory[i] == null:
			inventory[i] = equipment
			equipment_added.emit(equipment, i)
			add_child(equipment)
			print("Added equipment to inventory")
			return true
		pass
	print("Inventory full, cannot add equipment")
	return false
	pass

func remove_equipment(equipment : Equipment):
	inventory.erase(equipment)
	pass
