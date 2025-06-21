class_name GearManager
extends Node

@export var headgear_slot : EquipmentSlot
@export var torso_slot : EquipmentSlot
@export var armgear_slot : EquipmentSlot
@export var shoes_slot : EquipmentSlot

func _ready():
	headgear_slot.equipment_slotted.connect(_on_headgear_slotted)
	torso_slot.equipment_slotted.connect(_on_torso_slotted)
	armgear_slot.equipment_slotted.connect(_on_armgear_slotted)
	shoes_slot.equipment_slotted.connect(_on_shoes_slotted)
	
	headgear_slot.equipment_unslotted.connect(_on_headgear_unslotted)
	torso_slot.equipment_unslotted.connect(_on_torso_unslotted)
	armgear_slot.equipment_unslotted.connect(_on_armgear_unslotted)
	shoes_slot.equipment_unslotted.connect(_on_shoes_unslotted)
	
	if headgear_slot.equipment != null:
		headgear_slot.equip(headgear_slot.equipment)
	if torso_slot.equipment != null:
		torso_slot.equip(torso_slot.equipment)
	if armgear_slot.equipment != null:
		armgear_slot.equip(armgear_slot.equipment)
	if shoes_slot.equipment != null:
		shoes_slot.equip(shoes_slot.equipment)
	pass


func _on_headgear_slotted (equipment : Equipment):
	headgear_slot.equip(headgear_slot.equipment)
	pass

func _on_torso_slotted (equipment : Equipment):
	torso_slot.equip(torso_slot.equipment)
	pass

func _on_armgear_slotted (equipment : Equipment):
	armgear_slot.equip(armgear_slot.equipment)
	pass

func _on_shoes_slotted (equipment : Equipment):
	shoes_slot.equip(shoes_slot.equipment)
	pass

func _on_headgear_unslotted (equipment : Equipment):
	headgear_slot.unequip(headgear_slot.equipment)
	pass

func _on_torso_unslotted (equipment : Equipment):
	torso_slot.unequip(torso_slot.equipment)
	pass

func _on_armgear_unslotted (equipment : Equipment):
	armgear_slot.unequip(armgear_slot.equipment)
	pass

func _on_shoes_unslotted (equipment : Equipment):
	shoes_slot.unequip(shoes_slot.equipment)
	pass
