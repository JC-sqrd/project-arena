class_name Ability
extends Node2D



enum CoolDownOn {CAST, START, END}
enum AbilityState {INVOKED, START, ACTIVE, DORMANT}
enum CastMode {
	##The actor manually aims the ability on the mouse position
	AIM,
	##The ability automatically casts the ability on the mouse position 
	AUTO}

## Determines the cast mode of the ability
@export var required_stat : AbilityRequiredStat = AbilityRequiredStat.create("current_mana", 1)
@export var cast_mode : CastMode = CastMode.AUTO
@export var start_cooldown_on : CoolDownOn = CoolDownOn.CAST
@export var cast_time : float = 0

@export var hit_listener : HitListener
@export var ability_name : String
@export var cooldown : float = 1
@export_multiline var ability_description : String
@export_multiline var ability_details : String
@export var ability_icon_texture : Texture2D
@export var sockets : Array[AbilitySocket]

@onready var cooldown_timer : Timer = initialize_cooldown_timer()

@onready var actor : Entity = await get_ability_actor()
@onready var current_state : AbilityState = AbilityState.DORMANT
@onready var actor_stats : StatManager = get_actor_stat_manager() 
var active : bool = false
var can_cast : bool = true
var cooling_down : bool = false
var cast_data : Dictionary
var get_cast_position : bool = false

var _cdr : Stat # Cooldown reduction

##Emitted when an ability's action key is pressed
signal ability_invoked
##Emitted when an ability is casted (Usually after invoked)
signal ability_casted 
##Emitted when an ability starts (Usually after casted)
signal ability_start
##Emitted when ability is active (usually after ability start)
signal ability_active
##Emitted when ability ends (usually after ability active)
signal ability_end
##Emitted when ability is canceled
signal ability_canceled
##Emitted when an ability hits an entity
signal ability_hit(hit_data : HitData)
##Emitted when an ability applies damage
signal ability_applied_damage (damage : float)

signal cooldown_start()
signal cooldown_end()

func _enter_tree():
	if owner is Entity:
		actor = owner
	elif owner.has_method("get_actor"):
		actor = owner.get_actor()

func _ready():
	if owner is Entity:
		actor = owner
	elif owner.has_method("get_actor"):
		actor = owner.get_actor()
		print("Abiltiy name: " + str(name))
	for socket in sockets:
		socket.ability = self
		if socket.socketable != null:
			#socket.socketable.apply_effects_to_ability(self)
			socket.activate_socketable()
	if actor != null:
		actor.ready.connect(_on_actor_ready)
	ready.connect(_on_actor_ready)

func _on_ready():
	if actor != null:
		actor.ready.connect(_on_actor_ready)
		pass
	pass

func _on_actor_ready():
	if actor != null:
		if actor.stat_manager != null:
			_cdr = actor.stat_manager.get_stat("cooldown_reduction")
	pass

func initialize_ability():
	pass

#This function is to be overriden by all subclass of this class
func invoke_ability():
	pass

func get_ability_actor() -> Entity:
	if owner is Entity:
		return owner
	elif owner.has_method("get_actor"):
		await owner.ready
		return owner.get_actor()
	else:
		return null
	pass
func get_actor_stat_manager() -> StatManager:
	if actor != null:
		return actor.stat_manager
	else:
		return null
	pass

func get_actor() -> Entity:
	return actor

func cancel_ability():
	pass

func initialize_cooldown_timer() -> Timer:
	cooldown_timer = Timer.new()
	cooldown_timer.autostart = false
	cooldown_timer.wait_time = cooldown
	cooldown_timer.one_shot = false
	#cooldown_timer.timeout.connect(on_cooldown_timer_timeout)
	if start_cooldown_on == CoolDownOn.CAST:
		ability_casted.connect(start_cooldown)
		print(str(ability_name) + " start cooldown on Ability Cast")
	elif start_cooldown_on == CoolDownOn.START:
		ability_start.connect(start_cooldown)
		print(str(ability_name) + " start cooldown on Ability Start")
	elif start_cooldown_on == CoolDownOn.END:
		ability_end.connect(start_cooldown)
		print(str(ability_name) + " start cooldown on Ability End")
	cooldown_timer = cooldown_timer
	add_child(cooldown_timer)
	return cooldown_timer

func on_cooldown_timer_timeout():
	cooldown_end.emit()
	cooling_down = false
	can_cast = true
	pass

func start_cooldown():
	var cooldown_time : float = cooldown * (1 - (_cdr.stat_derived_value / 100))
	cooldown_timer.start(cooldown_time)
	cooling_down = true
	can_cast = false
	cooldown_start.emit()
	print(ability_name + " Start cooldown")
	pass
