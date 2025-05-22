class_name GeneralShopUI
extends Control

@onready var item_buy_container: GridContainer = $Panel/ItemBuyContainer
@onready var player : Entity = Globals.player



func _ready() -> void:
	visible = false
	for buy_item in item_buy_container.get_children():
		if buy_item is BuyInstanceUI:
			buy_item.attempt_to_buy.connect(on_item_attempt_to_buy)
			pass
		pass
	pass

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("open_shop"):
		visible = !visible
		pass



func on_item_attempt_to_buy(buy_instance : BuyInstanceUI):
	buy_instance.buy(player)
	pass
