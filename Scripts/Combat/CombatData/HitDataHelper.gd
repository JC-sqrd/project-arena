class_name HitDataHelper
extends RefCounted


static func create_hit_data(source : Node, target : Entity, actor : Entity) -> Dictionary:
	var hit_data : Dictionary
	hit_data["source"] = source
	hit_data["target"] = target
	hit_data["actor"] = actor
	return hit_data
