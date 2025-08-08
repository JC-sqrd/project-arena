class_name ShopButtonUI
extends Button



func _ready():
	pressed.connect(_on_shop_button_pressed)
	pass

func _on_shop_button_pressed():
	Globals.general_shop.show_general_shop()
	pass
