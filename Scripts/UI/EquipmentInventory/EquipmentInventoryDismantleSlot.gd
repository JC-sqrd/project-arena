class_name EquipmentInventoryDismantleSlot
extends EquipmentInventorySlot


func _ready() -> void:
	super()
	slot_type = SlotType.DISMANTLE

func dismantle_slotted_equipment():
	if equipment == null: 
		return
	equipment.queue_free()
	equipment = null
	equipment_inventory_slot_icon.clear_equipment()
	update_equipment_data()
	pass
