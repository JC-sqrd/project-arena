class_name SpawnableBehavior
extends Node

@export var spawnable : Spawnable

func _ready():
	if owner is Spawnable:
		spawnable = owner
	pass

func apply_behavior():
	pass
