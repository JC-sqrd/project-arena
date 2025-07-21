class_name StateIndicatorContainer
extends Control

@onready var h_box_container: HBoxContainer = %HBoxContainer
const STATE_INDICATOR = preload("res://Scenes/UI/StateIndicator/state_indicator.tscn")


static func create_state_indicator(lifetime : float, icon : Texture, description : String, is_permanent : bool = false) -> StateIndicator:
	var state_indicator_ui : StateIndicator = STATE_INDICATOR.instantiate() as StateIndicator
	state_indicator_ui.lifetime = lifetime
	state_indicator_ui.icon = icon
	state_indicator_ui.description = description
	state_indicator_ui.is_permanent = is_permanent
	return state_indicator_ui
	pass

func add_state_indicator(state_indicator : StateIndicator):
	h_box_container.add_child(state_indicator)
	if state_indicator.icon != null:
		state_indicator.state_indicator_icon.texture = state_indicator.icon
	state_indicator.start_indicator_lifetime(state_indicator.lifetime)
	pass




func remove_state_indicator():
	pass
