class_name ActiveAbility
extends Ability

enum InputMode {PRESSED, HELD}
@export var input_mode : PressedAbilityInputMode = PressedAbilityInputMode.new()

func get_cast_data() -> Dictionary:
	var data : Dictionary
	var getting_cast_data : bool = true
	if cast_mode == CastMode.AIM and !active:
		if Input.is_action_just_pressed("confirm"):
			data["target_position"] = actor.get_global_mouse_position()
			cast_data = data
			get_cast_position = false
			actor.stat_manager.stats[required_stat.stat_name].stat_derived_value -= required_stat.required_value
			ability_casted.emit()
			await get_tree().create_timer(cast_time, false, true, false).timeout
			ability_start.emit()
		elif Input.is_action_just_pressed("cancel"):
			ability_canceled.emit()
	elif cast_mode == CastMode.AUTO and !active:
		data["target_position"] = actor.get_global_mouse_position()
		cast_data = data
		get_cast_position = false
		actor.stat_manager.stats[required_stat.stat_name].stat_derived_value -= required_stat.required_value
		ability_casted.emit()
		await get_tree().create_timer(cast_time, false, true, false).timeout
		ability_start.emit()
	return data
	pass
