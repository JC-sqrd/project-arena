class_name HitData
extends Node

var hit_source : Node2D
var hit_target : Node2D
var global_mouse_position : Vector2
var data : Dictionary

static func create() -> HitData:
	var hit_data : HitData = HitData.new()
	#hit_data.hit_source = source
	#hit_data.hit_target = target
	#hit_data.global_mouse_position = mouse_pos
	return hit_data
	pass


func get_data(key : String) -> Variant:
	return data[key]
