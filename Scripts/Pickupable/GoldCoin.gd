class_name GoldCoin
extends Pickupable


@export var gold_add : float = 1
@export var gold_number_scene : PackedScene

func _ready():
	var tween : Tween = create_tween()
	for child in get_children():
		if child is Area2D:
			child.process_mode = 4
		pass
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "position", position + (Vector2.UP * randf_range(-30,30)), 0.5)
	tween.finished.connect(func() : 
		for child in get_children():
			if child is Area2D:
				child.process_mode = 0
				pass
	)
	pass


func pickup(entity : Entity):
	if entity is PlayerCharacter:
		entity.gold_manager.add_gold(gold_add)
		#entity.stat_manager.stats.get("gold").stat_value += gold_add
	picked_up.emit()
	_lerp_weight_counter = _lerp_weight
	queue_free()
	pass
