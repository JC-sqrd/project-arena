class_name EquipmentBuyInstanceUI
extends BuyInstanceUI

@export var equipment_data : EquipmentData
var equipment : Equipment
var equipment_scene : PackedScene

@onready var equipment_name_label: RichTextLabel = %EquipmentNameLabel
@onready var cost_button: Button = %CostButton
@onready var lock_button: Button = %LockButton
@onready var lock_icon: TextureRect = %LockIcon
@onready var equipment_icon: EquipmentInventorySlotIcon = %EquipmentIcon
@onready var cost_label: Label = %CostLabel
const EQUIPMENT_TOOLTIP = preload("res://Scenes/UI/EquipmentInventory/equipment_tooltip.tscn")

func _ready():
	super()
	cost_button.pressed.connect(_on_buy_button_pressed)
	lock_button.pressed.connect(_on_lock_button_pressed)
	lock_icon.visible = false
	if equipment_scene != null:
		#equipment = equipment_data.instantiate() as Equipment
		equipment = equipment_scene.instantiate() as Equipment
		equipment_icon.texture = equipment.equipment_icon
		equipment_icon.set_equipment(equipment)
		#equipment_icon.set_equipment_icon(equipment_data.equipment_icon)
		#equipment_icon.set_equipment_tier(equipment_data.tier)
		cost_label.text = str(equipment.buy_cost)
		cost_button.text = str(equipment.buy_cost)
		equipment_name_label.text = equipment.equipment_name
		pass
	pass

func buy(buyer : Entity):
	var buyer_gold : Stat = buyer.stat_manager.get_stat("gold") as Stat
	if buyer_gold.stat_value >= equipment.buy_cost:
		#equipment = equipment_data.equipment_scene.instantiate() as Equipment
		equipment.actor = buyer
		equipment.tier = equipment.tier
		if buyer.equipment_inventory.add_equipment(equipment):
			buyer_gold.stat_value -= equipment.buy_cost
			print("Equipment bought!")
			queue_free()
		else:
			print("Inventory full!")
			slot_border.modulate = Color.ORANGE
	else:
		slot_border.modulate = Color.RED
		await get_tree().create_timer(0.1, false, false, false).timeout
		slot_border.modulate = Color.WHITE
	pass

func _on_buy_button_pressed():
	attempt_to_buy.emit(self)
	pass

func _on_lock_button_pressed():
	is_locked = !is_locked
	if is_locked:
		lock_icon.visible = true
		lock_button.text = "UNLOCK"
	else:
		lock_icon.visible = false
		lock_button.text = "LOCK"
	pass

func delete_buy_instance():
	if equipment != null:
		equipment.queue_free()
	queue_free()
	pass

func _make_custom_tooltip(for_text: String) -> Object:
	if equipment == null:
		return null
	
	var equipment_tooltip = EQUIPMENT_TOOLTIP.instantiate()
	
	equipment_tooltip.initialize_equipment_tooltip(equipment)
	return equipment_tooltip
