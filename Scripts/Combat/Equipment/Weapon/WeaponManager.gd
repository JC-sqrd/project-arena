class_name WeaponManager
extends Node2D

@export var main_weapon_slot : WeaponSlot
@export var offhand_weapon_slot : OffhandWeaponSlot
@export var main_weapon_ability_container : AbilityContainer
@export var offhand_weapon_ability_container : AbilityContainer


var current_weapon_slot : WeaponSlot


var actor : Entity

var main_weapon : bool = true

signal weapon_switched(weapon_slot : WeaponSlot)

func _ready() -> void:
	if owner is Entity:
		actor = owner
	elif owner.has_method("get_actor"):
		actor = owner.get_actor()
	current_weapon_slot = main_weapon_slot
	main_weapon_slot.equipment_equipped.connect(_on_main_weapon_equipped)
	offhand_weapon_slot.equipment_equipped.connect(_on_off_weapon_equipped)
	offhand_weapon_slot.equipment_unequipped.connect(_on_off_weapon_unequipped	)
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
		#Switch Main to Offhand
		if offhand_weapon_slot.equipment != null:
			main_weapon_slot.unequip(main_weapon_slot.equipment)
			main_weapon_slot.equipment.actor = actor
			offhand_weapon_slot.equip_offhand()
			offhand_weapon_slot.equipment.actor.can_attack = true
			current_weapon_slot = offhand_weapon_slot
			weapon_switched.emit(offhand_weapon_slot)
		else:
			main_weapon = !main_weapon
		pass
	elif main_weapon:
		#Switch Offhand to Main
		offhand_weapon_slot.unequip(offhand_weapon_slot.equipment)
		offhand_weapon_slot.equipment.actor = actor
		main_weapon_slot.equip(main_weapon_slot.equipment)
		main_weapon_slot.equipment.actor.can_attack = true
		current_weapon_slot = main_weapon_slot
		weapon_switched.emit(main_weapon_slot)
		pass
	pass

func _on_main_weapon_equipped(equipment : Equipment):
	main_weapon_ability_container.ability = (equipment as Weapon).weapon_ability
	pass

func _on_main_weapon_unequipped(equipment : Equipment):
	main_weapon_ability_container.ability = null
	pass

func _on_off_weapon_equipped(equipment : Equipment):
	offhand_weapon_ability_container.ability = (equipment as Weapon).weapon_ability
	offhand_weapon_ability_container.ability.ready.emit()
	print("ABILITY EQUIPPED TO CONTAINER, ABILITY OWNER: " + str(offhand_weapon_ability_container.ability.owner))
	pass

func _on_off_weapon_unequipped(equipment : Equipment):
	offhand_weapon_ability_container.ability = null
	print("OFFHAND ABILITY UNEQUIPPED : " + str(offhand_weapon_ability_container.ability))
	pass
