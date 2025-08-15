class_name GeneralShopUI
extends Control


@onready var item_buy_container: HBoxContainer = %ItemBuyContainer
@onready var equipment_buy_container: HBoxContainer = %EquipmentBuyContainer
@onready var restock_item_button: Button = %RestockItemButton
@onready var restock_equipment_button: Button = %RestockEquipmentButton
@onready var restock_shop_button: Button = %RestockShopButton
@onready var close_shop_button: Button = %CloseShopButton



@export_category("Item and Equipment Card Scene")
@export var item_card_scene : PackedScene
@export var equipment_card_scene : PackedScene

const ITEM_SHOP_CARD = preload("res://Scenes/UI/EquipmentShop/item_shop_card.tscn")
var max_item_stock : int = 5
var max_equipment_stock : int = 5

var common_item_chance : float = 0
var uncommon_item_chance : float = 0
var legendary_item_chance : float = 0

var wave_spawner : WaveSpawner

var restock_item_price : float = 5
var base_restock_item_price : float = 5
var restock_equipment_price : float = 5
var base_restock_equipment_price : float = 5

var player : Entity



func _ready() -> void:
	Globals.general_shop = self
	player = Globals.player
	owner.ready.connect(
		func():
			wave_spawner = Globals.wave_spawner
			wave_spawner.current_wave_end.connect(_on_current_wave_end)
			player = Globals.player
			print("Wave spawner: " + str(wave_spawner))
			pass
	)
	visible = false
	for buy_item in item_buy_container.get_children():
		if buy_item is BuyInstanceUI:
			buy_item.attempt_to_buy.connect(on_item_attempt_to_buy)
			pass
		pass
	for buy_equipment in equipment_buy_container.get_children():
		if buy_equipment is BuyInstanceUI:
			buy_equipment.attempt_to_buy.connect(on_item_attempt_to_buy)
			pass
		pass
	restock_equipment_button.text = "Restock Equipment - " + str(restock_equipment_price)
	restock_item_button.text = "Restock Item - " + str(restock_item_price)
	stock_items(max_item_stock)
	stock_equipment(max_equipment_stock)
	restock_item_button.pressed.connect(attempt_restock_items)
	restock_equipment_button.pressed.connect(attempt_restock_equipment)
	restock_shop_button.pressed.connect(restock_shop)
	close_shop_button.pressed.connect(hide_general_shop)
	pass

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("open_shop"):
		visible = !visible
		pass

func show_general_shop():
	visible = true
	pass

func hide_general_shop():
	visible = false
	pass

func restock_shop():
	restock_items(restock_item_price)
	restock_equipment(restock_equipment_price)
	pass

func stock_items(stock_amount : int):
	var item_pools : Dictionary = {
		"common": {
			"items": Globals.common_item_pool,
			"weight": 70
		},
		"rare": {
			"items": Globals.rare_item_pool,
			"weight": 25
		}
	}
	var total_weight : float = 0
	for pool in item_pools.values():
		total_weight += pool.weight
	
	for i in stock_amount:
		var roll := randi_range(1, total_weight)
		var selected_pool : Array[PackedScene] 
		var cumulative_weight : float = 0
		
		for pool_name in item_pools:
			cumulative_weight += item_pools[pool_name].weight
			if roll <= cumulative_weight:
				selected_pool = item_pools[pool_name].items
				break
		
		if selected_pool.size() > 0:
			var random_item = selected_pool[randi_range(0, selected_pool.size() - 1)]
			var item_card : ItemBuyInstanceUI = item_card_scene.instantiate() as ItemBuyInstanceUI
			item_card.item_scene = random_item
			item_card.attempt_to_buy.connect(on_item_attempt_to_buy)
			item_buy_container.add_child(item_card)
		
		#var item_card : ItemBuyInstanceUI = item_card_scene.instantiate() as ItemBuyInstanceUI
		#item_card.item_scene = Globals.common_item_pool[randi_range(0, Globals.common_item_pool.size() - 1)]
		#item_card.attempt_to_buy.connect(on_item_attempt_to_buy)
		#item_buy_container.add_child(item_card)
	pass

