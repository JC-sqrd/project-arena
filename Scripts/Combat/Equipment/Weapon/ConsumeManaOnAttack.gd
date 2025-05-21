class_name ConsumeManaOnAttack
extends Node


var attack : Weapon
@export var mana_consumption : Stat


func _ready():
	if owner is Weapon:
		attack = owner
		attack.attack_start.connect(consume_mana)
	pass


func consume_mana():
	attack.actor.stat_manager.stats["current_mana"].stat_derived_value -= minf(attack.actor.stat_manager.stats["current_mana"].stat_derived_value, mana_consumption.stat_derived_value)
	pass
