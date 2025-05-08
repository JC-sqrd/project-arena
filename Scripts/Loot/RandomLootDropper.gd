class_name RandomLootDropper
extends LootDropper

var droppers : Array[LootDropper]
var total_drop_chance : float = 0

func _ready():
	for child in get_children():
		if child is LootDropper:
			droppers.append(child)
			total_drop_chance += child.drop_chance

func drop_loot(drop_position : Vector2):
	var random : float = randf_range(0, total_drop_chance)
	var cursor : float = 0
	for dropper in droppers:
		cursor += dropper.drop_chance
		if cursor >= random and active:
			if dropper.loot != null and dropper.active:
				var loot_obj = dropper.loot.instantiate()
				loot_obj.global_position = drop_position
				get_tree().root.add_child(loot_obj)
			return
	pass
