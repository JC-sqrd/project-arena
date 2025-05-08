extends Item

@export var trigger_chance : float = 1
@export var chain_count : Stat 
@export var lightning_scene : PackedScene
@export var hit_listener : HitListener

func _ready():
	item_equipped.connect(_on_item_equipped)
	pass

func _on_item_equipped():
	actor.trigger_on_hit_effect.connect(_on_hit_trigger)
	pass

func _on_hit_trigger(hit_data : Dictionary):
	if trigger_chance >= randf_range(0, 1):
		cast_lightning(hit_data)
	pass

func cast_lightning(hit_data : Dictionary):
	var lightning = lightning_scene.instantiate()
	var target : Entity = hit_data["target"] as Entity
	if lightning is ChainSpawnable:
		lightning.actor = actor
		lightning.stack = stack
		lightning.source = self
		lightning.current_host = target
		lightning.chain_count = int(chain_count.stat_derived_value) + (stack - 1)
		if hit_listener != null:
			lightning.hit_data = hit_listener.generate_effect_data()
		lightning.on_hit.connect(_on_lightning_chain)
		target.add_child(lightning)
	pass

func _on_lightning_chain(hit_data : Dictionary):
	if hit_listener != null:
		hit_listener.on_hit(hit_data)
	pass
