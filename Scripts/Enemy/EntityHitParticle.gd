class_name EntityHitParticle
extends Node

@export var entity : Entity
@export var particle_scene : PackedScene

@export var hit_particle : GPUParticles2D

func _ready():
	if entity != null:
		entity.took_damage_with_data.connect(_on_entity_took_damage_data)
		#hit_particle = particle_scene.instantiate() as GPUParticles2D
		#entity.add_child(hit_particle,true)
		#hit_particle.global_position = entity.global_position
		#hit_particle.one_shot = true
		#hit_particle.emitting = false
		#print("INITIALIZED HIT PARTICLE SYSTEM FOR: " + str(entity.name))
	pass

func _on_entity_took_damage_data(data : DamageEffectData):
	if data.source is Node2D and hit_particle != null:
		hit_particle.look_at((data.source.global_position))
	elif data.source is not Node2D and hit_particle != null:
		hit_particle.look_at(-Vector2.DOWN + (Vector2.RIGHT * randf_range(-180, 180)))
	if hit_particle != null:
		hit_particle.emitting = false
		hit_particle.restart()
		hit_particle.emitting = true
		print("EMITTED HIT PARTICLE SYSTEM FOR: " + str(entity.name) + " PARTICLE SYSTEM: " + str(hit_particle.name))
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
