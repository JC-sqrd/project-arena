class_name PickupableManager
extends Area2D

@export var actor : PlayerCharacter

signal play_pickup_sound(audio : AudioStream)

func _ready():
	area_entered.connect(_on_area_entered)
	pass


func _on_area_entered(area : Area2D):
	if area.owner is Pickupable:
		var pickupable : Pickupable = area.owner 
		pickupable.pickup(actor)
		if pickupable.pickup_sound != null:
			play_pickup_sound.emit(pickupable.pickup_sound)
		pass
	pass
	
