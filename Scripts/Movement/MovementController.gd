class_name MovementController
extends Node

@export var character : PlayerCharacter
@export var movement_input : MovementInput
@export var speed : Stat  
@export var acceleration : Stat
var decelaration : float = 10000

var direction : Vector2

func _process(delta):
	if character.can_move:
		direction = movement_input.get_movement_input()
	else:
		direction = Vector2.ZERO

func _physics_process(delta):
	if direction.length() > 0:
		character.velocity = direction * speed.stat_derived_value
		#character.velocity = Vector2(
			#move_toward(character.velocity.x, direction.x * speed.stat_derived_value, acceleration.stat_derived_value * delta),
			#move_toward(character.velocity.y, direction.y * speed.stat_derived_value, acceleration.stat_derived_value * delta)
			#)
	else:
		character.velocity = Vector2.ZERO
		#character.velocity = Vector2(
			#move_toward(character.velocity.x, 0, decelaration * delta),
			#move_toward(character.velocity.y, 0, decelaration * delta)
			#)
	character.move_and_slide()
	pass
