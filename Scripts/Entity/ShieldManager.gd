class_name ShieldManager
extends Node

@export var stat_manager : StatManager
@export var max_shield : Stat
@export var current_shield : Stat
@export var shield_regen : Stat
@export var allow_greater : bool = false
var shield_regen_timer : Timer

signal shield_depleted()
signal shield_manager_ready()
signal current_shield_value_changed(current_shield : float, max_shield : float)
signal max_shield_value_changed(current_shield : float, max_shield : float)

func _ready():
	shield_regen_timer = Timer.new()
	shield_regen_timer.autostart = false
	shield_regen_timer.one_shot = false
	shield_regen_timer.wait_time = 1
	shield_regen_timer.timeout.connect(_on_shield_regen_timer_timeout)
	add_child(shield_regen_timer)
	shield_depleted.connect(_on_shield_depleted)
	
	max_shield.ready.connect(
		func():
			current_shield_value_changed.emit(max_shield.stat_derived_value, max_shield.stat_derived_value)
	)
	
	max_shield.stat_derived_value_changed_data.connect(_on_max_shield_changed_data)

	owner.ready.connect(
		func():
			current_shield.stat_value = max_shield.stat_derived_value
			current_shield.stat_derived_value_changed.connect(_on_current_shield_changed)
			max_shield.stat_derived_value_changed.connect(_on_max_shield_changed)
			current_shield_value_changed.emit(max_shield.stat_derived_value, max_shield.stat_derived_value)
			pass
	)

	
	shield_manager_ready.emit()
	pass


func _on_max_shield_changed_data(old_value : float, new_value : float):
	#current_shield.stat_derived_value = max_shield.stat_derived_value
	var shield_difference : float = current_shield.stat_derived_value - old_value 
	current_shield.stat_derived_value = new_value + shield_difference
	current_shield_value_changed.emit(current_shield.stat_derived_value, max_shield.stat_derived_value)
	max_shield_value_changed.emit(current_shield.stat_derived_value, max_shield.stat_derived_value)
	pass

func add_current_shield(shield : float):
	current_shield.stat_derived_value += shield
	_evaluate_shield()
	pass

func remove_current_shield(shield : float):
	current_shield.stat_derived_value -= shield
	_evaluate_shield()
	pass

func add_base_current_shield(shield : float):
	current_shield.stat_value +=  shield
	_evaluate_shield()

func remove_base_current_shield(shield : float):
	current_shield.stat_value -=  shield
	_evaluate_shield()

func add_max_shield(shield : float):
	max_shield.stat_derived_value += shield
	_evaluate_shield()
	pass

func remove_max_shield(shield : float):
	max_shield.stat_derived_value -= shield
	_evaluate_shield()
	pass

func add_base_max_shield(shield : float):
	max_shield.stat_value += shield
	_evaluate_shield()
	pass

func remove_base_max_shield(shield : float):
	max_shield.stat_value -= shield
	_evaluate_shield()
	pass

func _on_current_shield_changed():
	current_shield_value_changed.emit(current_shield.stat_derived_value, max_shield.stat_derived_value)
	_evaluate_shield()
	pass

func _on_max_shield_changed():
	max_shield_value_changed.emit(current_shield.stat_derived_value, max_shield.stat_derived_value)
	_evaluate_shield()
	pass

func _evaluate_shield():
	if current_shield.stat_derived_value <= 0:
		shield_depleted.emit()
	
	if !allow_greater and current_shield.stat_derived_value > max_shield.stat_derived_value:
		current_shield.stat_derived_value = max_shield.stat_derived_value
	
	if current_shield.stat_derived_value < max_shield.stat_derived_value:
		shield_regen_timer.start()
	else:
		shield_regen_timer.stop()
	
	pass

func _on_shield_depleted():
	#entity.velocity = Vector2.ZERO
	if owner is Entity:
		owner.velocity = Vector2.ZERO
		owner.die()
	pass

func _on_shield_regen_timer_timeout():
	add_current_shield(shield_regen.stat_derived_value)
	pass
