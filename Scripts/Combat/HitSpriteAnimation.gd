extends AnimatedSprite2D

@export var entity : Entity

func _ready():
	if entity != null:
		#entity.took_damage.connect(_on_damage_taken)
		entity.died.connect(_on_entity_died)
	pass

func _on_damage_taken(damage : float):
	speed_scale = 1
	rotation = randf_range(0, 360)
	if is_playing():
		#return
		stop()
	play("hit_spark")
	pass


func _on_entity_died(entity : Entity):
	speed_scale = 1
	rotation = randf_range(0, 360)
	if is_playing():
		#return
		stop()
	play("hit_spark")
	pass
