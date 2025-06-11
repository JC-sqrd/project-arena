class_name EquipmentPassiveAbilityContainer
extends Node


@export var passive_ability : PassiveAbility
var equipment : Equipment


func _ready() -> void:
	if owner is Equipment:
		equipment = owner
		equipment.equipped.connect(_on_equipment_equipped)
		equipment.unequipped.connect(_on_equipment_unequipped)

func _on_equipment_equipped(actor : Entity):
	passive_ability.actor = equipment.actor
	passive_ability.enable_passive_ability(equipment.actor)
	pass

func _on_equipment_unequipped():
	passive_ability.disable_passive_ability()
	passive_ability.actor = null
	pass
	
