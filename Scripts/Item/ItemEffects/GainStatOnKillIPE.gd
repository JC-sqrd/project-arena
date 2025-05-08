class_name GainStatOnKillIPE
extends ItemPassiveEffect


@export var stat_to_give : String
@export var gain_value : Stat 

func _ready() -> void:
	super()
	item.item_equipped.connect(on_item_equipped)


func on_item_equipped():
	item.actor.slayed.connect(give_stat)
	pass

func give_stat(slayed : Entity):
	var stat : Stat = item.actor.stat_manager.stats[stat_to_give] as Stat
	stat.stat_derived_value += gain_value.stat_derived_value
	pass
