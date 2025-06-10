class_name GainDecayingStrengthOnHit
extends PassiveAbility

@export var bonus_strength_on_hit : float = 2
@export var max_bonus_strength : float = 50
@export var decay_timer : Timer
@export var decay_delay_timer : Timer
var actor_strength : Stat
var actor_level : Stat
var bonus_strength : float = 0
var _max_bonus : float = 0


var decay_delay : float = 2
var decay_time : float = 3
var _decay_time_counter : float = 0
var _decay_rate : float = 0

func _ready():
	super()
	decay_timer.autostart = false
	decay_delay_timer.autostart = false
	decay_delay_timer.wait_time = decay_delay
	_max_bonus = max_bonus_strength
	pass


func enable_passive_ability():
	if actor != null:
		decay_delay_timer.timeout.connect(_on_decay_delay_timer_timeout)
		decay_timer.timeout.connect(_on_decay_timer_timeout)
		actor.basic_attack_hit.connect(_on_basic_attack_hit)
		actor_strength = actor.stat_manager.stats.get("strength")
		actor_level = actor.stat_manager.stats.get("level")
		(actor_level as Stat).stat_derived_value_changed.connect(_on_actor_level_changed)
		enabled = true
	pass

func disable_passive_ability():
	decay_delay_timer.timeout.disconnect(_on_decay_delay_timer_timeout)
	decay_timer.timeout.disconnect(_on_decay_timer_timeout)
	actor.basic_attack_hit.disconnect(_on_basic_attack_hit)
	enabled = false
	#actor_strength = actor.stat_manager.stats.get("strength")
	#actor_level = actor.stat_manager.stats.get("level")
	#(actor_level as Stat).stat_derived_value_changed.connect(_on_actor_level_changed)
	pass


func _on_basic_attack_hit(hit_data : Dictionary):
	decay_delay_timer.stop()
	decay_timer.stop()
	if bonus_strength >= _max_bonus:
		decay_delay_timer.start(decay_delay)
		return
	actor.stat_manager.stats.get("strength").bonus_value += bonus_strength_on_hit
	actor.stat_manager.stats.get("strength").update_stat()
	bonus_strength += bonus_strength_on_hit
	decay_delay_timer.start(decay_delay)
	pass

func _on_decay_delay_timer_timeout():
	_decay_rate = bonus_strength / decay_time
	_decay_time_counter = decay_time
	decay_delay_timer.stop()
	decay_timer.start(1)
	print("Decay strength")
	pass

func _on_decay_timer_timeout():
	_decay_rate = ceilf(max(1, bonus_strength / decay_time))
	#_decay_rate = min(0, _decay_rate)
	actor.stat_manager.stats.get("strength").bonus_value -= _decay_rate
	actor.stat_manager.stats.get("strength").update_stat()
	bonus_strength -= _decay_rate
	print("Bonus Strength: " + str(bonus_strength))
	if bonus_strength > 0:
		decay_timer.start(1)
		pass
	else:
		decay_timer.stop()
	pass

func _on_actor_level_changed():
	_max_bonus = max_bonus_strength + (actor_level.stat_derived_value * 5)
	pass
