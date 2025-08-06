class_name StatFormatter
extends Resource

enum FormatPrefix {NONE, ADDITIVE, SUBTRACTIVE}
enum FormatMode {BASE, DERIVED, BONUS}

@export var format_mode : FormatMode = FormatMode.DERIVED
@export var prefix : FormatPrefix = FormatPrefix.NONE

func get_formatted_stat_text(stat : Stat) -> String:
	return _format_prefix(stat) + _format_stat(stat)

func _format_stat(stat : Stat) -> String:
	match format_mode:
		FormatMode.BASE:
			return str(stat.stat_value)
		FormatMode.DERIVED:
			return str(stat.stat_derived_value)
		FormatMode.BONUS:
			return str(stat.bonus_value)
			pass
		_:
			return str(stat.stat_derived_value)

func _format_prefix(stat : Stat) -> String:
	match prefix:
		FormatPrefix.NONE:
			return ""
		FormatPrefix.ADDITIVE:
			return "+"
		FormatPrefix.SUBTRACTIVE:
			return ""
		_:
			return ""

func get_stat_value_text(stat : Stat) -> String:
	return str(stat.stat_value)

func get_stat_derived_value_text(stat : Stat) -> String:
	return str(stat.stat_derived_value)

func get_bonus_value_text(stat : Stat) -> String:
	return str(stat.bonus_value)
