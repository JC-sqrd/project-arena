class_name SelfTargetAbility
extends Ability

func _ready() -> void:
	super()

func invoke_ability():
	ability_casted.emit()
	ability_start.emit()
	ability_active.emit()
	if hit_listener != null:
		actor.on_hit.emit(_create_hit_data())
	ability_end.emit()
	pass

func _create_hit_data() -> Dictionary:
	var hit_data : Dictionary
	if hit_listener != null:
		hit_data = hit_listener.generate_effect_data()
	hit_data["target"] = actor
	hit_data["source"] = self
	hit_data["actor"] = actor
	return hit_data
