class_name WeaponAbilityAnimatedSprite2D
extends AnimatedSprite2D

enum VisibleOn {CAST, START, ACTIVE, END}

@export var weapon_anim_sprite : AnimatedSprite2D
@export var ability : Ability
@export var weapon : Weapon
@export var weapon_sprite_visible_on : VisibleOn = VisibleOn.START
@export var flip_on_weapon : bool = false
var anim_speed : float = 0
var mouse_angle_degree : float = 0


func _ready() -> void:
	visible = false
	if ability != null:
		ability.ability_casted.connect(_on_ability_cast)
		animation_finished.connect(_on_animation_finished)
	if weapon_sprite_visible_on == VisibleOn.CAST:
		ability.ability_casted.connect(_show_weapon_sprite)
	elif weapon_sprite_visible_on == VisibleOn.START:
		ability.ability_start.connect(_show_weapon_sprite)
	elif weapon_sprite_visible_on == VisibleOn.ACTIVE:
		ability.ability_active.connect(_show_weapon_sprite)
	elif weapon_sprite_visible_on == VisibleOn.END:
		ability.ability_end.connect(_show_weapon_sprite)

func _process(delta: float) -> void:
	if weapon.is_equipped:
		mouse_angle_degree = -rad_to_deg(weapon.actor.global_position.direction_to(get_global_mouse_position()).angle())
		if !(mouse_angle_degree <= 90 and mouse_angle_degree >= -90):
			flip_v = true
		else:
			flip_v = false
	pass


func _on_ability_cast():
	visible = true
	weapon_anim_sprite.visible = false
	play("cast_animation")
	pass

func _on_animation_finished():
	visible = false
	#weapon_anim_sprite.visible = true
	pass

func _on_ability_end():
	weapon_anim_sprite.visible = true
	pass

func _show_weapon_sprite():
	weapon_anim_sprite.visible = true
	pass
