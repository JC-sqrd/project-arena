class_name PassiveAbilityContainer
extends Node2D


@export var actor : Entity
@export var ability : PassiveAbility : set = _set_ability
var ability_icon : Texture2D

func _ready() -> void:
	if actor != null:
		actor.ready.connect(_on_actor_ready)


func _on_actor_ready():
	if ability != null:
		ability.enable_passive_ability()
	pass

func _set_ability(new_ability : PassiveAbility):
	if ability != null:
		ability.remove_from_group("equipped_abilities")
		ability.disable_passive_ability()
	ability = new_ability
	ability.add_to_group("equipped_abilities")
	ability.enable_passive_ability()
	ability_icon = new_ability.ability_icon_texture
	pass
