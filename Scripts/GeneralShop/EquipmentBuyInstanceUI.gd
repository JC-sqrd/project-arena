class_name EquipmentBuyInstanceUI
extends BuyInstanceUI

@export var equipment_data : EquipmentData
var equipment : Equipment
@onready var cost_button: Button = $Panel/VBoxContainer/CostButton
@onready var equipment_name_label: RichTextLabel = $Panel/VBoxContainer/EquipmentNameLabel


func _ready():
	super()
	cost_button.pressed.connect(_on_buy_button_pressed)
	if equipment_data != null:
		#equipment = equipment_data.instantiate() as Equipment
		equipment_icon.texture = equipment_data.equipment_icon
		cost_label.text = str(equipment_data.buy_cost)
		equipment_name_label.text = equipment_data.equipment_name
		pass
	pass

func buy(buyer : Entity):
	var buyer_gold : Stat = buyer.stat_manager.get_stat("gold") as Stat
	if buyer_gold.stat_value >= equipment_data.buy_cost:
		equipment = equipment_data.equipment_scene.instantiate() as Equipment
		equipment.actor = buyer
		if buyer.equipment_inventory.add_equipment(equipment):
			buyer_gold.stat_value -= equipment_data.buy_cost
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
