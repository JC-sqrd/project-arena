class_name LootDropper
extends Node

@export var dropper : LootDropManager
@export var loot : PackedScene
@export var drop_chance : float = 1
@export var active : bool = true
@export var scaler : DropChanceScaler
var drop_chance_multiplier : float = 1

func _ready():
	
	pass
	
func drop_loot(drop_position : Vector2):
	if scaler != null:
		drop_chance = scaler.get_scaled_drop_chance(self)
	if drop_chance >= randf_range(0, 1) and active:
		var loot_obj = loot.instantiate()
		loot_obj.global_position = drop_position
		get_tree().root.add_child(loot_obj)
	pass
