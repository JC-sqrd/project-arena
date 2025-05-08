class_name SpawnOnAttack
extends StatusEffect


@export var spawn_effect : SpawnEffect
var stack_stat_scalers : Array[StatScaler]
var bonus_damage : float = 0

var stat_scaler : StatScaler

func _ready():
	is_permanent = true
	if stack_stat != null:
		if stack_stat.stat_value >= 0:
			stack_stat.stat_value = 1
			pass

func activate_status_effect(target : Entity):
	target.basic_attack.connect(on_basic_attack)
	pass

func on_basic_attack(weapon : Weapon):
	spawn_effect.apply_effect(HitDataHelper.create_hit_data(actor, actor, actor))
	pass


func add_stat(amount : int):
	stack = stack + amount
	stack_stat.stat_value += float(amount)
	pass

func _set_stat(new_value : int):
	stack = new_value
	stack_stat.stat_value = new_value
	stack_stat.update_stat()
	pass

func get_actor() -> Entity:
	return actor
