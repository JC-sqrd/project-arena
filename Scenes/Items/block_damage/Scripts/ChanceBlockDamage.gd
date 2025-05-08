class_name ChanceBlockDamage
extends Item

@export var block_chance : Stat

var _block_modifier : BlockModifier

func _ready():
	item_equipped.connect(_on_item_equipeed)
	block_chance.stat_derived_value_changed.connect(on_block_chance_changed)
	pass

func _on_item_equipeed():
	_block_modifier = BlockModifier.new()
	_block_modifier.block_chance = block_chance.stat_derived_value
	actor.damage_listener.add_child(_block_modifier, true)
	pass

func on_block_chance_changed():
	_block_modifier.block_chance = block_chance.stat_derived_value
	pass
