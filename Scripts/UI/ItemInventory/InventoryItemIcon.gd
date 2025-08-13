class_name InventoryItemIcon
extends Control

var item_id : String 
var item_name : String
@export var item_texture_rect : TextureRect
@export var item_stack_label : Label
var item : Item
var item_detail : String

const ITEM_TOOLTIP = preload("res://Scenes/UI/ItemInventoryUI/item_tooltip.tscn")

func configure_item_icon(item : Item):
	self.item = item
	item_id = item.string_id
	item_name = item.item_name
	item_texture_rect.texture = item.item_icon
	item_detail = item.item_detail
	pass

func _ready():
	tooltip_text = item_name + "\n" +item_detail 

func _make_custom_tooltip(for_text: String) -> Object:
	var item_tooltip : ItemTooltipUI = ITEM_TOOLTIP.instantiate()
	item_tooltip.initialize_item_tooltip(item)
	return item_tooltip
