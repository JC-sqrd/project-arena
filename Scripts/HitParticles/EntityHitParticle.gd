class_name EntityHitParticle2D
extends GPUParticles2D


func _ready():
	for child in get_children():
		if child is GPUParticles2D:
			if child.one_shot:
				child.emitting = true
