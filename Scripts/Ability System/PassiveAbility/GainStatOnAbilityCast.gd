class_name GainStatOnAbilityCast
extends PassiveAbility

enum GainStatOnCast {PRIMARY, UTILITY, MAIN_WEAPON, OFFHAND_WEAPON}

@export var bonus_stat : Stat
@export var bonus_stat_time : Stat
@export var stat_id : String
@export var gain_stat_on_cast : GainStatOnCast = GainStatOnCast.PRIMARY
@export var is_percentage : bool = false

var _bonus_stat : float = 0
var _stat_to_modify : Stat
var _bonus_stat_timer : Timer


func enable_ability(actor : Entity):
	super(actor)
	if gain_stat_on_cast == GainStatOnCast.PRIMARY:
		(actor as PlayerCharacter).innate_active_ability.ability.ability_casted.connect(_on_ability_cast)
	elif gain_stat_on_cast == GainStatOnCast.UTILITY:
		(actor as PlayerCharacter).utility_ability.ability.ability_casted.connect(_on_ability_cast)
	elif gain_stat_on_cast == GainStatOnCast.MAIN_WEAPON:
		(actor as PlayerCharacter).weapon_manager.main_weapon_slot.weapon.weapon_ability.ability_casted.connect(_on_ability_cast)
	elif gain_stat_on_cast == GainStatOnCast.OFFHAND_WEAPON:
		(actor as PlayerCharacter).weapon_manager.offhand_weapon_slot.weapon.weapon_ability.ability_casted.connect(_on_ability_cast)
	
	_bonus_stat_timer = Timer.new()
	_bonus_stat_timer.autostart = false
	_bonus_stat_timer.one_shot = false
	_bonus_stat_timer.timeout.connect(_on_bonus_stat_timer_timeout)
	add_child(_bonus_stat_timer)
	
	pass

func disable_ability():
	if gain_stat_on_cast == GainStatOnCast.PRIMARY:
		(actor as PlayerCharacter).innate_active_ability.ability.ability_casted.disconnect(_on_ability_cast)
	elif gain_stat_on_cast == GainStatOnCast.UTILITY:
		(actor as PlayerCharacter).utility_ability.ability.ability_casted.disconnect(_on_ability_cast)
	elif gain_stat_on_cast == GainStatOnCast.MAIN_WEAPON:
		(actor as PlayerCharacter).weapon_manager.main_weapon_slot.weapon.weapon_ability.ability_casted.disconnect(_on_ability_cast)
	elif gain_stat_on_cast == GainStatOnCast.OFFHAND_WEAPON:
		(actor as PlayerCharacter).weapon_manager.offhand_weapon_slot.weapon.weapon_ability.ability_casted.disconnect(_on_ability_cast)
	
	_bonus_stat_timer.timeout.disconnect(_on_bonus_stat_timer_timeout)
	_bonus_stat_timer.queue_free()
	
	super()
	pass

func _on_ability_cast():
	if !cooling_down and !active:
		_stat_to_modify = actor.stat_manager.get_stat(stat_id)
		if !is_percentage:
			_bonus_stat = bonus_stat.stat_derived_value
			_stat_to_modify.bonus_value += _bonus_stat
		else:
			var stat_value : float = _stat_to_modify.stat_derived_value
			_bonus_stat = (stat_value * bonus_stat.stat_derived_value)
			_stat_to_modify.bonus_value += _bonus_stat
		_stat_to_modify.update_stat()
		if _bonus_stat_timer.is_stopped():
			_bonus_stat_timer.start(bonus_stat_time.stat_derived_value)
			active = true
		#get_tree().create_timer(bonus_stat_time.stat_derived_value, false, false, false).timeout.connect(_on_bonus_stat_timer_timeout)
		start_cooldown()
	pass

func _on_bonus_stat_timer_timeout():
	_stat_to_modify.bonus_value -= _bonus_stat
	_stat_to_modify.update_stat()
	_bonus_stat_timer.stop()
	active = false
	pass
