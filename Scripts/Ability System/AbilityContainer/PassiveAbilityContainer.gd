class_name PassiveAbilityContainer
extends Node2D


@export var actor : Entity
@export var ability : Ability : set = _set_ability
var ability_icon : Texture2D

func _set_ability(new_ability : Ability):
	if ability != null:
		ability.remove_from_group("equipped_abilities")
	ability = new_ability
	ability.add_to_group("equipped_abilities")
	ability_icon = new_ability.ability_icon_texture
	pass
