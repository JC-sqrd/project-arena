class_name MeleeAnimationPlayer
extends AnimationPlayer

var melee_weapon : MeleeWeapon
@export var max_speed_scale : float = 5
@export var animation : Animation

func _ready() -> void:
	if owner is MeleeWeapon:
		melee_weapon = owner
		melee_weapon.attack_start.connect(on_weapon_attack_start)
		melee_weapon.windup_done.connect(on_weapon_attack_start)
		melee_weapon.attack_speed_stat.stat_derived_value_changed.connect(update_animation_speed_scale)
		update_animation_speed_scale()
	animation_finished.connect(on_attack_animation_finished)

func on_weapon_attack_start():
	play("attack")
	pass

func on_weapon_windup_start():
	play("windup")
	pass

func on_attack_animation_finished(anim_name : StringName):
	if anim_name == "attack":
		stop()
	pass

func update_animation_speed_scale():
	speed_scale = min(max_speed_scale, melee_weapon.attack_speed_stat.stat_derived_value)
	pass