func stock_equipment(stock_amount : int):
	var equipment_pools : Dictionary = {
		"common": {
			"equipment": Globals.common_equipment_pool,
			"weight": 70
		},
		"rare": {
			"equipment": Globals.rare_equipment_pool,
			"weight": 25
		}
	}
	var total_weight : float = 0
	for pool in equipment_pools.values():
		total_weight += pool.weight
	
	for i in stock_amount:
		var roll := randi_range(1, total_weight)
		var selected_pool : Array[PackedScene] 
		var cumulative_weight : float = 0
		
		for pool_name in equipment_pools:
			cumulative_weight += equipment_pools[pool_name].weight
			if roll <= cumulative_weight:
				selected_pool = equipment_pools[pool_name].equipment
				break
		
		if selected_pool.size() > 0:
			var random_equipment = selected_pool[randi_range(0, selected_pool.size() - 1)]
			var equipment_card : EquipmentBuyInstanceUI = equipment_card_scene.instantiate() as EquipmentBuyInstanceUI
			equipment_card.equipment_scene = random_equipment
			equipment_card.attempt_to_buy.connect(on_item_attempt_to_buy)
			equipment_buy_container.add_child(equipment_card)
	
	#for i in stock_amount:
		#var equipment_card : EquipmentBuyInstanceUI = equipment_card_scene.instantiate() as EquipmentBuyInstanceUI
		#equipment_card.equipment_scene = Globals.common_equipment_pool[randi_range(0, Globals.common_equipment_pool.size() - 1)]
		#equipment_card.attempt_to_buy.connect(on_item_attempt_to_buy)
		#equipment_buy_container.add_child(equipment_card)
	pass

func attempt_restock_items():
	restock_items(restock_item_price)
	pass

func restock_items(restock_price : float):
	if player.stat_manager.stats.get("gold").stat_value >= restock_price: 
		var stock_count : int = max_item_stock
		for item_buy in item_buy_container.get_children():
			if (item_buy as BuyInstanceUI).is_locked:
				stock_count -= 1
			else:
				(item_buy as BuyInstanceUI).delete_buy_instance()
		stock_items(stock_count)
		player.stat_manager.stats.get("gold").stat_value -= restock_price
		restock_item_price += restock_price
		restock_item_button.text = "Restock Item - " + str(restock_item_price)
	else:
		return
	pass

func attempt_restock_equipment():
	restock_equipment(restock_equipment_price)
	pass

func restock_equipment(restock_price : float):
	if player.stat_manager.stats.get("gold").stat_value >= restock_price:
		var stock_count : int = max_equipment_stock
		for equipment_buy in equipment_buy_container.get_children():
			if (equipment_buy as BuyInstanceUI).is_locked:
				stock_count -= 1
			else:
				(equipment_buy as EquipmentBuyInstanceUI).delete_buy_instance()
		stock_equipment(stock_count)
		player.stat_manager.stats.get("gold").stat_value -= restock_price
		restock_equipment_price += restock_price
		restock_equipment_button.text = "Restock Equipment - " + str(restock_equipment_price)
	pass

func on_item_attempt_to_buy(buy_instance : BuyInstanceUI):
	buy_instance.buy(player)
	pass

func _on_current_wave_end(wave : Wave):
	visible = true
	restock_item_price = wave_spawner.wave_count * base_restock_item_price
	restock_item_button.text = "Restock Item - " + str(restock_item_price)
	restock_equipment_price = wave_spawner.wave_count * base_restock_equipment_price
	restock_equipment_button.text = "Restock Equipment - " + str(restock_equipment_price)
	restock_items(0)
	restock_equipment(0)
	pass
