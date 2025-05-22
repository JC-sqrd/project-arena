class_name EquipmentInventoryManager
extends Control
 

@export var equipment_inventory : EquipmentInventory
@export var weapon_slot : WeaponSlot
@export var offhand_slot : OffhandWeaponSlot
@export var headgear_slot : EquipmentSlot
@export var torso_slot : EquipmentSlot
@export var armgear_slot : EquipmentSlot
@export var shoes_slot : EquipmentSlot

const EQUIPMENT_INVENTORY_SLOT = preload("res://Scenes/UI/EquipmentInventory/equipment_inventory_slot.tscn")
#@export var weapon_EIS : EquipmentInventorySlot
#@export var headgear_EIS : EquipmentInventorySlot
#@export var torso_EIS : EquipmentInventorySlot
#@export var armgear_EIS : EquipmentInventorySlot
#@export var shoes_EIS : EquipmentInventorySlot
@onready var weapon_equip_slot: EquipmentEquipSlot = $EquippedSlots/MarginContainer/VBoxContainer/WeaponEquipSlot
@onready var headgear_equip_slot: EquipmentEquipSlot = $EquippedSlots/MarginContainer/VBoxContainer/HeadgearEquipSlot
@onready var torso_equip_slot: EquipmentEquipSlot = $EquippedSlots/MarginContainer/VBoxContainer/TorsoEquipSlot
@onready var armgear_equip_slot: EquipmentEquipSlot = $EquippedSlots/MarginContainer/VBoxContainer/ArmgearEquipSlot
@onready var shoes_equip_slot: EquipmentEquipSlot = $EquippedSlots/MarginContainer/VBoxContainer/ShoesEquipSlot
@onready var offhand_equip_slot: EquipmentEquipSlot = $EquippedSlots/MarginContainer/VBoxContainer/OffhandEquipSlot

@onready var inventory_grid: GridContainer = $EquipmentInventory/MarginContainer/InventoryGrid

var inventory_slots : Array[EquipmentInventorySlot]

var selected_slot : EquipmentInventorySlot

func _ready():
	visible = false
	if weapon_slot != null:
		weapon_equip_slot.equipment_slot = weapon_slot
		if weapon_slot.equipment != null:
			weapon_equip_slot.equipment = weapon_slot.equipment
			weapon_equip_slot.equipment_icon.texture = weapon_slot.equipment.equipment_icon
	if offhand_slot != null:
		offhand_equip_slot.equipment_slot = offhand_slot
		if offhand_slot.equipment != null:
			offhand_equip_slot.equipment = offhand_slot.equipment
			offhand_equip_slot.equipment_icon.texture = offhand_slot.equipment.equipment_icon
	if armgear_slot != null:
		armgear_equip_slot.equipment_slot = armgear_slot
		if armgear_slot.equipment != null:
			armgear_equip_slot.equipment = armgear_slot.equipment
			armgear_equip_slot.equipment_icon.texture = armgear_slot.equipment.equipment_icon
	if headgear_slot != null:
		headgear_equip_slot.equipment_slot = headgear_slot
		if headgear_slot.equipment != null:
			headgear_equip_slot.equipment = headgear_slot.equipment
			headgear_equip_slot.equipment_icon.texture = headgear_slot.equipment.equipment_icon
	if torso_slot != null:
		torso_equip_slot.equipment_slot = torso_slot
		if torso_slot.equipment != null:
			torso_equip_slot.equipment = torso_slot.equipment
			torso_equip_slot.equipment_icon.texture = torso_slot.equipment.equipment_icon
	if shoes_slot != null:
		shoes_equip_slot.equipment_slot = shoes_slot
		if shoes_slot.equipment != null:
			shoes_equip_slot.equipment = shoes_slot.equipment
			shoes_equip_slot.equipment_icon.texture = shoes_slot.equipment.equipment_icon
	
	weapon_equip_slot.selected.connect(on_inventory_slot_selected)
	headgear_equip_slot.selected.connect(on_inventory_slot_selected)
	torso_equip_slot.selected.connect(on_inventory_slot_selected)
	armgear_equip_slot.selected.connect(on_inventory_slot_selected)
	shoes_equip_slot.selected.connect(on_inventory_slot_selected)
	offhand_equip_slot.selected.connect(on_inventory_slot_selected)
	
	equipment_inventory.equipment_added.connect(on_equipment_added_to_inventory)
	
	for i in equipment_inventory.max_size:
		var inventory_slot : EquipmentInventorySlot = EQUIPMENT_INVENTORY_SLOT.instantiate()
		inventory_slot.slot_type = EquipmentInventorySlot.SlotType.INVENTORY
		inventory_slot.slot_index = i
		inventory_grid.add_child(inventory_slot)
		inventory_slot.selected.connect(on_inventory_slot_selected)
		if equipment_inventory.inventory[i] != null:
			inventory_slot.equipment = equipment_inventory.inventory[i]
			#print("INVENTORY INDEX: " + str(i))
			pass
		pass
	
	for child in inventory_grid.get_children():
		if child is EquipmentInventorySlot:
			inventory_slots.append(child)
	
	for equipment in equipment_inventory.inventory:
		
		pass
	pass


