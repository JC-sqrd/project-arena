class_name WeaponSprite
extends Sprite2D

var weapon : Weapon
var mouse_angle_degree : float = 0

func _ready() -> void:
	if owner is Weapon:
		weapon = owner

func _process(delta: float) -> void:
	if weapon.is_equipped:
		mouse_angle_degree = -rad_to_deg(weapon.actor.global_position.direction_to(get_global_mouse_position()).angle())
		if !(mouse_angle_degree <= 90 and mouse_angle_degree >= -90):
			flip_v = true
		else:
			flip_v = false
	pass
