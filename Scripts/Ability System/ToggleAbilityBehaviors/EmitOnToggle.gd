class_name EmitOnToggle
extends ToggleAbilityBehavior


@export var spawnable : PackedScene
@export var hit_listener : HitListener
@export var emit_position : Node2D
@export var look_at_mouse : bool = false
var spawnable_object : Spawnable


func _ready() -> void:
	if owner is ToggleAbility:
		toggle_ability = owner
		toggle_ability.ability_toggled_off.connect(on_ability_toggled_off)
		toggle_ability.ability_toggled_on.connect(on_ability_toggled_on)



func on_ability_toggled_on():
	spawnable_object = spawnable.instantiate() as Spawnable
	if spawnable_object is Spawnable:
		spawnable_object.actor = toggle_ability.actor
		spawnable_object.source = toggle_ability
		spawnable_object.on_hit.connect(_on_ability_hit)
		spawnable_object.on_destroy.connect(_end_emit)
		if hit_listener != null:
			spawnable_object.hit_data = hit_listener.generate_effect_data()
		#object.on_destroy.connect(_end_emit)
	toggle_ability.actor.add_child(spawnable_object)
	spawnable_object.global_position = emit_position.global_position
	if look_at_mouse:
		spawnable_object.rotation = toggle_ability.global_position.direction_to(toggle_ability.actor.get_global_mouse_position()).angle()
	pass

func on_ability_toggled_off():
	if spawnable_object != null:
		spawnable_object.queue_free()
	pass

func _on_ability_hit():
	pass

func _end_emit():
	pass
