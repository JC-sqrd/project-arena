class_name PercentageStatFormatter
extends StatFormatter

func _format_stat(stat : Stat) -> String:
	match format_mode:
		FormatMode.BASE:
			return str(stat.stat_value * 100) + "%"
		FormatMode.DERIVED:
			return str(stat.stat_derived_value * 100) + "%"
		FormatMode.BONUS:
			return str(stat.bonus_value * 100) + "%"
			pass
		_:
			return str(stat.stat_derived_value * 100) + "%"
