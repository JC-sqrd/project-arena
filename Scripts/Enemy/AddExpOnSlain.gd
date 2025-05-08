class_name AddExpOnSlain
extends Node


@export var exp_add : float = 0
@export var exp_label_color : Color = Color.PURPLE

func _ready() -> void:
	if owner is Entity:
		owner.slain.connect(_on_slain)
		pass


func _on_slain(slain_by : Entity):
	slain_by.level_manager.add_exp(exp_add)
	
	var desired_size : float = 22
	var exp_number : Label = Label.new()
	var text_color : Color = exp_label_color

	exp_number.global_position = slain_by.global_position + (Vector2.RIGHT * 15) #+ (Vector2.RIGHT * randi_range(-10,10))
	exp_number.text = "+" + str(floorf(exp_add)) + "xp"
	exp_number.z_index = 5
	exp_number.scale = Vector2.ONE * 1
	exp_number.label_settings = LabelSettings.new()
	exp_number.self_modulate = text_color
	
	exp_number.label_settings.font_color = "#FFF"
	exp_number.label_settings.font_size = desired_size
	exp_number.label_settings.outline_color = "#000"
	exp_number.label_settings.outline_size = 10
	#exp_number.scale = Vector2.ZERO
	
	call_deferred("add_child", exp_number)
	
	await  exp_number.resized

	exp_number.pivot_offset = Vector2(exp_number.size / 2)
	var scale_tween : Tween = create_tween()
	var pos_tween : Tween = create_tween()
	var modulate_tween : Tween = create_tween()
	scale_tween.set_ease(Tween.EASE_IN)
	scale_tween.set_trans(Tween.TRANS_BACK)
	scale_tween.tween_property(exp_number, "scale", Vector2(0.5,0.5), 0.8)
	pos_tween.set_ease(Tween.EASE_OUT)
	pos_tween.set_trans(Tween.TRANS_BACK)
	pos_tween.tween_property(exp_number, "position", exp_number.position + (Vector2.UP * 100), 0.6)
	pos_tween.finished.connect(func(): exp_number.queue_free())
	modulate_tween.set_ease(Tween.EASE_IN)
	modulate_tween.set_trans(Tween.TRANS_QUART)
	modulate_tween.tween_property(exp_number, "modulate", Color(1,1,1,0.25), 0.6)
	pass
