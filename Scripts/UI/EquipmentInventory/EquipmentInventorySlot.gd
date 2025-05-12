class_name EquipmentInventorySlot
extends Control

enum SlotType {INVENTORY, EQUIP}

var equipment : Equipment : set = set_equipment
@export var slot_type : SlotType
@onready var equipment_icon: TextureRect = $SlotBorder/MarginContainer/EquipmentIcon
@onready var slot_border: TextureRect = $SlotBorder
var is_selected : bool = false

signal selected (equipment_slot : EquipmentInventorySlot)

func _ready() -> void:
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	gui_input.connect(on_gui_input)

func on_gui_input(event : InputEvent):
	if event is InputEventMouseButton and event.pressed and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		slot_border.modulate = Color.AQUA
		selected.emit(self)
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
	tooltip_text = ""
	equipment = new_equipment
	if equipment != null:
		equipment_icon.texture = new_equipment.equipment_icon
		tooltip_text = equipment.equipment_name
	pass

func set_slot_type(new_slot_type : SlotType):
	slot_type = new_slot_type
	pass
