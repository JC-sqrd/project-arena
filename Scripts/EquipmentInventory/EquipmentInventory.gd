class_name EquipmentInventory
extends Node


@export var max_size : int = 6
@export var weapon_slot : WeaponSlot
@export var headgear_slot : EquipmentSlot
@export var torso_slot : EquipmentSlot
@export var armgear_slot : EquipmentSlot
@export var shoes_slot : EquipmentSlot
@export var offhand_weapon_slot : EquipmentSlot

var inventory : Array[Equipment] = [null, null, null, null, null, null]
var equip_inventory : Array[Equipment] = [null, null, null, null, null, null] 

var equipped_weapon : Weapon
var equipped_headgear : Equipment
var equipped_torso : Equipment
var equipped_armgear : Equipment
var equipped_shoes : Equipment

var _equip_slot_dict : Dictionary [int, EquipmentSlot]

signal equipment_added(equipment : Equipment, slot_index : int)
signal slot_updated (index : int)
signal equip_slot_updated (index : int)
signal weapon_slot_updated
signal headgear_slot_updated
signal torso_slot_updated
signal armgear_slot_updated
signal shoes_slot_updated
signal offhand_slot_updated
signal inventory_full()

func _ready() -> void:
	_equip_slot_dict[0] = weapon_slot
	_equip_slot_dict[1] = headgear_slot
	_equip_slot_dict[2] = torso_slot
	_equip_slot_dict[3] = armgear_slot
	_equip_slot_dict[4] = shoes_slot
	_equip_slot_dict[5] = offhand_weapon_slot
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
	offhand_weapon_slot.equipment_equipped.connect(on_offhand_weapon_equipped)
	offhand_weapon_slot.equipment_unequipped.connect(on_offhand_weapon_unequipped)
	

func on_weapon_equipped(equipment : Equipment):
	equip_inventory[0] = equipment
	weapon_slot_updated.emit()
	pass

func on_weapon_unequipped(equipment : Equipment):
	equip_inventory[0] = null
	weapon_slot_updated.emit()
	pass

func on_headgear_equipped(equipment : Equipment):
	equip_inventory[1] = equipment
	headgear_slot_updated.emit()
	pass

func on_headgear_unequipped(equipment : Equipment):
	equip_inventory[1] = null
	headgear_slot_updated.emit()
	pass

func on_torso_equipped(equipment : Equipment):
	equip_inventory[2] = equipment
	torso_slot_updated.emit()
	pass

func on_torso_unequipped(equipment : Equipment):
	equip_inventory[2] = null
	torso_slot_updated.emit()
	pass

func on_armgear_equipped(equipment : Equipment):
	equip_inventory[3] = equipment
	armgear_slot_updated.emit()
	pass

func on_armgear_unequipped(equipment : Equipment):
	equip_inventory[3] = null
	armgear_slot_updated.emit()
	pass

func on_shoes_equipped(equipment : Equipment):
	equip_inventory[4] = equipment
	shoes_slot_updated.emit()
	pass

func on_shoes_unequipped(equipment : Equipment):
	equip_inventory[4] = null
	shoes_slot_updated.emit()
	pass

func on_offhand_weapon_equipped(equipment : Equipment):
	equip_inventory[5] = equipment
	offhand_slot_updated.emit()
	pass

func on_offhand_weapon_unequipped(equipment : Equipment):
	equip_inventory[5] = null
	offhand_slot_updated.emit()
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
	inventory_full.emit()
	return false
	pass

func remove_equipment(equipment : Equipment):
	var equipment_index : int = _linear_search(equipment)
	if equipment_index >= 0:
		inventory[equipment_index] = null
		slot_updated.emit(equipment_index)
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

func _linear_search_equip(equipment : Equipment) -> int:
	var index : int = 0
	for _equipment in equip_inventory:
		if _equipment == equipment:
			return index
		index += 1
	return -1

func is_full() -> bool:
	for _slot in inventory:
		if _slot == null:
			return false
	return true

func try_to_combine_pair(equipment : Equipment):
	var pair : Array[Equipment] = get_equipment_pair(equipment)
	if pair.size() < 2 or pair.size() > 2:
		print("No pair found")
		return
	if pair[0].tier_manager != null:
		#new_equipment = pair[0].equipment.tier_manager.get_next_level_equipment()
		#slot.equipment = new_equipment
		pair[0].tier_manager.upgrade_to_next_tier()
		#pair[0].update_equipment_data()
		var equipped_equipment_index : int = _linear_search_equip(pair[1])
		if equipped_equipment_index >= 0:
			remove_equipment(pair[1])
			pair[1].queue_free()
			pair[1] = null
			equip_slot_updated.emit(equipped_equipment_index)
			print("Equipment leveled up")
			return
		remove_equipment(pair[1])
		pair[1].queue_free()
		pair[1] = null
		slot_updated.emit(_linear_search(pair[0]))
		print("Equipment leveled up")
	else:
		print("Equipment does not have level manager")
	#for _slot in pair:
		#equipment_inventory.remove_equipment(_slot.equipment)
		#_slot.equipment.queue_free()
		#_slot.equipment = null
		#pass
	#if new_equipment != null:
		#equipment_inventory.add_equipment(new_equipment)
	pass

func get_equipment_pair(equipment : Equipment) -> Array[Equipment]:
	var pair : Array[Equipment]
	pair.append(equipment)
	var all_slots : Array[Equipment] = inventory.duplicate()
	for equip in equip_inventory:
		all_slots.append(equip)
	
	for i in all_slots.size():
		if all_slots[i] == null or equipment == null:
			continue
		if all_slots[i].string_id == equipment.string_id and all_slots[i].tier == equipment.tier and all_slots[i] != equipment:
			#Duplicate found, append to array
			pair.append(all_slots[i])
			break
		pass
	return pair
