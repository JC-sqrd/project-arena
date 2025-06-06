extends TextureProgressBar

@export var health_manager : HealthManager
#@export var shield_progress_bar : TextureProgressBar
#@export var under_health_bar : TextureProgressBar
@export var show_health_text : bool = true : set = _set_show_health_text

@onready var health_label: Label = $HealthLabel
@onready var shield_progress_bar: TextureProgressBar = $ShieldProgressBar
@onready var under_health_bar: TextureProgressBar = $UnderHealthBar

func _ready():
	health_label.visible = show_health_text
	if health_manager == null:
		printerr("Health bar does not have a health manager reference for: " + owner.name)
		pass
		
	owner.ready.connect(
		func():
			max_value = health_manager.max_health.stat_derived_value + health_manager.current_shield.stat_derived_value
			shield_progress_bar.max_value = health_manager.max_health.stat_derived_value + health_manager.current_shield.stat_derived_value
			value = health_manager.current_health.stat_derived_value 
			shield_progress_bar.value = health_manager.current_health.stat_derived_value + health_manager.current_shield.stat_derived_value
			health_label.text = str(value)
			if health_manager != null:
				health_manager.current_health_value_changed.connect(update_health_ui)
				health_manager.max_health_value_changed.connect(update_health_ui)
			pass
			if under_health_bar != null:
				under_health_bar.max_value = max_value#health_manager.max_health.stat_derived_value
				under_health_bar.value = value#health_manager.current_health.stat_derived_value
				pass
	)
	pass

func initialize():
	value = health_manager.max_health.stat_derived_value
	pass


func update_health_ui(new_current : float, new_max : float):
	#Increase
	if new_current > value:
		#Tween the bar value then update the values
		if under_health_bar != null:
			under_health_bar.max_value = new_max + health_manager.current_shield.stat_derived_value  
			under_health_bar.tint_progress = Color.SPRING_GREEN
			var tween : Tween = create_tween()
			tween.tween_property(under_health_bar, "value", new_current, 0.5)
			tween.finished.connect(
				func():
						max_value = new_max + health_manager.current_shield.stat_derived_value
						if health_manager.current_health.stat_derived_value <= health_manager.max_health.stat_derived_value:
							value = health_manager.current_health.stat_derived_value
							shield_progress_bar.max_value = health_manager.max_health.stat_derived_value + health_manager.current_shield.stat_derived_value
							shield_progress_bar.value = value + health_manager.current_shield.stat_derived_value
							health_label.text = str(ceilf(health_manager.current_health.stat_derived_value))
			)
	#Decrease
	elif new_current < value:
		#Update the values then tween the bar value
		max_value = new_max + health_manager.current_shield.stat_derived_value
		value = new_current
		shield_progress_bar.max_value = health_manager.max_health.stat_derived_value + health_manager.current_shield.stat_derived_value
		shield_progress_bar.value = health_manager.current_health.stat_derived_value + health_manager.current_shield.stat_derived_value
		health_label.text = str(ceilf(new_current))
		if under_health_bar != null:
			under_health_bar.max_value = max_value
			under_health_bar.tint_progress = Color.ORANGE_RED
			var tween : Tween = create_tween()
			var tint_tween : Tween = create_tween()
			tint_tween.set_ease(Tween.EASE_IN)
			tint_tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(under_health_bar, "value", new_current, 0.5)
			tint_tween.tween_property(under_health_bar, "tint_progress", Color.WHITE, 0.5)
	elif new_current == value:
		value = new_current
	#max_value = new_max
	#value = new_current
	#health_label.text = str(ceilf(new_current))
	pass

func _set_show_health_text(value : bool):
	show_health_text = value 
	if health_label != null:
		health_label.visible = value
	pass
