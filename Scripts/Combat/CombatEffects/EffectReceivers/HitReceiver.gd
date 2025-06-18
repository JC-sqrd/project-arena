class_name HitReceiver
extends Node


var receivers : Array[EffectReceiver] 

func _ready():
	for child in get_children():
		if child is EffectReceiver:
			receivers.append(child)
	pass

func receive_hit(hit_data : Dictionary):
	_receive_spawn_effect(hit_data)
	for receiver in receivers:
		receiver.receive_effect(hit_data)
	pass

func _receive_spawn_effect(hit_data : Dictionary):
	if hit_data.has("spawn_effect"):
		(hit_data["spawn_effect"] as SpawnEffect).spawn(hit_data)
		pass
	pass
