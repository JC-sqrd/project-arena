class_name ItemBuyInstanceUI
extends BuyInstanceUI

@export var item_data : ItemData
var item_scene : PackedScene
var item : Item

@onready var cost_button: Button = %CostButton
@onready var lock_button: Button = %LockButton
@onready var locked_icon: TextureRect = %LockedIcon
@onready var item_name_label: RichTextLabel = %ItemNameLabel
@onready var item_detail_label: RichTextLabel = %ItemDetailLabel
@onready var item_icon: TextureRect = %ItemIcon
@onready var cost_label: Label = %CostLabel
@onready var inventory_item_icon: InventoryItemIcon = $VBoxContainer/MarginContainer/SlotBorder/MarginContainer/InventoryItemIcon


const ITEM_TOOLTIP = preload("res://Scenes/UI/ItemInventoryUI/item_tooltip.tscn")

func _ready():
	super()
	cost_button.pressed.connect(_on_buy_button_pressed)
	lock_button.pressed.connect(_on_lock_button_pressed)
	locked_icon.visible = false
	if item_scene != null:
		item = item_scene.instantiate() as Item
		inventory_item_icon.configure_item_icon(item)
		item_icon.texture = item.item_icon
		cost_label.text = str(item.buy_cost)
		cost_button.text = str(item.buy_cost)
		item_name_label.text = item.item_name
		item_detail_label.text = item.item_detail
		pass
	pass

func buy(buyer : Entity):
	var buyer_gold : Stat = buyer.stat_manager.get_stat("gold") as Stat
	if buyer_gold.stat_value >= item.buy_cost:
		buyer.item_iventory.add_item(item)
		buyer_gold.stat_value -= item.buy_cost
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

func delete_buy_instance():
	if item != null:
		item.queue_free()
	queue_free()
	pass

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

func _make_custom_tooltip(for_text: String) -> Object:
	var item_tooltip : ItemTooltipUI = ITEM_TOOLTIP.instantiate()
	item_tooltip.initialize_item_tooltip(item)
	return item_tooltip
