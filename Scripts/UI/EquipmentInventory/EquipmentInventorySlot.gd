class_name EquipmentInventorySlot
extends Control

enum SlotType {INVENTORY, EQUIP, DISMANTLE}

var equipment : Equipment : set = set_equipment
@export var slot_type : SlotType
@onready var equipment_icon: TextureRect = %EquipmentIcon
@onready var equipment_inventory_slot_icon: EquipmentInventorySlotIcon = $SlotBorder/MarginContainer/EquipmentInventorySlotIcon
@onready var slot_border: TextureRect = $SlotBorder

const EQUIPMENT_CONTEXT_MENU = preload("res://Scenes/UI/EquipmentInventory/equipment_context_menu.tscn")
const EQUIPMENT_TOOLTIP = preload("res://Scenes/UI/ItemInventoryUI/equipment_tooltip.tscn")

var context_menu : EquipmentContextMenu
var is_selected : bool = false
var slot_index : int = -1


signal selected (equipment_slot : EquipmentInventorySlot)
signal right_clicked (equipment_slot : EquipmentInventorySlot)

func _ready() -> void:
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	gui_input.connect(on_gui_input)

func on_gui_input(event : InputEvent):
	if event is InputEventMouseButton and event.pressed and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		slot_border.modulate = Color.AQUA
		selected.emit(self)
		pass
	if event is InputEventMouseButton and event.pressed and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_RIGHT:
		slot_border.modulate = Color.DARK_ORCHID
		right_clicked.emit(self)
		pass
	pass

func on_mouse_entered():
	if !is_selected:
		slot_border.modulate = Color.GREEN
	pass

func on_mouse_exited():
	if !is_selected:
		slot_border.modulate = Color.WHITE
	pass

func set_equipment(new_equipment : Equipment):
	equipment_icon.texture = null
	equipment_inventory_slot_icon.clear_equipment()
	tooltip_text = ""
	equipment = new_equipment
	if equipment != null:
		equipment_inventory_slot_icon.set_equipment(new_equipment)
		equipment_icon.texture = new_equipment.equipment_icon
		tooltip_text = equipment.equipment_name
	pass

func update_equipment_data():
	equipment_inventory_slot_icon.clear_equipment()
	tooltip_text = ""
	if equipment != null:
		equipment_inventory_slot_icon.set_equipment(equipment)
		equipment_icon.texture = equipment.equipment_icon
		tooltip_text = equipment.equipment_name
	pass

func set_slot_type(new_slot_type : SlotType):
	slot_type = new_slot_type
	pass

func _make_custom_tooltip(for_text: String) -> Object:
	if equipment == null:
		return null
	
	var equipment_tooltip = EQUIPMENT_TOOLTIP.instantiate()
	
	equipment_tooltip.initialize_equipment_tooltip(equipment)
	return equipment_tooltip
