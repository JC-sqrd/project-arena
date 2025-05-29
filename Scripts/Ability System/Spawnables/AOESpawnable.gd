class_name AOESpawnable
extends Node

@export var radius : float = 100
@onready var collision_shape_2d = $CollisionShape2D
var characters_on_range : Array[CharacterBody2D]


func _ready():
	if collision_shape_2d.shape is CircleShape2D:
		collision_shape_2d.shape.radius = radius
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	pass
	
func _on_body_entered(body : Node2D):
	if body is CharacterBody2D:
		characters_on_range.append(body)
	pass

func _on_body_exited(body : Node2D):
	if body is CharacterBody2D:
		characters_on_range.erase(body)
	pass	
