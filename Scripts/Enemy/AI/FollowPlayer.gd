class_name FollowPlayer
extends Node


@export var enemy : Enemy
@onready var player : PlayerCharacter = enemy.player
@export var speed : Stat


var direction_to_player : Vector2 = Vector2.ZERO
#var steering : Vector2 = Vector2.ZERO
var desired_velocity : Vector2 = Vector2.ZERO

func _ready():
	pass

func _process(delta):
	if player != null:
		direction_to_player = enemy.global_position.direction_to(player.position)

func _physics_process(delta):
	_move_to_player()

func _move_to_player():
	if enemy.follow_player and enemy.can_move:
		desired_velocity = direction_to_player * speed.stat_derived_value
		#steering = min_vector(desired_velocity - enemy.velocity, Vector2(1000,1000))
		#min(Vector2(10,10), Vector2(100,100))
		enemy.velocity = direction_to_player * speed.stat_derived_value#min_vector(enemy.velocity + steering, Vector2(10000,10000))#direction_to_player * speed.stat_derived_value
	else:
		enemy.velocity = Vector2(move_toward(enemy.velocity.x, 0, 20),
		move_toward(enemy.velocity.y, 0, 20)
		)

func min_vector(a : Vector2, b : Vector2) -> Vector2:
	if a.length() > b.length():
		return b
	return a
