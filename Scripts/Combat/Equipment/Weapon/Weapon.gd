class_name Weapon
extends Equipment


enum AttackState {START,ACTIVE, DORMANT}


@export var attack_windup_time : float
@export var look_at_mouse : bool = true
@export var weapon_ability : Ability
@export var hit_listener : HitListener
@export var sockets : Array[WeaponSocket]
@export_category("Weapon Stats")
@export var attack_damage : Stat : set = _set_attack_damage
@export var attack_speed_stat : Stat 


var action_trigger : String 
var action_held : bool = false
var auto_fire : bool = false
var can_attack : bool = true
var attack_cooldown : float
var cooldown_counter : float
var attack_speed : float
var attack_state : AttackState = AttackState.DORMANT
var enemy_hits : Array[Entity]
var enemy_hit : Node2D

var _ability_input_buffer : float = 0.01
var _ability_input_buffer_counter : float = 0

var _start_cooldown : bool = false

signal attack_start
signal attack_active
signal attack_hits(enemy_hits : Array[Node2D]) # Deprecated
signal attack_hit(hit_data : HitData)
signal attack_end 
signal windup_done()

func _ready():
	equipped.connect(on_equipped)
	unequipped.connect(on_unequipped)
	for socket in sockets:
		socket.weapon = self
		if socket.socketable != null:
			#socket.socketable.apply_effects_to_ability(self)
			socket.activate_socketable()
		pass

func _unhandled_input(event: InputEvent) -> void:
	#print(str(event))
	
	
	if is_equipped and event is InputEventKey and event.is_pressed() and event.keycode == KEY_G and event.echo == false:
		auto_fire = !auto_fire
	
	if is_equipped and event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			attack_key_pressed()
			action_held = true
		elif event.button_index == 1 and event.is_released():
			attack_key_released()
			action_held = false
	
	
	#Ability trigger
	#if is_equipped and  Input.is_action_just_pressed(action_trigger):
		#if weapon_ability != null and weapon_ability.can_cast and actor.can_cast:
			#if actor.stat_manager.stats[weapon_ability.required_stat.stat_name].stat_derived_value >= weapon_ability.required_stat.required_value:
				#_ability_input_buffer_counter = _ability_input_buffer
				#get_tree().create_timer(0.05, false, true, false).timeout.connect(func(): 
					#weapon_ability.invoke_ability()
					#)
				#pass
	pass

func _process(delta: float) -> void:
	_weapon_process(delta)
	
	if action_held:
		attack_key_held()
	pass

func _weapon_process(delta : float):
	if is_equipped:
		if !auto_fire and is_equipped:
			if action_held and actor.can_attack and can_attack:
				#_start_attack_cooldown()
				initialize_attack()
				_start_cooldown = true
		elif is_equipped:
			if actor.can_attack and can_attack:
				#_start_attack_cooldown()
				initialize_attack()
				_start_cooldown = true
		
		#if _ability_input_buffer_counter and weapon_ability.can_cast:
			#_ability_input_buffer_counter = 0
			#get_tree().create_timer(0.05, false, true, false).timeout.connect(func(): 
				#weapon_ability.invoke_ability()
				#)
			#pass
		#
		#if _ability_input_buffer_counter > 0:
			#_ability_input_buffer_counter -= delta
		
		if _start_cooldown:
			cooldown_counter = 1 / attack_speed_stat.stat_derived_value
			_start_cooldown = false
			can_attack = false
		
		if cooldown_counter > 0:
			cooldown_counter -= delta
		
		if cooldown_counter <= 0 and !can_attack and is_equipped:
			can_attack = true
			cooldown_counter = 0
			#actor.can_attack = true
	pass

func start_attack():
	pass
	
func end_attack():
	pass

func attack_key_pressed():
	pass

func attack_key_released():
	pass

func attack_key_held():
	pass

#func _create_hit_data(entity_hit : Entity) -> HitData:
	#var hit_data = HitData.create()
	#hit_data.data["target"] = entity_hit
	#hit_data.data["source"] = self
	#hit_data.data["actor"] = actor
	#return hit_data
	#pass

func initialize_attack():
	#actor.can_attack = false
	cooldown_counter = attack_cooldown
	start_attack()
	pass

func _create_hit_data(entity_hit : Entity) -> Dictionary:
	var hit_data : Dictionary
	if hit_listener != null:
		hit_data = hit_listener.generate_effect_data()
	hit_data["target"] = entity_hit
	hit_data["source"] = self
	hit_data["actor"] = actor
	return hit_data
	pass

func get_actor() -> Entity:
	return actor


func _set_attack_damage(new_attack_damage : Stat):
	attack_damage = new_attack_damage
	if actor != null:
		actor.stat_manager.stats["weapon_damage"] = new_attack_damage

func _set_actor_weapon_damage():
	actor.stat_manager.stats["weapon_damage"] = attack_damage
	pass

func on_equipped(actor : Entity):
	if actor != null:
		actor.ready.connect(_set_actor_weapon_damage)
		if hit_listener != null:
			if !actor.hit_listeners.has(hit_listener):
				actor.hit_listeners.append(hit_listener)
	if weapon_ability != null:
		weapon_ability.actor = actor
		print("WEAPON ACTOR: " + str(actor))
		#weapon_ability.ready.emit()
	ready.emit()
	pass

func on_unequipped():
	#if weapon_ability != null:
		#weapon_ability.process_mode = Node.PROCESS_MODE_DISABLED
	pass
