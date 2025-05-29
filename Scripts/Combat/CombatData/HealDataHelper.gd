class_name HealDataHelper
extends RefCounted


static func create_heal_data(source : Node, heal_amount : float) -> HealEffectData:
	var heal_data : HealEffectData = HealEffectData.new(heal_amount)
	heal_data.source = source
	return heal_data
