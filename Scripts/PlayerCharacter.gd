class_name PlayerCharacter
extends Entity

var total_damage_applied : float = 0
var damage_effects : Array[Node]
@export var gold_manager : GoldManager
@export var innate_active_ability : AbilityContainer
@export var innate_utility_ability : AbilityContainer
@export var utility_ability : AbilityContainer

signal item_picker_picked_up (player : PlayerCharacter, loot_pool : Array[PackedScene])

func _ready():
	super()
	Globals.player = self
	print("Equipped abilities: " + str(ability_containers))
	damage_effects = find_children("DamageEffect", "DamageEffect")
	for damage_effect in damage_effects:
		if damage_effect is DamageEffect:
			damage_effect.applied_damage.connect(_on_damage_applied)
			damage_effect.damage_data_created.connect(_on_damage_data_created)
			pass
	applied_damage.connect(_on_damage_applied)
	pass

func take_damage(damage_data : Dictionary) -> float:
	var mitigated_damage = damage_listener.apply_mitigation_effects(damage_data)
	damage_data["damage"] = mitigated_damage
	took_damage_with_type.emit(mitigated_damage, damage_data["damage_type"])
	took_damage_with_data.emit(damage_data)
	took_damage.emit(mitigated_damage)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
	return mitigated_damage
	pass

func heal(heal_data : Dictionary):
	health_manager.add_current_health(heal_data["heal_amount"])
	healed.emit(heal_data["heal_amount"])
	pass

func attack(attack_data : Dictionary):
	pass

func on_hit_received(hit_data : Dictionary):
	if hit_receiver != null:
		hit_receiver.receive_hit(hit_data)
		print("Player received hit data")
	pass

func _on_damage_applied(damage : float):
	total_damage_applied += damage
	pass

func _on_damage_data_created(damage_data : Dictionary):
	damage_data_created.emit(damage_data)
	pass

func die():
	velocity = Vector2.ZERO
	collision_layer = 0
	collision_mask = 0
	get_tree().create_timer(0.5, false, false, false).timeout.connect(
		func(): 
			queue_free()
			died.emit()
			)
	pass
