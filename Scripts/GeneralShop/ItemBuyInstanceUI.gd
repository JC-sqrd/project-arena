class_name ItemBuyInstanceUI
extends BuyInstanceUI

@export var item_scene : PackedScene
@export var item_buy_data : ItemBuyData
var item : Item

func _ready():
	super()
	if item_scene != null:
		item = item_scene.instantiate() as Item
		equipment_icon.texture = item.item_icon
		cost_label.text = str(item_buy_data.buy_cost)
		pass
	pass

func buy(buyer : Entity):
	var buyer_gold : Stat = buyer.stat_manager.get_stat("gold") as Stat
	if buyer_gold.stat_derived_value >= item_buy_data.buy_cost:
		buyer.item_iventory.add_item(item)
		buyer_gold.stat_derived_value -= item_buy_data.buy_cost
		queue_free()
	else:
		slot_border.modulate = Color.RED
	pass
