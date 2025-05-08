class_name ConsumeManaToggle
extends ToggleAbilityBehavior


@export var consumption_rate : float = 1
@export var mana_consumption : Stat

var actor_mana : Stat
var timer : Timer = Timer.new()


func _ready():
	super()
	toggle_ability.ability_toggled_on.connect(on_ability_toggled_on)
	toggle_ability.ability_toggled_off.connect(on_ability_toggled_off)
	add_child(timer, true)
	timer.wait_time = consumption_rate
	timer.timeout.connect(consume_mana)


func on_ability_toggled_on():
	toggle_ability.actor.stat_manager.stats["current_mana"].stat_derived_value -= mana_consumption.stat_derived_value
	timer.start()
	pass

func on_ability_toggled_off():
	timer.stop()
	pass


func consume_mana():
	actor_mana = toggle_ability.actor.stat_manager.stats["current_mana"]
	actor_mana.stat_derived_value -= mana_consumption.stat_derived_value 
	if actor_mana.stat_derived_value < mana_consumption.stat_derived_value:
		toggle_ability.ability_start.emit()
		pass
	pass
