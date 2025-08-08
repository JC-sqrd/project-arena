class_name ItemInventoryUI
extends Control


@export var inventory : ItemInventory
@onready var item_grid : GridContainer = $MarginContainer/PanelContainer/MarginContainer/GridContainer
const item_icon_scene = preload("res://Scenes/UI/ItemInventoryIcons/inventory_item_icon.tscn")
var item_icons : Array[InventoryItemIcon]



func _ready():
	if inventory != null:
		inventory.new_item_added.connect(_on_new_item_added)
		inventory.item_stack_added.connect(_on_item_stack_added)
	pass

func _on_new_item_added(item : Item):
	var item_icon : InventoryItemIcon = item_icon_scene.instantiate() as InventoryItemIcon
	item_icon.configure_item_icon(item)
	if item.stack != 1:
		item_icon.item_stack_label.text = str(item.stack)
	else:
		item_icon.item_stack_label.text = ""
	item_grid.add_child(item_icon, true)
	item_icons.append(item_icon)
	pass

func _on_item_stack_added(item : Item):
	for item_icon in item_icons:
		if item_icon.item_id == item.string_id:
			item_icon.item_stack_label.text = str(item.stack)
	pass

func get_item_by_id():
	pass
