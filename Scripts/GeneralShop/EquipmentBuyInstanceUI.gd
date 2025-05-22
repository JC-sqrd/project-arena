class_name EquipmentBuyInstanceUI
extends BuyInstanceUI

@export var equipment_scene : PackedScene
@export var item_buy_data : ItemBuyData
var equipment : Equipment

func _ready():
	super()
	if equipment_scene != null:
		equipment = equipment_scene.instantiate() as Equipment
		equipment_icon.texture = equipment.equipment_icon
		cost_label.text = str(item_buy_data.buy_cost)
		pass
	pass

func buy(buyer : Entity):
	var buyer_gold : Stat = buyer.stat_manager.get_stat("gold") as Stat
	if buyer_gold.stat_derived_value >= item_buy_data.buy_cost:
		if buyer.equipment_inventory.add_equipment(equipment):
			buyer_gold.stat_derived_value -= item_buy_data.buy_cost
			print("Equipment bought!")
			queue_free()
		else:
			print("Inventory full!")
			slot_border.modulate = Color.ORANGE
	else:
		slot_border.modulate = Color.RED
	pass
