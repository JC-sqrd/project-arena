class_name GoldDropper
extends LootDropper


@export var gold_add : float = 10

func drop_loot(drop_position : Vector2):
	if scaler != null:
		drop_chance = scaler.get_scaled_drop_chance(self)
	if drop_chance >= randf_range(0, 1) and active:
		var loot_obj = loot.instantiate()
		if loot_obj is GoldCoin:
			loot_obj.gold_add = gold_add
		loot_obj.global_position = drop_position
		get_tree().root.add_child(loot_obj)
	pass
