class_name EquipmentInventorySlotIcon
extends TextureRect

const TIER_STAR = preload("res://Sprites/UI/Tier Star/Tier Star.png")
@onready var h_box_container: HBoxContainer = $HBoxContainer
var equipment : Equipment


func _ready() -> void:
	pass

func set_equipment(equipment : Equipment):
	self.equipment = equipment
	texture = equipment.equipment_icon
	for i in range(equipment.tier + 1):
		var texture_rect : TextureRect = TextureRect.new()
		texture_rect.texture = TIER_STAR
		texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		texture_rect.custom_minimum_size = Vector2(20, 20)
		h_box_container.add_child(texture_rect)
		pass
	pass

func clear_equipment():
	equipment = null
	texture = null
	for child in h_box_container.get_children():
		child.queue_free()
	pass
