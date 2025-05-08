class_name MovementController
extends Node

@export var character : PlayerCharacter
@export var movement_input : MovementInput
@export var speed : Stat  

var direction : Vector2

func _process(delta):
	if character.can_move:
		direction = movement_input.get_movement_input()
	else:
		direction = Vector2.ZERO

func _physics_process(delta):
	if direction.length() > 0:
		character.velocity = direction * speed.stat_derived_value
	else:
		character.velocity = Vector2.ZERO
	character.move_and_slide()
	pass
