class_name AbilityIconUI
extends Control


@export var default_icon : Texture2D

var ability_container : AbilityContainer
var ability : Ability
var ability_icon_texture : Texture2D

@onready var icon_texture_rect: TextureRect = $IconTextureRect
@onready var ability_count_label: Label = $TextureRect/AbilityCountLabel
@onready var key_label: Label = $IconTextureRect/KeyLabel
@onready var cooldown_progress_bar: TextureProgressBar = $IconTextureRect/CooldownProgressBar

var cooldown_time : float = 0
var cooldown_time_counter : float = 0


func _ready():
	#ability_key_label.text = ability_container.ability_action_trigger
	
	#assigning your input action from Project Settings Input Map
	#var prompt_action = ability_container.ability_action_trigger
	#if InputMap.has_action(prompt_action):
		##will depend on how many keys assigned to action
		#var key_action : InputEvent = InputMap.action_get_events(prompt_action)[0]
		#if key_action is InputEventKey:
			#var key_string = OS.get_keycode_string(key_action.physical_keycode)
			#ability_key_label.text = str(key_string)
	pass


func initialize_ability_icon_with_container(ability_container : AbilityContainer):
	self.ability_container = ability_container
	self.ability = ability_container.ability
	
	connect_signals()
	
	if ability_container.ability != null and ability_container.ability.ability_icon_texture == null:
		icon_texture_rect.texture = default_icon
	else:
		icon_texture_rect.texture = ability_container.ability.ability_icon_texture
	
	var prompt_action : StringName = ability_container.ability_action_trigger
	if InputMap.has_action(prompt_action):
		#will depend on how many keys assigned to action
		var key_action : InputEvent = InputMap.action_get_events(prompt_action)[0]
		if key_action is InputEventKey:
			var key_string = OS.get_keycode_string(key_action.physical_keycode)
			key_label.text = str(key_string)
	pass

func initialize_ability_icon(ability : Ability, action_trigger : String):
	self.ability = ability
	
	connect_signals()
	
	if ability == null:
		icon_texture_rect.texture = default_icon
	elif ability != null and ability.ability_icon_texture == null:
		icon_texture_rect.texture = default_icon
	elif ability != null:
		icon_texture_rect.texture = ability.ability_icon_texture
	
	var prompt_action : StringName = action_trigger
	if InputMap.has_action(prompt_action):
		#will depend on how many keys assigned to action
		var key_action : InputEvent = InputMap.action_get_events(prompt_action)[0]
		if key_action is InputEventKey:
			var key_string = OS.get_keycode_string(key_action.physical_keycode)
			key_label.text = str(key_string)
	pass


func connect_signals():
	if ability != null:
		ability.cooldown_start.connect(_on_ability_cooldown_start)
		ability.cooldown_end.connect(_on_ability_cooldown_end)
	pass


func _on_ability_cooldown_start(cooldown : float):
	var tween : Tween = create_tween()
	cooldown_progress_bar.value = cooldown_progress_bar.max_value
	tween.tween_property(cooldown_progress_bar, "value", 0, cooldown)
	pass

func _on_ability_cooldown_end():
	cooldown_progress_bar.value = 0
	pass
