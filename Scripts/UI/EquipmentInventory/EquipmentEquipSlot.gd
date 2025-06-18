class_name EquipmentEquipSlot
extends EquipmentInventorySlot


@export var equip_type : Equipment.EquipmentType = Equipment.EquipmentType.WEAPON
var equipment_slot : EquipmentSlot

func set_equipment(new_equipment : Equipment):
	equipment_icon.texture = null
	equipment_inventory_slot_icon.clear_equipment()
	tooltip_text = ""
	equipment = new_equipment
	if equipment != null:
		equipment_inventory_slot_icon.set_equipment(new_equipment)
		equipment_icon.texture = new_equipment.equipment_icon
		tooltip_text = equipment.equipment_name
		equipment_slot.equipment = new_equipment
	else:
		equipment_icon.texture = null
		equipment_inventory_slot_icon.clear_equipment()
		tooltip_text = ""
		equipment_slot.equipment = null
	pass
