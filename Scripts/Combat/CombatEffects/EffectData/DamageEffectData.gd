class_name DamageEffectData
extends EffectData

var actor : Entity
var target : Entity
var source : Node
var damage : float
var total_damage : float
var penetrates : bool = false
var penetration : float
var critical : bool = false
var crit_multiplier : float = 1.65
var damage_type : Enums.DamageType = Enums.DamageType.PHYSICAL
var is_lifesteal : bool = false
var blocked : bool = false
var dodged : bool = false
var lifesteal : DamageReceiver.Lifesteal
var lifesteal_percentage : float
var checks : Array[BonusValueCondition]
var damage_received_callback : Callable
var recieved : bool = false

signal damage_data_created(data : DamageEffectData)
