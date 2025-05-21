class_name AddGoldOnSlain
extends Node


@export var gold_add : float = 0
@export var gold_label_color : Color = Color.GOLD
@export var active : bool = true

func _ready() -> void:
	if owner is Entity:
		if active:
			owner.slain.connect(_on_slain)
		pass


func _on_slain(slain_by : Entity):
	if slain_by != null and slain_by.stat_manager.stats.has("gold"):
		slain_by.stat_manager.stats.get("gold").stat_value += gold_add
		spawn_gold_number(slain_by)
	pass

func spawn_gold_number(slain_by : Entity):
	var desired_size : float = 22
	var gold_number : Label = Label.new()
	var text_color : Color = gold_label_color

	gold_number.global_position = slain_by.global_position + (Vector2.RIGHT * -30) #+ (Vector2.RIGHT * randi_range(-10,10))
	gold_number.text = "+" + str(floorf(gold_add))
	gold_number.z_index = 5
	gold_number.scale = Vector2.ONE * 1
	gold_number.label_settings = LabelSettings.new()
	gold_number.self_modulate = text_color
	
	gold_number.label_settings.font_color = "#FFF"
	gold_number.label_settings.font_size = desired_size
	gold_number.label_settings.outline_color = "#000"
	gold_number.label_settings.outline_size = 10
	#gold_number.scale = Vector2.ZERO
	
	call_deferred("add_child", gold_number)
	
	await  gold_number.resized

	gold_number.pivot_offset = Vector2(gold_number.size / 2)
	var scale_tween : Tween = create_tween()
	var pos_tween : Tween = create_tween()
	var modulate_tween : Tween = create_tween()
	scale_tween.set_ease(Tween.EASE_IN)
	scale_tween.set_trans(Tween.TRANS_BACK)
	scale_tween.tween_property(gold_number, "scale", Vector2(0.5,0.5), 0.8)
	pos_tween.set_ease(Tween.EASE_OUT)
	pos_tween.set_trans(Tween.TRANS_BACK)
	pos_tween.tween_property(gold_number, "position", gold_number.position + (Vector2.UP * 100), 0.6)
	pos_tween.finished.connect(func(): gold_number.queue_free())
	modulate_tween.set_ease(Tween.EASE_IN)
	modulate_tween.set_trans(Tween.TRANS_QUART)
	modulate_tween.tween_property(gold_number, "modulate", Color(1,1,1,0.25), 0.6)
	pass
