class_name SpawnableRayFilter
extends SpawnableEnterFilter

func is_valid(spawnable : Node2D, body : Node2D, entity_arr : Array[Entity]) -> bool:
	var space : PhysicsDirectSpaceState2D = body.get_viewport().world_2d.direct_space_state
	var ray : PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(spawnable.global_position,body.position, 2)
	var result = space.intersect_ray(ray)
	if result.size() != 0 and result["collider"] == body and body.is_in_group("Hittable"):
		return true
	return false
