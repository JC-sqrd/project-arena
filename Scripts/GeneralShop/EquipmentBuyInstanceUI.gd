class_name EquipmentBuyInstanceUI
extends BuyInstanceUI

@export var equipment_scene : PackedScene
var equipment : Equipment
@onready var cost_button: Button = $VBoxContainer/CostButton

func _ready():
	super()
	cost_button.pressed.connect(_on_buy_button_pressed)
	if equipment_scene != null:
		equipment = equipment_scene.instantiate() as Equipment
		equipment_icon.texture = equipment.equipment_icon
		cost_label.text = str(equipment.buy_cost)
		pass
	pass

func buy(buyer : Entity):
	var buyer_gold : Stat = buyer.stat_manager.get_stat("gold") as Stat
	if buyer_gold.stat_derived_value >= equipment.buy_cost:
		equipment.actor = buyer
		if buyer.equipment_inventory.add_equipment(equipment):
			buyer_gold.stat_derived_value -= equipment.buy_cost
			print("Equipment bought!")
			queue_free()
		else:
			print("Inventory full!")
			slot_border.modulate = Color.ORANGE
	else:
		slot_border.modulate = Color.RED
	pass

func _on_buy_button_pressed():
	attempt_to_buy.emit(self)
	pass
