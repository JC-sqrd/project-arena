class_name CharacterAbilityPreviewPanel
extends Control

@onready var ability_icon: TextureRect = %AbilityIcon
@onready var ability_name_label: RichTextLabel = %AbilityNameLabel
@onready var ability_type_label: RichTextLabel = %AbilityTypeLabel
@onready var ability_description_label: RichTextLabel = %AbilityDescriptionLabel

const DEFAULT_ABILITY_ICON = preload("res://icon.svg")

func set_ability_preview(ability : Ability):
	if ability is ActiveAbility:
		configure_active_ability(ability as ActiveAbility)
	elif ability is PassiveAbility:
		configure_passive_ability(ability as PassiveAbility)
	pass

func configure_active_ability(ability : ActiveAbility):
	if ability.ability_icon_texture != null:
		ability_icon.texture = ability.ability_icon_texture
	else:
		ability_icon.texture = DEFAULT_ABILITY_ICON
	ability_name_label.text = ability.ability_name
	ability_type_label.text = "Active Ability"
	ability_description_label.text = ability.ability_description
	pass

func configure_passive_ability(ability : PassiveAbility):
	if ability.ability_icon_texture != null:
		ability_icon.texture = ability.ability_icon_texture
	else:
		ability_icon.texture = DEFAULT_ABILITY_ICON
	ability_name_label.text = ability.ability_name
	ability_type_label.text = "Passive Ability"
	ability_description_label.text = ability.ability_description
	pass
