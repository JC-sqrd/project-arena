class_name BonusDamageIPE
extends ItemPassiveEffect


var damage_effects : Array[DamageEffect]
@export var bonus_damage_stat : Stat
@export var percentage : bool
var _bonus_damage_check : BonusDamageCheck

func _ready():
	super()
	if owner is Item:
		owner.item_equipped.connect(
			func():
				var damage_effect_children : Array[Node] = owner.actor.find_children("DamageEffect", "DamageEffect")
				for damage_effect in damage_effect_children:
					var casted_damage_effect = damage_effect as DamageEffect
					damage_effects.append(casted_damage_effect)
					_bonus_damage_check = BonusDamageCheck.new()
					
					if percentage:
						_bonus_damage_check.is_multiplier = true
					
					_bonus_damage_check.bonus_damage_stat = bonus_damage_stat
					casted_damage_effect.add_child(_bonus_damage_check)
				pass
		)
		
		pass
	else:
		printerr("Owner is not item")
	pass
