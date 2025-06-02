class_name AbilityIconUI
extends Control


var ability_container : AbilityContainer
var ability_icon_texture : Texture2D
@export var ability_icon_text_rect : TextureRect
@export var default_icon : Texture2D
@export var ability_key_label : Label
@export var cooldown_progresss_bar : TextureProgressBar
@onready var ability_count_label: Label = $TextureRect/AbilityCountLabel

var cooldown_time : float = 0
var cooldown_time_counter : float = 0

func _ready():
	ability_container.cooldown_start.connect(_on_ability_container_cooldown)
	#ability_container.ability.cooldown_start.connect(_on_ability_cooldown)
	ability_container.cooling_down.connect(on_ability_container_cooling_down)
	ability_container.cooldown_end.connect(_on_ability_container_cooldown_end)
	
	if ability_container.ability != null and ability_container.ability.ability_icon_texture == null:
		ability_icon_text_rect.texture = default_icon
	else:
		ability_icon_text_rect.texture = ability_icon_texture
	#print("Input map actions: " + str(InputMap.get_actions()))
	ability_key_label.text = ability_container.ability_action_trigger
	
	#assigning your input action from Project Settings Input Map
	var prompt_action = ability_container.ability_action_trigger
	if InputMap.has_action(prompt_action):
		#will depend on how many keys assigned to action
		var key_action : InputEvent = InputMap.action_get_events(prompt_action)[0]
		if key_action is InputEventKey:
			var key_string = OS.get_keycode_string(key_action.physical_keycode)
			ability_key_label.text = str(key_string)
	pass

func _on_ability_container_cooldown():
	cooldown_time = ability_container.cooldown_timer.wait_time
	cooldown_time_counter = cooldown_time / cooldown_time
	ability_count_label.text = str((ability_container.ability as ActiveAbility).ability_count) 
	#var tween : Tween = create_tween()
	#cooldown_progresss_bar.max_value = ability_container.ability_cooldown - 1
	cooldown_progresss_bar.value = cooldown_progresss_bar.max_value 
	#tween.tween_property(cooldown_progresss_bar, "value", 0, ability_container.ability_cooldown)
	pass

func _on_ability_container_cooldown_end():
	ability_count_label.text = str((ability_container.ability as ActiveAbility).ability_count)
	pass

func _on_ability_cooldown():
	cooldown_time = ability_container.cooldown_timer.wait_time
	cooldown_time_counter = cooldown_time / cooldown_time
	#var tween : Tween = create_tween()
	#cooldown_progresss_bar.max_value = ability_container.ability_cooldown - 1
	cooldown_progresss_bar.value = cooldown_progresss_bar.max_value 
	#tween.tween_property(cooldown_progresss_bar, "value", 0, ability_container.ability_cooldown)
	pass

func _process(delta):
	#if !ability_container.cooldown_timer.is_stopped():
		#cooldown_progresss_bar.value = ability_container.cooldown_timer.time_left
	#	cooldown_progresss_bar.value = lerpf(cooldown_progresss_bar.value, ability_container.cooldown_timer.time_left, 1)
	#	pass
	pass

func on_ability_container_cooling_down(time_left : float):
	cooldown_time_counter = lerpf(cooldown_time_counter, (time_left / cooldown_time), 1)
	cooldown_progresss_bar.value = cooldown_progresss_bar.max_value * cooldown_time_counter
	#print("Cooldown time left: " + str(cooldown_time_counter))
	pass

func get_assigned_input_event_key(action : String):
	for a in InputMap.action_get_events("interact"):
		var key : InputEventKey = a as InputEventKey
		if key != null:
			return OS.get_keycode_string(key.keycode)
	pass
