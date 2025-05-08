class_name SpawnableEnterFilter
extends Resource


func is_valid(spawnable: Node2D, body : Node2D, entity_arr : Array[Entity]) -> bool:
	if body != null and body.is_in_group("Hittable"):
		return true
	return false
