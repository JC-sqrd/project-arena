class_name DashAbility
extends ActiveAbility

enum DirectionInput {MOUSE, KEYBOARD}

@export var dash_distance : float
@export var dash_speed : float = 2500
@export var direction_input : DirectionInput = DirectionInput.MOUSE
@export var can_cast_while_dashing : bool = false

var _mouse_direction : Vector2 = Vector2.ZERO

@export var debug_visual : bool = false


var _dash_direction : Vector2
var _last_dash_direction : Vector2 = Vector2.RIGHT
var _dash_position : Vector2
var _dash_duration : float


var _begin_dashing : bool = false
var _get_dash_direction : bool = false


#ABILITY FLOW : ability invoked (start) -> get direction input 
# -> disable actor from moving -> dash to desired position
# -> if actor reached desired position, enable movement (end) 

func _ready():
	super()
	ability_start.connect(_start_dash)
	ability_canceled.connect(_cancel_dash)
	ability_end.connect(_on_ability_end)
	
func initialize_ability():
	if debug_visual:
		var draw_func = func(): 
			if _get_dash_direction:
				#NOTE: When calling draw_line() from an instace of node2D, Vector2.ZERO counts as the node's position (local position)
				_mouse_direction = (actor.get_global_mouse_position() - actor.position).normalized()
				actor.draw_line(Vector2.ZERO, Vector2.ZERO + (_mouse_direction * dash_distance),
				Color(Color.AQUAMARINE, 0.45), 50)
				
		actor.draw.connect(draw_func)
	pass
func invoke_ability():
	#Ability started
	current_state = AbilityState.INVOKED
	#Input.action_release("cancel")
	_get_dash_direction = true
	ability_invoked.emit()
	pass
	
func _process(delta):
	if _get_dash_direction:
		#Debug Visual
		actor.can_attack = false
		actor.can_cast = false
		actor.queue_redraw()
		
		get_cast_data()

		pass

func _physics_process(delta):
	if _begin_dashing and active:
		dash(delta)
		#_dash_duration -= delta
	#if _dash_duration <= 0:
		#end_dash()
		#Distance condition
		#if actor.position.distance_to(_dash_position) <= 10:
			#end_dash()

func _start_dash():
	active = true
	actor.collision_layer =  0
	actor.remove_from_group("Hittable")
	current_state = AbilityState.START
	if direction_input == DirectionInput.MOUSE:
		_dash_direction = (actor.get_global_mouse_position() - actor.global_position).normalized()
	else:
		var keyboard_direction = Input.get_vector("left","right","up","down").normalized()
		if keyboard_direction == Vector2.ZERO:
			_dash_direction = _last_dash_direction
		else:
			_dash_direction = keyboard_direction
			_last_dash_direction = keyboard_direction	
	if can_cast_while_dashing:
		actor.can_cast = true
	else:
		actor.can_cast = false
	
	_dash_position = actor.position + (_dash_direction * dash_distance)
	_dash_duration = dash_distance / dash_speed
	_begin_dashing = true
	_get_dash_direction = false
	#Start Dash Timer
	get_tree().create_timer(_dash_duration, false, false, false).timeout.connect(end_dash)
	pass
	
func _cancel_dash():
	actor.collision_layer = actor.original_coll_layer
	_get_dash_direction = false
	actor.can_attack = true
	actor.can_cast = true
	current_state = AbilityState.DORMANT
	pass
	
func dash(delta : float):
	#Ability is on and active
	current_state = AbilityState.ACTIVE
	#Prohibits the player from moving the actor while dashing
	actor.can_move = false
	#VELOCITY DASH
	actor.velocity = _dash_direction * (dash_speed) 
	#actor.velocity += lerp(actor.velocity, _dash_direction * dash_speed, 1)
	actor.move_and_slide()
	ability_active.emit()
	pass
	
func end_dash():
	#Ability ended
	active = false
	_begin_dashing = false
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
