class_name ToggleAbility
extends ActiveAbility

var toggled : bool = false : set = set_toggled

signal ability_toggled_on ()
signal ability_toggled_off ()

func _ready() -> void:
	ability_start.connect(on_ability_start)
	cast_mode = CastMode.AUTO

func invoke_ability():
	ability_invoked.emit()
	ability_start.emit()
	pass

func on_ability_start():
	toggled = !toggled
	pass

func set_toggled(new_value : bool):
	toggled = new_value
	if toggled:
		ability_toggled_on.emit()
		print("Ability toggled on")
	else:
		ability_toggled_off.emit()
		print("Ability toggled off")
