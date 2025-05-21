extends Item

@export var stat_threshold : Stat
@export var hit_damage_multiplier : Stat
@export var threshold_percent : float
@export var cooldown_time : float 
@export var spawnable_scene : PackedScene
@export var hit_listener : HitListener
var on_cooldown : bool = false

func _ready():
	item_equipped.connect(_on_item_equipped)
	pass

func _on_item_equipped():
	actor.applied_damage_with_data.connect(_on_actor_applied_damage_with_data)
	#actor.on_hit.connect(_on_actor_on_hit)
	pass

func _on_actor_applied_damage_with_data(damage_data : DamageEffectData):
	var damage : float = damage_data.damage
	var target : Entity = damage_data.target
	#var actor : Entity = damage_data.get("actor") as Entity
	var source : Node = damage_data.source
	var target_health : float = target.stat_manager.get_stat("max_health").stat_derived_value 
	if !on_cooldown and !(source as Node).is_in_group("dot"):#damage >= (target_health * threshold_percent) and !on_cooldown:
		var spawnable : Spawnable = spawnable_scene.instantiate()
		if spawnable is Spawnable:
			#spawnable.rotation = (actor.get_global_mouse_position() - actor.global_position).normalized().angle()
			spawnable.source = self
			spawnable.stack = stack
			spawnable.on_hit.connect(_on_spawnable_hit)
			spawnable.collision_mask = target.original_coll_layer
			if hit_listener != null:
				var effect_data : Dictionary = hit_listener.generate_effect_data()
				if effect_data.has("damage_effect"):
					effect_data["damage_effect"].damage += (damage_data.damage * hit_damage_multiplier.stat_derived_value)
				spawnable.hit_data = effect_data
			get_tree().root.add_child(spawnable)
			spawnable.global_position = target.global_position
			get_tree().create_timer(cooldown_time,false,true,false).timeout.connect(_on_cooldown_end)
			on_cooldown = true
		pass
	pass

#func _on_actor_applied_damage_with_data(damage_data : Dictionary):
	#var damage : float = damage_data.get("damage") 
	#var target : Entity = damage_data.get("target") as Entity
	##var actor : Entity = damage_data.get("actor") as Entity
	#var source : Node = damage_data.get("source")
	#var target_health : float = target.stat_manager.get_stat("max_health").stat_derived_value 
	#if !on_cooldown and !(source as Node).is_in_group("dot"):#damage >= (target_health * threshold_percent) and !on_cooldown:
		#var spawnable : Spawnable = spawnable_scene.instantiate()
		#if spawnable is Spawnable:
			##spawnable.rotation = (actor.get_global_mouse_position() - actor.global_position).normalized().angle()
			#spawnable.source = self
			#spawnable.stack = stack
			#spawnable.on_hit.connect(_on_spawnable_hit)
			#spawnable.collision_mask = target.original_coll_layer
			#print("Spawnable coll mask: " + str(target.collision_layer))
			#if hit_listener != null:
				#var effect_data : Dictionary = hit_listener.generate_effect_data()
				#if effect_data.has("damage_effect"):
					#effect_data["damage_effect"]["damage"] += (damage_data["damage"] * hit_damage_multiplier.stat_derived_value)
				#spawnable.hit_data = effect_data
			#get_tree().root.add_child(spawnable)
			#spawnable.global_position = target.global_position
			#get_tree().create_timer(cooldown_time,false,true,false).timeout.connect(_on_cooldown_end)
			#on_cooldown = true
		#pass
	#pass

func _on_actor_on_hit(hit_data : Dictionary):
	var damage_data : Dictionary = hit_data["damage_effect"]
	var damage : float = damage_data.get("damage") 
	var target : Entity = damage_data.get("target") as Entity
	var target_health : float = target.stat_manager.get_stat("max_health").stat_derived_value
	if !on_cooldown:#damage >= (target_health * threshold_percent) and !on_cooldown:
		var spawnable : Spawnable = spawnable_scene.instantiate()
		if spawnable is Spawnable:
			#spawnable.rotation = (actor.get_global_mouse_position() - actor.global_position).normalized().angle()
			spawnable.source = self
			spawnable.stack = stack
			spawnable.on_hit.connect(_on_spawnable_hit)
			if hit_listener != null:
				var effect_data : Dictionary = hit_listener.generate_effect_data()
				if effect_data.has("damage_effect"):
					effect_data["damage_effect"]["damage"] += (damage_data["damage"] * hit_damage_multiplier.stat_derived_value)
				spawnable.hit_data = effect_data
			get_tree().root.add_child(spawnable)
			spawnable.global_position = target.global_position
			get_tree().create_timer(cooldown_time,false,true,false).timeout.connect(_on_cooldown_end)
			on_cooldown = true
		pass
	pass

func _on_spawnable_hit(hit_data : Dictionary):
	if hit_listener != null:
		hit_listener.on_hit(hit_data)
		pass
	pass

func _on_cooldown_end():
	on_cooldown = false
	pass
