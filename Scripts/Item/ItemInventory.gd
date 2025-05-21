class_name ItemInventory
extends Node

@export var actor : Entity
var items : Array[Item]

signal new_item_added (item : Item)
signal item_stack_added (item : Item)
signal item_stack_changed (item : Item)

func _ready():
	actor.ready.connect(
		func():
			for child in get_children():
				if child is Item:
					add_item(child)
					child.item_stack_changed.connect(_on_item_stack_changed)
	)
	pass

func add_item(new_item : Item):
	var new_item_id : int = new_item.item_id
	var new_item_string_id : String = new_item.string_id
	if items.size() == 0:
		items.append(new_item)
		new_item.actor = actor
		add_child(new_item)
		new_item.owner = actor
		new_item.equip_item(actor)
		new_item_added.emit(new_item)
	else:
		if has_item_string_id(new_item):
			# Item already exists in inventory ; add stack to existing item and destroy the item object 
			var item : Item = get_item_by_string_id(new_item.string_id)#get_item_by_id(new_item.item_id)
			item.stack += 1
			item_stack_added.emit(item)
			new_item.queue_free()
		else:
			# New item
			items.append(new_item)
			new_item.actor = actor
			add_child(new_item, true)
			new_item.owner = actor
			new_item.equip_item(actor)
			new_item_added.emit(new_item)
	pass

func remove_item(item : Item):
	if items.has(item):
		items.erase(item)
		item.unequip_item()
		remove_child(item)
	pass

func has_item(new_item : Item):
	for item in items:
		if item.item_id == new_item.item_id:
			return true
	return false

func has_item_string_id(new_item : Item):
	for item in items:
		if item.string_id == new_item.string_id:
			return true
	return false

func get_item_by_id(id : int):
	for item in items:
		if item.item_id == id:
			return item
	return null
	pass

func get_item_by_string_id(string_id : String):
	for item in items:
		if item.string_id == string_id:
			return item
	return null
	pass

func _on_item_stack_changed(item : Item):
	item_stack_added.emit(item)
	pass
