class_name AIRangeAttack
extends AIBehavior

@export var attack_range : float = 150
@export var ai_ability_container : AIAbilityContainer
var distance : float

func _ready():
	ai_ability_container.enemy = enemy
	pass

func _physics_process(delta):
	if player != null and enemy.can_cast:
		distance = (enemy.global_position - player.global_position).length()
		if distance <= attack_range:
			if ai_ability_container.ability != null:
				ai_ability_container.activate_ability()
			pass
	pass
