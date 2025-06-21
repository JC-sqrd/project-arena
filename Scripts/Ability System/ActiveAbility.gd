class_name ActiveAbility
extends Ability

enum InputMode {PRESSED, HELD}
@export var input_mode : PressedAbilityInputMode = PressedAbilityInputMode.new()
@export var ability_count : int = 1
@export var hit_listener : HitListener
var listen_for_cast : bool = false

func get_cast_data() -> Dictionary:
	var data : Dictionary
	var getting_cast_data : bool = true
	if cast_mode == CastMode.AIM and !active:
		if Input.is_action_just_pressed("confirm"):
			data["target_position"] = actor.get_global_mouse_position()
			cast_data = data
			listen_for_cast = false
			actor.stat_manager.stats[required_stat.stat_name].stat_derived_value -= required_stat.required_value
			ability_casted.emit()
			await get_tree().create_timer(cast_time, false, true, false).timeout
			ability_start.emit()
		elif Input.is_action_just_pressed("cancel"):
			ability_canceled.emit()
	elif cast_mode == CastMode.AUTO and !active:
		data["target_position"] = actor.get_global_mouse_position()
		cast_data = data
		listen_for_cast = false
		actor.stat_manager.stats[required_stat.stat_name].stat_derived_value -= required_stat.required_value
		ability_casted.emit()
		print("ABILITY " + str(name)+" CASTED")
		await get_tree().create_timer(cast_time, false, true, false).timeout
		ability_start.emit()
	return data
	pass

func start_cooldown():
	var cooldown_time : float = cooldown * (1 - (_cdr.stat_derived_value / 100))
	get_tree().create_timer(cooldown_time, false, false, false).timeout.connect(on_cooldown_timer_timeout)
	ability_count -= 1
	if ability_count == 0:
		#cooldown_timer.start()
		cooling_down = true
		can_cast = false
	cooldown_start.emit(cooldown_time)
	pass

func on_cooldown_timer_timeout():
	ability_count += 1
	cooldown_end.emit()
	cooling_down = false
	can_cast = true
	pass

func disable_ability():
	super()
	listen_for_cast = false
	pass
