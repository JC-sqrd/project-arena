class_name BlinkAbility
extends ActiveAbility


enum DirectionInput {MOUSE, KEYBOARD}
@export var max_range : float = 300
@export var direction_input : DirectionInput = DirectionInput.MOUSE
var _get_blink_position : bool = false

var _start_blinking : bool = false
var _blink_position : Vector2 
var _last_blink_direction : Vector2
var _cast_data : Dictionary

func _ready():
	super()
	ability_start.connect(_start_blink)
	ability_canceled.connect(_cancel_blink)
	ability_end.connect(_on_ability_end)
	
func initialize_ability():
	pass
func invoke_ability():
	#Ability started
	current_state = AbilityState.INVOKED
	#Input.action_release("cancel")
	_get_blink_position = true
	ability_invoked.emit()
	pass
	
func _process(delta):
	if _get_blink_position:
		#Debug Visual
		actor.can_attack = false
		actor.can_cast = false
		actor.queue_redraw()
		
		await get_cast_data()
		pass
	
	if _start_blinking:
		ability_active.emit()

func _start_blink():
	active = true
	actor.collision_layer =  0
	actor.remove_from_group("Hittable")
	current_state = AbilityState.START
	if direction_input == DirectionInput.MOUSE:
		var target_position : Vector2 = get_global_mouse_position()
		if actor.global_position.distance_to(target_position) > max_range:
			_blink_position = actor.global_position + (target_position - actor.global_position).normalized() * max_range
			pass
		else:
			_blink_position = target_position
	else:
		var keyboard_direction = Input.get_vector("left","right","up","down").normalized()
		if keyboard_direction == Vector2.ZERO:
			_blink_position = actor.global_position + (_last_blink_direction * max_range)
		else:
			_blink_position = actor.global_position + (keyboard_direction * max_range)
			_last_blink_direction = keyboard_direction
		
		
	_start_blinking = true
	_get_blink_position = false
	blink(_blink_position)
	get_tree().create_timer(0.05, false, false, false).timeout.connect(end_blink)
	pass
	
func _cancel_blink():
	actor.collision_layer = actor.original_coll_layer
	_get_blink_position = false
	actor.can_attack = true
	actor.can_cast = true
	current_state = AbilityState.DORMANT
	pass

func blink(position : Vector2):
	actor.global_position = position
	pass


func end_blink():
	#Ability ended
	active = false
	_start_blinking = false
	current_state = AbilityState.DORMANT
	actor.can_attack = true
	actor.can_move = true
	actor.can_cast = true
	actor.velocity = Vector2.ZERO
	ability_end.emit()
	pass

func _on_ability_end():
	actor.collision_layer = actor.original_coll_layer
	actor.add_to_group("Hittable")
	pass
