class_name HealOverTimeStatusEffect
extends StatusEffect


@export var heal_effect : HealEffect
var heal_speed : float = 1
var heal_rate : float = 1 / heal_speed
var heal_tick_timer : Timer


func _ready():
	if stack_stat != null:
		stack_stat.stat_value = float(1)
		pass
	pass

func activate_status_effect(target : Entity):
	active = true
	target_entity = target
	heal_tick_timer = Timer.new()
	add_child(heal_tick_timer)
	heal_tick_timer.wait_time = heal_rate
	heal_tick_timer.one_shot = false
	heal_tick_timer.timeout.connect(_on_damage_tick) 
	
	
	if !is_permanent:
		timer = Timer.new()
		add_child(timer)
		timer.wait_time = duration
		timer.one_shot = true
		timer.timeout.connect(_on_duration_end)
		timer.start()
	
	heal_tick_timer.start()
	pass

func _on_damage_tick():
	target_entity.on_hit.emit(_create_hit_data())
	pass

func _on_duration_end():
	active = false
	#_on_damage_tick()
	queue_free()
	pass

func _create_hit_data() -> Dictionary:
	var hit_data : Dictionary
	hit_data["source"] = self
	hit_data["target"] = target_entity
	hit_data["actor"] = actor
	hit_data[heal_effect.get_effect_key()] = heal_effect.get_effect_value()
	return hit_data

func _set_stat(new_value : int):
	stack = new_value
	if stack_stat != null:
		stack_stat.stat_value = float(new_value)
	pass
