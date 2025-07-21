class_name PercentageStatFormatter
extends StatFormatter

func get_formatted_stat_text(stat : Stat) -> String:
	match format_mode:
		FormatMode.BASE:
			return str(stat.stat_value) + "%"
		FormatMode.DERIVED:
			return str(stat.stat_derived_value) + "%"
		FormatMode.BONUS:
			return str(stat.bonus_value) + "%"
			pass
		_:
			return str(stat.stat_derived_value) + "%"
