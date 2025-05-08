class_name StopOnCast
extends AbilityBehavior

@export var stop_time : float = 0
@export var stop_on : StopOn = StopOn.CAST

enum StopOn {CAST, START}


func _ready() -> void:
	super()
	if stop_on == StopOn.CAST:
		ability.ability_casted.connect(on_ability_cast)
	elif stop_on == StopOn.START:
		ability.ability_start.connect(on_ability_cast)

func on_ability_cast():
	ability.actor.can_move = false
	await get_tree().create_timer(stop_time, false, true, false).timeout
	ability.actor.can_move = true
	pass
