class_name Enemy
extends Entity



@export var player : PlayerCharacter
@export var speed : float
@export var follow_player : bool = true
@export var hit_listener : HitListener
#@onready var health_bar = $ProgressBar
var move : bool = true
var multipliers : Dictionary

var knockbacked : bool = false
var collisions : Array[KinematicCollision2D] 

signal enemy_died (enemy : Enemy)


func _ready():
	super()


func _physics_process(delta):
	move_and_slide()
	if get_slide_collision_count() > 0 and get_slide_collision(0) != null: 
		var collided_object = get_slide_collision(0).get_collider()
		if collided_object != null and can_attack:
			if collided_object is PlayerCharacter:
				var attack_speed = stat_manager.stats["attack_speed"].stat_derived_value
				var attack_damage = stat_manager.stats["attack_damage"].stat_derived_value
				collided_object.on_hit.emit(create_hit_data(collided_object))
				trigger_on_hit_effect.emit({"actor" : self, "source" : self, "target" : collided_object})
				can_attack = false
				get_tree().create_timer(1 / attack_speed, false, true, false).timeout.connect(
					func():
						can_attack = true
						pass
				)
				pass
	pass
		
func knockback(direction : Vector2, strength : float):
	can_move = false
	var knockback_time = 0.15
	get_tree().create_timer(knockback_time, false, false, false).timeout.connect(
		func(): 
			self.can_move = true
			)
	velocity += direction * strength
	#velocity = lerp(velocity, velocity + (_knockback_direction * _knockback_strength), 1 / knockback_time)

#func update_health_ui():W
	#health_label.text = str(ceilf(stat_manager.stats["current_health"].stat_derived_value)) 
	#health_bar.max_value = stat_manager.stats["max_health"].stat_derived_value
	#health_bar.value = stat_manager.stats["current_health"].stat_derived_value
	#pass

#func take_damage(damage_data : Dictionary) -> float:
	#var source : Node = damage_data["source"]
	#var damage : float = damage_data["damage"]
	#var type : Enums.DamageType = damage_data["damage_type"]
	#var mitigated_damage : float 
	#mitigated_damage = (damage_listener.apply_mitigation_effects(damage_data))
	##update ui
	#update_health_ui.emit(stat_manager.stats["current_health"].stat_derived_value,
	#stat_manager.stats["max_health"].stat_derived_value)
	#damage_data["damage"] = mitigated_damage
	#took_damage_with_data.emit(damage_data)
	#took_damage.emit(mitigated_damage)
	#took_damage_with_type.emit(mitigated_damage, type)
	#return mitigated_damage
	#pass


func die():
	move = false
	velocity = Vector2.ZERO
	collision_layer = 0
	collision_mask = 0
	#$CollisionShape2D.disabled = true
	follow_player = false
	can_attack = false
	can_cast = false
	enemy_died.emit(self)
	died.emit()
	get_tree().create_timer(0.5, false, false, false).timeout.connect(
		func(): 
			queue_free()
			)
	pass


func is_dead() -> bool:
	if stat_manager.stats["current_health"].stat_value <= 0:
		return true
	else:
		return false
	pass

func create_hit_data(target : Entity) -> Dictionary:
	var hit_data : Dictionary
	if hit_listener != null:
		hit_data = hit_listener.generate_effect_data()
	hit_data["actor"] = self
	hit_data["target"] = target
	hit_data["source"] = self
	return hit_data

func _populate_stats_from_node(manager : Node):
	for stat : Stat in manager.get_children():
		stat_manager[stat.stat_name] = stat
	pass


func get_multipliers() -> Dictionary:
	return multipliers
