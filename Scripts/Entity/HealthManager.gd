class_name HealthManager
extends Node

@export var stat_manager : StatManager
@export var max_health : Stat
@export var current_health : Stat
@export var health_regen : Stat
@export var allow_greater : bool = false
@export_category("Shield")
@export var max_shield : Stat
@export var current_shield : Stat
@export var shield_regen : Stat

var health_regen_timer : Timer

signal health_depleted()
signal health_manager_ready()
signal current_health_value_changed(current_health : float, max_health : float)
signal max_health_value_changed(current_health : float, max_health : float)
signal current_shield_value_changed(current : float, max : float)
signal max_shield_value_changed(current : float, max : float)


func _ready():
	health_regen_timer = Timer.new()
	health_regen_timer.autostart = false
	health_regen_timer.one_shot = false
	health_regen_timer.wait_time = 1
	health_regen_timer.timeout.connect(_on_health_regen_timer_timeout)
	add_child(health_regen_timer)
	health_depleted.connect(_on_health_depleted)
	
	max_health.ready.connect(
		func():
			current_health_value_changed.emit(max_health.stat_derived_value, max_health.stat_derived_value)
	)
	max_shield.ready.connect(
		func():
			current_shield_value_changed.emit(max_shield.stat_derived_value, max_shield.stat_derived_value)
	)
	
	max_health.stat_derived_value_changed_data.connect(_on_max_health_changed_data)
	max_shield.stat_derived_value_changed_data.connect(_on_max_shield_changed_data)
	
	owner.ready.connect(
		func():
			current_health.stat_value = max_health.stat_derived_value
			current_health.stat_derived_value_changed.connect(_on_current_health_changed)
			max_health.stat_derived_value_changed.connect(_on_max_health_changed)
			current_health_value_changed.emit(max_health.stat_derived_value, max_health.stat_derived_value)
			current_shield.stat_value = max_shield.stat_derived_value
			current_shield.stat_derived_value_changed.connect(_on_current_shield_changed)
			pass
	)

	
	health_manager_ready.emit()
	pass


func _on_max_health_changed_data(old_value : float, new_value : float):
	#current_health.stat_derived_value = max_health.stat_derived_value
	var health_difference : float = new_value - old_value 
	current_health.stat_derived_value +=  health_difference
	current_health_value_changed.emit(current_health.stat_derived_value, max_health.stat_derived_value)
	max_health_value_changed.emit(current_health.stat_derived_value, max_health.stat_derived_value)
	pass

func _on_max_shield_changed_data(old : float, new : float):
	var shield_difference : float = new - old 
	current_shield.stat_derived_value +=  shield_difference
	current_shield_value_changed.emit(current_health.stat_derived_value, max_health.stat_derived_value)
	max_shield_value_changed.emit(current_health.stat_derived_value, max_health.stat_derived_value)
	pass

func add_current_health(health : float):
	current_health.stat_derived_value += health
	_evaluate_health()
	pass

func remove_current_health(health : float):
	#var leftover_damage : float = 0
	if current_shield.stat_derived_value > 0:
		current_shield.stat_derived_value -= health
		current_shield.stat_value -= health
	else:
		current_health.stat_derived_value -= health
		current_health.stat_value -= health
	_evaluate_health()
	pass

func add_base_current_health(health : float):
	current_health.stat_value +=  health
	_evaluate_health()

func remove_base_current_health(health : float):
	current_health.stat_value -=  health
	_evaluate_health()

func add_max_health(health : float):
	max_health.stat_derived_value += health
	_evaluate_health()
	pass

func remove_max_health(health : float):
	max_health.stat_derived_value -= health
	_evaluate_health()
	pass

func add_base_max_health(health : float):
	max_health.stat_value += health
	_evaluate_health()
	pass

func remove_base_max_health(health : float):
	max_health.stat_value -= health
	_evaluate_health()
	pass

func _on_current_health_changed():
	current_health_value_changed.emit(current_health.stat_derived_value, max_health.stat_derived_value)
	_evaluate_health()
	pass

func _on_max_health_changed():
	max_health_value_changed.emit(current_health.stat_derived_value, max_health.stat_derived_value)
	_evaluate_health()
	pass

func _on_current_shield_changed():
	current_shield_value_changed.emit(current_shield.stat_derived_value, max_shield.stat_derived_value)
	pass


func _evaluate_health():
	if current_health.stat_derived_value <= 0:
		health_depleted.emit()
	
	if !allow_greater and current_health.stat_derived_value > max_health.stat_derived_value:
		current_health.stat_derived_value = max_health.stat_derived_value
	
	if current_health.stat_derived_value < max_health.stat_derived_value:
		health_regen_timer.start()
	else:
		health_regen_timer.stop()
	
	pass

func _on_health_depleted():
	#entity.velocity = Vector2.ZERO
	if owner is Entity:
		owner.velocity = Vector2.ZERO
	pass

func _on_health_regen_timer_timeout():
	add_current_health(health_regen.stat_derived_value)
	pass
