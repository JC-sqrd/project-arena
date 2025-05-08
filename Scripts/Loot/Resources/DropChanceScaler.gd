class_name DropChanceScaler
extends Resource


@export var scale_value : float = 1

func get_scaled_drop_chance(loot_dropper : LootDropper):
	return loot_dropper.drop_chance * scale_value
	pass
