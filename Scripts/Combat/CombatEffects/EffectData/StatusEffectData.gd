class_name StatusEffectData
extends EffectData



var status_effect_scene : PackedScene
var stack : int = 1
var chance : float = 1

var tags : Array[StringName]

func _init(status_effect_scene : PackedScene, stack : int, chance : float):
	self.status_effect_scene = status_effect_scene
	self.stack = stack
	self.chance = chance
