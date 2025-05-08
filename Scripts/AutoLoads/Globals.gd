extends Node

var player : PlayerCharacter

var common_item_pool : Array[PackedScene] = [
	preload("res://Scenes/Items/gain_move_speed/item_move_speed.tscn"),
	preload("res://Scenes/Items/gain_attack_speed/item_attack_speed.tscn"),
	preload("res://Scenes/Items/item_magic.tscn"),
	preload("res://Scenes/Items/item_strength.tscn"),
	preload("res://Scenes/Items/item_vitality.tscn"),
	preload("res://Scenes/Items/block_damage/item_chance_block_damage.tscn")
]

var rare_item_pool : Array[PackedScene] = [
	preload("res://Scenes/Items/chain_lightning/item_chain_lightning.tscn"),
	preload("res://Scenes/Items/flying_dagger/item_flying_dagger.tscn"),
	preload("res://Scenes/Items/burst_damage/item_burst_damage.tscn"),
	preload("res://Scenes/Items/charge_move_speed/item_charge_move_speed.tscn"),
	preload("res://Scenes/Items/mana_on_kill/item_mana_on_kill.tscn")
]


var player_modifiers : Dictionary = {
	
}

var item_modifiers : Dictionary = {
	"cooldown":1.0
}
