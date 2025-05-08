extends Node

class_name AbilityBehavior

var ability : Ability



func _ready():
	var parent = get_parent()
	if parent is Ability:
		ability = parent
	assert(ability != null, "Ability behavior is not attached to an Ability class")
