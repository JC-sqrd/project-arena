class_name ConsumeStatusEffect
extends Effect


@export var status_effect_id : String 
var effects : Array[Effect]

func _ready():
	for child in get_children():
		if child is Effect:
			effects.append(child)
		pass

func get_effect_key() -> Variant:
	return "consume_status_effect"

func get_effect_value() -> ConsumeStatusEffectData:
	return ConsumeStatusEffectData.new(status_effect_id, _create_effect_data())

class ConsumeStatusEffectData:
	var status_effect_id : String
	var effect_data : Dictionary
	
	func _init(status_effect_id : String, effect_data : Dictionary):
		self.status_effect_id = status_effect_id
		self.effect_data = effect_data

func _create_effect_data() -> Dictionary:
	var effect_data : Dictionary
	for effect in effects:
		effect_data[effect.get_effect_key()] = effect.get_effect_value()
	return effect_data
