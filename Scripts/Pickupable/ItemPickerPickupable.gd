class_name ItemPickerPickupable
extends Pickupable

@export var item_pool : Array[PackedScene]


func pickup(entity : Entity):
	if entity is PlayerCharacter:
		entity.item_picker_picked_up.emit(entity, item_pool)
		pass
	picked_up.emit()
	_lerp_weight_counter = _lerp_weight
	queue_free()
	pass
