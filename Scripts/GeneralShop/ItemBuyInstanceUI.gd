class_name ItemBuyInstanceUI
extends BuyInstanceUI

@export var item_scene : PackedScene
var item : Item
@onready var cost_button: Button = $VBoxContainer/CostButton

func _ready():
	super()
	cost_button.pressed.connect(_on_buy_button_pressed)
	if item_scene != null:
		item = item_scene.instantiate() as Item
		equipment_icon.texture = item.item_icon
		cost_label.text = str(item.buy_cost)
		cost_button.text = str(item.buy_cost)
		pass
	pass

func buy(buyer : Entity):
	var buyer_gold : Stat = buyer.stat_manager.get_stat("gold") as Stat
	if buyer_gold.stat_derived_value >= item.buy_cost:
		buyer.item_iventory.add_item(item)
		buyer_gold.stat_derived_value -= item.buy_cost
		queue_free()
	else:
		slot_border.modulate = Color.RED
		await get_tree().create_timer(0.1, false, false, false).timeout
		slot_border.modulate = Color.WHITE
	pass

func _on_buy_button_pressed():
	attempt_to_buy.emit(self)
	pass
