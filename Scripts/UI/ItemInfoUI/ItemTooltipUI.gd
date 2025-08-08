class_name ItemTooltipUI
extends Control

@export var item_tooltip_icon : TooltipItemIcon
@export var item_name_label : RichTextLabel
@export var item_details_label : RichTextLabel

func _ready() -> void:
	pass

func initialize_item_tooltip(item : Item):
	item_tooltip_icon.set_item_icon_texture(item.item_icon)
	item_name_label.text = item.item_name
	item_details_label.text = item.item_detail
	pass
