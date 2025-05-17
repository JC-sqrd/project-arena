extends ProjectileWeapon

@export var throw_amount : int = 1
@export var return_speed : float = 700
@export var return_hit_listener : HitListener

var throwing : bool = false

func _ready():
	super()
	pass

func _process(delta):
	super(delta)
	projectile_weapon_process(delta)
	pass

func _weapon_process(delta : float):
	if !auto_fire and is_equipped:
		if action_held and actor.can_attack and can_attack:
			#_start_attack_cooldown()
			initialize_attack()
	elif is_equipped:
		if actor.can_attack and can_attack:
			#_start_attack_cooldown()
			initialize_attack()
	
	if _start_cooldown:
		cooldown_counter = 1 / attack_speed_stat.stat_derived_value 
		_start_cooldown = false
		can_attack = false
	
	if cooldown_counter > 0:
		cooldown_counter -= delta
	
	if cooldown_counter <= 0 and !can_attack and is_equipped:
		can_attack = true
		actor.can_attack = true
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
		throw_amount -= 1
		_spawn_projectile()
		await get_tree().create_timer(0.05, false, true, false).timeout
		throwing = false
	
	if look_at_mouse:
		rotation = lerp_angle(rotation, (get_global_mouse_position() - global_position).normalized().angle(), 10 * delta)
	pass

func initialize_attack():
	if throw_amount <= 0:
		actor.can_attack = false
	cooldown_counter = attack_cooldown
	start_attack()
	pass

func start_attack():
	if throw_amount > 0 and can_attack and !throwing:
		start_windup = true
		attack_windup_time = minf(attack_windup_time, 1 / attack_speed)
		attack_state = AttackState.START
		attacking = true
		throwing = true
		#attack_timer.wait_time = min(attack_windup_time, attack_cooldown)
		#attack_timer.start()
		attack_start.emit()
		actor.basic_attack.emit(self)
	pass

func end_attack():
	attack_state = AttackState.DORMANT
	#look_at_mouse = true
	attacking = false
	if throw_amount <= 0:
		_start_cooldown = true
	throw_amount += 1
	attack_end.emit()

func _spawn_projectile():
	if projectile != null:
		var new_projectile = projectile.instantiate()
		if new_projectile is ProjectileChakram:
			new_projectile.on_hit.connect(_on_attack_hit)
			if hit_listener != null:
				new_projectile.hit_data = hit_listener.generate_effect_data()
				print("CHAKRAM PROJECTILE SPAWN")
				if return_hit_listener != null:
					new_projectile.return_hit_data = return_hit_listener.generate_effect_data()
				else:
					new_projectile.return_hit_data = hit_listener.generate_effect_data()
			new_projectile.returned_to_actor.connect(end_attack)
			new_projectile.source = self
			new_projectile.max_distance = max_distance
			new_projectile.speed = speed
			new_projectile.return_speed = return_speed
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
	else:
		printerr("No projectile to spawn")
	pass


func _on_attack_hit(hit_data : Dictionary):
	if hit_listener != null:
		hit_listener.on_hit(hit_data)
	attack_hit.emit(hit_data)
	actor.basic_attack_hit.emit(hit_data)
	pass
