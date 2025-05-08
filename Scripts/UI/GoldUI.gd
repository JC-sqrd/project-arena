class_name GoldUI
extends Control


@export var gold_stat : Stat
@onready var gold_label: Label = %GoldLabel

func _ready() -> void:
	gold_stat.stat_derived_value_changed_data.connect(on_gold_changed)
	
	
func on_gold_changed(old_value : float, new_value : float):
	gold_label.text = " " + str(floorf(new_value))
	pass
	
