class_name WeaponMuzzleParticles2D
extends GPUParticles2D

@export var look_at_mouse : bool = true

var weapon : Weapon
var mouse_angle_degree : float = 0
var particle_process_material : ParticleProcessMaterial

func _ready():
	if owner is Weapon:
		weapon = owner
		weapon.equipped.connect(_on_weapon_equipped)
	if process_material != null:
		particle_process_material = process_material as ParticleProcessMaterial
	one_shot = true
	pass




func _on_weapon_equipped(actor : Entity):
	if look_at_mouse:
		weapon.attack_active.connect(_emit_muzzle_particle_mouse_angled)
	else:
		weapon.attack_active.connect(_emit_muzzle_particle)
	pass


func _emit_muzzle_particle_mouse_angled():
	var mouse_angle : float = -rad_to_deg(weapon.actor.global_position.direction_to(get_global_mouse_position()).angle())
	particle_process_material.angle_min = mouse_angle
	particle_process_material.angle_max = mouse_angle
	emitting = false
	restart()
	emitting = true
	pass

func _emit_muzzle_particle():
	emitting = false
	restart()
	emitting = true
	pass
