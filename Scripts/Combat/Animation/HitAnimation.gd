class_name HitAnimation
extends AnimationPlayer




func _ready():
	if owner is Entity:
		owner.took_damage.connect(_on_entity_took_damage)
	pass


func _on_entity_took_damage(damage : float):
	
	pass
