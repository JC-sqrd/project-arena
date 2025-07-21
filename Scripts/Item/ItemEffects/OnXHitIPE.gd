class_name OnXHitIPE
extends ItemPassiveEffect

@export var hit_requirement : int = 1

var hit_counter : int = 0

func _ready():
	super()
	if owner is Item:
		item = owner
		owner.item_equipped.connect(
			func():
			owner.actor.trigger_on_hit_effect.connect(on_trigger_on_hit_effect)
			owner.actor.basic_attack_hit.connect(on_basic_attack)
		)
		
	pass

func apply_passive_effect(actor : Entity):
	
	pass

func on_trigger_on_hit_effect(hit_data : Dictionary):
	
	pass

func on_basic_attack(hit_data : Dictionary):
	hit_counter += 1
	hit_data["stack"] = item.stack
	#item.actor.state_indicator_container.add_state_indicator(StateIndicatorContainer.create_state_indicator(1, item.item_icon, "", true))
	if hit_counter >= hit_requirement:
		hit_counter = 0
		for effect in effects:
			effect.apply_effect(hit_data)
		pass
	pass
