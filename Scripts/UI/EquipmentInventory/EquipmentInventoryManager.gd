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
@onready var weapon_equip_slot: EquipmentEquipSlot = %WeaponEquipSlot
@onready var headgear_equip_slot: EquipmentEquipSlot = %HeadgearEquipSlot
@onready var torso_equip_slot: EquipmentEquipSlot = %TorsoEquipSlot
@onready var armgear_equip_slot: EquipmentEquipSlot = %ArmgearEquipSlot
@onready var shoes_equip_slot: EquipmentEquipSlot = %ShoesEquipSlot
@onready var offhand_equip_slot: EquipmentEquipSlot = %OffhandEquipSlot
@onready var _floating_icon: TextureRect = $_FloatingIcon

@onready var inventory_grid: GridContainer = %InventoryGrid
@onready var equipment_inventory_dismantle_slot: EquipmentInventoryDismantleSlot = %EquipmentInventoryDismantleSlot


var inventory_slots : Array[EquipmentInventorySlot]
var equip_slots : Array[EquipmentEquipSlot] = [null, null, null, null, null, null]
var selected_slot : EquipmentInventorySlot



func _ready():
	visible = false
	if weapon_slot != null:
		weapon_equip_slot.equipment_slot = weapon_slot
		equip_slots[0] = weapon_equip_slot
		if weapon_slot.equipment != null:
			weapon_equip_slot.equipment = weapon_slot.equipment
			weapon_equip_slot.equipment_icon.texture = weapon_slot.equipment.equipment_icon
			
	if headgear_slot != null:
		headgear_equip_slot.equipment_slot = headgear_slot
		equip_slots[1] = headgear_equip_slot
		if headgear_slot.equipment != null:
			headgear_equip_slot.equipment = headgear_slot.equipment
			headgear_equip_slot.equipment_icon.texture = headgear_slot.equipment.equipment_icon
			
	if armgear_slot != null:
		armgear_equip_slot.equipment_slot = armgear_slot
		equip_slots[2] = armgear_equip_slot
		if armgear_slot.equipment != null:
			armgear_equip_slot.equipment = armgear_slot.equipment
			armgear_equip_slot.equipment_icon.texture = armgear_slot.equipment.equipment_icon
			
	if torso_slot != null:
		torso_equip_slot.equipment_slot = torso_slot
		equip_slots[3] = torso_equip_slot
		if torso_slot.equipment != null:
			torso_equip_slot.equipment = torso_slot.equipment
			torso_equip_slot.equipment_icon.texture = torso_slot.equipment.equipment_icon
			
	if shoes_slot != null:
		shoes_equip_slot.equipment_slot = shoes_slot
		equip_slots[4] = shoes_equip_slot
		if shoes_slot.equipment != null:
			shoes_equip_slot.equipment = shoes_slot.equipment
			shoes_equip_slot.equipment_icon.texture = shoes_slot.equipment.equipment_icon
			
	if offhand_slot != null:
		offhand_equip_slot.equipment_slot = offhand_slot
		equip_slots[5] = offhand_equip_slot
		if offhand_slot.equipment != null:
			offhand_equip_slot.equipment = offhand_slot.equipment
			offhand_equip_slot.equipment_icon.texture = offhand_slot.equipment.equipment_icon
			
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
		inventory_slot.right_clicked.connect(on_slot_right_clicked)
		if equipment_inventory.inventory[i] != null:
			inventory_slot.equipment = equipment_inventory.inventory[i]
			#print("INVENTORY INDEX: " + str(i))
			pass
		pass
	
	equipment_inventory_dismantle_slot.selected.connect(on_inventory_slot_selected)
	
	for child in inventory_grid.get_children():
		if child is EquipmentInventorySlot:
			inventory_slots.append(child)
	pass


#func _input(event: InputEvent) -> void:
	#if selected_slot != null and event is InputEventMouseMotion:
		#_floating_icon.visible = true
		#_floating_icon.texture = selected_slot.equipment_icon.texture
		#_floating_icon.global_position = get_global_mouse_position()
	#else:
		#_floating_icon.visible = false
		#pass

