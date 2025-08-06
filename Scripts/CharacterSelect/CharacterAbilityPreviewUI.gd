class_name CharacterAbilityPreviewUI
extends Control

var current_character : PlayerCharacter
const CHARACTER_SELECT_CHARACTER_ABILITY_PANEL = preload("res://Scenes/UI/Character Select/character_select_character_ability_panel.tscn")

@onready var passive_ability_preview_panel: CharacterAbilityPreviewPanel = %PassiveAbilityPreviewPanel
@onready var primary_ability_preview_panel: CharacterAbilityPreviewPanel = %PrimaryAbilityPreviewPanel
@onready var utility_ability_preview_panel: CharacterAbilityPreviewPanel = %UtilityAbilityPreviewPanel



func set_chracter_ability_preview(character : PlayerCharacter):
	passive_ability_preview_panel.set_ability_preview(character.passive_ability_container.ability)
	primary_ability_preview_panel.set_ability_preview(character.innate_active_ability.ability)
	utility_ability_preview_panel.set_ability_preview(character.utility_ability.ability)
	pass
