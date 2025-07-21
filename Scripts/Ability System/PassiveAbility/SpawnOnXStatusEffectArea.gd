class_name SpawnOnXStatusEffectArea
extends PassiveAbility

@export var area : Area2D
@export var spawn_scene : PackedScene
@export var hit_listener : HitListener
@export var status_effect_id : String
@export var stack_threshold : int = 10
var entities : Array[Entity]


func enable_ability(actor : Entity):
	super(actor)
	area.body_entered.connect(_on_body_enter_area)
	area.body_exited.connect(_on_body_exit_area)
	pass

func disable_ability():
	super()
	pass

func _on_body_enter_area(body : Node2D):
	body = body as Entity
	if body != null and body != actor:
		entities.append(body)
		body.status_effect_manager.status_effect_added.connect(_on_status_effect_added_on_target)
		pass
	pass

func _on_body_exit_area(body : Node2D):
	body = body as Entity
	if entities.has(body):
		body.status_effect_manager.status_effect_added.disconnect(_on_status_effect_added_on_target)
		entities.erase(body)
	pass

func _on_status_effect_added_on_target(status_effect : StatusEffect):
	if status_effect.id == status_effect_id and status_effect.stack == stack_threshold:
		print("Passive abiltiy triggered, spawning spawnable")
		status_effect.target_entity
		var spawn : Spawnable = SpawnableHelper.initialize_spawnable(spawn_scene, actor, self, hit_listener)
		spawn.rotation = actor.global_position.direction_to(actor.get_global_mouse_position()).angle()
		spawn.global_position = status_effect.target_entity.global_position
		spawn.collision_mask = (spawn.collision_mask - actor.collision_layer)
		actor.get_tree().root.add_child(spawn)
		pass
	pass
