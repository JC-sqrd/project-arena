class_name WeaponFlipRotation
extends Node

var weapon : Weapon
var mouse_angle_degree : float = 0
var parent : Node2D

var flip_left : bool = false
var flip_right : bool = false

var flip : bool = false

func _ready():
	if owner is Weapon:
		weapon = owner
		weapon.equipped.connect(_on_weapon_equipped)
		pass
	parent = get_parent()
	
	#mouse_angle_degree = -rad_to_deg(owner.global_position.direction_to(owner.get_global_mouse_position()).angle())
	#var original_y = parent.position.y
	#if !(mouse_angle_degree <= 90 and mouse_angle_degree >= -90) and flip_left == false:
		##Flip vertically
		#parent.position.y = -original_y
		#print("Flip Left: " + str(parent.position.y))
		#flip_left = true
		#flip_right = false
		#pass
	#elif (mouse_angle_degree <= 90 and mouse_angle_degree >= -90) and flip_right == false:
		##Flip vertically
		#parent.position.y = -original_y
		#print("Flip Right: " + str(parent.position.y))
		#flip_left = false
		#flip_right = true
		#pass
	pass

func _process(delta: float) -> void:
	if weapon.is_equipped:
		mouse_angle_degree = -rad_to_deg(weapon.actor.global_position.direction_to(weapon.get_global_mouse_position()).angle())
		var original_y = parent.position.y
		if !(mouse_angle_degree <= 90 and mouse_angle_degree >= -90) and flip_left == false:
			#Flip vertically
			parent.position.y = -original_y
			print("Flip Left: " + str(parent.position.y))
			flip_left = true
			flip_right = false
			pass
		elif (mouse_angle_degree <= 90 and mouse_angle_degree >= -90) and flip_right == false:
			#Flip vertically
			parent.position.y = -original_y
			print("Flip Right: " + str(parent.position.y))
			flip_left = false
			flip_right = true
			pass
	pass

func _on_weapon_equipped(actor : Entity):
	mouse_angle_degree = -rad_to_deg(actor.global_position.direction_to(actor.get_global_mouse_position()).angle())
	var original_y = parent.position.y
	if !(mouse_angle_degree <= 90 and mouse_angle_degree >= -90) and flip_left == false:
		#Flip vertically
		parent.position.y = -original_y
		print("Flip Left: " + str(parent.position.y))
		flip_left = true
		flip_right = false
		pass
	elif (mouse_angle_degree <= 90 and mouse_angle_degree >= -90) and flip_right == false:
		#Flip vertically
		parent.position.y = -original_y
		print("Flip Right: " + str(parent.position.y))
		flip_left = false
		flip_right = true
		pass
	pass
#func _process(delta: float) -> void:
	#if weapon.is_equipped:
		#var flip = !(mouse_angle_degree <= 90 and mouse_angle_degree >= -90)
		## Flip spawn point horizontally
		#var original_y = abs(parent.position.y)
		#if flip:
			#parent.position.y = -original_y
			#print("Flip Left")
		#else:
			#parent.position.y = original_y
			#print("Flip Right")
	#pass
