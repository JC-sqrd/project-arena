class_name ExpOrb
extends Pickupable

@export var exp : float = 20
var player : PlayerCharacter


func _ready():
	var tween : Tween = create_tween()
	for child in get_children():
		if child is Area2D:
			child.process_mode = 4
		pass
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "position", position + (Vector2.UP * 30), 0.5)
	tween.finished.connect(func() : 
		for child in get_children():
			if child is Area2D:
				child.process_mode = 0
				pass
	)
	pass
		

func pickup(entity : Entity):
	if entity is PlayerCharacter:
		var player_level_manager : LevelManager = entity.level_manager
		player_level_manager.add_exp(exp)
		picked_up.emit()
		queue_free()
	pass

	
