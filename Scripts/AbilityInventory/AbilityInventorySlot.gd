class_name AbilityInventorySlot
extends Control




@export var ability_in_slot : Ability 
@onready var slot_border: TextureRect = $SlotBorder
@onready var ability_icon: TextureRect = $SlotBorder/BoxContainer/AbilityIcon

var selected : bool = false
var slotted  : bool = false
var dragging : bool = false
var move : bool = false

signal slot_selected (ability_inventory_slot : AbilityInventorySlot)
signal slot_clicked (ability_inventory_slot : AbilityInventorySlot)

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)
	
	if ability_in_slot != null:
		ability_icon.texture = ability_in_slot.ability_icon_texture
		slotted = true
	pass


func _on_mouse_entered():
	if !dragging:
		slot_border.modulate = Color.GREEN
		selected = true
	pass

func _on_mouse_exited():
	slot_border.modulate = Color.WHITE
	selected = false
	pass

func _on_gui_input(event : InputEvent):
	if event is InputEventMouseButton and event.is_pressed():
		slot_clicked.emit(self)
	pass

func slot_abilitiy(ability: Ability):
	slotted = true
	ability_in_slot = ability
	ability_icon.position = Vector2.ZERO
	ability_icon.texture = ability.ability_icon_texture

func unslot_ability() -> Ability:
	slotted = false
	var temp : Ability = ability_in_slot
	ability_in_slot = null
	ability_icon.texture = null
	return temp


func _process(delta: float) -> void:
	pass
