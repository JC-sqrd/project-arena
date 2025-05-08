extends TextureProgressBar

@export var mana_manager : ManaManager
@export var mana_label : Label
@export var under_manabar : TextureProgressBar

func _ready():
	if mana_manager == null:
		printerr("mana bar does not have a mana manager reference for: " + owner.name)
		pass
		
	owner.ready.connect(
		func():
			max_value = mana_manager.max_mana.stat_derived_value
			value = mana_manager.current_mana.stat_derived_value
			mana_label.text = str(value)
			if mana_manager != null:
				mana_manager.current_mana_value_changed.connect(update_mana_ui)
				mana_manager.max_mana_value_changed.connect(update_mana_ui)
			pass
			if under_manabar != null:
				under_manabar.max_value = mana_manager.max_mana.stat_derived_value
				under_manabar.value = mana_manager.current_mana.stat_derived_value
				pass
	)
	pass

func initialize():
	value = mana_manager.max_mana.stat_derived_value
	pass


func update_mana_ui(new_current : float, new_max : float):
	#Increase
	if new_current > value:
		#Tween the bar value then update the values
		if under_manabar != null:
			under_manabar.max_value = new_max
			under_manabar.tint_progress = Color.SPRING_GREEN
			max_value = new_max
			var tween : Tween = create_tween()
			tween.tween_property(under_manabar, "value", new_current, 0.5)
			tween.finished.connect(
				func():
						max_value = new_max
						if mana_manager.current_mana.stat_derived_value <= mana_manager.max_mana.stat_derived_value:
							value = mana_manager.current_mana.stat_derived_value
							mana_label.text = str(ceilf(mana_manager.current_mana.stat_derived_value))
						pass
			)
	#Decrease
	elif new_current < value:
		#Update the values then tween the bar value
		max_value = new_max
		value = new_current
		mana_label.text = str(ceilf(new_current))
		if under_manabar != null:
			under_manabar.max_value = max_value
			under_manabar.tint_progress = Color("d2ff69")
			var tween : Tween = create_tween()
			var tint_tween : Tween = create_tween()
			tint_tween.set_ease(Tween.EASE_IN)
			tint_tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(under_manabar, "value", new_current, 0.5)
			tint_tween.tween_property(under_manabar, "tint_progress", Color.WHITE, 0.5)
	elif new_current == value:
		value = new_current
	#max_value = new_max
	#value = new_current
	#mana_label.text = str(ceilf(new_current))
	pass
