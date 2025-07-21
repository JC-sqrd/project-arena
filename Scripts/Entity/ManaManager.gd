class_name ManaManager
extends Node

@export var stat_manager : StatManager
@export var max_mana : Stat
@export var current_mana : Stat
@export var mana_regen : Stat
@export var allow_greater : bool = false

var mana_regen_timer : Timer

signal mana_depleted()
signal mana_manager_ready()
signal current_mana_value_changed(current_mana : float, max_mana : float)
signal max_mana_value_changed(current_mana : float, max_mana : float)

func _ready():
	mana_regen_timer = Timer.new()
	mana_regen_timer.autostart = false
	mana_regen_timer.one_shot = false
	mana_regen_timer.wait_time = 1
	mana_regen_timer.timeout.connect(_on_mana_regen_timer_timeout)
	add_child(mana_regen_timer)
	mana_depleted.connect(_on_mana_depleted)
	
	max_mana.ready.connect(
		func():
			current_mana_value_changed.emit(max_mana.stat_derived_value, max_mana.stat_derived_value)
	)
	
	max_mana.stat_derived_value_changed_data.connect(_on_max_mana_changed_data)

	owner.ready.connect(
		func():
			current_mana.stat_value = max_mana.stat_derived_value
			current_mana.stat_derived_value_changed.connect(_on_current_mana_changed)
			max_mana.stat_derived_value_changed.connect(_on_max_mana_changed)
			current_mana_value_changed.emit(max_mana.stat_derived_value, max_mana.stat_derived_value)
			pass
	)

	
	mana_manager_ready.emit()
	pass


func _process(delta: float) -> void:
	if current_mana.stat_derived_value >= max_mana.stat_derived_value and mana_regen_timer.is_stopped():
		return
	elif current_mana.stat_derived_value < max_mana.stat_derived_value and mana_regen_timer.is_stopped():
		print("Start mana regen timer")
		mana_regen_timer.start()
	elif current_mana.stat_derived_value >= max_mana.stat_derived_value and !mana_regen_timer.is_stopped():
		print("Stop mana regen timer")
		mana_regen_timer.stop()
		
	pass

func _on_max_mana_changed_data(old_value : float, new_value : float):
	#current_mana.stat_derived_value = max_mana.stat_derived_value
	var mana_difference : float = current_mana.stat_derived_value - old_value 
	current_mana.stat_derived_value = new_value + mana_difference
	current_mana_value_changed.emit(current_mana.stat_derived_value, max_mana.stat_derived_value)
	max_mana_value_changed.emit(current_mana.stat_derived_value, max_mana.stat_derived_value)
	pass

func add_current_mana(mana : float):
	current_mana.stat_derived_value += mana
	_evaluate_mana()
	pass

func remove_current_mana(mana : float):
	current_mana.stat_derived_value -= mana
	_evaluate_mana()
	pass

func add_base_current_mana(mana : float):
	current_mana.stat_value +=  mana
	_evaluate_mana()

func remove_base_current_mana(mana : float):
	current_mana.stat_value -=  mana
	_evaluate_mana()

func add_max_mana(mana : float):
	max_mana.stat_derived_value += mana
	_evaluate_mana()
	pass

func remove_max_mana(mana : float):
	max_mana.stat_derived_value -= mana
	_evaluate_mana()
	pass

func add_base_max_mana(mana : float):
	max_mana.stat_value += mana
	_evaluate_mana()
	pass

func remove_base_max_mana(mana : float):
	max_mana.stat_value -= mana
	_evaluate_mana()
	pass

func _on_current_mana_changed():
	current_mana_value_changed.emit(current_mana.stat_derived_value, max_mana.stat_derived_value)
	_evaluate_mana()
	pass

func _on_max_mana_changed():
	max_mana_value_changed.emit(current_mana.stat_derived_value, max_mana.stat_derived_value)
	_evaluate_mana()
	pass

func _evaluate_mana():
	if current_mana.stat_derived_value <= 0:
		current_mana.stat_derived_value_changed.disconnect(_on_current_mana_changed)
		current_mana.stat_derived_value = 0
		current_mana.stat_derived_value_changed.connect(_on_current_mana_changed)
		mana_depleted.emit()
	
	if !allow_greater and current_mana.stat_derived_value > max_mana.stat_derived_value:
		current_mana.stat_derived_value = max_mana.stat_derived_value
	pass

func _on_mana_depleted():
	#entity.velocity = Vector2.ZERO
	pass

func _on_mana_regen_timer_timeout():
	add_current_mana(mana_regen.stat_derived_value)
	pass