func _process(delta: float) -> void:
	if selected_slot != null:
		_floating_icon.visible = true
		_floating_icon.texture = selected_slot.equipment_icon.texture
		_floating_icon.global_position = get_global_mouse_position()
	else:
		_floating_icon.visible = false

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
		#INVENTORY SLOT -> DISMANTLE SLOT
		elif selected_slot.slot_type == EquipmentInventorySlot.SlotType.INVENTORY and inventory_slot.slot_type == EquipmentInventorySlot.SlotType.DISMANTLE:
			inventory_slot = inventory_slot as EquipmentInventoryDismantleSlot
			if selected_slot.equipment != null and inventory_slot.equipment == null:
				inventory_slot.equipment = selected_slot.equipment
				#equipment_inventory.inventory[inventory_slot.slot_index] = selected_slot.equipment
				selected_slot.equipment = null
				selected_slot.is_selected = false
				selected_slot.slot_border.modulate = Color.WHITE
				selected_slot = null
				return
			elif selected_slot.equipment != null and inventory_slot.equipment != null:
				inventory_slot.dismantle_slotted_equipment()
				inventory_slot.equipment = selected_slot.equipment
				#equipment_inventory.inventory[inventory_slot.slot_index] = selected_slot.equipment
				selected_slot.equipment = null
				selected_slot.is_selected = false
				selected_slot.slot_border.modulate = Color.WHITE
				selected_slot = null
				return
				pass
			pass 
		#DISMANTLE SLOT -> INVENTORY SLOT
		elif selected_slot.slot_type == EquipmentInventorySlot.SlotType.DISMANTLE and inventory_slot.slot_type == EquipmentInventorySlot.SlotType.INVENTORY:
			selected_slot = selected_slot as EquipmentInventoryDismantleSlot
			if selected_slot.equipment != null and inventory_slot.equipment == null:
				inventory_slot.equipment = selected_slot.equipment
				equipment_inventory.inventory[inventory_slot.slot_index] = selected_slot.equipment
				selected_slot.equipment = null
				selected_slot.is_selected = false
				selected_slot.slot_border.modulate = Color.WHITE
				selected_slot = null
				return
	elif inventory_slot.equipment == null:
		return
	selected_slot = inventory_slot
	#Check if the new selected slot is not null
	if selected_slot != null:
		selected_slot.slot_border.modulate = Color.AQUA
		selected_slot.is_selected = true
	else:
		selected_slot = null
		return
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

func on_slot_right_clicked(slot : EquipmentInventorySlot):
	try_to_combine_pair(slot)
	#print("EQUIPMENT PAIR: " + str(equipment_inventory.get_equipment_pair(slot.equipment)))
	#equipment_inventory.try_to_combine_pair(slot.equipment)
	pass


func try_to_combine_pair(slot : EquipmentInventorySlot):
	var pair : Array[EquipmentInventorySlot] = get_equipment_pair(slot)
	if pair.size() < 2 or pair.size() > 2:
		print("No pair found")
		return
	var new_equipment : Equipment
	if pair[0].equipment.tier_manager != null:
		#new_equipment = pair[0].equipment.tier_manager.get_next_level_equipment()
		#slot.equipment = new_equipment
		pair[0].equipment.tier_manager.upgrade_to_next_tier()
		pair[0].update_equipment_data()
		equipment_inventory.remove_equipment(pair[1].equipment)
		pair[1].equipment.queue_free()
		pair[1].equipment = null
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

func check_duplicate(slot : EquipmentInventorySlot):
	var duplicates : Array[EquipmentInventorySlot]
	for duplicate in duplicates:
		if duplicate.equipment != null:
			duplicate.equipment.queue_free()
			duplicate.equipment = null
	pass

func get_equipment_pair(slot : EquipmentInventorySlot) -> Array[EquipmentInventorySlot]:
	var pair : Array[EquipmentInventorySlot]
	pair.append(slot)
	var all_slots : Array[EquipmentInventorySlot] = inventory_slots.duplicate()
	for equip_slot in equip_slots:
		all_slots.append(equip_slot)
	
	for i in all_slots.size():
		if all_slots[i].equipment == null or slot.equipment == null:
			continue
		if all_slots[i].equipment.string_id == slot.equipment.string_id and all_slots[i].equipment.tier == slot.equipment.tier and all_slots[i] != slot:
			#Duplicate found, append to array
			pair.append(all_slots[i])
			break
		pass
	return pair

func clear_dismantle_slot():
	equipment_inventory_dismantle_slot.dismantle_slotted_equipment()
	pass

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("open_inventory"):
		visible = !visible
		if !visible:
			clear_dismantle_slot()
		clear_selected_slot()
		pass
	if event is InputEventMouseButton and event.pressed and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_RIGHT:
		clear_selected_slot()
		pass
