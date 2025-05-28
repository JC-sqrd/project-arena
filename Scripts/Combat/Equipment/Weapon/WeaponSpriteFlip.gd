class_name WeaponSpriteFlip
extends Node


@export var sprite : Sprite2D
var weapon : Weapon

var mouse_angle_degree : float = 0

func _ready() -> void:
	if owner is Weapon:
		weapon = owner

func _process(delta: float) -> void:
	if weapon.is_equipped and sprite != null:
		mouse_angle_degree = -rad_to_deg(weapon.actor.global_position.direction_to(sprite.get_global_mouse_position()).angle())
		if !(mouse_angle_degree <= 90 and mouse_angle_degree >= -90):
			sprite.flip_v = true
		else:
			sprite.flip_v = false
	pass
