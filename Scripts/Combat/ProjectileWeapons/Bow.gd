extends ProjectileWeapon

@export var charge_time : float = 0.5
@export var arrow_sprite : Node2D
var throw_counter : float = 0

var charge_bow : bool = false
var full_charged : bool = false
var charge : float = 0

signal charge_start()
signal charge_end()
signal charging_bow()
signal bow_released()

func _process(delta):
	super(delta)
	if charge_bow and !full_charged:
		charge += delta
		charging_bow.emit()
	
	if charge >= charge_time and !full_charged:
		charge = charge_time
		print("BOW CHARGED")
		full_charged = true
	
	
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

func _weapon_process(delta : float):
	if auto_fire and is_equipped:
		if actor.can_attack and can_attack:
			#_start_attack_cooldown()
			initialize_attack()
			_start_cooldown = true
	
	if _start_cooldown:
		cooldown_counter = 1 / attack_speed_stat.stat_derived_value 
		_start_cooldown = false
		can_attack = false
	
	if cooldown_counter > 0:
		cooldown_counter -= delta
	
	if cooldown_counter <= 0 and !can_attack:
		can_attack = true
		actor.can_attack = true
	pass

func _spawn_projectile():
	spawn_arrow(charge)
	charge = 0
	pass

func spawn_arrow(charge : float):
	if projectile != null:
		var new_projectile = projectile.instantiate()
		
		if new_projectile is Projectile:
			new_projectile.on_hit.connect(_on_attack_hit)
			if hit_listener != null:
				var effect_data : Dictionary = hit_listener.generate_effect_data()
				new_projectile.hit_data = effect_data
				if effect_data.has("damage_effect"):
					effect_data["damage_effect"]["damage"] *= max(0.5, 2 * (charge/charge_time))
				
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

func attack_key_pressed():
	if can_attack:
		charge_bow = true
		charge_start.emit()
		print("BOW CHARGE START")
	pass

func attack_key_released():
	if charge_bow:
		charge_bow = false
		full_charged = false
		print("BOW CHARGE: " + str(charge/charge_time))
		charge_end.emit()
		_spawn_projectile()
		_start_cooldown = true
	pass

func attack_key_held():
	if can_attack and !charge_bow:
		charge_bow = true
		charge_start.emit()
		print("BOW CHARGE START")
	pass
