class_name MovementInput
extends Node


func get_movement_input() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")
	
