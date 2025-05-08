class_name HitReceiver
extends Node


var receivers : Array[EffectReceiver] 

func _ready():
	for child in get_children():
		if child is EffectReceiver:
			receivers.append(child)
	pass

func receive_hit(hit_data : Dictionary):
	for receiver in receivers:
		receiver.receive_effect(hit_data)
	pass
