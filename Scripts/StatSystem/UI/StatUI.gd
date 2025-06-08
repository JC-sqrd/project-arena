class_name StatUI
extends Control


enum StatDisplay {BONUS, BASE, DERIVED, }

@export var actor : Entity
@export var stat_name : String = "Stat"
@export var stat_id : String
@export var stat_display : StatDisplay = StatDisplay.BONUS
@export var stat_icon : Texture

@onready var stat_icon_rect: TextureRect = $HBoxContainer/StatIconRect
@onready var stat_value_label: Label = $HBoxContainer/StatValueLabel
@onready var stat_name_label: Label = $HBoxContainer/StatNameLabel


var stat : Stat


func initialize(actor : Entity):
	print("STAT UI ACTOR: " + str(actor))
	if actor != null:
		stat = actor.stat_manager.get_stat(stat_id)
		if stat != null:
			stat_name_label.text = stat_name + ": "
			if stat_display == StatDisplay.BONUS:
				stat.stat_derived_value_changed_data.connect(_on_bonus_value_changed)
				stat_value_label.text = str(stat.bonus_value)
				pass
			elif stat_display == StatDisplay.BASE:
				stat.stat_derived_value_changed_data.connect(_on_base_value_changed)
				stat_value_label.text = str(stat.bonus_value)
				pass
			elif stat_display == StatDisplay.DERIVED:
				stat.stat_derived_value_changed_data.connect(_on_derived_value_changed)
				stat_value_label.text = str(stat.stat_derived_value)
				pass
			pass
		pass
	if stat_icon != null:
		stat_icon_rect.texture = stat_icon
		pass
	pass

func _on_bonus_value_changed(old_value : float, new_value : float):
	_evaluate_stat_label_color(stat.bonus_value)
	stat_value_label.text += str(stat.bonus_value)
	pass

func _on_base_value_changed(old_value : float, new_value : float):
	_evaluate_stat_label_color(stat.stat_value)
	stat_value_label.text += str(stat.stat_value)
	pass

func _on_derived_value_changed(old_value : float, new_value : float):
	_evaluate_stat_label_color(stat.stat_derived_value)
	stat_value_label.text += str(stat.stat_derived_value)
	pass

func _evaluate_stat_label_color(stat_value : float):
	if stat_value > 0:
		stat_value_label.modulate = Color.GREEN
		stat_value_label.text = "+"
		pass
	elif stat_value < 0:
		stat_value_label.modulate = Color.RED
		stat_value_label.text = ""
	else:
		stat_value_label.modulate = Color.WHITE
		stat_value_label.text = ""
	pass
