class_name DamageNumber
extends Node

#@export var entity : Entity

func _ready():
	if owner is Entity:
		owner.took_damage_with_data.connect(on_spawn_damage_number)
		owner.healed.connect(on_spawn_heal_number)
	#if entity != null:
		##entity.took_damage.connect(spawn_damage_number)
		#entity.took_damage_with_data.connect(on_spawn_damage_number)
		#entity.healed.connect(on_spawn_heal_number)
	pass

func on_spawn_damage_number(damage_data : DamageEffectData):
	var damage_taken = damage_data.total_damage#damage_data["total_damage"]
	var damage_type = damage_data.damage_type#["damage_type"]
	var is_critical : bool = false
	var blocked : bool = damage_data.blocked
	var dodged : bool = damage_data.dodged
	is_critical = damage_data.critical
	var desired_size : float = 22
	var damage_number : Label = Label.new()
	var text_color : Color
	if !dodged:
		if damage_type == Enums.DamageType.PHYSICAL:
			if is_critical:
				text_color = Color.ORANGE
				desired_size = 28
			else:
				text_color = Color(0.996, 0.173, 0.196)
		elif damage_type == Enums.DamageType.MAGIC:
			text_color = Color.DEEP_SKY_BLUE
		else:
			text_color = Color.WHITE
	else:
		text_color = Color.GRAY
	damage_number.global_position = owner.global_position + (Vector2.UP * 25) #+ (Vector2.RIGHT * randi_range(-15,15))
	if !dodged:
		damage_number.text = str(floorf(damage_taken))
	else:
		damage_number.text = "dodged"
	damage_number.z_index = 5
	damage_number.scale = Vector2.ONE * 1
	damage_number.label_settings = LabelSettings.new()
	#damage_number.self_modulate = text_color
	
	damage_number.label_settings.font_color = text_color
	damage_number.label_settings.font_size = desired_size
	damage_number.label_settings.outline_color = Color.BLACK
	damage_number.label_settings.outline_size = 10
	#damage_number.scale = Vector2.ZERO
	
	call_deferred("add_child", damage_number)
	
	await  damage_number.resized

	damage_number.pivot_offset = Vector2(damage_number.size / 2)
	var scale_tween : Tween = create_tween()
	var pos_tween : Tween = create_tween()
	var modulate_tween : Tween = create_tween()
	scale_tween.set_ease(Tween.EASE_IN)
	scale_tween.set_trans(Tween.TRANS_BACK)
	scale_tween.tween_property(damage_number, "scale", Vector2(0.5,0.5), 0.55)
	pos_tween.set_ease(Tween.EASE_OUT)
	pos_tween.set_trans(Tween.TRANS_BACK)
	pos_tween.tween_property(
		damage_number,
		"position",
		damage_number.position + (Vector2.UP * 100) + (Vector2.RIGHT * randi_range(-15,15)),
		0.6
		)
	pos_tween.finished.connect(func(): damage_number.queue_free())
	modulate_tween.set_ease(Tween.EASE_IN)
	modulate_tween.set_trans(Tween.TRANS_QUART)
	modulate_tween.tween_property(damage_number, "modulate", Color(1,1,1,0.25), 0.6)
	
	pass

