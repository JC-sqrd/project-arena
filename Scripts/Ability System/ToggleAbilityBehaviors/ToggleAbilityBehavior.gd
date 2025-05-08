class_name ToggleAbilityBehavior
extends Node


var toggle_ability : ToggleAbility


func _ready() -> void:
	if owner is ToggleAbility:
		toggle_ability = owner
