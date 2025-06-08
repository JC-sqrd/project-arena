class_name AbilityContainer
extends Node2D

@export var ability_action_trigger : String
@export var actor : Entity
@export var ability : Ability : set = _set_ability
@export var mana : Stat
@export var ability_cooldown : float = 1
@export var start_cooldown_on : Ability.AbilityState = Ability.AbilityState.START
var ability_icon : Texture2D
@onready var cooldown_timer : Timer #= $Timer

var required_stat : Stat

var can_cast : bool = true

var _ability_input_buffer : float = 0.35
var _ability_input_buffer_counter : float = 0 

signal ability_triggered
signal cooldown_start()
signal cooldown_end()
signal cooling_down(time_left : float)

func _ready():
	#cooldown_timer.wait_time = ability_cooldown
	if ability != null:
		ability_icon = ability.ability_icon_texture
		ability_cooldown = ability.cooldown
		ability.actor = actor
		ability.initialize_ability()
	
	if ability != null:
		ability.actor = actor
		ability.initialize_ability()
		#if start_cooldown_on == Ability.CoolDownOn.CAST:
			#ability.ability_invoked.connect(_start_cooldown)
			#ability.actor = actor
			#ability.initialize_ability()
		#elif start_cooldown_on == Ability.CoolDownOn.START:
			#ability.ability_start.connect(_start_cooldown)
			#ability.actor = actor
			#ability.initialize_ability()
		#elif start_cooldown_on == Ability.CoolDownOn.END:
			#ability.ability_end.connect(_start_cooldown)
			#ability.actor = actor
			#ability.initialize_ability()
		#else:
			#printerr("Cannot start cooldown on ability active")
	pass

func _process(delta):
	if Input.is_action_just_pressed(ability_action_trigger) and ability != null:
		#Input.action_release(ability_action_trigger)
		if actor.stat_manager.stats[ability.required_stat.stat_name].stat_derived_value >= ability.required_stat.required_value and _ability_input_buffer_counter <= 0:
			_ability_input_buffer_counter = _ability_input_buffer
			#get_tree().create_timer(0.05, false, true, false).timeout.connect(func(): 
				#ability.invoke_ability()
				#ability_triggered.emit()
				#)
		#ability.invoke_ability()
		#ability_triggered.emit()
	
	if _ability_input_buffer_counter > 0 and ability.can_cast and actor.can_cast:
		_ability_input_buffer_counter = 0
		get_tree().create_timer(0.05, false, true, false).timeout.connect(func(): 
			ability.invoke_ability()
			ability_triggered.emit()
			)
		pass
	
	if _ability_input_buffer_counter > 0:
		_ability_input_buffer_counter -= delta
	
	
	if !ability.cooldown_timer.is_stopped():
		cooling_down.emit(ability.cooldown_timer.time_left)
	pass

func _start_cooldown():
	can_cast = false
	ability.cooling_down = true
	cooldown_timer.wait_time = ability_cooldown
	cooldown_timer.start()
	cooldown_start.emit()


func _reset_ability():
	cooldown_timer.stop()
	can_cast = true

func _set_ability(new_ability : Ability):
	if ability != null:
		ability.ready.disconnect(_on_ability_ready)
		ability.remove_from_group("equipped_abilities")
	if new_ability != null:
		new_ability.ready.connect(_on_ability_ready)
		#cooldown_timer = new_ability.cooldown_timer
		#ability_cooldown = new_ability.cooldown
		#new_ability.cooldown_start.connect(_on_ability_cooldown_start)
		#new_ability.cooldown_timer.timeout.connect(_reset_ability)
		#if new_ability.start_cooldown_on == Ability.CoolDownOn.CAST:
			#new_ability.ability_casted.connect(_start_cooldown)
			#new_ability.actor = actor
			#new_ability.initialize_ability()
		#elif new_ability.start_cooldown_on == Ability.CoolDownOn.START:
			#new_ability.ability_start.connect(_start_cooldown)
			#new_ability.actor = actor
			#new_ability.initialize_ability()
		#elif new_ability.start_cooldown_on == Ability.CoolDownOn.END:
			#new_ability.ability_end.connect(_start_cooldown)
			#new_ability.actor = actor
			#new_ability.initialize_ability()
	ability = new_ability
	ability.add_to_group("equipped_abilities")
	ability_icon = new_ability.ability_icon_texture
	pass

func _on_ability_ready():
	if ability != null:
		cooldown_timer = ability.cooldown_timer
		ability_cooldown = ability.cooldown
		ability.cooldown_end.connect(_on_ability_cooldown_end)
		ability.cooldown_start.connect(_on_ability_cooldown_start)
		ability.cooldown_timer.timeout.connect(_reset_ability)
		if ability.start_cooldown_on == Ability.CoolDownOn.CAST:
			ability.ability_casted.connect(_start_cooldown)
			ability.actor = actor
			ability.initialize_ability()
		elif ability.start_cooldown_on == Ability.CoolDownOn.START:
			ability.ability_start.connect(_start_cooldown)
			ability.actor = actor
			ability.initialize_ability()
		elif ability.start_cooldown_on == Ability.CoolDownOn.END:
			ability.ability_end.connect(_start_cooldown)
			ability.actor = actor
			ability.initialize_ability()
	pass

func _on_ability_cooldown_end():
	cooldown_end.emit()
	pass

func _on_ability_start():
	actor.stat_manager.stats[ability.required_stat.stat_name].stat_derived_value -= ability.required_stat.required_value
	pass

func _on_ability_cooldown_start():
	#cooldown_start.emit()
	pass
