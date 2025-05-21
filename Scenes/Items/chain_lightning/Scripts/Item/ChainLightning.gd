extends Item

@export var trigger_chance : float = 1
@export var chain_count : Stat 
@export var lightning_scene : PackedScene
@export var hit_listener : HitListener

const MAX_INSTANCE : int = 3
var current_instance : int = 0

var instances : Array[ChainSpawnable]

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
	if lightning is ChainSpawnable and current_instance < MAX_INSTANCE:
		lightning.actor = actor
		lightning.stack = stack
		lightning.source = self
		lightning.current_host = target
		lightning.chain_count = int(chain_count.stat_derived_value) + (stack - 1)
		if hit_listener != null:
			lightning.hit_data = hit_listener.generate_effect_data()
		lightning.on_hit.connect(_on_lightning_chain)
		lightning.on_destroy.connect(_on_lightning_destroy)
		#target.add_child(lightning)
		get_tree().root.add_child(lightning)
		instances.append(lightning)
		current_instance += 1
	pass

func _on_lightning_chain(hit_data : Dictionary):
	if hit_listener != null:
		hit_listener.on_hit(hit_data)
	pass

func _on_lightning_destroy():
	current_instance -= 1
	instances.pop_front()
	pass
