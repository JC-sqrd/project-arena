class_name EmitAbility
extends ActiveAbility

@export var spawnable_scene : PackedScene
@export var show_object_behind_parent : bool = false
 
func _ready():
	super()
	ability_start.connect(_start_emit)
	ability_casted.connect(_on_ability_casted)

func invoke_ability():
	listen_for_cast = true
	ability_invoked.emit()
	pass

func _process(delta):
	if listen_for_cast:
		if actor is PlayerCharacter:
			#actor.can_attack = false
			actor.can_cast = false
		get_cast_data()

func _start_emit():
	listen_for_cast = false
	var object = spawnable_scene.instantiate() as Spawnable
	object.source = self
	object.actor = actor
	object.on_hit.connect(_on_ability_hit)
	object.inactive.connect(_end_emit)
	object.collision_mask = (object.collision_mask - actor.original_coll_layer)
	if hit_listener != null:
		object.hit_data = hit_listener.generate_effect_data()
	#object.on_destroy.connect(_end_emit)
	actor.add_child(object)
	object.show_behind_parent = show_object_behind_parent
	object.rotation = actor.global_position.direction_to(actor.get_global_mouse_position()).angle()
	pass

func _on_ability_casted():
	active = true
	pass

func _end_emit():
	actor.can_attack = true
	actor.can_cast = true
	active = false
	ability_end.emit()
	print("Ability end " + str(can_cast))
	pass

#func _on_ability_hit(hit_data : HitData):
	#if hit_listener != null:
		#hit_listener.on_hit(hit_data)
	#pass
func _on_ability_hit(hit_data : Dictionary):
	if hit_listener != null:
		hit_listener.on_hit(hit_data)
	pass

func apply_socket_effects():
	
	pass
