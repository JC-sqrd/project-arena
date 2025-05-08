class_name AbilityIPE
extends ItemPassiveEffect

@export var ability : Ability
@export var cooldown : Stat


func _ready():
	super()
	var timer : Timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_cooldown_end)
	timer.one_shot = false
	timer.wait_time = cooldown.stat_derived_value
	timer.autostart = true
	timer.start()


func apply_passive_effect(actor : Entity):
	pass

func _on_cooldown_end():
	ability.cast_data["target_position"] = owner.actor.get_global_mouse_position() 
	ability.ability_start.emit()
	pass
