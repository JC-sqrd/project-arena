class_name MeleeWeapon
extends Weapon

@export var offset : float
@export var piercing : bool = false
@export var debug_visual : bool = false
@export var filter : SpawnableEnterFilter = SpawnableRayFilter.new()
@export var look_at_mouse : bool = false

#Onready

@onready var coll_enabled_timer : Timer = $CollisionEnabledTimer
@onready var hitbox_coll : CollisionShape2D = $CollisionShape2D
@onready var rect_shape : RectangleShape2D = RectangleShape2D.new()
@onready var attack_timer: Timer = $AttackTimer


var area_size_mult : float = 1

var windup_counter : float = 0
var start_windup : bool = false
var winding_up : bool = false

var coll_enabled_counter : float = 0
var start_coll_timer : bool = false
var coll_enabled : bool = false

var attacking : bool = false

#ATTACK FLOW: start attack(attack wind up) -> enable attack collider
# -> end attack (disable collider)

func _ready():
	super()
	pass

func _process(delta):
	super(delta)
	melee_weapon_process(delta)
	pass

func melee_weapon_process(delta : float):
	if start_windup:
		start_windup = false
		winding_up = true
		attack_windup_time = minf(attack_windup_time, 1 / attack_speed)
		windup_counter = attack_windup_time
	
	if windup_counter > 0:
		windup_counter -= delta
	
	if windup_counter <= 0 and winding_up:
		winding_up = false
		windup_counter = 0
		start_coll_timer = true
		look_at_mouse = false
	
	if start_coll_timer:
		start_coll_timer = false
		coll_enabled = true
		coll_enabled_counter = 0.01
		_enable_coll()
		modulate = Color.ORANGE_RED
	
	if coll_enabled_counter > 0:
		coll_enabled_counter -= delta
		
	if coll_enabled_counter <= 0 and coll_enabled:
		coll_enabled = false
		coll_enabled_counter = 0
		end_attack()
		modulate = Color.WHITE
	
	if look_at_mouse:
		#look_at(get_global_mouse_position())
		rotation = lerp_angle(rotation, (get_global_mouse_position() - global_position).normalized().angle(), 10 * delta)
		#rotation = lerp(rotation, (get_global_mouse_position() - global_position).normalized().angle(), 0.1) #get_global_mouse_position().normalized().angle()
	pass


func start_attack():
	#rect_shape.size = hitbox_size
	#hitbox_coll.shape = rect_shape
	if !attacking and can_attack:
		start_windup = true
		attack_state = AttackState.START
		attacking = true
		attack_timer.wait_time = min(attack_windup_time, attack_cooldown)
		attack_timer.start()
		attack_start.emit()
		actor.basic_attack.emit(self)
		
		if debug_visual:
			queue_redraw()
			
	pass

func _enable_coll():
	attack_state = AttackState.ACTIVE
	attack_timer.stop()
	look_at_mouse = false
	hitbox_coll.disabled = false
	#coll_enabled_timer.start()
	attack_active.emit()
	_hit_enemy()
	
	if debug_visual:
		queue_redraw()
	pass

func end_attack():
	attack_state = AttackState.DORMANT
	#coll_enabled_timer.stop()
	#look_at_mouse = true
	attacking = false
	attack_end.emit()
	#enemy_hits.clear()
	
	if debug_visual:
		queue_redraw()
	pass

func set_coll_position():
	hitbox_coll.position = Vector2.ZERO + (Vector2(1,0) * (offset / floorf(scale.length())))

func get_coll_position() -> Vector2:
	return hitbox_coll.position
	
#func get_enemy_hit(body : Node2D):
	#if body is Entity:
		#if piercing and body != actor:
			#body.on_hit.emit()
			#enemy_hit = body
			#enemy_hits.append(body)
			##attack_hits.emit(enemy_hits)
			#var hit_data = _create_hit_data(enemy_hit)
			#attack_hit.emit(hit_data)
			#if hit_listener != null:
				#hit_listener.on_hit(hit_data)
		#elif body != actor:
			#var space : PhysicsDirectSpaceState2D = get_viewport().world_2d.direct_space_state
			#var ray : PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(global_position,body.position, 2)
			#var result = space.intersect_ray(ray)
			#if result.size() != 0 and result["collider"] == body:
				##Enemy gets hit and takes damage
				#body.on_hit.emit()
				#enemy_hit = body
				#enemy_hits.append(body)
				##attack_hits.emit(enemy_hits)
				#var hit_data = _create_hit_data(enemy_hit)
				#attack_hit.emit(hit_data)
				#if hit_listener != null:
					#hit_listener.on_hit(hit_data)
				#
		#
		#
		#if debug_visual:
			#queue_redraw()
	#pass

func get_enemy_hit(body : Node2D):
	if body.is_in_group("Hittable"):
		enemy_hits.append(body)
		#if piercing and body != actor:
			#enemy_hit = body
			#enemy_hits.append(body)
			#attack_hits.emit(enemy_hits)
			
		#elif body != actor:
			#var space : PhysicsDirectSpaceState2D = get_viewport().world_2d.direct_space_state
			#var ray : PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(global_position,body.position, 2)
			#var result = space.intersect_ray(ray)
			#if result.size() != 0 and result["collider"] == body:
				##Enemy gets hit and takes damage
				#enemy_hit = body
				#enemy_hits.append(body)


		if debug_visual:
			queue_redraw()
	pass

func _remove_enemy_hit(body : Node2D):
	if body is Entity:
		enemy_hits.erase(body)
	pass

func _hit_enemy():
	for enemy in enemy_hits:
		var hit_data : Dictionary = _create_hit_data(enemy)
		if hit_listener != null and filter.is_valid(self, enemy, enemy_hits):
			attack_hit.emit(hit_data)
			enemy.on_hit.emit(hit_data)
			hit_listener.on_hit(hit_data)
			actor.basic_attack_hit.emit(hit_data)
		pass
	pass

func on_equipped(actor : Entity):
	super(actor)
	if actor.stat_manager.stats.has("area_size"):
		actor.stat_manager.stats["area_size"].stat_changed.connect(
			func():
				area_size_mult = actor.stat_manager.stats["area_size"].stat_derived_value
				scale = Vector2.ONE
				scale *= area_size_mult
				#set_coll_position()
		)
		area_size_mult = actor.stat_manager.stats["area_size"].stat_derived_value
	scale *= area_size_mult
	self.body_entered.connect(get_enemy_hit)
	self.body_exited.connect(_remove_enemy_hit)
	#hitbox_coll = $CollisionShape2D
	#Initialization
	attack_windup_time = minf(attack_windup_time, 1 / attack_speed)
	attack_timer.wait_time = attack_windup_time	
	#hitbox_coll.set_deferred("disabled", true)
	#set_coll_position()
	#rect_shape.size = hitbox_size
	#hitbox_coll.set_deferred("shape", rect_shape)
	pass


func _draw():
	if look_at_mouse == false:
		var line_start = Vector2(hitbox_coll.position.x - ((hitbox_coll.position.x) - offset),
		hitbox_coll.position.y)
		var line_end = Vector2(hitbox_coll.position.x + ((hitbox_coll.position.x) - offset),
		hitbox_coll.position.y)
		#draw_line(line_start,line_end, Color(Color.DARK_GOLDENROD, 0.45), hitbox_size.y)
	
	for enemy in enemy_hits:
		if enemy != null:
			draw_line(position, to_local(enemy.position), Color.CRIMSON, 5)
