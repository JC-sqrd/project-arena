extends AnimatedSprite2D

var input_vector : Vector2

func _ready() -> void:
	if owner is Entity:
		owner.took_damage.connect(_on_damage_taken)

func _process(delta):
	input_vector = get_movement_input()
	
	if input_vector.x >= 1:
		play("side_idle")
		flip_h = false
	elif input_vector.x <= -1:
		play("side_idle")
		flip_h = true
	elif input_vector.y >= 1:
		play("front_idle")
	elif input_vector.y <= -1:
		play("back_idle")
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

func get_movement_input() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")
