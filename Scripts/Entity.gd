class_name Entity
extends CharacterBody2D

@export var hit_receiver : HitReceiver
@export var stat_manager : StatManager
@export var level_manager : LevelManager
@export var health_manager : HealthManager
@export var mana_manager : ManaManager
@export var status_effect_manager : StatusEffectManager
@export var stat_mods_manager : StatModManager
@export var damage_listener : DamageListener
@export var item_iventory : ItemInventory
@export var equipment_inventory : EquipmentInventory
@export var ability_containers : Array[AbilityContainer] = []
var hit_listeners : Array[HitListener]

@onready var original_coll_layer : int = collision_layer 
var can_move : bool = true
var can_attack : bool = true
var can_cast : bool = true 

signal took_damage (damage_taken : float)
signal took_damage_with_type (damage_taken : float, type : Enums.DamageType) 
signal took_damage_with_data (damage_data : DamageEffectData)
signal effect_data_created (effect_data : EffectData)
signal applied_damage (damage_applied : float)
signal applied_damage_with_data (damage_data : Dictionary)
signal critical_striked(data : Dictionary)
signal healed (healed_amount : float)
signal trigger_on_hit_effect (hit_data : Dictionary)
signal on_hit (hit_data : Dictionary)
signal basic_attack_hit (hit_data : Dictionary)
signal basic_attack (weapon : Weapon)
signal update_health_ui (new_current : float, new_max : float)
signal died ()
signal slayed (slayed : Entity)
signal slain (slain_by : Entity)


func _ready():
	on_hit.connect(on_hit_received)
	pass

func take_damage(damage_data : DamageEffectData):
	took_damage.emit(damage_data.total_damage)
	took_damage_with_type.emit(damage_data.total_damage, damage_data.damage_type)
	took_damage_with_data.emit(damage_data)
	pass

func hit(hit_data : Dictionary):
	on_hit.emit(hit_data)
	pass

func heal(heal_data : Dictionary):
	healed.emit(heal_data["heal_amount"])
	pass

func attack(attack_data : Dictionary):
	pass

func die():
	died.emit()
	pass

func on_hit_received(hit_data : Dictionary):
	if hit_receiver != null:
		hit_receiver.receive_hit(hit_data)
	pass
