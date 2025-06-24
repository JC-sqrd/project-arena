class_name ItemBuyInstanceUI
extends BuyInstanceUI

@export var item_data : ItemData
var item : Item

@onready var cost_button: Button = %CostButton
@onready var lock_button: Button = %LockButton
@onready var locked_icon: TextureRect = %LockedIcon
@onready var item_name_label: RichTextLabel = $Panel/VBoxContainer/ItemNameLabel
@onready var item_detail_label: RichTextLabel = $Panel/VBoxContainer/ItemDetailLabel




func _ready():
	super()
	cost_button.pressed.connect(_on_buy_button_pressed)
	lock_button.pressed.connect(_on_lock_button_pressed)
	locked_icon.visible = false
	if item_data != null:
		#item = item_scene.instantiate() as Item
		print("EQUIPMENT ICON: " + str(cost_label))
		equipment_icon.texture = item_data.item_icon
		cost_label.text = str(item_data.buy_cost)
		cost_button.text = str(item_data.buy_cost)
		item_name_label.text = item_data.item_name
		item_detail_label.text = item_data.item_detail
		pass
	pass

func buy(buyer : Entity):
	var buyer_gold : Stat = buyer.stat_manager.get_stat("gold") as Stat
	if buyer_gold.stat_value >= item_data.buy_cost:
		buyer.item_iventory.add_item(item_data.item_scene.instantiate() as Item)
		buyer_gold.stat_value -= item_data.buy_cost
		queue_free()
	else:
		slot_border.modulate = Color.RED
		await get_tree().create_timer(0.1, false, false, false).timeout
		slot_border.modulate = Color.WHITE
	pass

func is_buyable(gold_amount : float) -> bool:
	if gold_amount >= item_data.buy_cost:
		return true
	return false


func _on_buy_button_pressed():
	attempt_to_buy.emit(self)
	pass

func _on_lock_button_pressed():
	is_locked = !is_locked
	if is_locked:
		locked_icon.visible = true
		lock_button.text = "UNLOCK"
	else:
		locked_icon.visible = false
		lock_button.text = "LOCK"
	pass
