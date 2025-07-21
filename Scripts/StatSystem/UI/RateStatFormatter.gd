class_name RateStatFormatter
extends StatFormatter



func get_formatted_stat_text(stat : Stat) -> String:
	match format_mode:
		FormatMode.BASE:
			return str(stat.stat_value) + "/s"
		FormatMode.DERIVED:
			return str(stat.stat_derived_value) + "/s"
		FormatMode.BONUS:
			return str(stat.bonus_value) + "/s"
			pass
		_:
			return str(stat.stat_derived_value) + "/s"
