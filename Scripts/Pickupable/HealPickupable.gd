class_name HealPickupable
extends Pickupable


@export var heal_value : float = 0


func pickup(entity : Entity):
	if entity is PlayerCharacter:
		entity.heal(HealDataHelper.create_heal_data(self, heal_value))
	picked_up.emit()
	queue_free()

func _create_heal_data() -> HealEffectData:
	var heal_data : HealEffectData
	return heal_data
