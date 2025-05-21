extends AnimatedSprite2D

@export var entity : Entity

func _ready():
	if entity != null:
		entity.took_damage.connect(_on_damage_taken)
	pass

func _on_damage_taken(damage : float):
	#material.set("shader_parameter/hit_opacity", 1.0)
	stop()
	play("hurt")
	var tween : Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_method(set_hit_opacity, 0.0, 1, 0.2)
	tween.finished.connect(func():
		var transparent_tween = create_tween()
		transparent_tween.set_ease(Tween.EASE_IN)
		transparent_tween.set_trans(Tween.TRANS_QUART)
		transparent_tween.tween_method(set_hit_opacity, 0.5, 0.0, 0.1)
	)
	pass

func set_hit_opacity(value : float):
	material.set("shader_parameter/hit_opacity", value)
	pass
