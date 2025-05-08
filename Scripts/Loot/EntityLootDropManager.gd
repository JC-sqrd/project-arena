class_name EntityLootDropManager
extends LootDropManager


@export var enemy : Entity
var loot_drops : Array[Node2D]
@export var drops : Array[PackedScene]
var droppers : Array[LootDropper]

func _ready():
	if owner is Enemy:
		enemy = owner
	enemy.died.connect(drop_loots)
	for child in get_children():
		if child is LootDropper:
			droppers.append(child)
	
func drop_loots():
	for dropper in droppers:
		dropper.drop_loot(enemy.global_position)
		
func _drop_loot(loot : Node2D):
	loot.process_mode = 1
	loot.visible = true
	loot.reparent(owner.get_parent())
	loot.position = enemy.position
	pass

func _spawn_loot(loot : PackedScene):
	var loot_node : Node2D = loot.instantiate()
	loot_node.position = enemy.position
	get_tree().root.add_child(loot_node)
	pass
