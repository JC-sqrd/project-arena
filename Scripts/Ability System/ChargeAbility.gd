class_name ChargeAbility
extends DashAbility

var input_vector : Vector2
var _current_charge_speed : float = 0

func dash(delta : float):
	#Ability is on and active
	current_state = AbilityState.ACTIVE
	#Prohibits the player from moving the actor while dashing
	actor.can_move = false
	#VELOCITY DASH
	input_vector = Input.get_vector("left", "right", "up", "down").normalized()
	_current_charge_speed += dash_acceleration / _dash_duration
	_current_charge_speed = clampf(_current_charge_speed, -INF, dash_speed)
	actor.velocity += lerp(actor.velocity, (input_vector) * _current_charge_speed, 1)
	actor.move_and_slide()
	ability_active.emit()
	pass

func end_dash():
	#Ability ended
	active = false
	current_state = AbilityState.DORMANT
	actor.can_attack = true
	actor.can_move = true
	actor.can_cast = true
	_begin_dashing = false
	_current_charge_speed = 0
	ability_end.emit()
	pass
