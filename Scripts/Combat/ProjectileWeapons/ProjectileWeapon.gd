class_name ProjectileWeapon
extends Weapon

@export var projectile : PackedScene
@export var speed : float = 100
@export var spawn_node : Node2D
@export var max_distance : float = 100
@export var look_at_mouse : bool = false
@export var sockets : Array[WeaponSocket]


var start_windup : bool = false
var winding_up : bool = false
var start_coll_timer : bool = false

var coll_enabled : bool = false
 
var windup_counter : float
var coll_enabled_counter : float

var attacking : bool = false

func _ready():
	super()
	for socket in sockets:
		socket.weapon = self
		if socket.socketable != null:
			#socket.socketable.apply_effects_to_ability(self)
			socket.activate_socketable()
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
		
	
	if start_coll_timer:
		start_coll_timer = false
		coll_enabled = true
		coll_enabled_counter = 0.01
		
	
	if coll_enabled_counter > 0:
		coll_enabled_counter -= delta
		
	if coll_enabled_counter <= 0 and coll_enabled:
		coll_enabled = false
		coll_enabled_counter = 0
		end_attack()
		
	if look_at_mouse:
		rotation = lerp_angle(rotation, (get_global_mouse_position() - global_position).normalized().angle(), 10 * delta)
	pass

func start_attack():
	if !attacking and can_attack:
		start_windup = true
		attack_windup_time = minf(attack_windup_time, 1 / attack_speed)
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
	if projectile != null:
		var new_projectile = projectile.instantiate()
		
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
			new_projectile.rotation = global_position.direction_to(get_global_mouse_position()).angle()
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
	actor.basic_attack_hit.emit(hit_data)
	pass
