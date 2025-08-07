class_name EquipmentEquipSlot
extends EquipmentInventorySlot


@export var equip_type : Equipment.EquipmentType = Equipment.EquipmentType.WEAPON
@export var background_icon_texture : Texture
@onready var background_icon: TextureRect = %BackgroundIcon

var equipment_slot : EquipmentSlot

func _ready() -> void:
	super()
	if background_icon_texture != null:
		background_icon.texture = background_icon_texture
		pass

func set_equipment(new_equipment : Equipment):
	background_icon.visible = true
	equipment_icon.texture = null
	equipment_inventory_slot_icon.clear_equipment()
	tooltip_text = ""
	equipment = new_equipment
	if equipment != null:
		background_icon.visible = false
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
