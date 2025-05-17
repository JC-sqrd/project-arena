class_name EntityHitParticle
extends Node

@export var entity : Entity
@export var particle_scene : PackedScene


func _ready():
	if entity != null:
		entity.took_damage_with_data.connect(_on_entity_took_damage_data)
	pass

func _on_entity_took_damage_data(data : DamageEffectData):
	var particle_system = particle_scene.instantiate()
	if particle_system is GPUParticles2D:
		entity.add_child(particle_system)
		particle_system.global_position = entity.global_position
		if data.source is Node2D:
			particle_system.look_at((data.source.global_position))
		else:
			particle_system.look_at(-Vector2.DOWN + (Vector2.RIGHT * randf_range(-180, 180)))
		particle_system.finished.connect(func(): 
			particle_system.queue_free()
			)
		particle_system.emitting = true
		pass
	
	pass

#func _on_entity_took_damage_data(data : Dictionary):
	#var particle_system = particle_scene.instantiate()
	#if particle_system is GPUParticles2D:
		#entity.add_child(particle_system)
		#particle_system.global_position = entity.global_position
		#if data["source"] is Node2D:
			#particle_system.look_at((data["source"].global_position))
		#else:
			#particle_system.look_at(-Vector2.DOWN + (Vector2.RIGHT * randf_range(-180, 180)))
		#particle_system.finished.connect(func(): 
			#particle_system.queue_free()
			#)
		#particle_system.emitting = true
		#pass
	#
	#pass
