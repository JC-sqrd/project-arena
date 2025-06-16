class_name EquipmentInventory
extends Node


@export var max_size : int = 6
@export var weapon_slot : WeaponSlot
@export var headgear_slot : EquipmentSlot
@export var torso_slot : EquipmentSlot
@export var armgear_slot : EquipmentSlot
@export var shoes_slot : EquipmentSlot

var inventory : Array[Equipment] = [null, null, null, null, null, null]
var equip_inventory : Array[Equipment] = [null, null, null, null, null] 

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
	weapon_slot.equipment_equipped.connect(on_weapon_equipped)
	weapon_slot.equipment_unequipped.connect(on_weapon_unequipped)
	headgear_slot.equipment_equipped.connect(on_headgear_equipped)
	headgear_slot.equipment_unequipped.connect(on_headgear_unequipped)
	torso_slot.equipment_equipped.connect(on_torso_equipped)
	torso_slot.equipment_unequipped.connect(on_torso_unequipped)
	armgear_slot.equipment_equipped.connect(on_armgear_equipped)
	armgear_slot.equipment_unequipped.connect(on_armgear_unequipped)
	shoes_slot.equipment_equipped.connect(on_shoes_equipped)
	shoes_slot.equipment_unequipped.connect(on_shoes_unequipped)


func on_weapon_equipped(equipment : Equipment):
	equip_inventory[0] = equipment
	pass

func on_weapon_unequipped(equipment : Equipment):
	equip_inventory[0] = null
	pass

func on_headgear_equipped(equipment : Equipment):
	equip_inventory[1] = equipment
	pass

func on_headgear_unequipped(equipment : Equipment):
	equip_inventory[1] = null
	pass

func on_torso_equipped(equipment : Equipment):
	equip_inventory[2] = equipment
	pass

func on_torso_unequipped(equipment : Equipment):
	equip_inventory[2] = null
	pass

func on_armgear_equipped(equipment : Equipment):
	equip_inventory[3] = equipment
	pass

func on_armgear_unequipped(equipment : Equipment):
	equip_inventory[3] = null
	pass

func on_shoes_equipped(equipment : Equipment):
	equip_inventory[4] = equipment
	pass

func on_shoes_unequipped(equipment : Equipment):
	equip_inventory[4] = null
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
	var equipment_index : int = _linear_search(equipment)
	if equipment_index >= 0:
		inventory[equipment_index] = null
		pass
	else:
		printerr("Equipment does not exist in inventory")
	pass

func _linear_search(equipment : Equipment) -> int:
	var index : int = 0
	for _equipment in inventory:
		if _equipment == equipment:
			return index
		index += 1
	return -1
	pass
