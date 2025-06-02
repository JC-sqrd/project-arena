class_name InventoryItemIcon
extends Control

var item_id : String 
var item_name : String
@export var item_texture_rect : TextureRect
@export var item_stack_label : Label
var item_detail : String

func _ready():
	tooltip_text = item_name + "\n" +item_detail 
