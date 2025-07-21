class_name AbilityTooltip
extends Control

@onready var ability_icon: TextureRect = %AbilityIcon
@onready var ability_name: RichTextLabel = %AbilityName
@onready var resource_cost: RichTextLabel = %ResourceCost
@onready var cooldown_time: RichTextLabel = %CooldownTime
@onready var ability_description: RichTextLabel = %AbilityDescription



func initialize_ability_tooltip(ability : Ability):
	await self.ready
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
