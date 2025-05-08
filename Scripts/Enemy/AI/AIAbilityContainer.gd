class_name AIAbilityContainer
extends AbilityContainer

var enemy : Enemy

func activate_ability():
	await get_tree().create_timer(0.05, false, true, false)
	if ability.can_cast:
			ability_triggered.emit()
			ability.ability_casted.emit()
			ability.cast_data["target_position"] = enemy.player.global_position
			ability.ability_start.emit()
	if !ability.cooldown_timer.is_stopped():
		cooling_down.emit(ability.cooldown_timer.time_left)
	pass

func _process(delta):
	pass
