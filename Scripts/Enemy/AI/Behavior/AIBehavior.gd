class_name AIBehavior
extends Node

var enemy : Enemy 
var player : PlayerCharacter

func _enter_tree():
	if owner is Enemy:
		enemy = owner
		player = enemy.player
	pass
