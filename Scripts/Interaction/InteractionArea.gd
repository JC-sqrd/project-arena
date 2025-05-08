class_name InteractionArea
extends Area2D


@export var action_name : String = "interact"


signal interact()


func _ready():
	body_entered.connect(on_body_entered)
	pass 


func on_body_entered(body : Node2D):
	if body.is_in_group("player"):
		InteractionManager.register_area(self)
	pass 

func on_body_exited(body : Node2D):
	if body.is_in_group("player"):
		InteractionManager.unregister_area(self)
	pass
