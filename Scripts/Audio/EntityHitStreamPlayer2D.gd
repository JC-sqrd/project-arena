class_name EntityHitStreamPlayer2D
extends AudioStreamPlayer2D

@export var entity : Entity

func _ready():
	entity.took_damage.connect(_play_hit_stream)
	pass
	
func _play_hit_stream(damage_taken : float):
	if stream != null:
		pitch_scale = randf_range(0.95, 1.15)
		play()
	pass