func on_equip_slot_selected(equip_slot : EquipmentInventorySlot):
	clear_selected_slot()
	selected_slot = equip_slot
	if selected_slot != null:
		selected_slot.slot_border.modulate = Color.AQUA
		selected_slot.is_selected = true
	pass

func on_inventory_slot_selected(inventory_slot : EquipmentInventorySlot):
	#Check if previous selected slot is not null
	if selected_slot != null:
		selected_slot.is_selected = false
		selected_slot.slot_border.modulate = Color.WHITE
		#If previous selected slot contain an equipment and the new selected slot is empty, 
		#transfer the previous slot's equipment to the new inventory slot, then deselect the current slot
		
		#INVENTORY SLOT -> INVENTORY SLOT
		if selected_slot.slot_type == EquipmentInventorySlot.SlotType.INVENTORY and inventory_slot.slot_type == EquipmentInventorySlot.SlotType.INVENTORY:
			#SLOTTED -> NON-SLOTTED
			if selected_slot.equipment != null and inventory_slot.equipment == null:
				inventory_slot.equipment = selected_slot.equipment
				equipment_inventory.inventory[inventory_slot.slot_index] = selected_slot.equipment
				equipment_inventory.inventory[selected_slot.slot_index] = null
				selected_slot.equipment = null
				selected_slot.is_selected = false
				selected_slot.slot_border.modulate = Color.WHITE
				selected_slot = null
				return
				pass
			#SLOTTED -> SLOTTED
			elif selected_slot.equipment != null and inventory_slot.equipment != null:
				var temp_equipment : Equipment = inventory_slot.equipment
				inventory_slot.equipment = selected_slot.equipment
				equipment_inventory.inventory[inventory_slot.slot_index] = selected_slot.equipment
				equipment_inventory.inventory[selected_slot.slot_index] = temp_equipment
				selected_slot.equipment = temp_equipment
				selected_slot.is_selected = false
				selected_slot.slot_border.modulate = Color.WHITE
				selected_slot = null
				return
			else:
				selected_slot.is_selected = false
				selected_slot.slot_border.modulate = Color.WHITE
				selected_slot = null
				return
			pass
		#INVENTORY SLOT -> EQUIP SLOT
		elif selected_slot.slot_type == EquipmentInventorySlot.SlotType.INVENTORY and inventory_slot.slot_type == EquipmentInventorySlot.SlotType.EQUIP:
			inventory_slot = inventory_slot as EquipmentEquipSlot
			if selected_slot.equipment != null and inventory_slot.equipment == null and selected_slot.equipment.type == inventory_slot.equip_type:
				inventory_slot.equipment = selected_slot.equipment
				equipment_inventory.inventory[selected_slot.slot_index] = null
				selected_slot.equipment = null
				selected_slot.is_selected = false
				selected_slot.slot_border.modulate = Color.WHITE
				selected_slot = null
				return
				pass
			elif selected_slot.equipment != null and inventory_slot.equipment != null and selected_slot.equipment.type == inventory_slot.equip_type:
				var temp_equipment : Equipment = inventory_slot.equipment
				inventory_slot.equipment = selected_slot.equipment
				equipment_inventory.inventory[selected_slot.slot_index] = temp_equipment
				selected_slot.equipment = temp_equipment
				selected_slot.is_selected = false
				selected_slot.slot_border.modulate = Color.WHITE
				selected_slot = null
				return
			else:
				selected_slot.is_selected = false
				selected_slot.slot_border.modulate = Color.WHITE
				selected_slot = null
				return
			pass
			#EQUIP SLOT -> INVENTORY SLOT
		elif selected_slot.slot_type == EquipmentInventorySlot.SlotType.EQUIP and inventory_slot.slot_type == EquipmentInventorySlot.SlotType.INVENTORY:
			selected_slot = selected_slot as EquipmentEquipSlot
			if selected_slot.equipment != null and inventory_slot.equipment == null:
				inventory_slot.equipment = selected_slot.equipment
				equipment_inventory.inventory[inventory_slot.slot_index] = selected_slot.equipment
				selected_slot.equipment = null
				selected_slot.is_selected = false
				selected_slot.slot_border.modulate = Color.WHITE
				selected_slot = null
				return
				pass
			elif selected_slot.equipment != null and inventory_slot.equipment != null and inventory_slot.equipment.type == selected_slot.equip_type:
				var temp_equipment : Equipment = inventory_slot.equipment
				inventory_slot.equipment = selected_slot.equipment
				equipment_inventory.inventory[inventory_slot.slot_index] = selected_slot.equipment
				selected_slot.equipment = temp_equipment
				selected_slot.is_selected = false
				selected_slot.slot_border.modulate = Color.WHITE
				selected_slot = null
				return
			else:
				selected_slot.is_selected = false
				selected_slot.slot_border.modulate = Color.WHITE
				selected_slot = null
				return
			pass
		
		#-------------------------------------------------------------------------------------------------------------------
		#if selected_slot.equipment != null and inventory_slot.equipment == null and inventory_slot.slot_type == EquipmentInventorySlot.SlotType.INVENTORY:
			#inventory_slot.equipment = selected_slot.equipment
			#selected_slot.equipment = null
			#selected_slot.is_selected = false
			#selected_slot.slot_border.modulate = Color.WHITE
			#selected_slot = null
			#return
		##If previous slot and new selected slot both contains an equipment, swap, then deselect
		#elif selected_slot.equipment != null and inventory_slot.equipment != null and inventory_slot.slot_type == EquipmentInventorySlot.SlotType.INVENTORY:
			#var temp_equipment : Equipment = inventory_slot.equipment
			#inventory_slot.equipment = selected_slot.equipment
			#selected_slot.equipment = temp_equipment
			#selected_slot.is_selected = false
			#selected_slot.slot_border.modulate = Color.WHITE
			#selected_slot = null
			#return
		##Equip equipment to empty equip slot
		#elif selected_slot.equipment != null and inventory_slot.equipment == null and inventory_slot is EquipmentEquipSlot:
			#inventory_slot = inventory_slot as EquipmentEquipSlot
			#if selected_slot.equipment.type == inventory_slot.equip_type:
				#inventory_slot.equipment = selected_slot.equipment
				#selected_slot.equipment = null
				#selected_slot.is_selected = false
				#selected_slot.slot_border.modulate = Color.WHITE
				#selected_slot = null
				#return
			#else:
				#selected_slot.is_selected = false
				#selected_slot.slot_border.modulate = Color.WHITE
				#selected_slot = null
				#return
		##Equip equipment and swap currently equipped equipment to new slot 
		#elif selected_slot.equipment != null and inventory_slot.equipment != null and inventory_slot is EquipmentEquipSlot:
			#inventory_slot = inventory_slot as EquipmentEquipSlot
			#if selected_slot.equipment.type == inventory_slot.equip_type:
				#var temp_equipment : Equipment = inventory_slot.equipment
				#inventory_slot.equipment = selected_slot.equipment
				#selected_slot.equipment = temp_equipment
				#selected_slot.is_selected = false
				#selected_slot.slot_border.modulate = Color.WHITE
				#selected_slot = null
				#return
			#else:
				#selected_slot.is_selected = false
				#selected_slot.slot_border.modulate = Color.WHITE
				#selected_slot = null
				#return
		#else:
			#selected_slot.is_selected = false
			#selected_slot.slot_border.modulate = Color.WHITE
			#selected_slot = null
			#return
			#pass
	selected_slot = inventory_slot
	#Check if the new selected slot is not null
	if selected_slot != null:
		selected_slot.slot_border.modulate = Color.AQUA
		selected_slot.is_selected = true
	pass

func on_equipment_added_to_inventory(equipment : Equipment, slot_index : int):
	for slot in inventory_slots:
		if slot.slot_index == slot_index:
			slot.equipment = equipment
			return
	pass

func clear_selected_slot():
	if selected_slot != null:
		selected_slot.is_selected = false
		selected_slot.slot_border.modulate = Color.WHITE
	selected_slot = null
	pass

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("open_inventory"):
		visible = !visible
		clear_selected_slot()
		pass
	if event is InputEventMouseButton and event.pressed and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_RIGHT:
		clear_selected_slot()
		pass
