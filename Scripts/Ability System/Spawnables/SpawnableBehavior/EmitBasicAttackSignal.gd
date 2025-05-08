class_name EmitBasicAttackSignal
extends SpawnableBehavior


func _ready() -> void:
	super()
	spawnable.on_hit.connect(on_spawnable_hit)

func on_spawnable_hit(hit_data : Dictionary):
	spawnable.actor.basic_attack_hit.emit(hit_data)
	pass