#func on_spawn_damage_number(damage_data : Dictionary):
	#var damage_taken = damage_data["total_damage"]
	#var damage_type = damage_data["damage_type"]
	#var is_critical : bool = false
	#var blocked : bool = damage_data["blocked"]
	#if damage_data.has("critical"):
		#is_critical = damage_data["critical"]
	#var desired_size : float = 22
	#var damage_number : Label = Label.new()
	#var text_color : Color
	#if !blocked:
		#if damage_type == Enums.DamageType.PHYSICAL:
			#if is_critical:
				#text_color = Color.ORANGE
				#desired_size = 28
			#else:
				#text_color = Color(0.996, 0.173, 0.196)
		#elif damage_type == Enums.DamageType.MAGIC:
			#text_color = Color.DEEP_SKY_BLUE
		#else:
			#text_color = Color.WHITE
	#else:
		#text_color = Color.GRAY
	#damage_number.global_position = owner.global_position + (Vector2.UP * 25) #+ (Vector2.RIGHT * randi_range(-15,15))
	#if !blocked:
		#damage_number.text = str(floorf(damage_taken))
	#else:
		#damage_number.text = "blocked"
	#damage_number.z_index = 5
	#damage_number.scale = Vector2.ONE * 1
	#damage_number.label_settings = LabelSettings.new()
	##damage_number.self_modulate = text_color
	#
	#damage_number.label_settings.font_color = text_color
	#damage_number.label_settings.font_size = desired_size
	#damage_number.label_settings.outline_color = Color.BLACK
	#damage_number.label_settings.outline_size = 10
	##damage_number.scale = Vector2.ZERO
	#
	#call_deferred("add_child", damage_number)
	#
	#await  damage_number.resized
#
	#damage_number.pivot_offset = Vector2(damage_number.size / 2)
	#var scale_tween : Tween = create_tween()
	#var pos_tween : Tween = create_tween()
	#var modulate_tween : Tween = create_tween()
	#scale_tween.set_ease(Tween.EASE_IN)
	#scale_tween.set_trans(Tween.TRANS_BACK)
	#scale_tween.tween_property(damage_number, "scale", Vector2(0.5,0.5), 0.55)
	#pos_tween.set_ease(Tween.EASE_OUT)
	#pos_tween.set_trans(Tween.TRANS_BACK)
	#pos_tween.tween_property(
		#damage_number,
		#"position",
		#damage_number.position + (Vector2.UP * 100) + (Vector2.RIGHT * randi_range(-15,15)),
		#0.6
		#)
	#pos_tween.finished.connect(func(): damage_number.queue_free())
	#modulate_tween.set_ease(Tween.EASE_IN)
	#modulate_tween.set_trans(Tween.TRANS_QUART)
	#modulate_tween.tween_property(damage_number, "modulate", Color(1,1,1,0.25), 0.6)
	#
	#pass

func on_spawn_heal_number(heal_amount : float):
	var desired_size : float = 18
	var heal_number : Label = Label.new()
	var text_color : Color
	
	text_color = Color.LAWN_GREEN
	heal_number.global_position = owner.global_position + (Vector2.UP * 25) #+ (Vector2.RIGHT * randi_range(-10,10))
	heal_number.text = str(ceil(heal_amount))
	heal_number.z_index = 5
	heal_number.scale = Vector2.ONE * 1.5
	heal_number.label_settings = LabelSettings.new()
	heal_number.self_modulate = text_color
	
	heal_number.label_settings.font_color = "#FFF"
	heal_number.label_settings.font_size = desired_size
	heal_number.label_settings.outline_color = "#000"
	heal_number.label_settings.outline_size = 10
	#damage_number.scale = Vector2.ZERO
	
	call_deferred("add_child", heal_number)
	
	await  heal_number.resized

	heal_number.pivot_offset = Vector2(heal_number.size / 2)
	var scale_tween : Tween = create_tween()
	var pos_tween : Tween = create_tween()
	var modulate_tween : Tween = create_tween()
	scale_tween.set_ease(Tween.EASE_IN)
	scale_tween.set_trans(Tween.TRANS_BACK)
	scale_tween.tween_property(heal_number, "scale", Vector2(0.5,0.5), 0.55)
	pos_tween.set_ease(Tween.EASE_OUT)
	pos_tween.set_trans(Tween.TRANS_BACK)
	pos_tween.tween_property(heal_number, "position", heal_number.position + (Vector2.UP * 100), 0.6)
	pos_tween.finished.connect(func(): heal_number.queue_free())
	modulate_tween.set_ease(Tween.EASE_IN)
	modulate_tween.set_trans(Tween.TRANS_QUART)
	modulate_tween.tween_property(heal_number, "modulate", Color(1,1,1,0.25), 0.6)
	pass
