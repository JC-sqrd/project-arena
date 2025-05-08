class_name StalkPlayer
extends Node


@export var enemy : Enemy
@export var stalk_distance : float = 300
@export var flee_distance : float = 250
@onready var player : PlayerCharacter = enemy.player
@export var speed : Stat


var direction_to_player : Vector2 = Vector2.ZERO
var distance_to_player : float = 0
var desired_position : Vector2 = Vector2.ZERO

var in_range : bool = false
var flee : bool = false

func _ready():
	pass

func _process(delta):
	if player != null:
		direction_to_player = enemy.global_position.direction_to(player.position)
		distance_to_player = enemy.global_position.distance_to(player.global_position)
		desired_position = direction_to_player * stalk_distance

func _physics_process(delta):
	if enemy.follow_player and enemy.can_move:
		_move_to_player()

func _move_to_player():
	#if distance_to_player == stalk_distance:
		##enemy.velocity = Vector2(move_toward(enemy.velocity.x, 0, 20),
		##move_toward(enemy.velocity.y, 0, 20)
		##)
		#enemy.velocity = Vector2.ZERO
	#elif distance_to_player > stalk_distance:
		#enemy.velocity = desired_position.normalized() * speed.stat_derived_value
	#elif distance_to_player <= stalk_distance:
		#enemy.velocity = -desired_position.normalized() * speed.stat_derived_value
	#else:
		##enemy.velocity = Vector2(move_toward(enemy.velocity.x, 0, 20),
		##move_toward(enemy.velocity.y, 0, 20)
		##)
		#enemy.velocity = Vector2.ZERO
	if distance_to_player <= stalk_distance:
		in_range = true  # The enemy becomes idle when close to the player.
	elif distance_to_player > stalk_distance:
		in_range = false  # The enemy resumes stalking if too far away.
	
	if distance_to_player <= flee_distance:
		flee = true
	elif distance_to_player > flee_distance:
		flee = false

	if in_range:
		enemy.velocity = Vector2.ZERO  # Stop moving when idle.
		#enemy.velocity = -desired_position.normalized() * speed.stat_derived_value
	else:
		enemy.velocity = desired_position.normalized() * speed.stat_derived_value

	if flee:
		enemy.velocity = -desired_position.normalized() * speed.stat_derived_value
