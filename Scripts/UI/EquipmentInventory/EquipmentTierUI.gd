class_name EquipmentTierUI
extends HBoxContainer

const TIER_STAR = preload("res://Sprites/UI/Tier Star/Tier Star.png")

func set_tier(tier : Equipment.EquipmentTier):
	for i in range(tier + 1):
		var texture_rect : TextureRect = TextureRect.new()
		texture_rect.texture = TIER_STAR
		texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		texture_rect.custom_minimum_size = Vector2(20, 20)
		add_child(texture_rect)
		pass
	pass

func clear_children():
	for child in get_children():
		child.queue_free()
		pass
	pass
