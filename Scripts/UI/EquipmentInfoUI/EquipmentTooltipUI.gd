class_name EquipmentTooltipUI
extends Control


@onready var equipment_inventory_slot_icon: EquipmentInventorySlotIcon = %EquipmentInventorySlotIcon
@onready var equipment_name_label: Label = %EquipmentNameLabel
@onready var v_box_container: VBoxContainer = $Panel/VBoxContainer
@onready var stat_v_box_container: VBoxContainer = %StatVBoxContainer


func initialize_equipment_tooltip(equipment : Equipment):
	await self.ready
	equipment_inventory_slot_icon.set_equipment(equipment)
	equipment_name_label.text = equipment.equipment_name
	
	for stat in equipment.tooltip_stats:
		var stat_label : Label = Label.new()
		stat_label.text = stat.name + ": " + str(stat.stat_derived_value)
		stat_v_box_container.add_child(stat_label)
	pass
