class_name BuyInstanceUI
extends Control

@onready var slot_border: TextureRect = %SlotBorder


var is_locked : bool = false
var is_selected : bool = false

signal selected (equipment_slot : EquipmentInventorySlot)
signal attempt_to_buy(buy_instance : BuyInstanceUI)
signal bought()

func _ready() -> void:
	gui_input.connect(on_gui_input)

func on_gui_input(event : InputEvent):
	if event is InputEventMouseButton and event.pressed and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		slot_border.modulate = Color.AQUA
		selected.emit(self)
		pass
	if event is InputEventMouseButton and event.pressed and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		if (event as InputEventMouseButton).double_click:
			slot_border.modulate = Color.GOLD
			attempt_to_buy.emit(self)
		pass
	pass

func buy(buyer : Entity):
	pass
