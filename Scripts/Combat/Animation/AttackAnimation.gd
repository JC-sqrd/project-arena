extends AnimatedSprite2D


@export var weapon : Weapon
@export var flip_on_weapon : bool = false
var anim_speed : float = 0
var mouse_angle_degree : float = 0

func _ready():
	if weapon != null:
		print(weapon.name)
		weapon.attack_start.connect(_play_wind_up)
		weapon.attack_active.connect(_play_attack)
		weapon.ready.connect(
			func():
				await weapon.actor.ready
				weapon.attack_speed_stat.stat_derived_value_changed_data.connect(_on_weapon_speed_changed)
				anim_speed = weapon.attack_speed_stat.stat_derived_value
				if anim_speed < 1:
					anim_speed = 1
		)
		
		#weapon.weapon_start.connect(_play_weapon_anim)
		#weapon.weapon_end.connect(_stop_weapon_anim)
	pass

func _play_weapon_anim():
	#position = weapon.get_coll_position()
	anim_speed = weapon.actor.stat_manager.get_stat("attack_speed").stat_derived_value
	print("Animation speed: " + str(anim_speed))
	#speed_scale = 1 - weapon.weapon_windup_time
	play("attack", anim_speed, false)
	if flip_on_weapon:
		flip_h = !flip_h
	if !is_playing():
		pass
	pass

func _process(delta: float) -> void:
	if weapon.is_equipped:
		mouse_angle_degree = -rad_to_deg(weapon.actor.global_position.direction_to(get_global_mouse_position()).angle())
		if !(mouse_angle_degree <= 90 and mouse_angle_degree >= -90):
			flip_v = true
		else:
			flip_v = false
	pass

func _play_wind_up():
	#position = weapon.get_coll_position()
	play("windup", anim_speed, false)
	pass

func _play_attack():
	#position = weapon.get_coll_position()
	play("attack", anim_speed, false)
	if flip_on_weapon:
		flip_h = !flip_h
	pass

func _stop_weapon_anim():
	stop()
	pass

func _on_weapon_speed_changed(old_value : float, new_value : float):
	if new_value < 1:
		anim_speed = 1
	else:
		anim_speed = new_value
	pass
