class_name CharacterSelectIconUI
extends Control

@export var character_data : CharacterSelectData

@onready var slot_border: TextureRect = $VBoxContainer/SlotBorder

var is_selected : bool = false

signal selected (character_icon : CharacterSelectIconUI)

func _ready() -> void:
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	gui_input.connect(on_gui_input)

func on_gui_input(event : InputEvent):
	if event is InputEventMouseButton and event.pressed and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		slot_border.modulate = Color.AQUA
		selected.emit(self)
		pass
	if event is InputEventMouseButton and event.pressed and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		if (event as InputEventMouseButton).double_click:
			slot_border.modulate = Color.GOLD
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
