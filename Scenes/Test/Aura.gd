extends Ability

var enemy_hits : Array[Entity]
@export var base_damage : float = 10
@export var magic_damage : Stat
@export var debug_visual : bool = false
@onready var timer = $Timer
@onready var aura_anim = $AuraAnim

var start_effect : bool = false


func _ready():
	aura_anim.animation_looped.connect(_on_anim_looped)
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	timer.timeout.connect(apply_damage)
	
func _process(delta):
	if timer.is_stopped():
		timer.start()
		play_anim()

func _physics_process(delta):
	if debug_visual:
		#self.queue_redraw()
		pass
	if timer.time_left <= 0.05 and !timer.is_stopped():
		start_effect = true
	else:
		start_effect = false
	pass

func apply_damage():
	for enemy in enemy_hits:
		var source = self
		enemy.on_hit.emit(_create_hit_data(enemy))
		hit_listener.on_hit(_create_hit_data(enemy))
		pass
	queue_free()
	pass
	
#func _create_hit_data(entity_hit : Entity) -> HitData:
	#var hit_data = HitData.create()
	#hit_data.data["target"] = entity_hit
	#hit_data.data["source"] = self
	#hit_data.data["actor"] = self.owner
	#return hit_data

func _create_hit_data(entity_hit : Entity) -> Dictionary:
	var hit_data : Dictionary
	if hit_listener != null:
		hit_data = hit_listener.generate_effect_data()
	hit_data["target"] = entity_hit
	hit_data["source"] = self
	hit_data["actor"] = self.owner
	return hit_data
	pass

func _on_body_entered(body : Node2D):
	if body != owner and body is Entity:
		enemy_hits.append(body)
	pass
	
	
func _on_body_exited(body : Node2D):
	enemy_hits.erase(body)
	if enemy_hits.size() == 0:
		timer.stop()
		aura_anim.stop()
	
	pass
	
func _on_anim_looped():
	#aura_anim.play("recovery", 1 ,false)
	pass

func play_anim():
	aura_anim.speed_scale = ( 1 / timer.wait_time)
	aura_anim.play("default", 1, false)
	pass

func _draw():
	for enemy in enemy_hits:
		#if start_effect:
			#self.draw_line(Vector2.ZERO, to_local(enemy.position), Color.BLACK, 10)
		#else:
			#self.draw_line(Vector2.ZERO, to_local(enemy.position), Color.POWDER_BLUE, 10)
		pass
