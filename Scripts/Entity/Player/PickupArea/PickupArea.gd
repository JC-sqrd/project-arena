class_name PickupArea
extends Area2D

@onready var player : PlayerCharacter = owner

func _ready():
	area_entered.connect(_on_area_entered)
	pass
	
func _on_area_entered(area : Area2D):
	if area.owner is Pickupable:
		var pick_object : Pickupable = area.owner
		pick_object.move_to_entity(player)
		pass
	pass
