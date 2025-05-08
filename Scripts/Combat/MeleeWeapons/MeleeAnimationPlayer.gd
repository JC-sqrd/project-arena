class_name MeleeAnimationPlayer
extends AnimationPlayer

var melee_weapon : MeleeWeapon
@export var animation : Animation

func _ready() -> void:
	if owner is MeleeWeapon:
		melee_weapon = owner
		melee_weapon.attack_start.connect(on_weapon_attack_start)

func on_weapon_attack_start():
	play("attack_animation")
	pass
