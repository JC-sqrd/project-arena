class_name SpawnOnAbilityCastArea
extends PassiveAbility

enum SpawnOnAbility {PRIMARY, UTILITY, MAIN_WEAPON, OFFHAND_WEAPON}

@export var spawn_on : SpawnOnAbility = SpawnOnAbility.PRIMARY
@export var spawn_scene : PackedScene
@export var max_targets : Stat
@export var area : Area2D
@export var hit_listener : HitListener
@export var look_at_mouse : bool = true
@export var spawn_on_nearest : bool = true

var _target_counter : int = 0
var hittable_entities : Array[Entity]
var _max_targets : int = 5

func enable_ability(actor : Entity):
	super(actor)
	self.actor = actor
	if spawn_on == SpawnOnAbility.PRIMARY:
		(self.actor as PlayerCharacter).innate_active_ability.ability.ability_casted.connect(_on_ability_casted)
	elif spawn_on == SpawnOnAbility.UTILITY:
		(self.actor as PlayerCharacter).utility_ability.ability.ability_casted.connect(_on_ability_casted)
	elif spawn_on == SpawnOnAbility.MAIN_WEAPON:
		self.actor = actor as PlayerCharacter
		(self.actor as PlayerCharacter).weapon_manager.main_weapon_slot.weapon.weapon_ability.ability_casted.connect(_on_ability_casted)
		(self.actor as PlayerCharacter).weapon_manager.main_weapon_slot.equipment_slotted.connect(_on_main_weapon_slotted)
		(self.actor as PlayerCharacter).weapon_manager.main_weapon_slot.equipment_unslotted.connect(_on_main_weapon_unslotted)
	elif spawn_on == SpawnOnAbility.OFFHAND_WEAPON:
		(self.actor as PlayerCharacter).weapon_manager.offhand_weapon_slot.weapon.weapon_ability.ability_casted.connect(_on_ability_casted)
		(self.actor as PlayerCharacter).weapon_manager.offhand_weapon_slot.equipment_slotted.connect(_on_offhand_weapon_slotted)
		(self.actor as PlayerCharacter).weapon_manager.offhand_weapon_slot.equipment_unslotted.connect(_on_offhand_weapon_unslotted)
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	var overlapping_bodies : Array[Node2D] = area.get_overlapping_bodies()
	for body in overlapping_bodies:
		area.body_entered.emit(body)
	pass

func disable_ability():
	if spawn_on == SpawnOnAbility.PRIMARY:
		(self.actor as PlayerCharacter).innate_active_ability.ability.ability_casted.disconnect(_on_ability_casted)
	elif spawn_on == SpawnOnAbility.UTILITY:
		(self.actor as PlayerCharacter).utility_ability.ability.ability_casted.disconnect(_on_ability_casted)
	elif spawn_on == SpawnOnAbility.MAIN_WEAPON:
		(self.actor as PlayerCharacter).weapon_manager.main_weapon_slot.weapon.weapon_ability.ability_casted.disconnect(_on_ability_casted)
		(self.actor as PlayerCharacter).weapon_manager.main_weapon_slot.equipment_slotted.disconnect(_on_main_weapon_slotted)
		(self.actor as PlayerCharacter).weapon_manager.main_weapon_slot.equipment_unslotted.disconnect(_on_main_weapon_unslotted)
	elif spawn_on == SpawnOnAbility.OFFHAND_WEAPON:
		(self.actor as PlayerCharacter).weapon_manager.offhand_weapon_slot.weapon.weapon_ability.ability_casted.disconnect(_on_ability_casted)
		(self.actor as PlayerCharacter).weapon_manager.offhand_weapon_slot.equipment_slotted.disconnect(_on_offhand_weapon_slotted)
		(self.actor as PlayerCharacter).weapon_manager.offhand_weapon_slot.equipment_unslotted.disconnect(_on_offhand_weapon_unslotted)
	super()
	area.body_entered.disconnect(_on_body_entered)
	area.body_exited.disconnect(_on_body_exited)
	hittable_entities.clear()
	pass


func _on_ability_casted():
	for i in min(hittable_entities.size(), int(max_targets.stat_derived_value)):
		if cooling_down:
			print(ability_name + "ABILITY COOLING DOWN")
			return
		print("PASSIVE UTIL CAST")
		var spawn = spawn_scene.instantiate() as Spawnable
		
		var spawn_rotation : float = 0
		
		spawn.source = self
		spawn.actor = actor
		spawn.on_hit.connect(_on_spawn_hit)
		spawn.inactive.connect(_on_spawn_inactive)
		spawn.collision_mask = (spawn.collision_mask - actor.collision_layer)
		if hit_listener != null:
			spawn.hit_data = hit_listener.generate_effect_data()
		
		#if !aim_at_mouse:
			#spawn_rotation = spawn_direction.angle()
		#else:
			#spawn_rotation = actor.global_position.direction_to(actor.get_global_mouse_position()).angle()
		#spawn_rotation = ability.global_position.direction_to(spawn_direction).angle()
		
		spawn.global_position = hittable_entities[i].global_position
		if look_at_mouse:
			spawn.rotation = actor.global_position.direction_to(actor.get_global_mouse_position()).angle()
		#actor.get_tree().root.add_child(spawn)
		get_tree().root.add_child(spawn)
	start_cooldown()
	pass

func _on_body_entered(body : Node2D):
	if body is Entity and body.is_in_group("Hittable") and body != actor:
		hittable_entities.append(body)
		hittable_entities.sort_custom(_sort_by_distance)
	pass

func _sort_by_distance(a : Entity, b : Entity) -> bool:
	if spawn_on_nearest:
		return a.global_position.distance_squared_to(actor.global_position) < b.global_position.distance_squared_to(actor.global_position)
	else:
		return a.global_position.distance_squared_to(actor.global_position) > b.global_position.distance_squared_to(actor.global_position)


func _on_body_exited(body : Node2D):
	if hittable_entities.has(body):
		hittable_entities.erase(body)
		hittable_entities.sort_custom(_sort_by_distance)
	pass

func _on_spawn_hit():
	pass

func _on_spawn_inactive():
	pass

func _on_main_weapon_slotted(equipment : Equipment):
	(equipment as Weapon).weapon_ability.ability_casted.connect(_on_ability_casted)
	pass

func _on_main_weapon_unslotted(equipment : Equipment):
	(equipment as Weapon).weapon_ability.ability_casted.disconnect(_on_ability_casted)
	pass

func _on_offhand_weapon_slotted(equipment : Equipment):
	(equipment as Weapon).weapon_ability.ability_casted.connect(_on_ability_casted)
	pass

func _on_offhand_weapon_unslotted(equipment : Equipment):
	(equipment as Weapon).weapon_ability.ability_casted.disconnect(_on_ability_casted)
	pass
