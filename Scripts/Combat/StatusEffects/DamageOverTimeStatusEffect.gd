class_name DamageOverTimeStatusEffect
extends StatusEffect


@export var damage_effect : DamageEffect

var damage_speed : float = 1
var damage_rate : float = 1 / damage_speed
var damage_tick_timer : Timer



func activate_status_effect(target : Entity):
	active = true
	target_entity = target
	if damage_tick_timer == null:
		damage_tick_timer = Timer.new()
		add_child(damage_tick_timer)
		damage_tick_timer.wait_time = damage_rate
		damage_tick_timer.one_shot = false
		damage_tick_timer.timeout.connect(_on_damage_tick) 
	
	
	if !is_permanent:
		timer = Timer.new()
		add_child(timer)
		timer.wait_time = duration
		timer.one_shot = true
		timer.timeout.connect(_on_duration_end)
		timer.start()
	
	damage_tick_timer.start()
	pass

func _on_damage_tick():
	if target_entity != null and actor != null:
		target_entity.on_hit.emit(_create_hit_data())
	pass

func _on_duration_end():
	active = false
	#_on_damage_tick()
	queue_free()
	pass

func _create_hit_data() -> Dictionary:
	var hit_data : Dictionary = HitDataHelper.create_hit_data(self, target_entity, actor)
	hit_data[damage_effect.get_effect_key()] = damage_effect.get_effect_value()
	return hit_data

func _set_stack(new_value : int):
	stack = min(new_value, max_stack)
	if stack_stat != null:
		stack_stat.stat_value = float(stack)
	pass
