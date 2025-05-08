class_name RequireStatToweapon
extends Node


var weapon : Weapon
@export var required_stat : String
@export var required_value : Stat


func _ready():
	if owner is Weapon:
		weapon = owner
		weapon.ready.connect(
			func():
				weapon.actor.ready.connect(on_actor_ready)
				#print("Connected to weapon")
				)
	pass

func on_actor_ready():
	(weapon.actor.stat_manager.stats[required_stat] as Stat).stat_derived_value_changed.connect(check_stat)
	pass

func check_stat():
	if (weapon.actor.stat_manager.stats[required_stat] as Stat).stat_derived_value < required_value.stat_derived_value:
		weapon.can_weapon = false
	else:
		weapon.can_weapon = true
	pass
