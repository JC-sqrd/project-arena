class_name MeleeSprite2D
extends Sprite2D


@export var weapon : Weapon
@export var flip_on_weapon : bool = false
var anim_speed : float = 0
var mouse_angle_degree : float = 0

func _process(delta: float) -> void:
	if weapon.is_equipped:
		mouse_angle_degree = -rad_to_deg(weapon.actor.global_position.direction_to(get_global_mouse_position()).angle())
		if !(mouse_angle_degree <= 90 and mouse_angle_degree >= -90):
			flip_v = true
		else:
			flip_v = false
	pass
