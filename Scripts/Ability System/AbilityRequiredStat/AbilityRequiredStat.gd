class_name AbilityRequiredStat
extends Resource


@export_enum("current_mana", "current_health") var stat_name : String = "current_mana"
@export var required_value : float = 0

static func create(stat_name : String, required_value : float) -> AbilityRequiredStat:
	var required_stat : AbilityRequiredStat = AbilityRequiredStat.new()
	required_stat.stat_name = stat_name
	required_stat.required_value = required_value
	return required_stat
