class_name HealDataHelper
extends RefCounted


static func create_heal_data(source : Node, heal_amount : float) -> Dictionary:
	var heal_data : Dictionary
	heal_data["heal_amount"] = heal_amount
	heal_data["source"] = source
	return heal_data
