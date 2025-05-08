class_name WeaponManager
extends Node2D

@export var main_weapon_slot : WeaponSlot
@export var offhand_weapon_slot : OffhandWeaponSlot

var main_weapon : bool = true


func _ready() -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_Q and event.echo == false:
		#Switch Weapons
		#dprint("Switch Weapon")
		switch_weapon()
		pass

func switch_weapon():
	main_weapon = !main_weapon
	if !main_weapon:
		print("Switch Main to Offhand")
		if offhand_weapon_slot.equipment != null:
			main_weapon_slot.unequip(main_weapon_slot.equipment)
			offhand_weapon_slot.equip_offhand()
		else:
			main_weapon = !main_weapon
		pass
	elif main_weapon:
		print("Switch Offhand to Main")
		offhand_weapon_slot.unequip(offhand_weapon_slot.equipment)
		main_weapon_slot.equip(main_weapon_slot.equipment)
		pass
	pass
