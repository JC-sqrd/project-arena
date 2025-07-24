class_name AbilityTooltip
extends Control

@onready var ability_icon: TextureRect = %AbilityIcon
@onready var ability_name: RichTextLabel = %AbilityName
@onready var resource_cost: RichTextLabel = %ResourceCost
@onready var cooldown_time: RichTextLabel = %CooldownTime
@onready var ability_stats_container: HBoxContainer = %AbilityStatsContainer
@onready var ability_description: RichTextLabel = %AbilityDescription
@onready var stat_name_container: VBoxContainer = %StatNameContainer
@onready var stat_value_container: VBoxContainer = %StatValueContainer



func initialize_ability_tooltip(ability : Ability):
	await self.ready
	if ability == null:
		return
	
	for stat in ability.tooltip_stats:
		var stat_label : Label = Label.new()
		var stat_value_label : Label = Label.new()
		
		stat_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		stat_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		
		stat_label.text = stat.name 
		stat_value_label.text = stat.formatter.get_formatted_stat_text(stat)#str(stat.stat_derived_value)
		
		stat_name_container.add_child(stat_label)
		stat_value_container.add_child(stat_value_label)
		print("Added tooltip stats")
	
	ability_icon.texture = ability.ability_icon_texture
	ability_name.text = ability.ability_name
	resource_cost.text = str(ability.required_stat.required_value)
	ability_description.text = ability.ability_description
	cooldown_time.text = str(ability.get_cooldown_time()) + "s"
	pass

func set_ability_icon_texture(icon : Texture):
	ability_icon.texture = icon
	pass

func set_ability_name_text(name : String):
	ability_name.text = name
	pass

func set_resource_cost_text(cost : String):
	resource_cost.text = cost
	pass

func set_ability_description_text(description : String):
	ability_description.text = description
	pass

func set_ability_cooldown_time_text(cooldown_time : float):
	self.cooldown_time.text = str(cooldown_time) + "s"
	pass
