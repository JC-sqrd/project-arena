extends Control

@onready var ability_inventory_grid: GridContainer = $AbilityInventoryGrid


var dragging : bool = false
var dragged_ability_slot : AbilityInventorySlot 

@onready var drag_icon : TextureRect = TextureRect.new()

func _ready():
	drag_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	drag_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	drag_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(drag_icon, true)
	visible = false
	for child in ability_inventory_grid.get_children():
		if child is AbilityInventorySlot:
			child.slot_clicked.connect(on_slot_clicked)
	pass


func on_slot_clicked(ability_inventory_slot : AbilityInventorySlot):
	if ability_inventory_slot.ability_in_slot != null:
		print("Inventory ability slot clicked: " + str(ability_inventory_slot.ability_in_slot.name))
	if !dragging and ability_inventory_slot.ability_in_slot != null:
		ability_inventory_slot.dragging = true
		dragging = true
		dragged_ability_slot = ability_inventory_slot
		dragged_ability_slot.ability_icon.visible = false
		drag_icon.texture = dragged_ability_slot.ability_icon.texture
		drag_icon.global_position = get_global_mouse_position()
		drag_icon.size = dragged_ability_slot.ability_icon.size
		drag_icon.visible = true
		return
	
	if dragging:
		if !ability_inventory_slot.slotted:
			#Slot
			print("Slot Ability")
			dragging = false
			dragged_ability_slot.dragging = false
			ability_inventory_slot.slot_abilitiy(dragged_ability_slot.unslot_ability()) 
			dragged_ability_slot = null
			ability_inventory_slot.ability_icon.visible = true
			drag_icon.global_position = Vector2.ZERO
			drag_icon.visible = false
			pass
		elif ability_inventory_slot == dragged_ability_slot:
			#Swap
			print("Swap Ability")
			dragging = false
			dragged_ability_slot.dragging = false
			var temp : Ability = ability_inventory_slot.unslot_ability()
			print("Temp Ability : " + str(temp))
			ability_inventory_slot.slot_abilitiy(temp)
			dragged_ability_slot = null
			ability_inventory_slot.ability_icon.visible = true
			drag_icon.global_position = Vector2.ZERO
			drag_icon.visible = false
			pass
		else:
			#Swap
			print("Swap Ability")
			dragging = false
			dragged_ability_slot.dragging = false
			var temp : Ability = ability_inventory_slot.unslot_ability()
			print("Temp Ability : " + str(temp))
			dragged_ability_slot.ability_icon.visible = true
			ability_inventory_slot.slot_abilitiy(dragged_ability_slot.unslot_ability())
			dragged_ability_slot.slot_abilitiy(temp)
			dragged_ability_slot = null
			ability_inventory_slot.ability_icon.visible = true
			drag_icon.global_position = Vector2.ZERO
			drag_icon.visible = false
			pass
		pass
	
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_ability_inventory"):
		visible = !visible

func _process(delta: float) -> void:
	if dragging:
		#dragged_ability_slot.ability_icon.position = lerp(dragged_ability_slot.ability_icon.position, get_global_mouse_position(), 10 * delta)
		drag_icon.global_position = lerp(drag_icon.global_position, get_global_mouse_position(), 10 * delta)
		pass
