class_name WeaponSlot
extends EquipmentSlot

#@export var weapon : Weapon : set = _set_weapon
@export var attack_speed : Stat
@export var weapon_position : Node2D

var _attack_cooldown : float
var _cooldown_counter : float

var weapon : Weapon 

var _start_cooldown : bool = false
var _on_cooldown : bool = false
var look_at_mouse : bool = true

var can_attack : bool = true

var action_held : bool = false

signal weapon_ability_triggered()

func _ready():
	if equipment != null:
		weapon = equipment
		_attack_cooldown = 1 / weapon.attack_speed_stat.stat_derived_value
		#attack.attack_end.connect(_start_attack_cooldown)
		weapon.attack_cooldown = _attack_cooldown
		weapon.attack_speed = attack_speed.stat_derived_value
	pass


func _process(delta):
	if look_at_mouse:
		rotation = lerp_angle(rotation, (get_global_mouse_position() - global_position).normalized().angle(), 10 * delta)

func _reset_attack():
	actor.can_attack = true

func _initialize_attack():
	actor.can_attack = false
	weapon.attack_cooldown = _attack_cooldown
	weapon.attack_speed = attack_speed.stat_derived_value
	weapon.start_attack()
	pass

func _set_weapon(new_weapon : Weapon):
	weapon = new_weapon
	pass


func set_equipment(new_equipment : Equipment):
	if equipment != null:
		equipment.visible = false
		print("Unequip Equipment: " + str(equipment.equipment_name))
		unequip(equipment)
	equipment = new_equipment
	weapon = equipment
	equip(new_equipment)
	pass 

func equip(equipment : Equipment):
	equipment.reparent(weapon_position)
	equipment.global_position = Vector2.ZERO
	equipment.rotation = 0
	equipment.position = Vector2.ZERO
	equipment.action_trigger = action_trigger
	equipment.equip(actor)
	equipment.visible = true
	pass

func unequip(equipment : Equipment):
	equipment.unequip()
	equipment.visible = false
	equipment = null
	pass

func _start_attack_cooldown():
	_attack_cooldown = 1 / weapon.attack_speed_stat.stat_derived_value
	pass

func get_actor() -> Entity:
	return actor
