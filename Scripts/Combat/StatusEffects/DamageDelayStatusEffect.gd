class_name DamageDelayStatusEffect
extends StatusEffect

@export var damage_effect : DamageEffect
var stack_stat_scalers : Array[StatScaler]
var bonus_damage : float = 0

var stat_scaler : StatScaler

func _ready():
	if stack_stat != null:
		if stack_stat.stat_value >= 0:
			stack_stat.stat_value = 1
			pass

func activate_status_effect(target : Entity):
	target_entity = target
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = duration
	timer.one_shot = true
	timer.timeout.connect(_on_duration_end)
	timer.start()
	pass

func _on_duration_end():
	target_entity.on_hit.emit(_create_hit_data())
	queue_free()
	pass



func _create_hit_data() -> Dictionary:
	var hit_data : Dictionary
	hit_data["source"] = self
	hit_data["actor"] = actor
	hit_data["target"] = target_entity
	hit_data[damage_effect.get_effect_key()] = damage_effect.get_effect_value()
	return hit_data

func add_stat(amount : int):
	stack = stack + amount
	stack_stat.stat_value += float(amount)
	pass

func _set_stat(new_value : int):
	stack = new_value
	stack_stat.stat_value = new_value
	stack_stat.update_stat()
	pass

func get_actor() -> Entity:
	return actor
