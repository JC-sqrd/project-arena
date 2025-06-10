class_name PosionSpread
extends PassiveAbility


@export var area : Area2D

var entities_in_area : Array[Entity]

func _ready():
	super()
	
	pass

func enable_passive_ability():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	enabled = true
	pass

func disable_passive_ability():
	area.body_entered.disconnect(_on_body_entered)
	area.body_exited.disconnect(_on_body_exited)
	enabled = false
	pass

func _on_body_entered(body : Node2D):
	if body is Entity and body != actor:
		entities_in_area.append(body)
		body.died.connect(_on_entity_death)
	pass

func _on_body_exited(body : Node2D):
	if entities_in_area.has(body):
		entities_in_area.erase(body)
		body.died.disconnect(_on_entity_death)
	pass

func _on_entity_death(entity : Entity):
	if cooling_down:
		print("Passive Ability: Poison Spread cooling down")
		return
	entities_in_area.erase(entity)
	var poison : StatusEffect = entity.status_effect_manager.get_status_effect_by_id("poison")
	if entities_in_area.size() != 0 and poison != null:
		poison.target_entity = entities_in_area[0]
		entities_in_area[0].status_effect_manager.add_status_effect(poison, poison.stack)
		poison.reparent(entities_in_area[0].status_effect_manager)
		start_cooldown()
		pass
	pass
