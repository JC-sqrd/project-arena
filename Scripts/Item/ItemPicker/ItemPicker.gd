class_name ItemPicker
extends Control

@export var item_card_scene : PackedScene
@export var item_card_container : HBoxContainer
var item_cards : Array[ItemCard]
var max_item_choice : int = 3
var index_pool : Array[int]
var player : PlayerCharacter

var current_item_pool : Array[PackedScene]
var item_pool_queue : Array

func _ready():
	visible = false
	if owner is PlayerCharacter:
		player = owner
		player.item_picker_picked_up.connect(_on_item_picker_picked)
		pass
	
	#for item_card in item_cards:
		#item_card.item_card_picked.connect(_on_item_card_picked)
		#pass
	pass

func _on_item_card_picked(item : Item):
	player.item_iventory.add_item(item)
	item_pool_queue.remove_at(0)
	if item_pool_queue.size() <= 0:
		visible = false
		PauseManager.resume_scene_tree()
		pass
	else:
		_shuffle_current_item_pool(item_pool_queue[item_pool_queue.size() - 1])
		#for item_card in item_cards:
			#item_card.initialize()
		pass
	pass

func _on_item_picker_picked(player : PlayerCharacter, loot_pool : Array[PackedScene]):
	PauseManager.pause_scene_tree()
	item_pool_queue.append(loot_pool)
	if !visible:
		current_item_pool = loot_pool
		_shuffle_current_item_pool(item_pool_queue[item_pool_queue.size() - 1])
	#for item_card in item_cards:
		#item_card.initialize()
		#pass
	visible = true
	pass

func _shuffle_current_item_pool(loot_pool : Array[PackedScene]):
	index_pool.clear()
	for child in item_card_container.get_children():
		child.queue_free()
	#for item_card in item_cards:
		#var item_index = randi_range(0, item_pool.size()-1)
		#while index_pool.has(item_index):
			#item_index = randi_range(0, item_pool.size()-1)
		#item_card.initialize(item_pool[item_index].instantiate() as Item)
		#index_pool.append(item_index)
	
	for i in max_item_choice:
		var item_index = randi_range(0, loot_pool.size() - 1)
		while index_pool.has(item_index):
			item_index = randi_range(0, loot_pool.size() - 1)
		
		var item_card_object = item_card_scene.instantiate() as ItemCard
		item_card_container.add_child(item_card_object)
		item_card_object.initialize(loot_pool[item_index].instantiate() as Item)
		item_card_object.item_card_picked.connect(_on_item_card_picked)
		index_pool.append(item_index)
	pass
