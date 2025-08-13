class_name EquipmentInventorySlotIcon
extends TextureRect

const TIER_STAR = preload("res://Sprites/UI/Tier Star/Tier Star.png")
#@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var equipment_tier_ui: EquipmentTierUI = %EquipmentTierUI


const EQUIPMENT_TOOLTIP = preload("res://Scenes/UI/EquipmentInventory/equipment_tooltip.tscn")
var equipment : Equipment


func _ready() -> void:
	if equipment != null:
		set_equipment(equipment)
	mouse_entered.connect(
		func():
			print("EQUIPMENT ICON MOUSE HOVERED")
	)
	pass

func set_equipment(equipment : Equipment):
	self.equipment = equipment
	equipment.visible = false
	texture = equipment.equipment_icon
	equipment_tier_ui.set_tier(equipment.tier)
	pass
 
func set_equipment_icon(icon : Texture):
	texture = icon
	pass

func set_equipment_tier(tier : Equipment.EquipmentTier):
	equipment_tier_ui.set_tier(tier)
	pass

func clear_equipment():
	equipment = null
	texture = null
	equipment_tier_ui.clear_children()
	pass

func _make_custom_tooltip(for_text: String) -> Object:
	if equipment == null:
		return null
	
	var equipment_tooltip = EQUIPMENT_TOOLTIP.instantiate()
	
	equipment_tooltip.initialize_equipment_tooltip(equipment)
	return equipment_tooltip
