class_name SlowOnCast
extends AbilityBehavior

@export var slow_time : float = 0
@export_range(0, 1, 0.01) var slow_multiplier : float = 1

var old_actor_move_speed : float = 0

func _ready() -> void:
	super()
	ability.ability_casted.connect(on_ability_casted)



func on_ability_casted():
	old_actor_move_speed = ability.actor.stat_manager.stats["move_speed"].stat_derived_value
	ability.actor.stat_manager.stats["move_speed"].stat_derived_value = ability.actor.stat_manager.stats["move_speed"].stat_value * slow_multiplier 
	await get_tree().create_timer(slow_time, false, true, false).timeout
	ability.actor.stat_manager.stats["move_speed"].stat_derived_value = old_actor_move_speed
	pass
