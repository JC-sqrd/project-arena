class_name ProjectileWeapon
extends Weapon

@export var projectile : PackedScene
@export var spread_degrees : float = 15
@export var speed : float = 100
@export var spawn_node : Node2D
@export var max_distance : float = 100
@export var look_at_mouse : bool = false



var start_windup : bool = false
var winding_up : bool = false
var start_coll_timer : bool = false
#var coll_enabled : bool = false
var windup_counter : float
#var coll_enabled_counter : float
var attacking : bool = false

var _projectile_count : int = 1
var _spawn_count : int = 0
var _start_angle : float = 0
var _base_angle : float = 0
var _angle_step : float = 0
var _spawn_angle : float = 0
var _spread : float = 0
var _spawn_index : float = 0


func _ready():
	super()
	pass

func _process(delta):
	super(delta)
	projectile_weapon_process(delta)
	pass

func projectile_weapon_process(delta : float):
	if start_windup:
		start_windup = false
		winding_up = true
		windup_counter = attack_windup_time
	
	if windup_counter > 0:
		windup_counter -= delta
	
	if windup_counter <= 0 and winding_up:
		winding_up = false
		windup_counter = 0
		start_coll_timer = true
		_spawn_projectile()
		
	
	#if start_coll_timer:
		#start_coll_timer = false
		#coll_enabled = true
		#coll_enabled_counter = 0.01
		#
	#
	#if coll_enabled_counter > 0:
		#coll_enabled_counter -= delta
		#
	#if coll_enabled_counter <= 0 and coll_enabled:
		#coll_enabled = false
		#coll_enabled_counter = 0
		#end_attack()
		
	if look_at_mouse:
		rotation = lerp_angle(rotation, (get_global_mouse_position() - global_position).normalized().angle(), 10 * delta)
	pass

func start_attack():
	if !attacking and can_attack:
		start_windup = true
		attack_windup_time = minf(attack_windup_time, 1 / attack_speed_stat.stat_derived_value)
		attack_state = AttackState.START
		attacking = true
		#attack_timer.wait_time = min(attack_windup_time, attack_cooldown)
		#attack_timer.start()
		attack_start.emit()
		actor.basic_attack.emit(self)
	pass

func end_attack():
	attack_state = AttackState.DORMANT
	#look_at_mouse = true
	attacking = false
	attack_end.emit()

func _spawn_projectile():
	_spawn_count = _projectile_count + int(actor.stat_manager.get_stat("projectile_count").stat_derived_value)
	if projectile != null:
		_base_angle = spawn_node.global_position.direction_to(get_global_mouse_position()).angle()
		_spread = deg_to_rad(spread_degrees)
		_start_angle = _base_angle - _spread * 0.5
		_angle_step = _spread / (_spawn_count)
		_spawn_index = 0
		
		if _spawn_count == 1:
			var new_projectile = projectile.instantiate()
			_spawn_angle = _start_angle + (_spawn_index  * _angle_step)
			print("PROJECTILE ANGLE: " + str(_spawn_angle) + " " + str(_start_angle))
			if new_projectile is Projectile:
				new_projectile.on_hit.connect(_on_attack_hit)
				if hit_listener != null:
					new_projectile.hit_data = hit_listener.generate_effect_data()
				new_projectile.max_distance_reached.connect(func() : attack_end.emit())
				new_projectile.source = self
				new_projectile.max_distance = max_distance
				new_projectile.speed = speed
				get_tree().root.add_child(new_projectile)
				new_projectile.set_collision_mask_value(actor.original_coll_layer, false)
				if spawn_node != null:
					new_projectile.position = spawn_node.global_position
				else:
					new_projectile.position = global_position
				#new_projectile.direction = ((get_global_mouse_position() + position) - position).normalized()
				#new_projectile.rotation = global_position.direction_to(get_global_mouse_position()).angle()
				new_projectile.rotation = _base_angle
				attack_active.emit()
				actor.basic_attack.emit(self)
				end_attack()
				return
		
		while _spawn_count > 0:
			var new_projectile = projectile.instantiate()
			_spawn_angle = _start_angle + (_spawn_index  * _angle_step)
			print("PROJECTILE ANGLE: " + str(_spawn_angle) + " " + str(_start_angle))
			if new_projectile is Projectile:
				new_projectile.on_hit.connect(_on_attack_hit)
				if hit_listener != null:
					new_projectile.hit_data = hit_listener.generate_effect_data()
				new_projectile.max_distance_reached.connect(func() : attack_end.emit())
				new_projectile.source = self
				new_projectile.max_distance = max_distance
				new_projectile.speed = speed
				get_tree().root.add_child(new_projectile)
				new_projectile.set_collision_mask_value(actor.original_coll_layer, false)
				if spawn_node != null:
					new_projectile.position = spawn_node.global_position
				else:
					new_projectile.position = global_position
				#new_projectile.direction = ((get_global_mouse_position() + position) - position).normalized()
				#new_projectile.rotation = global_position.direction_to(get_global_mouse_position()).angle()
				new_projectile.rotation = _spawn_angle
				_spawn_count -= 1
				_spawn_index += 1
			attack_active.emit()
			actor.basic_attack.emit(self)
			end_attack()
	else:
		printerr("No projectile to spawn")
	pass



func _on_attack_hit(hit_data : Dictionary):
	if hit_listener != null:
		hit_listener.on_hit(hit_data)
	attack_hit.emit(hit_data)
	if actor != null:
		actor.basic_attack_hit.emit(hit_data)
	pass
